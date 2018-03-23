//
//  CheckoutShippingAddressEditTableCellSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CheckoutShippingAddressEditTableCellSpec: QuickSpec {
    override func spec() {
        var cell: CheckoutShippingAddressEditTableCell!
        var nameLabel: UILabel!
        var addressLabel: UILabel!
        var phoneLabel: UILabel!
        var editButton: UIButton!
        
        beforeEach {
            let provider = OrderDetailsTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.delegate = provider
            tableView.registerNibForCell(CheckoutShippingAddressEditTableCell.self)
            
            let indexPath = IndexPath(row: 0, section: 2)
            let dequeuedCell: CheckoutShippingAddressEditTableCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            nameLabel = self.findView(withAccessibilityLabel: "name", in: cell) as! UILabel
            addressLabel = self.findView(withAccessibilityLabel: "address", in: cell) as! UILabel
            phoneLabel = self.findView(withAccessibilityLabel: "phone", in: cell) as! UILabel
            editButton = self.findView(withAccessibilityLabel: "edit", in: cell) as! UIButton
        }
        
        describe("when cell initialized") {
            it("should have correct selection style") {
                expect(cell.selectionStyle.rawValue) == UITableViewCellSelectionStyle.none.rawValue
            }
            
            it("should have correct title of edit button") {
                expect(editButton.title(for: .normal)) == "Button.Edit".localizable.uppercased()
            }
        }
        
        describe("when cell configured with address") {
            var address: Address!
            
            beforeEach {
                address = Address()
                address.firstName = "First"
                address.lastName = "Last"
                address.address = "Address"
            }
            
            it("needs to setup text of name label") {
                cell.configure(with: address)
                
                expect(nameLabel.text) == address.fullName
            }
            
            it("needs to setup text of address label") {
                cell.configure(with: address)
                
                expect(addressLabel.text) == address.fullAddress
            }
            
            context("if address has phone") {
                it("needs to setup text of phone label") {
                    address.phone = "Phone"
                    cell.configure(with: address)
                    
                    expect(phoneLabel.text) == String.localizedStringWithFormat("Label.Phone".localizable, address.phone!)
                }
            }
            
            context("if address hasn't phone") {
                it("needs to setup text of phone label") {
                    address.phone = nil
                    cell.configure(with: address)
                    
                    expect(phoneLabel.text).to(beNil())
                }
            }
        }
        
        describe("when user needs to change visibility of edit button") {
            it("needs to show/hide edit button") {
                let isVisible = false
                cell.setEditButtonVisible(isVisible)
                
                expect(editButton.isHidden) == !isVisible
            }
        }
        
        describe("when edit button pressed") {
            it("needs to notify delegate") {
                let delegateMock = CheckoutShippingAddressEditCellDelegateMock()
                cell.delegate = delegateMock
                editButton.sendActions(for: .touchUpInside)
                
                expect(delegateMock.cell) === cell
            }
        }
    }
}
