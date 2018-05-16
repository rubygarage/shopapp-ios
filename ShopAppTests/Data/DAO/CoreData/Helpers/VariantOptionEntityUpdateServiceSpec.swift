//
//  VariantOptionEntityUpdateServiceSpec.swift
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

class VariantOptionEntityUpdateServiceSpec: QuickSpec {
    override func spec() {
        var managedObjectContext: NSManagedObjectContext!
        
        beforeEach {
            let coreDataTestHelper = CoreDataTestHelper()
            managedObjectContext = coreDataTestHelper.managedObjectContext
        }
        
        describe("when update service used") {
            it("needs to update entity with item") {
                let description = NSEntityDescription.entity(forEntityName: "VariantOptionEntity", in: managedObjectContext)!
                let entity = VariantOptionEntity(entity: description, insertInto: nil)
                
                let item = VariantOption()
                item.name = "name"
                item.value = "value"
                
                VariantOptionEntityUpdateService.update(entity, with: item)
                
                expect(entity.name) == item.name
                expect(entity.value) == item.value
            }
        }
    }
}
