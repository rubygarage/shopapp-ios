//
//  CoreDataProductVariantAdapterSpec.swift
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

class CoreDataProductVariantAdapterSpec: QuickSpec {
    override func spec() {
        var managedObjectContext: NSManagedObjectContext!
        
        beforeEach {
            let coreDataTestHelper = CoreDataTestHelper()
            managedObjectContext = coreDataTestHelper.managedObjectContext
        }
        
        describe("when adapter used") {
            it("needs to adapt entity item to model object") {
                let imageDescription = NSEntityDescription.entity(forEntityName: "ImageEntity", in: managedObjectContext)!
                let variantOptionDescription = NSEntityDescription.entity(forEntityName: "VariantOptionEntity", in: managedObjectContext)!
                let productVariantDescription = NSEntityDescription.entity(forEntityName: "ProductVariantEntity", in: managedObjectContext)!
                
                let image = ImageEntity(entity: imageDescription, insertInto: nil)
                image.id = "id"
                
                let variantOption = VariantOptionEntity(entity: variantOptionDescription, insertInto: nil)
                variantOption.name = "name"
                
                let item = ProductVariantEntity(entity: productVariantDescription, insertInto: nil)
                item.id = "id"
                item.price = 5.5
                item.title = "title"
                item.available = true
                item.image = image
                item.productId = "productId"
                item.addToSelectedOptions(variantOption)
                
                let object = CoreDataProductVariantAdapter.adapt(item: item)!
      
                expect(object.id) == item.id
                expect(object.price) == item.price?.decimalValue
                expect(object.title) == item.title
                expect(object.available) == item.available
                expect(object.image?.id) == item.image?.id
                expect(object.productId) == item.productId
                expect(object.selectedOptions?.first?.name) == (item.selectedOptions?.allObjects.first as? VariantOptionEntity)?.name
            }
        }
    }
}
