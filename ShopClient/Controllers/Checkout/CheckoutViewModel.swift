//
//  CheckoutViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class CheckoutViewModel: BaseViewModel {
    var paymentSuccess = PublishSubject<Bool>()
    var availableRates = Variable<[ShippingRate]>([ShippingRate]())
    var rateUpdatingSuccess = PublishSubject<Bool>()
    
    var checkout: Checkout?
    var currency: String?
    var billingAddress: Address!
    
    // MARK: - public
    public func loadData(with disposeBag: DisposeBag) {
        state.onNext(.loading(showHud: true))
        createCheckout.subscribe(onSuccess: { [weak self] (checkout) in
            self?.checkout = checkout
            self?.state.onNext(.content)
        }) { [weak self] (error) in
            let castedError = error as? RepoError
            self?.state.onNext(.error(error: castedError))
        }.disposed(by: disposeBag)
    }
    
    public func getShippingRates(with address: Address) {
        billingAddress = address
        if let checkout = checkout {
            state.onNext(.loading(showHud: true))
            Repository.shared.getShippingRates(with: checkout, address: address, callback: { [weak self] (rates, error) in
                if let error = error {
                    self?.state.onNext(.error(error: error))
                }
                if let rates = rates {
                    self?.state.onNext(.content)
                    self?.availableRates.value = rates
                }
            })
        }
    }
    
    public func updateCheckout(with rate: ShippingRate) {
        if let checkout = checkout {
            state.onNext(.loading(showHud: true))
            Repository.shared.updateCheckout(with: rate, checkout: checkout) { [weak self] (checkout, error) in
                if let error = error {
                    self?.state.onNext(.error(error: error))
                }
                if let checkout = checkout {
                    self?.checkout = checkout
                    self?.state.onNext(.content)
                    self?.rateUpdatingSuccess.onNext(true)
                }
            }
        }
    }
    
    public func pay(with card: CreditCard) {
        if let checkout = checkout {
            state.onNext(.loading(showHud: true))
            Repository.shared.pay(with: card, checkout: checkout, billingAddress: billingAddress) { [weak self] (success, error) in
                if let error = error {
                    self?.state.onNext(.error(error: error))
                }
                if let success = success {
                    self?.state.onNext(.content)
                    self?.paymentSuccess.onNext(success)
                }
            }
        }
    }
    
    // MARK: - private
    private var getProductList: Single<[CartProduct]> {
        return Single.create(subscribe: { (event) in
            Repository.shared.getCartProductList { [weak self] (cartProducts, error) in
                if let error = error {
                    event(.error(error))
                }
                if let products = cartProducts {
                    self?.currency = cartProducts?.first?.currency
                    event(.success(products))
                }
            }
            return Disposables.create()
        })
    }
    
    private var createCheckout: Single<Checkout> {
        return getProductList.flatMap({ (cartProducts) in
            Single.create(subscribe: { (event) in
                Repository.shared.getCheckout(cartProducts: cartProducts) { (checkout, error) in
                    if let error = error {
                        event(.error(error))
                    }
                    if let checkout = checkout {
                        event(.success(checkout))
                    }
                }
                return Disposables.create()
            })
        })
    }
}
