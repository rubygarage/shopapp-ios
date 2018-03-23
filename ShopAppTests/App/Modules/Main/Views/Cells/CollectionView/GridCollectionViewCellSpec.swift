//
//  GridCollectionViewCellSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class GridCollectionViewCellSpec: QuickSpec {
    override func spec() {
        var cell: GridCollectionViewCell!
        var productImageView: UIImageView!
        var titleLabel: UILabel!
        var priceLabel: UILabel!
        
        beforeEach {
            let provider = GridCollectionProvider()
            let collectionViewLayout = UICollectionViewLayout()
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
            collectionView.dataSource = provider
            collectionView.delegate = provider
            collectionView.registerNibForCell(GridCollectionViewCell.self)
            
            provider.products = [Product()]
            collectionView.reloadData()
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: GridCollectionViewCell = collectionView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            productImageView = self.findView(withAccessibilityLabel: "imageView", in: cell) as! UIImageView
            titleLabel = self.findView(withAccessibilityLabel: "titleLabel", in: cell) as! UILabel
            priceLabel = self.findView(withAccessibilityLabel: "priceLabel", in: cell) as! UILabel
        }
        
        describe("when cell size and insets requested") {
            it("should return correct cell size") {
                let screenWidth = UIScreen.main.bounds.size.width
                let collectionViewWidth = screenWidth - 2 * 7
                let cellWidth = (collectionViewWidth - 7) / 2
                let cellRatio: CGFloat = 210 / 185
                let cellHeight = Float(cellWidth * cellRatio)
                let roundedCellheight = CGFloat(lroundf(cellHeight))
                let cellSize = CGSize(width: cellWidth, height: roundedCellheight)
                
                expect(GridCollectionViewCell.cellSize) == cellSize
            }
            
            it("should return correct default collection view insets") {
                expect(GridCollectionViewCell.defaultCollectionViewInsets) == UIEdgeInsets(top: 20, left: 7, bottom: 20, right: 7)
            }
            
            it("should return correct popular collection view insets") {
                expect(GridCollectionViewCell.popularCollectionViewInsets) == UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
            }
            
            it("should return correct search collection view insets") {
                expect(GridCollectionViewCell.searchCollectionViewInsets) == UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
            }
            
            it("should returnn correct sortable collection view insets") {
                expect(GridCollectionViewCell.sortableCollectionViewInsets) == UIEdgeInsets(top: 80, left: 7, bottom: 20, right: 7)
            }
        }
        
        describe("when cell configured") {
            var product: Product!
            
            beforeEach {
                product = Product()
                product.title = "Product title"
                product.currency = "USD"
                product.price = Decimal(floatLiteral: 10)
            }
            
            context("if product has alternative price") {
                beforeEach {
                    product.hasAlternativePrice = true
                    cell.configure(with: product)
                }
                
                it("should have image view") {
                    expect(productImageView.image).toNot(beNil())
                }
                
                it("should have correct title ") {
                    expect(titleLabel.text) == product.title
                }
                
                it("should have correct price label text") {
                    let formatter = NumberFormatter.formatter(with: product.currency!)
                    let localizedString = "Label.PriceFrom".localizable
                    let price = NSDecimalNumber(decimal: product.price!)
                    let formattedPrice = formatter.string(from: price)!
                    let expectedText = String.localizedStringWithFormat(localizedString, formattedPrice)
                    
                    expect(priceLabel.text) == expectedText
                }
            }
            
            context("and if hasn't alternative price") {
                beforeEach {
                    product.hasAlternativePrice = false
                    cell.configure(with: product)
                }
                
                it("should have image view") {
                    expect(productImageView.image).toNot(beNil())
                }
                
                it("should have correct title ") {
                    expect(titleLabel.text) == product.title
                }
                
                it("should have correct price label text") {
                    let formatter = NumberFormatter.formatter(with: product.currency!)
                    let price = NSDecimalNumber(decimal: product.price!)
                    let expectedText = formatter.string(from: price)!
                    
                    expect(priceLabel.text) == expectedText
                }
            }
        }
    }
}
