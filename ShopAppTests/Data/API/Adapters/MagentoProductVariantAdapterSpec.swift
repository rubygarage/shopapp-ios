//
//  MagentoProductVariantAdapterSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class MagentoProductVariantAdapterSpec: QuickSpec {
    override func spec() {
        describe("when adapter used") {
            it("needs to adapt shopapp model to other one") {
                let product = Product()
                product.id = "id"
                product.title = "title"
                product.price = Decimal(10.5)
                product.images = [Image()]
                
                let productVariant = MagentoProductVariantAdapter.adapt(product)
                
                expect(productVariant.id) == product.id
                expect(productVariant.title) == product.title
                expect(productVariant.price) == product.price
                expect(productVariant.available) == true
                expect(productVariant.image) === product.images?.first
                expect(productVariant.selectedOptions?.isEmpty) == true
                expect(productVariant.productId) == product.id
            }
        }
    }
}
