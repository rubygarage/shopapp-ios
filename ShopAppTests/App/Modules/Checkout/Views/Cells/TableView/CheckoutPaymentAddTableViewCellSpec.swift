//
//  CheckoutPaymentAddTableViewCellSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CheckoutPaymentAddTableViewCellSpec: QuickSpec {
    override func spec() {
        var cell: CheckoutPaymentAddTableViewCell!
        var addPaymentButton: BlackButton!
        
        beforeEach {
            let provider = CheckoutTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.registerNibForCell(CheckoutPaymentAddTableViewCell.self)
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: CheckoutPaymentAddTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            addPaymentButton = self.findView(withAccessibilityLabel: "addPaymentButton", in: cell) as! BlackButton
        }
        
        describe("when cell initialized") {
            it("should have correct selection style") {
                expect(cell.selectionStyle.rawValue) == UITableViewCellSelectionStyle.none.rawValue
            }
        }
        
        describe("when cell configured") {
            context("if payment add cell type is 'type'") {
                it("should set correct add payment button title") {
                    cell.configure(type: .type)
                    
                    expect(addPaymentButton.title(for: .normal)) == "Button.AddPaymentType".localizable.uppercased()
                }
            }
            
            context("if payment add cell type is 'card'") {
                it("should set correct add payment button title") {
                    cell.configure(type: .card)
                    
                    expect(addPaymentButton.title(for: .normal)) == "Button.AddCard".localizable.uppercased()
                }
            }
            
            context("if payment add cell type is 'billingAddress'") {
                it("should set correct add payment button title") {
                    cell.configure(type: .billingAddress)
                    
                    expect(addPaymentButton.title(for: .normal)) == "Button.AddBillingAddress".localizable.uppercased()
                }
            }
        }
        
        describe("when add payment did press") {
            it("should notify delegate") {
                let delegateMock = CheckoutPaymentAddCellDelegateMock()
                cell.delegate = delegateMock
                
                let type: PaymentAddCellType = .type
                cell.configure(type: .type)
                
                addPaymentButton.sendActions(for: .touchUpInside)
                
                expect(delegateMock.cell) === cell
                expect(delegateMock.paymentType) == type
            }
        }
    }
}
