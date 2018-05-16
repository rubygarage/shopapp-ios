//
//  AddressListTableViewCellSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/3/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class AddressListTableViewCellSpec: QuickSpec {
    override func spec() {
        var cell: AddressListTableViewCell!
        var customerNameLabel: UILabel!
        var addressLabel: UILabel!
        var phoneLabel: UILabel!
        var selectButton: UIButton!
        var editButton: UIButton!
        var deleteButton: UIButton!
        var defaultAddressButton: UIButton!
        var address: Address!
        
        beforeEach {
            let provider = CheckoutTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.registerNibForCell(AddressListTableViewCell.self)
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: AddressListTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            customerNameLabel = self.findView(withAccessibilityLabel: "customerNameLabel", in: cell) as! UILabel
            addressLabel = self.findView(withAccessibilityLabel: "addressLabel", in: cell) as! UILabel
            phoneLabel = self.findView(withAccessibilityLabel: "phoneLabel", in: cell) as! UILabel
            selectButton = self.findView(withAccessibilityLabel: "selectButton", in: cell) as! UIButton
            editButton = self.findView(withAccessibilityLabel: "editButton", in: cell) as! UIButton
            deleteButton = self.findView(withAccessibilityLabel: "deleteButton", in: cell) as! UIButton
            defaultAddressButton = self.findView(withAccessibilityLabel: "defaultAddressButton", in: cell) as! UIButton
            
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
            
            it("should have correct button images") {
                expect(selectButton.imageView?.image) == #imageLiteral(resourceName: "radio_btn_disabled")
            }
            
            it("should have correct button titles") {
                expect(editButton.title(for: .normal)) == "Button.Edit".localizable.uppercased()
                expect(deleteButton.title(for: .normal)) == "Button.Delete".localizable.uppercased()
                expect(defaultAddressButton.title(for: .normal)) == "Button.Default".localizable.uppercased()
            }
        }
        
        describe("when cell configured") {
            var isSelected: Bool!
            var isDefault: Bool!
            var showSelectionButton: Bool!
            
            context("when label's texts did set") {
                beforeEach {
                    isSelected = true
                    isDefault = true
                    showSelectionButton = true
                }
                
                context("if phone exist") {
                    beforeEach {
                        address.phone = "12345"
                        
                        cell.configure(with: address, isSelected: isSelected, isDefault: isDefault, showSelectionButton: showSelectionButton)
                    }
                    
                    it("should have correct customer name label text") {
                        expect(customerNameLabel.text) == address.fullName
                    }
                    
                    it("should have correct address label text") {
                        expect(addressLabel.text) == address.fullAddress
                    }
                    
                    it("should have correct phone label text") {
                        expect(phoneLabel.text) == String.localizedStringWithFormat("Label.Phone".localizable, address.phone!)
                    }
                }
                
                context("if phone doesn't exist") {
                    it("should have correct phone label text") {
                        cell.configure(with: address, isSelected: isSelected, isDefault: isDefault, showSelectionButton: showSelectionButton)
                        
                        expect(phoneLabel.text).to(beNil())
                    }
                }
            }
            
            context("when buttons did update") {
                context("if address selected, default and it needs to show selection button") {
                    beforeEach {
                        isSelected = true
                        isDefault = true
                        showSelectionButton = true
                        
                        cell.configure(with: address, isSelected: isSelected, isDefault: isDefault, showSelectionButton: showSelectionButton)
                    }
                    
                    it("should change select buttons's 'isSelected' property") {
                        expect(selectButton.isSelected) == true
                    }
                    
                    it("should change select buttons's 'isHidden' property") {
                        expect(selectButton.isHidden) == false
                    }
                    
                    it("should change delete buttons's 'isHidden' property") {
                        expect(deleteButton.isEnabled) == false
                    }
                    
                    it("should change default address buttons's 'isEnabled' property") {
                        expect(deleteButton.isEnabled) == false
                    }
                }
                
                context("if address not selected, not default and it not needs to show selection button") {
                    beforeEach {
                        isSelected = false
                        isDefault = false
                        showSelectionButton = false
                        
                        cell.configure(with: address, isSelected: isSelected, isDefault: isDefault, showSelectionButton: showSelectionButton)
                    }
                    
                    it("should change select buttons's 'isSelected' property") {
                        expect(selectButton.isSelected) == false
                    }
                    
                    it("should change select buttons's 'isHidden' property") {
                        expect(selectButton.isHidden) == true
                    }
                    
                    it("should change delete buttons's 'isHidden' property") {
                        expect(deleteButton.isEnabled) == true
                    }
                    
                    it("should change default address buttons's 'isEnabled' property") {
                        expect(deleteButton.isEnabled) == true
                    }
                }
            }
        }
        
        describe("when buttons did press") {
            var delegateMock: AddressListTableCellDelegateMock!
            
            beforeEach {
                delegateMock = AddressListTableCellDelegateMock()
                cell.delegate = delegateMock
                
                cell.configure(with: address, isSelected: true, isDefault: true, showSelectionButton: true)
            }
            
            context("if select button did press") {
                it("should notify delegate") {
                    selectButton.sendActions(for: .touchUpInside)
                    
                    expect(delegateMock.selectAddressDidPress) == true
                    expect(delegateMock.cell) === cell
                    expect(delegateMock.address) === address
                }
            }
            
            context("if edit button did press") {
                it("should notify delegate") {
                    editButton.sendActions(for: .touchUpInside)
                    
                    expect(delegateMock.editAddressDidPress) == true
                    expect(delegateMock.cell) === cell
                    expect(delegateMock.address) === address
                }
            }
            
            context("if delete button did press") {
                it("should notify delegate") {
                    deleteButton.sendActions(for: .touchUpInside)
                    
                    expect(delegateMock.deleteAddressDidPress) == true
                    expect(delegateMock.cell) === cell
                    expect(delegateMock.address) === address
                }
            }
            
            context("if default address button did press") {
                it("should notify delegate") {
                    defaultAddressButton.sendActions(for: .touchUpInside)
                    
                    expect(delegateMock.defaultAddressDidPress) == true
                    expect(delegateMock.cell) === cell
                    expect(delegateMock.address) === address
                }
            }
        }
    }
}
