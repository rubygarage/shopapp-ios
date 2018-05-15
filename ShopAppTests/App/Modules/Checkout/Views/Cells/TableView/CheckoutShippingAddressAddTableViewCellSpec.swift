//
//  CheckoutShippingAddressAddTableViewCellSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/4/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CheckoutShippingAddressAddTableViewCellSpec: QuickSpec {
    override func spec() {
        var cell: CheckoutShippingAddressAddTableViewCell!
        var addNewAddressButton: BlackButton!
        
        beforeEach {
            let provider = CheckoutTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.registerNibForCell(CheckoutShippingAddressAddTableViewCell.self)
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: CheckoutShippingAddressAddTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            addNewAddressButton = self.findView(withAccessibilityLabel: "addNewAddressButton", in: cell) as! BlackButton
        }
        
        describe("when cell initialized") {
            it("should have correct selection style") {
                expect(cell.selectionStyle.rawValue) == UITableViewCellSelectionStyle.none.rawValue
            }
            
            it("should have correct buttons titles") {
                expect(addNewAddressButton.title(for: .normal)) == "Button.AddNewAddress".localizable.uppercased()
            }
        }
        
        describe("when add new address did press") {
            it("should notify delegate") {
                let delegateMock = CheckoutShippingAddressAddCellDelegateMock()
                cell.delegate = delegateMock
                
                addNewAddressButton.sendActions(for: .touchUpInside)
                
                expect(delegateMock.cell) === cell
            }
        }
    }
}
