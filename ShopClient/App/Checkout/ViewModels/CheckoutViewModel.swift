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
}

enum PaymentTypeSection: Int {
    case creditCard
    case applePay
    
    static let allValues = PKPaymentAuthorizationController.canMakePayments() ? [creditCard, applePay] : [creditCard]
}

class CheckoutViewModel: BaseViewModel {
    private let checkoutUseCase = CheckoutUseCase()
    private let cartProductListUseCase = CartProductListUseCase()
    private let deleteCartProductsUseCase = DeleteCartProductsUseCase()
    private let customerUseCase = CustomerUseCase()
    
    var cartItems = [CartProduct]()
    var checkout = Variable<Checkout?>(nil)
    var checkoutSuccedded = PublishSubject<()>()
    
    var billingAddress: Address?
    var creditCard: CreditCard?
    var order: Order?
    
    var placeOrderPressed: AnyObserver<()> {
        return AnyObserver { [weak self] _ in
            self?.placeOrderAction()
        }
    }
    
    public func loadData(with disposeBag: DisposeBag) {
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
    
    public func getCheckout() {
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
    
    public func updateCheckoutShippingAddress(with address: Address, isDefaultAddress: Bool) {
        state.onNext(.loading(showHud: true))
        let checkoutId = checkout.value?.id ?? ""
        checkoutUseCase.updateCheckoutShippingAddress(with: checkoutId, address: address) { [weak self] (success, error) in
            if let error = error {
                self?.state.onNext(.error(error: error))
            } else if let success = success, success == true {
                self?.processUpdateCheckoutShippingAddress(address: address, isDefaultAddress: isDefaultAddress)
            } else {
                self?.state.onNext(.error(error: RepoError()))
            }
        }
    }
    
    public func productVariant(with productVariantId: String) -> ProductVariant? {
        var variant: ProductVariant?
        
        cartItems.forEach {
            if let productVariant = $0.productVariant, productVariant.id == productVariantId {
                variant = productVariant
            }
        }
        
        return variant
    }
    
    public func updateShippingRate(with rate: ShippingRate) {
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
    
    // MARK: - private
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
    
    private func getCustomer() {
        customerUseCase.getCustomer { [weak self] (customer, _) in
            if let address = customer?.defaultAddress {
                self?.updateCheckoutShippingAddress(with: address, isDefaultAddress: false)
            } else {
                self?.state.onNext(.content)
            }
        }
    }
    
    private func processUpdateCheckoutShippingAddress(address: Address, isDefaultAddress: Bool) {
        customerUseCase.addAddress(with: address) { [weak self] (addressId, _) in
            if let addressId = addressId {
                self?.processCustomerAddingAddress(with: addressId, isDefaultAddress: isDefaultAddress)
            } else {
                self?.getCheckout()
            }
        }
    }
    
    private func processCustomerAddingAddress(with addressId: String, isDefaultAddress: Bool) {
        if isDefaultAddress {
            updateCustomerDefaultAddress(with: addressId)
        } else {
            getCheckout()
        }
    }
    
    private func updateCustomerDefaultAddress(with addressId: String) {
        customerUseCase.updateDefaultAddress(with: addressId) { [weak self] (_, _) in
            self?.getCheckout()
        }
    }
    
    private func placeOrderAction() {
        if let checkout = checkout.value, let card = creditCard, let billingAddress = billingAddress {
            state.onNext(.loading(showHud: true))
            checkoutUseCase.pay(with: card, checkout: checkout, billingAddress: billingAddress) { [weak self] (response, error) in
                if let error = error {
                    self?.state.onNext(.error(error: error))
                }
                if let order = response {
                    self?.clearCart(with: order)
                }
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
