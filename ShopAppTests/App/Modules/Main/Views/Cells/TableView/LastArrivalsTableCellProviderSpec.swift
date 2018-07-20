//
//  LastArrivalsTableCellProviderSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class LastArrivalsTableCellProviderSpec: QuickSpec {
    override func spec() {
        var collectionProvider: LastArrivalsTableCellProvider!
        var collectionView: UICollectionView!
        
        beforeEach {
            collectionProvider = LastArrivalsTableCellProvider()
            collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
            collectionView.registerNibForCell(LastArrivalsCollectionViewCell.self)
            collectionView.registerNibForCell(GridCollectionViewCell.self)
            collectionView.dataSource = collectionProvider
            collectionView.delegate = collectionProvider
        }
        
        describe("when provider initialized") {
            it("should have correct properties") {
                expect(collectionProvider.products.count) == 0
            }
            
            it("should return correct rows count") {
                let rowsCount = collectionProvider.collectionView(collectionView, numberOfItemsInSection: 0)
                
                expect(rowsCount) == 0
            }
        }
        
        describe("when data did set") {
            var products: [Product]!
            
            beforeEach {
                products = [TestHelper.productWithoutAlternativePrice]
                collectionProvider.products = products
                
                collectionView.reloadData()
            }
            
            it("should have correct rows count") {
                let rowsCount = collectionProvider.collectionView(collectionView, numberOfItemsInSection: 0)
                
                expect(rowsCount) == products.count
            }
            
            context("and size for item returned") {
                context("if layout is verical") {
                    it("should have correct cell size") {
                        collectionProvider.isVerticalLayout = true
                        
                        let indexPath = IndexPath(row: 0, section: 0)
                        let cellSize = collectionProvider.collectionView(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAt: indexPath)
                        
                        expect(cellSize) == GridCollectionViewCell.cellSize
                    }
                }
                
                context("if layout is horizontal") {
                    it("should have correct cell size") {
                        let indexPath = IndexPath(row: 0, section: 0)
                        let cellSize = collectionProvider.collectionView(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAt: indexPath)
                        
                        expect(cellSize.width) == 200
                        expect(cellSize.height) == 200
                    }
                }
            }
            
            context("and min line spacing for section returned") {
                context("if layout is verical") {
                    it("should have correct spacing") {
                        collectionProvider.isVerticalLayout = true

                        let spacing = collectionProvider.collectionView(collectionView, layout: collectionView.collectionViewLayout, minimumLineSpacingForSectionAt: 0)
                        
                        expect(spacing) == 0
                    }
                }
                
                context("if layout is horizontal") {
                    it("should have correct spacing") {
                        let spacing = collectionProvider.collectionView(collectionView, layout: collectionView.collectionViewLayout, minimumLineSpacingForSectionAt: 0)
                        
                        expect(spacing) == 20
                    }
                }
            }
            
            context("and cell for item returned") {
                context("if layout is verical") {
                    it("should have correct cell class") {
                        collectionProvider.isVerticalLayout = true
                        
                        let indexPath = IndexPath(row: 0, section: 0)
                        let cell = collectionProvider.collectionView(collectionView, cellForItemAt: indexPath)
                        
                        expect(cell).to(beAnInstanceOf(GridCollectionViewCell.self))
                    }
                }
                
                context("if layout is horizontal") {
                    it("should have correct cell class") {
                        let indexPath = IndexPath(row: 0, section: 0)
                        let cell = collectionProvider.collectionView(collectionView, cellForItemAt: indexPath)
                        
                        expect(cell).to(beAnInstanceOf(LastArrivalsCollectionViewCell.self))
                    }
                }
            }
        }
        
        describe("when item selected") {
            var product: Product!
            var delegateMock: LastArrivalsTableCellProviderDelegateMock!
            
            beforeEach {
                product = TestHelper.productWithoutAlternativePrice
                collectionProvider.products = [product]
                
                delegateMock = LastArrivalsTableCellProviderDelegateMock()
                
                collectionView.reloadData()
            }
            
            context("if delegate did set") {
                it("should select item") {
                    collectionProvider.delegate = delegateMock
                    let indexPath = IndexPath(row: 0, section: 0)
                    collectionProvider.collectionView(collectionView, didSelectItemAt: indexPath)
                    
                    expect(delegateMock.provider) === collectionProvider
                    expect(delegateMock.product) == product
                }
            }
            
            context("and if not") {
                it("shouldn't select item") {
                    let indexPath = IndexPath(row: 0, section: 0)
                    collectionProvider.collectionView(collectionView, didSelectItemAt: indexPath)
                    
                    expect(delegateMock.provider).to(beNil())
                    expect(delegateMock.product).to(beNil())
                }
            }
        }
    }
}
