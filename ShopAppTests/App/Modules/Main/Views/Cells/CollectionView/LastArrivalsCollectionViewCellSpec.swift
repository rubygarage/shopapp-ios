//
//  LastArrivalsCollectionViewCellSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Quick
import Nimble
import ShopApp_Gateway

@testable import ShopApp

class LastArrivalsCollectionViewCellSpec: QuickSpec {
    override func spec() {
        var cell: LastArrivalsCollectionViewCell!
        var productImageView: UIImageView!
        var titleLabel: UILabel!
        var priceLabel: UILabel!
        
        beforeEach {
            let provider = LastArrivalsTableCellProvider()
            
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
            collectionView.registerNibForCell(LastArrivalsCollectionViewCell.self)
            
            collectionView.dataSource = provider
            collectionView.delegate = provider
            
            provider.products = [TestHelper.productWithoutAlternativePrice]
            collectionView.reloadData()
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: LastArrivalsCollectionViewCell = collectionView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            productImageView = self.findView(withAccessibilityLabel: "imageView", in: cell) as! UIImageView
            titleLabel = self.findView(withAccessibilityLabel: "titleLabel", in: cell) as! UILabel
            priceLabel = self.findView(withAccessibilityLabel: "priceLabel", in: cell) as! UILabel
        }
        
        describe("when cell configured") {
            var product: Product!
            
            beforeEach {
                product = TestHelper.productWithoutAlternativePrice
            }
            
            it("should have image") {
                cell.configure(with: product)
                
                expect(productImageView.image).toNot(beNil())
            }
            
            it("should have correct title label text") {
                cell.configure(with: product)
                
                expect(titleLabel.text) == product.title
            }
            
            context("if product hasn't alternative price") {
                it("should have correct price label text") {
                    cell.configure(with: product)
                    
                    let formatter = NumberFormatter.formatter(with: product.currency)
                    let price = NSDecimalNumber(decimal: product.price)
                    let formattedPrice = formatter.string(from: price)!
                    
                    expect(priceLabel.text) == formattedPrice
                }
            }
            
            context("if product has alternative price") {
                it("should have correct price label text") {
                    product = TestHelper.productWithAlternativePrice
                    cell.configure(with: product)
                    
                    let formatter = NumberFormatter.formatter(with: product.currency)
                    let localizedString = "Label.PriceFrom".localizable
                    let price = NSDecimalNumber(decimal: product.price)
                    let formattedPrice = formatter.string(from: price)!
                    let formattedLocalizedPrice = String.localizedStringWithFormat(localizedString, formattedPrice)
                    
                    expect(priceLabel.text) == formattedLocalizedPrice
                }
            }
        }
    }
}
