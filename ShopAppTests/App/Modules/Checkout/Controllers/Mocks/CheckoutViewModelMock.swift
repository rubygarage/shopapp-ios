//
//  CheckoutViewModelMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/10/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class CheckoutViewModelMock: CheckoutViewModel {
    var isGetCheckoutStarted = false
    var isUpdateShippingRateStarted = false
    
    override func getCheckout() {
        isGetCheckoutStarted = true
    }
    
    func generateCheckout(_ generatedChekout: Checkout?) {
        checkout.value = generatedChekout
    }
    
    func generateIsCheckoutValid(_ valid: Bool) {
        selectedType.value = valid ? .applePay : .creditCard
        customerEmail.value = valid ? "customer@mail.com" : ""
    }
    
    func generateCartItems(_ items: [CartProduct]) {
        cartItems.value = items
    }
    
    func generateCustomerHasEmail(_ hasEmail: Bool) {
        customerHasEmail.onNext(hasEmail)
    }
    
    func generateCustomerEmail(_ email: String) {
        customerEmail.value = email
    }
    
    override func updateShippingRate(with rate: ShippingRate) {
        isUpdateShippingRateStarted = true
    }
}
