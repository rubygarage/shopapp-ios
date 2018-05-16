//
//  CustomerEmailTableViewCellSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/4/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CustomerEmailTableViewCellSpec: QuickSpec {
    override func spec() {
        var cell: CustomerEmailTableViewCell!
        var emailTextFieldView: InputTextFieldView!
        
        beforeEach {
            let provider = CheckoutTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.registerNibForCell(CustomerEmailTableViewCell.self)
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: CustomerEmailTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            emailTextFieldView = self.findView(withAccessibilityLabel: "emailTextFieldView", in: cell) as! InputTextFieldView
        }
        
        describe("when cell initialized") {
            it("should have correct selection style") {
                expect(cell.selectionStyle.rawValue) == UITableViewCellSelectionStyle.none.rawValue
            }
            
            it("should have correct email textfield view placeholder") {
                expect(emailTextFieldView.placeholder) == "Placeholder.Email".localizable.required.uppercased()
            }
        }
        
        describe("when delegate did set") {
            it("should set delegate to email textfield view") {
                let delegateMock = InputTextFieldViewDelegateMock()
                cell.delegate = delegateMock
                
                expect(emailTextFieldView.delegate) === delegateMock
            }
        }
    }
}
