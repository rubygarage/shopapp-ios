//
//  CheckoutSelectedTypeTableViewCellSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CheckoutSelectedTypeTableViewCellSpec: QuickSpec {
    override func spec() {
        var cell: CheckoutSelectedTypeTableViewCell!
        var paymentTypeImage: UIImageView!
        var paymentTypeLabel: UILabel!
        var editButton: UIButton!
        
        beforeEach {
            let provider = CheckoutTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.registerNibForCell(CheckoutSelectedTypeTableViewCell.self)
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: CheckoutSelectedTypeTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            paymentTypeImage = self.findView(withAccessibilityLabel: "paymentTypeImage", in: cell) as? UIImageView
            paymentTypeLabel = self.findView(withAccessibilityLabel: "paymentTypeLabel", in: cell) as? UILabel
            editButton = self.findView(withAccessibilityLabel: "editButton", in: cell) as? UIButton
        }
        
        describe("when cell initialized") {
            it("should have correct selection style") {
                expect(cell.selectionStyle.rawValue) == UITableViewCell.SelectionStyle.none.rawValue
            }
            
            it("should have correct edit button title") {
                expect(editButton.title(for: .normal)) == "Button.Edit".localizable.uppercased()
            }
        }
        
        describe("when cell initialized") {
            var type: PaymentType!
            
            context("if payment type is 'credit card'") {
                beforeEach {
                    type = .creditCard
                    cell.configure(type: type)
                }
                
                it("should have correct type label text") {
                    expect(paymentTypeLabel.text) == "Label.Payment.CreditCard".localizable
                }
                
                it("should have correct type image") {
                    expect(paymentTypeImage.image) == #imageLiteral(resourceName: "payment_card")
                }
            }
            
            context("if payment type is 'apple pay'") {
                var type: PaymentType!
                
                beforeEach {
                    type = .applePay
                    cell.configure(type: type)
                }
                
                it("should have correct type label text") {
                    expect(paymentTypeLabel.text) == "Label.Payment.ApplePay".localizable
                }
                
                it("should have correct type image") {
                    expect(paymentTypeImage.image) == #imageLiteral(resourceName: "payment_apple_pay")
                }
            }
        }
        
        describe("when edit button did press") {
            it("should notify delegate") {
                let delegateMock = CheckoutSelectedTypeTableCellDelegateMock()
                cell.delegate = delegateMock
            
                editButton.sendActions(for: .touchUpInside)

                expect(delegateMock.cell) === cell
            }
        }
    }
}
