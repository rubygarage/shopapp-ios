//
//  SettingsTableProviderSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class SettingsTableProviderSpec: QuickSpec {
    override func spec() {
        var tableProvider: SettingsTableProvider!
        var tableView: UITableView!
        
        beforeEach {
            tableProvider = SettingsTableProvider()
            tableView = UITableView()
            tableView.registerNibForCell(SwitchTableViewCell.self)
            tableView.dataSource = tableProvider
        }
        
        describe("when provider created") {
            it("should return correct sections count") {
                let sectionsCount = tableProvider.numberOfSections(in: tableView)
                expect(sectionsCount) == 0
            }
            
            it("should return correct rows count") {
                let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                expect(rowsCount) == 1
            }
        }
        
        describe("when promo did set") {
            var promo: (description: String, state: Bool)!
            
            beforeEach {
                promo = (description: "Description", state: false)
                tableProvider.promo = promo
            }
            
            it("should return correct sections count") {
                let sectionsCount = tableProvider.numberOfSections(in: tableView)
                expect(sectionsCount) == 1
            }
            
            it("should return correct cell class") {
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                expect(cell).to(beAnInstanceOf(SwitchTableViewCell.self))
            }
        }
    }
}
