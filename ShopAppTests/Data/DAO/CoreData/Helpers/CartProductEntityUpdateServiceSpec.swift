//
//  CartProductEntityUpdateServiceSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/29/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import CoreData

import CoreStore
import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CartProductEntityUpdateServiceSpec: QuickSpec {
    override func spec() {
        beforeEach {
            let inMemoryStore = InMemoryStore()
            try! CoreStore.addStorageAndWait(inMemoryStore)
        }
        
        describe("when update service used") {
            it("needs to update entity with item") {                
                let productVariant = ProductVariant()
                productVariant.id = "id"
                
                let item = CartProduct()
                item.productId = "id"
                item.productTitle = "title"
                item.quantity = 5
                item.currency = "currency"
                item.productVariant = productVariant
                
                var entity: CartProductEntity!
                
                waitUntil(timeout: 10) { done in
                    CoreStore.perform(asynchronous: { transaction in
                        entity = transaction.create(Into<CartProductEntity>())
                        
                        CartProductEntityUpdateService.update(entity, with: item, transaction: transaction)
                    }, completion: { _ in
                        expect(entity.productId) == item.productId
                        expect(entity.productTitle) == item.productTitle
                        expect(entity.quantity) == Int64(item.quantity)
                        expect(entity.currency) == item.currency
                        expect(entity.productVariant?.id) == productVariant.id
                        
                        done()
                    })
                }
            }
        }
    }
}

