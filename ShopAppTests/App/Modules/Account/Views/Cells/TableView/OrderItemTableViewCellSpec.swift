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
            
            itemImageView = self.findView(withAccessibilityLabel: "image", in: cell) as? UIImageView
            totalPriceLabel = self.findView(withAccessibilityLabel: "totalPrice", in: cell) as? UILabel
            titleLabel = self.findView(withAccessibilityLabel: "title", in: cell) as? UILabel
            subtitleLabel = self.findView(withAccessibilityLabel: "subtitle", in: cell) as? UILabel
            quantityLabel = self.findView(withAccessibilityLabel: "quantity", in: cell) as? UILabel
            quantityValueLabel = self.findView(withAccessibilityLabel: "quantityValue", in: cell) as? UILabel
            itemPriceLabel = self.findView(withAccessibilityLabel: "itemPrice", in: cell) as? UILabel
        }
        
        describe("when cell initialized") {
            it("should have correct selection style") {
                expect(cell.selectionStyle.rawValue) == UITableViewCell.SelectionStyle.none.rawValue
            }
            
            it("should have correct quantity text") {
                expect(quantityLabel.text) == "Label.Order.Quantity".localizable
            }
        }
        
        describe("when cell configured") {
            let currencyCode = "UAH"
            
            var orderProduct: OrderProduct!
            
            beforeEach {
                orderProduct = TestHelper.orderProductWithoutProductVariant
            }
            
            it("should have correct image, title and quantity texts") {
                cell.configure(with: orderProduct, currencyCode: currencyCode)
                
                expect(itemImageView.image).toNot(beNil())
                expect(titleLabel.text) == orderProduct.title
                expect(quantityValueLabel.text) == String(orderProduct.quantity)
            }
            
            context("when order item hasn't product variant") {
                it("should have correct total price and submit texts, hidden item price") {
                    cell.configure(with: orderProduct, currencyCode: currencyCode)
                    
                    expect(totalPriceLabel.text) == "Label.N/A".localizable
                    expect(subtitleLabel.text).to(beNil())
                    expect(itemPriceLabel.isHidden) == true
                }
            }
            
            context("when order item has product variant") {
                beforeEach {
                    orderProduct = TestHelper.orderProductWithoutSelectedOptions
                }
                
                it("should have correct total price and item price texts") {
                    cell.configure(with: orderProduct, currencyCode: currencyCode)
                    
                    expect(totalPriceLabel.text) == "UAH20.00"
                    expect(itemPriceLabel.isHidden) == false
                    expect(itemPriceLabel.text) == String.localizedStringWithFormat("Label.PriceEach".localizable, "UAH10.00")
                }
                
                context("if it haven't selected option of product variant") {
                    it("shouldn't have subtitle text") {
                        cell.configure(with: orderProduct, currencyCode: currencyCode)
                        
                        expect(subtitleLabel.text).to(beNil())
                    }
                }

                context("if it have selected option of product variant") {
                    it("should have correct subtitle text") {
                        orderProduct = TestHelper.orderProductWithSelectedOptions
                        
                        let firstSelectedOption = orderProduct.productVariant!.selectedOptions.first!
                        let firstPartOfSubtitle = String.localizedStringWithFormat("Label.Order.Option".localizable, firstSelectedOption.name, firstSelectedOption.value)
                        
                        let secondSelectedOption = orderProduct.productVariant!.selectedOptions.last!
                        let secondPartOfSubtitle = String.localizedStringWithFormat("Label.Order.Option".localizable, secondSelectedOption.name, secondSelectedOption.value)
                        
                        let subtitle = firstPartOfSubtitle + "\n" + secondPartOfSubtitle

                        cell.configure(with: orderProduct, currencyCode: currencyCode)
                        
                        expect(subtitleLabel.text) == subtitle
                    }
                }
            }
        }
    }
}
