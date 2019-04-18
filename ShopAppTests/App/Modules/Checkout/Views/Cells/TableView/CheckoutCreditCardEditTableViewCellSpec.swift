//
//  CheckoutCreditCardEditTableViewCellSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CheckoutCreditCardEditTableViewCellSpec: QuickSpec {
    override func spec() {
        var cell: CheckoutCreditCardEditTableViewCell!
        var cardTypeImageView: UIImageView!
        var cardNumberLabel: UILabel!
        var expirationDateLabel: UILabel!
        var holderNameLabel: UILabel!
        var editButton: UIButton!
        
        beforeEach {
            let provider = CheckoutTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.registerNibForCell(CheckoutCreditCardEditTableViewCell.self)
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: CheckoutCreditCardEditTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            cardTypeImageView = self.findView(withAccessibilityLabel: "cardTypeImageView", in: cell) as? UIImageView
            cardNumberLabel = self.findView(withAccessibilityLabel: "cardNumberLabel", in: cell) as? UILabel
            expirationDateLabel = self.findView(withAccessibilityLabel: "expirationDateLabel", in: cell) as? UILabel
            holderNameLabel = self.findView(withAccessibilityLabel: "holderNameLabel", in: cell) as? UILabel
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
        
        describe("when cell configured") {
            var creditCard: CreditCard!
            
            beforeEach {
                creditCard = CreditCard()
                creditCard.firstName = "First name"
                creditCard.lastName = "Last name"
                creditCard.cardNumber = "4111111111111111"
                creditCard.expireMonth = "12"
                creditCard.expireYear = "20"
                creditCard.verificationCode = "123"
                
                cell.configure(with: creditCard)
            }
            
            it("should have correct card number label") {
                expect(cardNumberLabel.text) == creditCard.maskedNumber
            }
            
            it("should have correct expiration date label") {
                expect(expirationDateLabel.text) == creditCard.expirationDateLocalized
            }
            
            it("should have correct holder name label") {
                expect(holderNameLabel.text) == creditCard.holderName
            }
            
            it("should have correct card type image") {
                expect(cardTypeImageView.image) == UIImage(named: creditCard.cardImageName)
            }
        }
        
        describe("when edit button did press") {
            it("should notify delegate") {
                let delegateMock = CheckoutCreditCardEditTableCellDelegateMock()
                cell.delegate = delegateMock
                
                editButton.sendActions(for: .touchUpInside)
                
                expect(delegateMock.cell) === cell
            }
        }
    }
}
