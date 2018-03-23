//
//  ProductOptionCollectionViewCellSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Quick
import Nimble
import ShopApp_Gateway

@testable import ShopApp

class ProductOptionCollectionViewCellSpec: QuickSpec {
    override func spec() {
        var cell: ProductOptionCollectionViewCell!
        var collectionView: UICollectionView!
        var optionTitleLabel: UILabel!
        
        beforeEach {
            let provider = ProductOptionsCollectionCellProvider()
            
            collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
            collectionView.registerNibForCell(ProductOptionCollectionViewCell.self)
            
            collectionView.dataSource = provider
            collectionView.delegate = provider
            
            provider.values = ["Value 1"]
            provider.selectedValue = "Value 1"
            collectionView.reloadData()
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: ProductOptionCollectionViewCell = collectionView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            optionTitleLabel = self.findView(withAccessibilityLabel: "label", in: cell) as! UILabel
        }
        
        describe("when cell configured") {
            var text: String!
            var selected: Bool!
            
            beforeEach {
                text = "Text"
            }
            
            it("should have correct corner radius") {
                cell.configure(with: "", selected: true)
                
                expect(cell.layer.cornerRadius) == cell.frame.size.height / 2
            }
            
            it("should have correct title") {
                cell.configure(with: text, selected: true)
                
                expect(optionTitleLabel.text) == text
            }
            
            context("if option selected") {
                beforeEach {
                    selected = true
                    cell.configure(with: text, selected: selected)
                }
                
                it("should have correct text color") {
                    expect(optionTitleLabel.textColor) == .white
                }
                
                it("should have correct background color") {
                    expect(cell.backgroundColor) == .black
                }
            }
            
            context("if option doesn't selected") {
                beforeEach {
                    selected = false
                    cell.configure(with: text, selected: selected)
                }
                
                it("should have correct text color") {
                    expect(optionTitleLabel.textColor) == .black
                }
                
                it("should have correct background color") {
                    expect(cell.backgroundColor) == UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
                }
            }
        }
    }
}
