//
//  AccountTableViewCellSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/6/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class AccountTableViewCellSpec: QuickSpec {
    override func spec() {
        var cell: AccountTableViewCell!
        var policyTitleLabel: UILabel!
        
        beforeEach {
            let provider = AccountTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.registerNibForCell(AccountTableViewCell.self)
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: AccountTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            policyTitleLabel = self.findView(withAccessibilityLabel: "policy", in: cell) as? UILabel
        }
        
        describe("when cell initialized") {
            it("should have correct selection style") {
                expect(cell.selectionStyle.rawValue) == UITableViewCell.SelectionStyle.none.rawValue
            }
        }
        
        describe("when cell configured") {
            it("needs to setup policy title") {
                let policy = Policy()
                policy.title = "Title"
                cell.configure(with: policy)
                
                expect(policyTitleLabel.text) == "Title"
            }
        }
    }
}
