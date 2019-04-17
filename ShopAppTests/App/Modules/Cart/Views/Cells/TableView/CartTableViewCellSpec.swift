//
//  CartTableViewCellSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CartTableViewCellSpec: QuickSpec {
    override func spec() {
        var cell: CartTableViewCell!
        var quantityLabel: UILabel!
        var quantityDropDownView: QuantityDropDownView!
        var variantImageView: UIImageView!
        var variantTitleLabel: UILabel!
        var totalPriceLabel: UILabel!
        var pricePerOneItemLabel: UILabel!
        var delegateMock: CartTableCellDelegateMock!
        
        beforeEach {
            let provider = CartTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.registerNibForCell(CartTableViewCell.self)
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: CartTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            delegateMock = CartTableCellDelegateMock()
            cell.cellDelegate = delegateMock
            
            quantityLabel = self.findView(withAccessibilityLabel: "quantityLabel", in: cell) as! UILabel
            quantityDropDownView = self.findView(withAccessibilityLabel: "quantityDropDownView", in: cell) as! QuantityDropDownView
            variantImageView = self.findView(withAccessibilityLabel: "variantImageView", in: cell) as! UIImageView
            variantTitleLabel = self.findView(withAccessibilityLabel: "variantTitleLabel", in: cell) as! UILabel
            totalPriceLabel = self.findView(withAccessibilityLabel: "totalPriceLabel", in: cell) as! UILabel
            pricePerOneItemLabel = self.findView(withAccessibilityLabel: "pricePerOneItemLabel", in: cell) as! UILabel
        }
        
        describe("when cell initialized") {
            it("should have correct selection style") {
                expect(cell.selectionStyle.rawValue) == UITableViewCell.SelectionStyle.none.rawValue
            }
            
            it("should have correct label titles") {
                expect(quantityLabel.text) == "Label.Quantity".localizable
            }
            
            it("should have correct quantity text field delegate") {
                expect(quantityDropDownView.delegate) === cell
            }
            
            it("should have hidden price per one label") {
                expect(pricePerOneItemLabel.isHidden) == true
            }
        }
        
        describe("when cell configured") {
            var cartProduct: CartProduct!
            
            context("if cart product nil") {
                beforeEach {
                    cell.configure(with: nil)
                }
                
                it("should have correct image") {
                    expect(variantImageView.image).toNot(beNil())
                }
                
                it("should haven't variant title label text") {
                    expect(variantTitleLabel.text).to(beNil())
                }
                
                it("should have correct quantity label text") {
                    expect(quantityDropDownView.text) == "0"
                }
                
                it("should have correct total price label text") {
                    expect(totalPriceLabel.text).to(beNil())
                }
                
                it("should hide price per one label") {
                    expect(pricePerOneItemLabel.isHidden) == true
                }
            }
            
            context("and if not nil and quantity more than 1") {
                beforeEach {
                    cartProduct = CartProduct()
                    cartProduct.productTitle = "Product title"
                    cartProduct.quantity = 10
                    cartProduct.currency = "USD"
                    
                    let productVariant = ProductVariant()
                    productVariant.title = "Variant title"
                    productVariant.price = Decimal(floatLiteral: 15)
                    
                    let image = Image()
                    image.src = "https://via.placeholder.com/100x100"
                    
                    cartProduct.productVariant = productVariant
                    
                    cell.configure(with: cartProduct)
                }
                
                it("should have correct image") {
                    expect(variantImageView.image).toNot(beNil())
                }
                
                it("should have correct variant title label text") {
                    expect(variantTitleLabel.text) == "Product title Variant title"
                }
                
                it("should have correct quantity label text") {
                    expect(quantityDropDownView.text) == "10"
                }
                
                it("should have correct total price label text") {
                    let formatter = NumberFormatter.formatter(with: cartProduct.currency!)
                    let price = NSDecimalNumber(decimal: cartProduct.productVariant!.price!)
                    let quantity = Double(cartProduct.quantity)
                    let totalPrice = NSDecimalNumber(value: price.doubleValue * quantity)
                    let expectedTotalPriceText = formatter.string(from: totalPrice)
                    
                    expect(totalPriceLabel.text) == expectedTotalPriceText
                }
                
                it("should show price per one label") {
                    expect(pricePerOneItemLabel.isHidden) == false
                }
                
                it("should have correct price per one label text") {
                    let formatter = NumberFormatter.formatter(with: cartProduct.currency!)
                    let price = NSDecimalNumber(decimal: cartProduct.productVariant!.price!)
                    let localizedString = "Label.PriceEach".localizable
                    let formattedPrice = formatter.string(from: price)!
                    let expectedPricePerOneText = String.localizedStringWithFormat(localizedString, formattedPrice)
                    
                    expect(pricePerOneItemLabel.text) == expectedPricePerOneText
                }
            }
            
            context("if not nil and quantity is 1") {
                beforeEach {
                    cartProduct = CartProduct()
                    cartProduct.quantity = 1
                    
                    cell.configure(with: cartProduct)
                }
                
                it("should hide price per one label") {
                    expect(pricePerOneItemLabel.isHidden) == true
                }
            }
            
            context("if it hasn't currency and price") {
                beforeEach {
                    cartProduct = CartProduct()
                    cartProduct.quantity = 5
                    
                    cell.configure(with: cartProduct)
                }
                
                it("should show zero price") {
                    let currency = cartProduct.currency ?? ""
                    let formatter = NumberFormatter.formatter(with: currency)
                    let price = NSDecimalNumber(decimal: cartProduct.productVariant?.price ?? Decimal())
                    let localizedString = "Label.PriceEach".localizable
                    let formattedPrice = formatter.string(from: price)!
                    let expectedPricePerOneText = String.localizedStringWithFormat(localizedString, formattedPrice)
                    
                    expect(pricePerOneItemLabel.text) == expectedPricePerOneText
                }
            }
        }
        
        describe("when quantity updated") {
            var cartProduct: CartProduct!
            
            beforeEach {
                cartProduct = CartProduct()
                cell.configure(with: cartProduct)
            }
            
            context("if quantity less than 5") {
                it("should notify delegate") {
                    quantityDropDownView.text = "3"
                    quantityDropDownView.textField.sendActions(for: .editingDidEnd)
                    
                    expect(delegateMock.cell) == cell
                    expect(delegateMock.updatedCartProduct) === cartProduct
                    expect(delegateMock.updatedQuantity) == 3
                }
            }
            
            context("if quantity more than 5") {
                it("should notify delegate") {
                    let count = 10
                    let view = QuantityDropDownView()
                    cell.quantityDropDownView(view, didSelectMoreWith: count)
                    
                    expect(delegateMock.cell) == cell
                    expect(delegateMock.updatedCartProduct) === cartProduct
                    expect(delegateMock.updatedQuantity) == count
                }
            }
        }
    }
}
