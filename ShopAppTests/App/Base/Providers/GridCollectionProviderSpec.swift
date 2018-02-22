//
//  GridCollectionProviderSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class GridCollectionProviderSpec: QuickSpec {
    override func spec() {
        let collectionViewLayout = UICollectionViewLayout()
        
        var collectionProvider: GridCollectionProvider!
        var collectionView: UICollectionView!
        
        beforeEach {
            collectionProvider = GridCollectionProvider()
            
            collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: collectionViewLayout)
            collectionView.registerNibForCell(GridCollectionViewCell.self)
            collectionView.dataSource = collectionProvider
            collectionView.delegate = collectionProvider
        }
        
        describe("when provider initialized") {
            it("should have correct number of items") {
                let numberOfItems = collectionProvider.collectionView(collectionView, numberOfItemsInSection: 0)
                
                expect(numberOfItems) == 0
            }
        }
        
        describe("when products updated") {
            var product: Product!
            
            beforeEach {
                product = Product()
                product.currency = "UDS"
                collectionProvider.products = [product]
            }
            
            it("should have correct number of items") {
                let numberOfItems = collectionProvider.collectionView(collectionView, numberOfItemsInSection: 0)
                
                expect(numberOfItems) == 1
            }
            
            it("should have correct cell type") {
                let indexPath = IndexPath(item: 0, section: 0)
                let cell = collectionProvider.collectionView(collectionView, cellForItemAt: indexPath)
                expect(cell).to(beAnInstanceOf(GridCollectionViewCell.self))
            }
            
            it("should have correct cell size") {
                let indexPath = IndexPath(item: 0, section: 0)
                let size = collectionProvider.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)

                expect(size) == GridCollectionViewCell.cellSize
            }
        }
        
        describe("when cell selected") {
            var product: Product!
            var delegateMock: GridCollectionProviderDelegateMock!
            
            beforeEach {
                product = Product()
                product.currency = "UDS"
                collectionProvider.products = [product]
                
                delegateMock = GridCollectionProviderDelegateMock()
                collectionProvider.delegate = delegateMock
            }
            
            it("needs to open product details") {
                let indexPath = IndexPath(item: 0, section: 0)
                collectionProvider.collectionView(collectionView, didSelectItemAt: indexPath)
                
                expect(delegateMock.provider) === collectionProvider
                expect(delegateMock.product) === product
            }
        }
        
        describe("when view scrolled") {
            var product: Product!
            var delegateMock: GridCollectionProviderDelegateMock!
            
            beforeEach {
                product = Product()
                product.currency = "UDS"
                collectionProvider.products = [product]
                
                delegateMock = GridCollectionProviderDelegateMock()
                collectionProvider.delegate = delegateMock
            }
            it("needs to hide sort veiw if needed") {
                collectionProvider.scrollViewDidScroll(collectionView)
                
                expect(delegateMock.provider) === collectionProvider
                expect(delegateMock.scrollView) === collectionView
            }
        }
    }
}
