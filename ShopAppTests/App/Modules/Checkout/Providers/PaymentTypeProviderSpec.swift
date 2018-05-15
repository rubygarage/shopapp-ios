//
//  PaymentTypeProviderSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/8/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class PaymentTypeProviderSpec: QuickSpec {
    override func spec() {
        var tableProvider: PaymentTypeProvider!
        var tableView: UITableView!
        
        beforeEach {
            tableProvider = PaymentTypeProvider()
            tableView = UITableView()
            tableView.registerNibForCell(PaymentTypeTableViewCell.self)
            tableView.dataSource = tableProvider
            tableView.delegate = tableProvider
        }
        
        describe("when provider created") {
            it("should return correct rows count") {
                let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                
                expect(rowsCount) == PaymentType.allValues.count
            }
            
            it("should return correct cell class") {
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                expect(cell).to(beAnInstanceOf(PaymentTypeTableViewCell.self))
            }
        }
        
        describe("when cell did select") {
            it("should notify delegate") {
                let delegateMock = PaymentTypeProviderDelegateMock()
                tableProvider.delegate = delegateMock
                
                let indexPath = IndexPath(row: 0, section: 0)
                tableProvider.tableView(tableView, didSelectRowAt: indexPath)
                
                expect(delegateMock.provider) === tableProvider
                expect(delegateMock.type) == PaymentType.allValues.first
            }
        }
    }
}
