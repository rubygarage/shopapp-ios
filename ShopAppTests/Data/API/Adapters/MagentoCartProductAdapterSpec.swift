//
//  MagentoCartProductAdapterSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 6/26/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class MagentoCartProductAdapterSpec: QuickSpec {
    override func spec() {
        describe("when adapter used") {
            it("needs to adapt magento response to shopapp model") {
                let currency = "UAH"
                let response = CartProductResponse(id: "id", title: "title", price: 5, quantity: 2, cartProductId: 1)
                let object = MagentoCartProductAdapter.adapt(response, currency: currency)
                
                expect(object.productId) == response.id
                expect(object.productTitle) == response.title
                expect(object.currency) == currency
                expect(object.quantity) == response.quantity
                expect(object.cartItemId) == String(response.cartProductId)
                expect(object.productVariant?.id) == response.id
                expect(object.productVariant?.productId) == response.id
                expect(object.productVariant?.price) == Decimal(response.price)
            }
        }
    }
}
