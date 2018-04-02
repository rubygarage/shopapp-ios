//
//  ProductVariantEntityUpdateServiceSpec.swift
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

class ProductVariantEntityUpdateServiceSpec: QuickSpec {
    override func spec() {
        beforeEach {
            let inMemoryStore = InMemoryStore()
            try! CoreStore.addStorageAndWait(inMemoryStore)
        }
        
        describe("when update service used") {
            it("needs to update entity with item") {
                let variantOption = VariantOption()
                variantOption.name = "name"
                
                let image = Image()
                image.id = "id"
                image.src = "src"
                
                let item = ProductVariant()
                item.id = "id"
                item.price = 5.5
                item.title = "title"
                item.available = true
                item.productId = "productId"
                item.selectedOptions = [variantOption]
                item.image = image
                
                var entity: ProductVariantEntity!
                
                waitUntil(timeout: 10) { done in
                    CoreStore.perform(asynchronous: { transaction in
                        entity = transaction.create(Into<ProductVariantEntity>())
                        
                        ProductVariantEntityUpdateService.update(entity, with: item, transaction: transaction)
                    }, completion: { _ in
                        expect(entity.id) == item.id
                        expect(entity.price) == NSDecimalNumber(decimal: item.price ?? Decimal())
                        expect(entity.title) == item.title
                        expect(entity.available) == item.available
                        expect(entity.productId) == item.productId
                        expect((entity.selectedOptions?.allObjects.first as? VariantOptionEntity)?.name) == variantOption.name
                        expect(entity.image?.id) == image.id
                        
                        done()
                    })
                }
            }
        }
    }
}
