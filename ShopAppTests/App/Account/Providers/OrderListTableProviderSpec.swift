//
//  OrderListTableProviderSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class OrderListTableProviderSpec: QuickSpec {
    override func spec() {
        var tableProvider: OrdersListTableProvider!
        var tableView: UITableView!
        
        beforeEach {
            tableProvider = OrdersListTableProvider()
            tableView = UITableView()
            tableView.registerNibForCell(CheckoutCartTableViewCell.self)
            tableView.dataSource = tableProvider
            tableView.delegate = tableProvider
        }
        
        describe("when provider created") {
            it("should return correct count") {
                let sectionsCount = tableProvider.numberOfSections(in: tableView)
                expect(sectionsCount) == 0
                
                let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                expect(rowsCount) == 1
                
                let header = tableProvider.tableView(tableView, viewForHeaderInSection: 0)
                expect(header).to(beNil())
                
                let footer = tableProvider.tableView(tableView, viewForFooterInSection: 0)
                expect(footer).to(beNil())
            }
        }
        
        describe("when orders did set") {
            var order: Order!
            
            beforeEach {
                order = Order()
                order.id = "order id"
                order.number = 1000
                order.createdAt = Date()
                order.currencyCode = "USD"
                order.totalPrice = Decimal(floatLiteral: 10)
                tableProvider.orders = [order, order, order]
                tableView.reloadData()
            }
            
            it("should return correct count") {
                let sectionsCount = tableProvider.numberOfSections(in: tableView)
                expect(sectionsCount) == tableProvider.orders.count
                
                let header = tableProvider.tableView(tableView, viewForHeaderInSection: 0)
                expect(header).to(beAnInstanceOf(OrderHeaderView.self))
                
                let footer = tableProvider.tableView(tableView, viewForFooterInSection: 0)
                expect(footer).to(beAnInstanceOf(OrderFooterView.self))
                
                let headerHeight = tableProvider.tableView(tableView, heightForHeaderInSection: 0)
                expect(headerHeight) == kOrderHeaderViewHeight
                
                let footerHeight = tableProvider.tableView(tableView, heightForFooterInSection: 0)
                expect(footerHeight) == kOrderFooterViewHeight
            }
            
            it("should return correct cell class") {
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                expect(cell).to(beAnInstanceOf(CheckoutCartTableViewCell.self))
            }
            
            it("should select order") {
                let providerDelegateMock = OrdersListTableProviderMock()
                tableProvider.delegate = providerDelegateMock
                expect(providerDelegateMock.selectedOrder).to(beNil())
                
                let header = tableProvider.tableView(tableView, viewForHeaderInSection: 0) as! OrderHeaderView
                header.delegate?.headerView(header, didTapWith: 0)
                expect(providerDelegateMock.selectedOrder?.id) == order.id
            }
            
            it("should select product variant") {
                let providerDelegateMock = OrdersListTableProviderMock()
                tableProvider.delegate = providerDelegateMock
                expect(providerDelegateMock.selectedProductVariantId).to(beNil())
                expect(providerDelegateMock.selectedIndex).to(beNil())
                
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath) as! CheckoutCartTableViewCell
                cell.cellDelegate?.tableViewCell(cell, didSelect: "product variant id", at: 0)
                expect(providerDelegateMock.selectedProductVariantId) == "product variant id"
                expect(providerDelegateMock.selectedIndex) == 0
            }
        }
    }
}
