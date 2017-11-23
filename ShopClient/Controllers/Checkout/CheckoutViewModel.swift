//
//  CheckoutViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class CheckoutViewModel: BaseViewModel {
    var checkout: Checkout?
    
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
    
    public func payByCard(with card: CreditCard) {
        Repository.shared.payByCard(with: card, url: checkout?.webUrl ?? String()) { (str, error) in
            print()
        }
    }
    
    // MARK: - private
    private var getProductList: Single<[CartProduct]> {
        return Single.create(subscribe: { (event) in
            Repository.shared.getCartProductList { (cartProducts, error) in
                if let error = error {
                    event(.error(error))
                }
                if let products = cartProducts {
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
