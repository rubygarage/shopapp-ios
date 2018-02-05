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
    
    var checkout = Variable<Checkout?>(nil)
    var creditCard = Variable<CreditCard?>(nil)
    var billingAddress = Variable<Address?>(nil)
    var selectedType = Variable<PaymentType?>(nil)
    var cartItems = Variable<[CartProduct]>([])
    var customerLogged = Variable<Bool>(false)
    var checkoutSuccedded = PublishSubject<()>()
    var order: Order?
    var selectedProductVariant: ProductVariant!
    
    var placeOrderPressed: AnyObserver<()> {
        return AnyObserver { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.placeOrderAction()
        }
    }
    var isCheckoutValid: Observable<Bool> {
        return Observable.combineLatest(selectedType.asObservable(), checkout.asObservable(), creditCard.asObservable(), billingAddress.asObservable()) { (type, checkout, card, address) in
            let applePayCondition = type == .applePay
            let creditCardCondition = type == .creditCard && checkout != nil && card != nil && address != nil && checkout?.shippingLine != nil
            return applePayCondition || creditCardCondition
        }
    }
    
    func loadData() {
        state.onNext(.loading(showHud: true))
        loginUseCase.getLoginStatus { [weak self] (isLogged) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.customerLogged.value = isLogged
            strongSelf.getCartItems()
        }
    }
    
    func getCheckout() {
        state.onNext(.loading(showHud: true))
        let checkoutId = checkout.value?.id ?? ""
        checkoutUseCase.getCheckout(with: checkoutId) { [weak self] (result, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let checkout = result {
                strongSelf.checkout.value = checkout
                strongSelf.state.onNext(.content)
            }
        }
    }
    
    func updateCheckoutShippingAddress(with address: Address) {
        state.onNext(.loading(showHud: true))
        let checkoutId = checkout.value?.id ?? ""
        checkoutUseCase.updateCheckoutShippingAddress(with: checkoutId, address: address) { [weak self] (success, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let success = success, success == true {
                strongSelf.getCheckout()
            } else {
                strongSelf.state.onNext(.error(error: RepoError()))
            }
        }
    }
    
    func productVariant(with productVariantId: String) -> ProductVariant? {
        var variant: ProductVariant?
        
        cartItems.value.forEach {
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
                guard let strongSelf = self else {
                    return
                }
                if let error = error {
                    strongSelf.state.onNext(.error(error: error))
                } else if let checkout = result {
                    strongSelf.checkout.value = checkout
                    strongSelf.state.onNext(.content)
                }
            })
        }
    }
    
    private func getCartItems() {
        cartProductListUseCase.getCartProductList({ [weak self] (result, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let cartItems = result {
                strongSelf.cartItems.value = cartItems
                strongSelf.createCheckout(cartItems: cartItems)
            }
        })
    }
    
    private func createCheckout(cartItems: [CartProduct]) {
        checkoutUseCase.createCheckout(cartProducts: cartItems, callback: { [weak self] (checkout, error) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.state.onNext(.error(error: error))
            } else if let checkout = checkout {
                strongSelf.checkout.value = checkout
                strongSelf.getCustomer()
            }
        })
    }
    
    private func getCustomer() {
        customerUseCase.getCustomer { [weak self] (customer, _) in
            guard let strongSelf = self else {
                return
            }
            if let address = customer?.defaultAddress {
                strongSelf.updateCheckoutShippingAddress(with: address)
            } else {
                strongSelf.state.onNext(.content)
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
            guard let strongSelf = self else {
                return
            }
            strongSelf.order = order
            strongSelf.checkoutSuccedded.onNext()
            strongSelf.state.onNext(.content)
        }
    }
}
