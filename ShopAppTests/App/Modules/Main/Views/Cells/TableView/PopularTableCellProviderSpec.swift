//
//  PopularTableCellProviderSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class PopularTableCellProviderSpec: QuickSpec {
    override func spec() {
        var collectionProvider: PopularTableCellProvider!
        var collectionView: UICollectionView!
        
        beforeEach {
            collectionProvider = PopularTableCellProvider()
            collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
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
                let product = Product()
                product.currency = "Currency"
                products = [product]
                collectionProvider.products = products
                
                collectionView.reloadData()
            }
            
            it("should have correct rows count") {
                let rowsCount = collectionProvider.collectionView(collectionView, numberOfItemsInSection: 0)
                
                expect(rowsCount) == products.count
            }
            
            it("should have correct cell size") {
                let indexPath = IndexPath(row: 0, section: 0)
                let cellSize = collectionProvider.collectionView(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAt: indexPath)
                
                expect(cellSize.width) == GridCollectionViewCell.cellSize.width
                expect(cellSize.height) == GridCollectionViewCell.cellSize.height
            }
            
            it("should have correct cell class") {
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = collectionProvider.collectionView(collectionView, cellForItemAt: indexPath)
                
                expect(cell).to(beAnInstanceOf(GridCollectionViewCell.self))
            }
        }
        
        describe("when item selected") {
            var product: Product!
            var delegateMock: PopularTableCellProviderDelegateMock!
            
            beforeEach {
                product = Product()
                product.currency = "Currency"
                collectionProvider.products = [product]
                
                delegateMock = PopularTableCellProviderDelegateMock()
                
                collectionView.reloadData()
            }
            
            context("if delegate did set") {
                it("should select item") {
                    collectionProvider.delegate = delegateMock
                    let indexPath = IndexPath(row: 0, section: 0)
                    collectionProvider.collectionView(collectionView, didSelectItemAt: indexPath)
                    
                    expect(delegateMock.provider) === collectionProvider
                    expect(delegateMock.product) === product
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
