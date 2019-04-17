//
//  CheckoutShippingOptionsEnabledTableViewCellSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/4/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CheckoutShippingOptionsEnabledTableViewCellSpec: QuickSpec {
    override func spec() {
        var cell: CheckoutShippingOptionsEnabledTableViewCell!
        var selectRateButton: UIButton!
        var priceLabel: UILabel!
        var titleLabel: UILabel!
        var shippingRate: ShippingRate!
        var currencyCode: String!
        var isRateSelected: Bool!
        
        beforeEach {
            let provider = CheckoutTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.registerNibForCell(CheckoutShippingOptionsEnabledTableViewCell.self)
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: CheckoutShippingOptionsEnabledTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            selectRateButton = self.findView(withAccessibilityLabel: "selectRateButton", in: cell) as? UIButton
            priceLabel = self.findView(withAccessibilityLabel: "priceLabel", in: cell) as? UILabel
            titleLabel = self.findView(withAccessibilityLabel: "titleLabel", in: cell) as? UILabel
            
            shippingRate = ShippingRate()
            shippingRate.title = "Rate title"
            shippingRate.price = "100"
            currencyCode = "USD"
        }
        
        describe("when cell initialized") {
            it("should have correct selection style") {
                expect(cell.selectionStyle.rawValue) == UITableViewCell.SelectionStyle.none.rawValue
            }
        }
        
        describe("when cell configured") {
            context("if rate selected") {
                beforeEach {
                    isRateSelected = true
                    
                    cell.configure(with: shippingRate, currencyCode: currencyCode, selected: isRateSelected)
                }
                
                it("should set not selected select rate button") {
                    expect(selectRateButton.isSelected) == true
                }
                
                it("should have have correct price label text") {
                    let formatter = NumberFormatter.formatter(with: currencyCode)
                    let price = NSDecimalNumber(string: shippingRate.price ?? "")
                    let expectedText = formatter.string(from: price)
                    expect(priceLabel.text) == expectedText
                }
                
                it("should have correct rate title label text") {
                    expect(titleLabel.text) == shippingRate.title
                }
            }
            
            context("if rate doesn't selected") {
                it("should set not selected select rate button") {
                    isRateSelected = false
                    
                    cell.configure(with: shippingRate, currencyCode: currencyCode, selected: isRateSelected)
                    
                    expect(selectRateButton.isSelected) == false
                }
            }
        }
        
        describe("when select shipping rate did press") {
            it("should notify delegate") {
                let delegateMock = CheckoutShippingOptionsEnabledTableCellDelegateMock()
                cell.delegate = delegateMock
                
                cell.configure(with: shippingRate, currencyCode: currencyCode, selected: false)
                
                selectRateButton.sendActions(for: .touchUpInside)
                
                expect(delegateMock.cell) === cell
                expect(delegateMock.shippingRate) === shippingRate
            }
        }
    }
}
