//
//  CheckoutBillingAddressEditTableViewCellSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CheckoutBillingAddressEditTableViewCellSpec: QuickSpec {
    override func spec() {
        var cell: CheckoutBillingAddressEditTableViewCell!
        var addressTitleLabel: UILabel!
        var nameLabel: UILabel!
        var addressDescriptionLabel: UILabel!
        var phoneLabel: UILabel!
        var editButton: UIButton!
        var address: Address!
        
        beforeEach {
            let provider = CheckoutTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.registerNibForCell(CheckoutBillingAddressEditTableViewCell.self)
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: CheckoutBillingAddressEditTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            addressTitleLabel = self.findView(withAccessibilityLabel: "addressTitleLabel", in: cell) as! UILabel
            nameLabel = self.findView(withAccessibilityLabel: "nameLabel", in: cell) as! UILabel
            addressDescriptionLabel = self.findView(withAccessibilityLabel: "addressDescriptionLabel", in: cell) as! UILabel
            phoneLabel = self.findView(withAccessibilityLabel: "phoneLabel", in: cell) as! UILabel
            editButton = self.findView(withAccessibilityLabel: "editButton", in: cell) as! UIButton
            
            address = Address()
            address.address = "Address"
            address.secondAddress = "Second address"
            address.city = "City"
            address.zip = "Zip"
            address.country = "Country"
        }
        
        describe("when cell initialized") {
            it("should have correct selection style") {
                expect(cell.selectionStyle.rawValue) == UITableViewCellSelectionStyle.none.rawValue
            }
            
            it("should have correct edit button title") {
                expect(editButton.title(for: .normal)) == "Button.Edit".localizable.uppercased()
            }
        }
        
        describe("when cell configured") {
            context("if phone exist") {
                beforeEach {
                    address.phone = "12345"
                    
                    cell.configure(with: address)
                }
                
                it("should have correct address title label text") {
                    expect(addressTitleLabel.text) == "Label.BillingAddress".localizable
                }
                
                it("should have correct name label text") {
                    expect(nameLabel.text) == address.fullName
                }
                
                it("should have correct address description label text") {
                    expect(addressDescriptionLabel.text) == address.fullAddress
                }
                
                it("should have correct phone label text") {
                    expect(phoneLabel.text) == String.localizedStringWithFormat("Label.Phone".localizable, address.phone!)
                }
            }
            
            context("if phone doesn't exist") {
                it("shouldn't have phone label text") {
                    address.phone = nil
                    
                    cell.configure(with: address)
                    
                    expect(phoneLabel.text).to(beNil())
                }
            }
        }
        
        describe("when edit button did press") {
            it("should notify delegate") {
                let delegateMock = CheckoutBillingAddressEditCellDelegateMock()
                cell.delegate = delegateMock
                
                editButton.sendActions(for: .touchUpInside)
                
                expect(delegateMock.cell) === cell
            }
        }
    }
}
