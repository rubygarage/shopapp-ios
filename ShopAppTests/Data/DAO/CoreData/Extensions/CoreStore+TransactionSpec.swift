//
//  CoreStore+TransactionSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/30/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import CoreData

import CoreStore
import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CoreStore_TransactionSpec: QuickSpec {
    override func spec() {
        beforeEach {
            let inMemoryStore = InMemoryStore()
            try! CoreStore.addStorageAndWait(inMemoryStore)
        }
        
        describe("when extention's func used") {
            context("if entity was created") {
                it("needs to return fetched entity") {
                    let id = "id"
                    let predicate = NSPredicate(format: "productId == %@", id)
                    
                    var entity: CartProductEntity?
                    
                    waitUntil(timeout: 10) { done in
                        CoreStore.perform(asynchronous: { transaction in
                            entity = transaction.create(Into<CartProductEntity>())
                            entity?.productId = "productId"
                            
                            entity = transaction.fetchOrCreate(predicate: predicate)
                            entity?.productId = id
                        }, completion: { _ in
                            expect(entity?.productId) == id
                            
                            done()
                        })
                    }
                }
            }
            
            context("if entity wasn't created") {
                it("needs to create a new entity and return it") {
                    let id = "id"
                    let predicate = NSPredicate(format: "productId == %@", id)
                    
                    var entity: CartProductEntity?
                    
                    waitUntil(timeout: 10) { done in
                        CoreStore.perform(asynchronous: { transaction in
                            entity = transaction.fetchOrCreate(predicate: predicate)
                            entity?.productId = id
                        }, completion: { _ in
                            expect(entity?.productId) == id
                            
                            done()
                        })
                    }
                }
            }
        }
    }
}
