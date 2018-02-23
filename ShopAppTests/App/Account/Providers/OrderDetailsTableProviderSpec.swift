//
//  OrderDetailsTableProviderSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class OrderDetailsTableProviderSpec: QuickSpec {
    override func spec() {
        var tableProvider: OrderDetailsTableProvider!
        var tableView: UITableView!
        
        beforeEach {
            tableProvider = OrderDetailsTableProvider()
            tableView = UITableView()
            tableView.registerNibForCell(OrderItemTableViewCell.self)
            tableView.registerNibForCell(CheckoutShippingAddressEditTableCell.self)
            tableView.dataSource = tableProvider
            tableView.delegate = tableProvider
        }
        
        describe("when provider initialized") {
            it("should have correct sections count") {
                let numberOfSections = tableProvider.numberOfSections(in: tableView)
                expect(numberOfSections) == 0
            }
            
            it("should return correct rows count") {
                let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                expect(rowsCount) == 0
            }
            
            it("should return header view") {
                let header = tableProvider.tableView(tableView, viewForHeaderInSection: 0)
                expect(header).to(beAnInstanceOf(UIView.self))
            }
            
            it("should return footer view") {
                let footer = tableProvider.tableView(tableView, viewForFooterInSection: 0)
                expect(footer).to(beNil())
            }
        }
        
        describe("when data did set") {
            var order: Order!
            
            beforeEach {
                order = Order()
                order.number = 1000
                order.createdAt = Date()
            }
            
            context("if order without items and shipping address") {
                beforeEach {
                    tableProvider.order = order
                }
                
                it("should return correct sections count") {
                    let sectionsCount = tableProvider.numberOfSections(in: tableView)
                    expect(sectionsCount) == 3
                }
                
                it("should return correct rows count for sections") {
                    let firstSectionRowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                    expect(firstSectionRowsCount) == 0
                    
                    let secondSectionRowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 1)
                    expect(secondSectionRowsCount) == 0
                    
                    let thirdSectionRowCount = tableProvider.tableView(tableView, numberOfRowsInSection: 2)
                    expect(thirdSectionRowCount) == 0
                }
                
                it("shoud return correct header class type") {
                    let headerSectionZero = tableProvider.tableView(tableView, viewForHeaderInSection: 0)
                    expect(headerSectionZero).to(beAnInstanceOf(OrderHeaderView.self))
                    
                    let headerSectionOne = tableProvider.tableView(tableView, viewForHeaderInSection: 1)
                    expect(headerSectionOne).to(beAnInstanceOf(BoldTitleTableHeaderView.self))
                    
                    let headerSectionTwo = tableProvider.tableView(tableView, viewForHeaderInSection: 2)
                    expect(headerSectionTwo).to(beAnInstanceOf(UIView.self))
                }
            }
            
            context("when order with items and shipping address") {
                beforeEach {
                    let orderItem = OrderItem()
                    orderItem.quantity = 1
                    order.items = [orderItem]
                    
                    let shippingAddress = Address()
                    shippingAddress.address = "1A Main street"
                    order.shippingAddress = shippingAddress
                    
                    order.currencyCode = "USD"
                    order.subtotalPrice = Decimal(integerLiteral: 10)
                    order.totalShippingPrice = Decimal(integerLiteral: 5)
                    order.totalPrice = Decimal(integerLiteral: 15)
                    
                    tableProvider.order = order
                }
                
                it("should return correct rows count for sections") {
                    let firstSectionRowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                    expect(firstSectionRowsCount) == 0
                    
                    let secondSectionRowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 1)
                    expect(secondSectionRowsCount) == 1
                    
                    let thirdSectionRowCount = tableProvider.tableView(tableView, numberOfRowsInSection: 2)
                    expect(thirdSectionRowCount) == 1
                }
                
                it("should return correct cells class types") {
                    let indexPathSectionZero = IndexPath(row: 0, section: 0)
                    let cellSectionZero = tableProvider.tableView(tableView, cellForRowAt: indexPathSectionZero)
                    expect(cellSectionZero).to(beAnInstanceOf(UITableViewCell.self))
                    
                    let indexPathSectionOne = IndexPath(row: 0, section: 1)
                    let cellSectionOne = tableProvider.tableView(tableView, cellForRowAt: indexPathSectionOne)
                    expect(cellSectionOne).to(beAnInstanceOf(OrderItemTableViewCell.self))
                    
                    let indexPathSectionTwo = IndexPath(row: 0, section: 2)
                    let cellSectionTwo = tableProvider.tableView(tableView, cellForRowAt: indexPathSectionTwo)
                    expect(cellSectionTwo).to(beAnInstanceOf(CheckoutShippingAddressEditTableCell.self))
                }
                
                it("shoud return correct header class type") {
                    let headerSectionZero = tableProvider.tableView(tableView, viewForHeaderInSection: 0)
                    expect(headerSectionZero).to(beAnInstanceOf(OrderHeaderView.self))
                    
                    let headerSectionOne = tableProvider.tableView(tableView, viewForHeaderInSection: 1)
                    expect(headerSectionOne).to(beAnInstanceOf(BoldTitleTableHeaderView.self))
                    
                    let headerSectionTwo = tableProvider.tableView(tableView, viewForHeaderInSection: 2)
                    expect(headerSectionTwo).to(beAnInstanceOf(BoldTitleTableHeaderView.self))
                }
                
                it("should return correct footer class type") {
                    let footerSectionZero = tableProvider.tableView(tableView, viewForFooterInSection: 0)
                    expect(footerSectionZero).to(beNil())
                    
                    let footerSectionOne = tableProvider.tableView(tableView, viewForFooterInSection: 1)
                    expect(footerSectionOne).to(beAnInstanceOf(PaymentDetailsFooterView.self))
                }
                
                it("should return correct header height") {
                    let headerHeightSectionZero = tableProvider.tableView(tableView, heightForHeaderInSection: 0)
                    expect(headerHeightSectionZero) == kOrderHeaderViewHeight
                    
                    let headerHeightSectionOne = tableProvider.tableView(tableView, heightForHeaderInSection: 1)
                    expect(headerHeightSectionOne) == kBoldTitleTableHeaderViewHeight
                }
                
                it("should return correct footer height") {
                    let footerHeightSectionZero = tableProvider.tableView(tableView, heightForFooterInSection: 0)
                    expect(footerHeightSectionZero) == TableView.headerFooterMinHeight
                    
                    let footerHeightSectionOne = tableProvider.tableView(tableView, heightForFooterInSection: 1)
                    expect(footerHeightSectionOne) == kPaymentDetailsFooterViewHeight
                }
            }
        }
        
        describe("when product variant did selected") {
            var order: Order!
            var providerDelegateMock: OrderDetailsTableProviderDelegateMock!
            
            beforeEach {
                order = Order()
                order.id = "order id"
                order.number = 1000
                order.createdAt = Date()
                order.currencyCode = "USD"
                order.totalPrice = Decimal(floatLiteral: 10)
                
                let productVariant = ProductVariant()
                productVariant.id = "product variant id"
                
                let orderItem = OrderItem()
                orderItem.productVariant = productVariant
                order.items = [orderItem]
                
                tableProvider.order = order
                
                providerDelegateMock = OrderDetailsTableProviderDelegateMock()
                tableProvider.delegate = providerDelegateMock
            }
            
            it("should select product variant") {
                let indexPath = IndexPath(row: 0, section: 1)
                tableProvider.tableView(tableView, didSelectRowAt: indexPath)
                expect(providerDelegateMock.selectedProductVariant?.id) == "product variant id"
            }
        }
    }
}
