//
//  SwitchTableViewCellMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class SwitchTableViewCellMock: QuickSpec {
    override func spec() {
        var cell: SwitchTableViewCell!
        var delegateMock: SwitchTableCellDelegateMock!
        var swicthDescriptionlabel: UILabel!
        var switchControl: UISwitch!
        
        beforeEach {
            let provider = SettingsTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.registerNibForCell(SwitchTableViewCell.self)
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: SwitchTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            swicthDescriptionlabel = self.findView(withAccessibilityLabel: "description", in: cell) as? UILabel
            switchControl = self.findView(withAccessibilityLabel: "switch", in: cell) as? UISwitch
        }
        
        describe("when cell initialized") {
            it("should have correct selection style") {
                expect(cell.selectionStyle.rawValue) == UITableViewCell.SelectionStyle.none.rawValue
            }
        }

        describe("when cell configured") {
            it("needs to setup description and control") {
                let indexPath = IndexPath(item: 0, section: 0)
                cell.configure(with: indexPath, description: "description", state: true)

                expect(swicthDescriptionlabel.text) == "description"
                expect(switchControl.isOn) == true
            }
        }
        
        describe("when switch value changed") {
            it("needs to update customer data") {
                let indexPath = IndexPath(item: 0, section: 0)
                cell.configure(with: indexPath, description: "description", state: true)
                
                delegateMock = SwitchTableCellDelegateMock()
                cell.delegate = delegateMock
                
                switchControl.isOn = true
                switchControl.sendActions(for: .valueChanged)
                
                expect(delegateMock.value).toEventually(equal(true), timeout: 1, pollInterval: 0.3)
            }
        }
    }
}
