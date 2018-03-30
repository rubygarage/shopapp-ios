//
//  CoreDataVariantOptionAdapterSpec.swift
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

class CoreDataVariantOptionAdapterSpec: QuickSpec {
    override func spec() {
        var managedObjectContext: NSManagedObjectContext!
        
        beforeEach {
            let coreDataTestHelper = CoreDataTestHelper()
            managedObjectContext = coreDataTestHelper.managedObjectContext
        }
        
        describe("when adapter used") {
            it("needs to adapt entity item to model object") {
                let description = NSEntityDescription.entity(forEntityName: "VariantOptionEntity", in: managedObjectContext)!
                
                let item = VariantOptionEntity(entity: description, insertInto: nil)
                item.name = "name"
                item.value = "value"
                
                let object = CoreDataVariantOptionAdapter.adapt(item: item)!
                
                expect(object.name) == item.name
                expect(object.value) == item.value
            }
        }
    }
}
