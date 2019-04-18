//
//  PaymentTypeTableViewCellSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/4/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class PaymentTypeTableViewCellSpec: QuickSpec {
    override func spec() {
        var cell: PaymentTypeTableViewCell!
        var paymentTypeLabel: UILabel!
        var paymentTypeImage: UIImageView!
        var selectedImageView: UIImageView!
        
        beforeEach {
            let provider = CheckoutTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.registerNibForCell(PaymentTypeTableViewCell.self)
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: PaymentTypeTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            paymentTypeLabel = self.findView(withAccessibilityLabel: "paymentTypeLabel", in: cell) as? UILabel
            paymentTypeImage = self.findView(withAccessibilityLabel: "paymentTypeImage", in: cell) as? UIImageView
            selectedImageView = self.findView(withAccessibilityLabel: "selectedImageView", in: cell) as? UIImageView
        }
        
        describe("when cell initialized") {
            it("should have correct selection style") {
                expect(cell.selectionStyle.rawValue) == UITableViewCell.SelectionStyle.none.rawValue
            }
            
            it("should have correct payment type label text") {
                expect(paymentTypeLabel.text) == "Label.Payment.CreditCard".localizable
            }
        }
        
        describe("when cell configured") {
            var paymentType: PaymentType!
            var isTypeSelected: Bool!
            
            context("if type is apple pay and type selected") {
                beforeEach {
                    paymentType = .applePay
                    isTypeSelected = true
                    
                    cell.configure(with: paymentType, selected: isTypeSelected)
                }
                
                it("should have correct payment type label text") {
                    expect(paymentTypeLabel.text) == "Label.Payment.ApplePay".localizable
                }
                
                it("should have correct payment type image") {
                    expect(paymentTypeImage.image) == #imageLiteral(resourceName: "payment_apple_pay")
                }
                
                it("should have correct selected image view image") {
                    expect(selectedImageView.image) == #imageLiteral(resourceName: "radio_btn_selected")
                }
            }
            
            context("if type is credit card and type not selected") {
                beforeEach {
                    paymentType = .creditCard
                    isTypeSelected = false
                    
                    cell.configure(with: paymentType, selected: isTypeSelected)
                }
                
                it("should have correct payment type label text") {
                    expect(paymentTypeLabel.text) == "Label.Payment.CreditCard".localizable
                }
                
                it("should have correct payment type image") {
                    expect(paymentTypeImage.image) == #imageLiteral(resourceName: "payment_card")
                }
                
                it("should have correct selected image view image") {
                    expect(selectedImageView.image) == #imageLiteral(resourceName: "radio_btn_disabled")
                }
            }
        }
    }
}
