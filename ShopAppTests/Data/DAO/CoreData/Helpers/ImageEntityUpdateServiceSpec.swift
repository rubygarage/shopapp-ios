//
//  ImageEntityUpdateServiceSpec.swift
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

class ImageEntityUpdateServiceSpec: QuickSpec {
    override func spec() {
        var managedObjectContext: NSManagedObjectContext!
        
        beforeEach {
            let coreDataTestHelper = CoreDataTestHelper()
            managedObjectContext = coreDataTestHelper.managedObjectContext
        }
        
        describe("when update service used") {
            it("needs to update entity with item") {
                let description = NSEntityDescription.entity(forEntityName: "ImageEntity", in: managedObjectContext)!
                let entity = ImageEntity(entity: description, insertInto: nil)
                
                let item = Image()
                item.id = "id"
                item.src = "src"
                item.imageDescription = "imageDescription"
                
                ImageEntityUpdateService.update(entity, with: item)
                
                expect(entity.id) == item.id
                expect(entity.src) == item.src
                expect(entity.imageDescription) == item.imageDescription
            }
        }
    }
}
