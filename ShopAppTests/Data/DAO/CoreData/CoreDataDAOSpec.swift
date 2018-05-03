//
//  CoreDataDAOSpec.swift
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

class CoreDataDAOSpec: QuickSpec {
    override func spec() {
        var dao: DAO!
        
        beforeEach {
            dao = CoreDataDAO()
            
            let inMemoryStore = InMemoryStore()
            try! CoreStore.addStorageAndWait(inMemoryStore)
        }
        
        describe("when cart product list should be get") {
            it("needs to fetch and return all adapted entities") {
                waitUntil(timeout: 10) { done in
                    CoreStore.perform(asynchronous: { transaction in
                        transaction.create(Into<CartProductEntity>())
                    }, completion: { _ in
                        dao.getCartProductList() { (result, _) in
                            expect(result?.count) == 1
                            
                            done()
                        }
                    })
                }
            }
        }

        describe("when cart product should be add") {
            var cartProduct: CartProduct!
            
            beforeEach {
                let productVariant = ProductVariant()
                productVariant.id = "id"
                
                cartProduct = CartProduct()
                cartProduct.productId = "id"
                cartProduct.quantity = 1
                cartProduct.productVariant = productVariant
            }
                
            context("if there is no entity with identifier") {
                it("needs to create new entity") {
                    waitUntil(timeout: 10) { done in
                        dao.addCartProduct(cartProduct: cartProduct) { (_, _) in
                            var numberOfEntities: Int?
                            
                            CoreStore.perform(asynchronous: { transaction in
                                numberOfEntities = transaction.fetchCount(From<CartProductEntity>())
                            }, completion: { _ in
                                expect(numberOfEntities) == 1
                                
                                done()
                            })
                        }
                    }
                }
            }
            
            context("if there is one entity with identifier") {
                it("needs to fetch entity and update them quantity") {
                    waitUntil(timeout: 10) { done in
                        dao.addCartProduct(cartProduct: cartProduct) { (_, _) in
                            dao.addCartProduct(cartProduct: cartProduct) { (_, _) in
                                var entities: [CartProductEntity]?
                                
                                CoreStore.perform(asynchronous: { transaction in
                                    entities = transaction.fetchAll(From<CartProductEntity>())
                                }, completion: { _ in
                                    expect(entities?.count) == 1
                                    expect(entities?.first?.quantity) == 2
                                    
                                    done()
                                })
                            }
                        }
                    }
                }
            }
        }
        
        describe("when cart product should be delete") {
            it("needs to delete selected entity") {
                let productVariantId = "id"
                
                waitUntil(timeout: 10) { done in
                    CoreStore.perform(asynchronous: { transaction in
                        let entity = transaction.create(Into<CartProductEntity>())
                        entity.productVariant = transaction.create(Into<ProductVariantEntity>())
                        entity.productVariant?.id = productVariantId
                    }, completion: { _ in
                        dao.deleteProductFromCart(with: productVariantId) { (_, _) in
                            var numberOfEntities: Int?
                            
                            CoreStore.perform(asynchronous: { transaction in
                                numberOfEntities = transaction.fetchCount(From<CartProductEntity>())
                            }, completion: { _ in
                                expect(numberOfEntities) == 0
                                
                                done()
                            })
                        }
                    })
                }
            }
        }
        
        describe("when cart products by ids should be delete") {
            it("should delete selected entities") {
                let productVariantId = "id1"
                let productVariantToDeleteId = "id2"
                let allProductVariantIds = [productVariantId, productVariantToDeleteId]
                
                waitUntil(timeout: 10) { done in
                    CoreStore.perform(asynchronous: { transaction in
                        allProductVariantIds.forEach({
                            let entity = transaction.create(Into<CartProductEntity>())
                            entity.productVariant = transaction.create(Into<ProductVariantEntity>())
                            entity.productVariant?.id = $0
                        })
                    }, completion: { _ in
                        dao.deleteProductsFromCart(with: [productVariantToDeleteId]) { (_, _) in
                            var numberOfEntities: Int?
                            var existProductVariantIds: [String?]?
                            
                            CoreStore.perform(asynchronous: { transaction in
                                numberOfEntities = transaction.fetchCount(From<CartProductEntity>())
                                let all = transaction.fetchAll(From<CartProductEntity>())
                                existProductVariantIds = all?.map({ $0.productVariant?.id })
                            }, completion: { _ in
                                expect(numberOfEntities) == 1
                                expect(existProductVariantIds).to(equal([productVariantId]))
                                
                                done()
                            })
                        }
                    })
                }
            }
        }
        
        describe("when all cart products should be delete") {
            it("needs to delete all entities") {
                waitUntil(timeout: 10) { done in
                    CoreStore.perform(asynchronous: { transaction in
                        _ = transaction.create(Into<CartProductEntity>())
                        _ = transaction.create(Into<CartProductEntity>())
                    }, completion: { _ in
                        dao.deleteAllProductsFromCart() { (_, _) in
                            var numberOfEntities: Int?
                            
                            CoreStore.perform(asynchronous: { transaction in
                                numberOfEntities = transaction.fetchCount(From<CartProductEntity>())
                            }, completion: { _ in
                                expect(numberOfEntities) == 0

                                done()
                            })
                        }
                    })
                }
            }
        }
        
        describe("when cart product's quantity should be change") {
            it("needs to change value") {
                let productVariantId = "id"
                let quantity = 2
                
                waitUntil(timeout: 10) { done in
                    CoreStore.perform(asynchronous: { transaction in
                        let entity = transaction.create(Into<CartProductEntity>())
                        entity.productVariant = transaction.create(Into<ProductVariantEntity>())
                        entity.productVariant?.id = productVariantId
                        entity.quantity = 1
                    }, completion: { _ in
                        dao.changeCartProductQuantity(with: productVariantId, quantity: quantity) { (_, _) in
                            var entity: CartProductEntity?
                            
                            CoreStore.perform(asynchronous: { transaction in
                                entity = transaction.fetchOne(From<CartProductEntity>())
                            }, completion: { _ in
                                expect(entity?.quantity) == Int64(quantity)
                                
                                done()
                            })
                        }
                    })
                }
            }
        }
    }
}
