//
//  CheckoutShippingOptionsDisabledTableViewCellSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/4/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CheckoutShippingOptionsDisabledTableViewCellSpec: QuickSpec {
    override func spec() {
        var cell: CheckoutShippingOptionsDisabledTableViewCell!
        var addAddressLabel: UILabel!
        
        beforeEach {
            let provider = CheckoutTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.registerNibForCell(CheckoutShippingOptionsDisabledTableViewCell.self)
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: CheckoutShippingOptionsDisabledTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            addAddressLabel = self.findView(withAccessibilityLabel: "addAddressLabel", in: cell) as! UILabel
        }
        
        describe("when cell initialized") {
            it("should have correct selection style") {
                expect(cell.selectionStyle.rawValue) == UITableViewCellSelectionStyle.none.rawValue
            }
            
            it("should have correct labels titles") {
                expect(addAddressLabel.text) == "Label.Checkout.AddShippingAddress".localizable
            }
        }
    }
}
