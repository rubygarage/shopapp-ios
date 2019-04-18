//
//  ProductOptionsCollectionViewCellSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Quick
import Nimble
import ShopApp_Gateway

@testable import ShopApp

class ProductOptionsCollectionViewCellSpec: QuickSpec {
    override func spec() {
        var cell: ProductOptionsCollectionViewCell!
        var collectionView: UICollectionView!
        
        beforeEach {
            let provider = ProductOptionsCollectionProvider()
            
            let controllerCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
            controllerCollectionView.registerNibForCell(ProductOptionsCollectionViewCell.self)
            
            controllerCollectionView.dataSource = provider
            controllerCollectionView.delegate = provider
            
            let option = ProductOption()
            option.name = "Option name"
            option.values = ["Option value 1", "Option value 2"]
            provider.options = [option]
            controllerCollectionView.reloadData()
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: ProductOptionsCollectionViewCell = controllerCollectionView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            collectionView = self.findView(withAccessibilityLabel: "collectionView", in: cell) as? UICollectionView
        }
        
        describe("when cell configured") {
            var values: [String]!
            var delegate: ProductOptionsCollectionCellDelegateMock!
            
            beforeEach {
                values = ["Value 1", "Value 2"]
                let selectedValue = "Value 1"
                delegate = ProductOptionsCollectionCellDelegateMock()
                cell.configure(with: values, selectedValue: selectedValue, delegate: delegate)
            }
            
            it("should have correct sections count") {
                expect(collectionView.numberOfSections) == 1
            }
            
            it("should have correct items count") {
                expect(collectionView.numberOfItems(inSection: 0)) == values.count
            }
            
            it("should set delegate") {
                expect(cell.delegate) === delegate
            }
        }
        
        describe("when option value did select") {
            var values: [String]!
            var delegateMock: ProductOptionsCollectionCellDelegateMock!
            let selectedValue = "Value 1"
            
            beforeEach {
                values = ["Value 1", "Value 2"]
                delegateMock = ProductOptionsCollectionCellDelegateMock()
                cell.configure(with: values, selectedValue: selectedValue, delegate: delegateMock)
            }
            
            it("should pass value option to delegate") {
                let provider = ProductOptionsCollectionCellProvider()
                cell.provider(provider, didSelect: selectedValue)
                
                expect(delegateMock.collectionViewCell) == cell
                expect(delegateMock.values) == values
                expect(delegateMock.selectedValue) == selectedValue
            }
        }
    }
}
