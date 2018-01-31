//
//  CheckoutViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import PassKit

import RxSwift

enum CheckoutSection: Int {
    case cart
    case shippingAddress
    case payment
    case shippingOptions
    
    static let allValues = [cart, shippingAddress, payment, shippingOptions]
    static let valuesWithoutShippingOptions = [cart, shippingAddress, payment]
}

enum PaymentType: Int {
    case creditCard
    case applePay
    
    static let allValues = PKPaymentAuthorizationController.canMakePayments() ? [creditCard, applePay] : [creditCard]
}

class CheckoutViewModel: BaseViewModel {
    private let checkoutUseCase = CheckoutUseCase()
    private let cartProductListUseCase = CartProductListUseCase()
    private let deleteCartProductsUseCase = DeleteCartProductsUseCase()
    private let customerUseCase = CustomerUseCase()
    private let loginUseCase = LoginUseCase()
    private let addAddressUseCase = AddAddressUseCase()
    private let updateDefaultAddressUseCase = UpdateDefaultAddressUseCase()
    
    var checkout = Variable<Checkout?>(nil)
    var creditCard = Variable<CreditCard?>(nil)
    var billingAddress = Variable<Address?>(nil)
    var selectedType = Variable<PaymentType?>(nil)
    var checkoutSuccedded = PublishSubject<()>()
    var cartItems = [CartProduct]()
    var order: Order?
    var selectedProductVariant: ProductVariant!
    
    private var cartItemsSingle: Single<[CartProduct]> {
        return Single.create(subscribe: { [weak self] (event) in
            self?.cartProductListUseCase.getCartProductList({ [weak self] (result, error) in
                if let error = error {
                    event(.error(error))
                }
                if let result = result {
                    self?.cartItems = result
                    event(.success(result))
                }
            })
            return Disposables.create()
        })
    }
    private var checkoutCreateSingle: Single<Checkout> {
        return cartItemsSingle.flatMap({ (cartItems) in
            Single.create(subscribe: { [weak self] (event) in
                self?.checkoutUseCase.createCheckout(cartProducts: cartItems, callback: { (checkout, error) in
                    if let error = error {
                        event(.error(error))
                    }
                    if let checkout = checkout {
                        event(.success(checkout))
                    }
                })
                return Disposables.create()
            })
        })
    }
    
    var placeOrderPressed: AnyObserver<()> {
        return AnyObserver { [weak self] _ in
            self?.placeOrderAction()
        }
    }
    var isCheckoutValid: Observable<Bool> {
        return Observable.combineLatest(selectedType.asObservable(), checkout.asObservable(), creditCard.asObservable(), billingAddress.asObservable()) { (type, checkout, card, address) in
            let applePayCondition = type == .applePay
            let creditCardCondition = type == .creditCard && checkout != nil && card != nil && address != nil && checkout?.shippingLine != nil
            return applePayCondition || creditCardCondition
        }
    }
    
    func loadData(with disposeBag: DisposeBag) {
        state.onNext(.loading(showHud: true))
        checkoutCreateSingle.subscribe(onSuccess: { [weak self] (checkout) in
            self?.checkout.value = checkout
            self?.getCustomer()
        }, onError: { [weak self] (error) in
            let castedError = error as? RepoError
            self?.state.onNext(.error(error: castedError))
        })
        .disposed(by: disposeBag)
    }
    
    func getCheckout() {
        let checkoutId = checkout.value?.id ?? ""
        checkoutUseCase.getCheckout(with: checkoutId) { [weak self] (result, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            }
            if let checkout = result {
                self?.checkout.value = checkout
                self?.state.onNext(.content)
            }
        }
    }
    
    func updateCheckoutShippingAddress(with address: Address) {
        state.onNext(.loading(showHud: true))
        let checkoutId = checkout.value?.id ?? ""
        checkoutUseCase.updateCheckoutShippingAddress(with: checkoutId, address: address) { [weak self] (success, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            } else if let success = success, success == true {
                self?.getCheckout()
            } else {
                self?.state.onNext(.error(error: RepoError()))
            }
        }
    }
    
    func productVariant(with productVariantId: String) -> ProductVariant? {
        var variant: ProductVariant?
        
        cartItems.forEach {
            if let productVariant = $0.productVariant, productVariant.id == productVariantId {
                variant = productVariant
            }
        }
        
        return variant
    }
    
    func updateShippingRate(with rate: ShippingRate) {
        if let checkoutId = checkout.value?.id {
            state.onNext(.loading(showHud: true))
            checkoutUseCase.updateShippingRate(with: checkoutId, rate: rate, callback: { [weak self] (result, error) in
                if let error = error {
                    self?.state.onNext(.error(error: error))
                }
                if let checkout = result {
                    self?.checkout.value = checkout
                    self?.state.onNext(.content)
                }
            })
        }
    }
    
    func getLoginStatus(callback: (_ isLogged: Bool) -> Void) {
        loginUseCase.getLoginStatus { (isLogged) in
            callback(isLogged)
        }
    }
    
    private func getCustomer() {
        customerUseCase.getCustomer { [weak self] (customer, _) in
            if let address = customer?.defaultAddress {
                self?.updateCheckoutShippingAddress(with: address)
            } else {
                self?.state.onNext(.content)
            }
        }
    }
    
    private func placeOrderAction() {
        switch selectedType.value! {
        case PaymentType.creditCard:
            payByCreditCard()
        case PaymentType.applePay:
            payByApplePay()
        }
    }
    
    private func payByCreditCard() {
        if let checkout = checkout.value, let card = creditCard.value, let billingAddress = billingAddress.value {
            state.onNext(.loading(showHud: true))
            checkoutUseCase.pay(with: card, checkout: checkout, billingAddress: billingAddress, callback: paymentCallback())
        }
    }
    
    private func payByApplePay() {
        if let checkout = checkout.value {
            state.onNext(.loading(showHud: true))
            checkoutUseCase.setupApplePay(with: checkout, callback: paymentCallback())
        }
    }
    
    private func paymentCallback() -> RepoCallback<Order> {
        return { [weak self] (response, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let order = response {
                strongSelf.clearCart(with: order)
            } else {
                strongSelf.state.onNext(.content)
            }
        }
    }
    
    private func clearCart(with order: Order) {
        deleteCartProductsUseCase.clearCart { [weak self] _ in
            self?.order = order
            self?.checkoutSuccedded.onNext()
            self?.state.onNext(.content)
        }
    }
}
