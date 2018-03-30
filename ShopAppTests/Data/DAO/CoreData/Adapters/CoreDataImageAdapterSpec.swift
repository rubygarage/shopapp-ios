//
//  CoreDataImageAdapterSpec.swift
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

class CoreDataImageAdapterSpec: QuickSpec {
    override func spec() {
        var managedObjectContext: NSManagedObjectContext!
        
        beforeEach {
            let coreDataTestHelper = CoreDataTestHelper()
            managedObjectContext = coreDataTestHelper.managedObjectContext
        }
        
        describe("when adapter used") {
            it("needs to adapt entity item to model object") {
                let description = NSEntityDescription.entity(forEntityName: "ImageEntity", in: managedObjectContext)!
                
                let item = ImageEntity(entity: description, insertInto: nil)
                item.id = "id"
                item.src = "src"
                item.imageDescription = "description"
                
                let object = CoreDataImageAdapter.adapt(item: item)!
                
                expect(object.id) == item.id
                expect(object.src) == item.src
                expect(object.imageDescription) == item.imageDescription
            }
        }
    }
}
