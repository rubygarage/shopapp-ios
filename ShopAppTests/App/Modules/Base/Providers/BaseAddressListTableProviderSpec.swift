//
//  BaseAddressListTableProviderSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class BaseAddressListTableProviderSpec: QuickSpec {
    override func spec() {
        var tableProvider: BaseAddressListTableProvider!
        var tableView: UITableView!
        var addresses: [AddressTuple]!
        
        beforeEach {
            tableProvider = BaseAddressListTableProvider()
            
            tableView = UITableView()
            tableView.registerNibForCell(AddressListTableViewCell.self)
            tableView.dataSource = tableProvider
            tableView.delegate = tableProvider
            
            addresses = []
            for index in 1...2 {
                let address = Address()
                address.id = "Address id \(index)"
                address.firstName = "Address first name \(index)"
                address.lastName = "Address last name \(index)"
                address.address = "Address \(index)"
                address.phone = "Address phone \(index)"
                
                let addressTuple = AddressTuple(address, true, true)
                addresses.append(addressTuple)
            }
        }
        
        describe("when provider initialized") {
            it("should return correct rows count") {
                let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                
                expect(rowsCount) == 0
            }
            
            it("should have correct header height") {
                let headerHeight = tableProvider.tableView(tableView, heightForHeaderInSection: 0)
                
                expect(headerHeight) == kAddressListTableHeaderViewHeight
            }
            
            it("should have correct header view class type") {
                let header = tableProvider.tableView(tableView, viewForHeaderInSection: 0)
                
                expect(header).to(beAnInstanceOf(AddressListTableHeaderView.self))
            }
        }
        
        describe("when data did set") {
            beforeEach {
                tableProvider.addresses = addresses
            }
            
            it("should return correct rows count") {
                let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                
                expect(rowsCount) == addresses.count
            }
            
            it("should have correct cell class type") {
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)

                expect(cell).to(beAKindOf(AddressListTableViewCell.self))
            }
        }
    }
}
