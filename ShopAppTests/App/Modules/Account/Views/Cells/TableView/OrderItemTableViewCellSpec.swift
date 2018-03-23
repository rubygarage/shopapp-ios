//
//  OrderItemTableViewCellSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class OrderItemTableViewCellSpec: QuickSpec {
    override func spec() {
        var cell: OrderItemTableViewCell!
        var itemImageView: UIImageView!
        var totalPriceLabel: UILabel!
        var titleLabel: UILabel!
        var subtitleLabel: UILabel!
        var quantityLabel: UILabel!
        var quantityValueLabel: UILabel!
        var itemPriceLabel: UILabel!
        
        beforeEach {
            let provider = OrderDetailsTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.delegate = provider
            tableView.registerNibForCell(OrderItemTableViewCell.self)
            
            let indexPath = IndexPath(row: 1, section: 0)
            let dequeuedCell: OrderItemTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            itemImageView = self.findView(withAccessibilityLabel: "image", in: cell) as! UIImageView
            totalPriceLabel = self.findView(withAccessibilityLabel: "totalPrice", in: cell) as! UILabel
            titleLabel = self.findView(withAccessibilityLabel: "title", in: cell) as! UILabel
            subtitleLabel = self.findView(withAccessibilityLabel: "subtitle", in: cell) as! UILabel
            quantityLabel = self.findView(withAccessibilityLabel: "quantity", in: cell) as! UILabel
            quantityValueLabel = self.findView(withAccessibilityLabel: "quantityValue", in: cell) as! UILabel
            itemPriceLabel = self.findView(withAccessibilityLabel: "itemPrice", in: cell) as! UILabel
        }
        
        describe("when cell initialized") {
            it("should have correct selection style") {
                expect(cell.selectionStyle.rawValue) == UITableViewCellSelectionStyle.none.rawValue
            }
            
            it("should have correct quantity text") {
                expect(quantityLabel.text) == "Label.Order.Quantity".localizable
            }
        }
        
        describe("when cell configured") {
            let currencyCode = "UAH"
            
            var orderItem: OrderItem!
            var productVariant: ProductVariant!
            
            beforeEach {
                orderItem = OrderItem()
                orderItem.title = "Order title"
                orderItem.quantity = 2
            }
            
            it("should have correct image, title and quantity texts") {
                cell.configure(with: orderItem, currencyCode: currencyCode)
                
                expect(itemImageView.image).toNot(beNil())
                expect(titleLabel.text) == "Order title"
                expect(quantityValueLabel.text) == "2"
            }
            
            context("when order item hasn't product variant") {
                it("should have correct total price and submit texts, hidden item price") {
                    cell.configure(with: orderItem, currencyCode: currencyCode)
                    
                    expect(totalPriceLabel.text) == "Label.N/A".localizable
                    expect(subtitleLabel.text).to(beNil())
                    expect(itemPriceLabel.isHidden) == true
                }
            }
            
            context("when order item has product variant") {
                beforeEach {
                    productVariant = ProductVariant()
                    productVariant.title = "Product variant title"
                    productVariant.price = 29.99
                    
                    orderItem.productVariant = productVariant
                }
                
                it("should have correct total price and item price texts") {
                    cell.configure(with: orderItem, currencyCode: currencyCode)
                    
                    expect(totalPriceLabel.text) == "UAH59.98"
                    expect(itemPriceLabel.isHidden) == false
                    expect(itemPriceLabel.text) == String.localizedStringWithFormat("Label.PriceEach".localizable, "UAH29.99")
                }
                
                context("if it haven't selected option of product variant") {
                    it("shouldn't have subtitle text") {
                        cell.configure(with: orderItem, currencyCode: currencyCode)
                        
                        expect(subtitleLabel.text).to(beNil())
                    }
                }
                
                context("if it have selected option of product variant") {
                    it("should have correct subtitle text") {
                        let firstVariantOption = VariantOption()
                        firstVariantOption.name = "First name"
                        firstVariantOption.value = "First value"
                        
                        let secondVariantOption = VariantOption()
                        secondVariantOption.name = "Second name"
                        secondVariantOption.value = "Second value"
                        
                        productVariant.selectedOptions = [firstVariantOption, secondVariantOption]
                        
                        let firstPartOfSubtitle = String.localizedStringWithFormat("Label.Order.Option".localizable, "First name", "First value")
                        let secondPartOfSubtitle = String.localizedStringWithFormat("Label.Order.Option".localizable, "Second name", "Second value")
                        let subtitle = firstPartOfSubtitle + "\n" + secondPartOfSubtitle
                        
                        cell.configure(with: orderItem, currencyCode: currencyCode)
                        
                        expect(subtitleLabel.text) == subtitle
                    }
                }
            }
        }
    }
}
