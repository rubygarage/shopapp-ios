//
//  ProductOptionsCollectionCellProviderSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Quick
import Nimble
import ShopApp_Gateway

@testable import ShopApp

class ProductOptionsCollectionCellProviderSpec: QuickSpec {
    override func spec() {
        var collectionProvider: ProductOptionsCollectionCellProvider!
        var collectionViewLayout: UICollectionViewLayout!
        var collectionView: UICollectionView!
        
        beforeEach {
            collectionProvider = ProductOptionsCollectionCellProvider()
            collectionViewLayout = UICollectionViewLayout()
            collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: collectionViewLayout)
            collectionView.registerNibForCell(ProductOptionCollectionViewCell.self)
            collectionView.dataSource = collectionProvider
            collectionView.delegate = collectionProvider
        }
        
        describe("when provider initialized") {
            it("should have correct properties") {
                expect(collectionProvider.values.isEmpty) == true
                expect(collectionProvider.selectedValue) == ""
            }
            
            it("should return zero items count") {
                let itemsCount = collectionProvider.collectionView(collectionView, numberOfItemsInSection: 0)
                
                expect(itemsCount) == 0
            }
        }
        
        describe("when data did set") {
            var values: [String]!
            var selectedValue: String!
            
            beforeEach {
                values = ["Value 1", "Value 2"]
                selectedValue = "Value 1"
                
                collectionProvider.values = values
                collectionProvider.selectedValue = selectedValue
            }
            
            it("should return correct items count") {
                let itemsCount = collectionProvider.collectionView(collectionView, numberOfItemsInSection: 0)
                
                expect(itemsCount) == values.count
            }
            
            it("should return correct cell size") {
                let text = values.first!
                let font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
                let attributes = [NSAttributedString.Key.font: font]
                let optionCollectionViewCellAdditionalWidth: CGFloat = 24
                let width = (text as NSString).size(withAttributes: attributes).width + optionCollectionViewCellAdditionalWidth
                let expectedSize = CGSize(width: width, height: kOptionCollectionViewCellHeight)
                
                let indexPath = IndexPath(item: 0, section: 0)
                let cellSize = collectionProvider.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
                
                expect(cellSize) == expectedSize
            }
            
            it("should return correct cell class") {
                let indexPath = IndexPath(item: 0, section: 0)
                let cell = collectionProvider.collectionView(collectionView, cellForItemAt: indexPath)
                
                expect(cell).to(beAnInstanceOf(ProductOptionCollectionViewCell.self))
            }
        }
        
        describe("when item did select") {
            var values: [String]!
            var selectedValue: String!
            
            beforeEach {
                values = ["Value 1", "Value 2"]
                selectedValue = "Value 1"
                
                collectionProvider.values = values
                collectionProvider.selectedValue = selectedValue
            }
            
            it("should pass value to delegate") {
                let delegateMock = ProductOptionsCollectionCellProviderDelegateMock()
                collectionProvider.delegate = delegateMock
                
                let indexPath = IndexPath(item: 0, section: 0)
                collectionProvider.collectionView(collectionView, didSelectItemAt: indexPath)
                
                expect(delegateMock.provider) == collectionProvider
                expect(delegateMock.value) == values.first
            }
        }
    }
}
