//
//  CategoryListCollectionProviderSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CategoryListCollectionProviderSpec: QuickSpec {
    override func spec() {
        var collectionProvider: CategoryListCollectionProvider!
        var collectionViewLayout: UICollectionViewLayout!
        var collectionView: UICollectionView!
        
        beforeEach {
            collectionProvider = CategoryListCollectionProvider()
            collectionViewLayout = UICollectionViewLayout()
            collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
            collectionView.registerNibForCell(CategoryCollectionViewCell.self)
            collectionView.dataSource = collectionProvider
            collectionView.delegate = collectionProvider
        }
        
        describe("when provider created") {
            it("should return correct rows count") {
                let itemsCount = collectionProvider.collectionView(collectionView, numberOfItemsInSection: 0)
                
                expect(itemsCount) == 0
            }
            
            it("should return correct cell size") {
                let indexPath = IndexPath(item: 0, section: 0)
                let cellSize = collectionProvider.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
                
                expect(cellSize) == CategoryCollectionViewCell.cellSize
            }
        }
        
        describe("when categories did set") {
            beforeEach {
                let category = Category()
                collectionProvider.categories = [category]
            }
            
            it("should return correct rows count") {
                let itemsCount = collectionProvider.collectionView(collectionView, numberOfItemsInSection: 0)
                
                expect(itemsCount) == collectionProvider.categories.count
            }
            
            it("should return correct cell class") {
                let indexPath = IndexPath(item: 0, section: 0)
                let cell = collectionProvider.collectionView(collectionView, cellForItemAt: indexPath)
                
                expect(cell).to(beAnInstanceOf(CategoryCollectionViewCell.self))
            }
        }
        
        describe("when category selected") {
            var category: ShopApp_Gateway.Category!
            
            beforeEach {
                category = Category()
                collectionProvider.categories = [category]
            }
            
            it("should select category") {
                let providerDelegateMock = CategoryListCollectionProviderDelegateMock()
                collectionProvider.delegate = providerDelegateMock
                
                let indexPath = IndexPath(item: 0, section: 0)
                collectionProvider.collectionView(collectionView, didSelectItemAt: indexPath)
                
                expect(providerDelegateMock.provider) === collectionProvider
                expect(providerDelegateMock.category) === category
            }
        }
    }
}
