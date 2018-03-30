//
//  CoreDataCartProductAdapterSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/29/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import CoreData

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CoreDataCartProductAdapterSpec: QuickSpec {
    override func spec() {
        var managedObjectContext: NSManagedObjectContext!
        
        beforeEach {
            let coreDataTestHelper = CoreDataTestHelper()
            managedObjectContext = coreDataTestHelper.managedObjectContext
        }
        
        describe("when adapter used") {
            it("needs to adapt entity item to model object") {
                let productVariantDescription = NSEntityDescription.entity(forEntityName: "ProductVariantEntity", in: managedObjectContext)!
                let cartProductDescription = NSEntityDescription.entity(forEntityName: "CartProductEntity", in: managedObjectContext)!
                
                let productVariant = ProductVariantEntity(entity: productVariantDescription, insertInto: nil)
                productVariant.id = "id"
                
                let item = CartProductEntity(entity: cartProductDescription, insertInto: nil)
                item.productId = "productId"
                item.productTitle = "title"
                item.productVariant = productVariant
                item.currency = "currency"
                item.quantity = 5
                
                let object = CoreDataCartProductAdapter.adapt(item: item)!
                
                expect(object.productId) == item.productId
                expect(object.productTitle) == item.productTitle
                expect(object.productVariant?.id) == item.productVariant?.id
                expect(object.currency) == item.currency
                expect(object.quantity) == Int(item.quantity)
            }
            
            it("needs to adapt model objects th other one") {
                let productQuantity = 5
                
                let product = Product()
                product.id = "id"
                product.title = "title"
                product.currency = "currency"
                
                let productVariant = ProductVariant()
                productVariant.id = "productVariantId"
                
                let object = CoreDataCartProductAdapter.adapt(product: product, productQuantity: productQuantity, variant: productVariant)!
                
                expect(object.productId) == product.id
                expect(object.productTitle) == product.title
                expect(object.productVariant?.id) == productVariant.id
                expect(object.currency) == product.currency
                expect(object.quantity) == productQuantity
            }
        }
    }
}
