//
//  AccountTableProviderSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/5/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class AccountTableProviderSpec: QuickSpec {
    override func spec() {
        var tableProvider: AccountTableProvider!
        var tableView: UITableView!
        
        beforeEach {
            tableProvider = AccountTableProvider(isOrdersEnabled: false)
            tableView = UITableView()
            tableView.registerNibForCell(AccountTableViewCell.self)
            tableView.registerNibForHeaderFooterView(AccountFooterView.self)
            tableView.dataSource = tableProvider
            tableView.delegate = tableProvider
        }

        describe("when provider created") {
            it("should return correct sections count") {
                let numberOfSections = tableProvider.numberOfSections(in: tableView)
                
                expect(numberOfSections) == 2
            }
            
            it("should return correct rows count") {
                (0...1).forEach {
                    let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: $0)
                    
                    expect(rowsCount) == 0
                }
            }
            
            it("should return correct cell class") {
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                expect(cell).to(beAnInstanceOf(AccountTableViewCell.self))
            }
            
            it("should return correct header height") {
                let customerHeaderHeight = tableProvider.tableView(tableView, heightForHeaderInSection: 0)
                let policiesHeaderHeight = tableProvider.tableView(tableView, heightForHeaderInSection: 1)
                
                expect(customerHeaderHeight) == kAccountNotLoggedHeaderViewHeight
                expect(policiesHeaderHeight) == 10
            }
            
            it("should return correct footer height") {
                (0...1).forEach {
                    let footerHeight = tableProvider.tableView(tableView, heightForFooterInSection: $0)
                    
                    expect(footerHeight) == TableView.headerFooterMinHeight
                }
            }
            
            it("should return correct header class type") {
                let customerHeader = tableProvider.tableView(tableView, viewForHeaderInSection: 0)
                let policiesHeader = tableProvider.tableView(tableView, viewForHeaderInSection: 1)
                
                expect(customerHeader).to(beAnInstanceOf(AccountNotLoggedHeaderView.self))
                expect(policiesHeader).to(beAnInstanceOf(UIView.self))
            }
            
            it("should return correct footer class type") {
                (0...1).forEach {
                    let footer = tableProvider.tableView(tableView, viewForFooterInSection: $0)
                    
                    expect(footer).to(beAnInstanceOf(UIView.self))
                }
            }
        }
        
        describe("when policies did set") {
            var policies: [Policy]!
            
            beforeEach {
                policies = [Policy()]
                tableProvider.policies = policies
            }
            
            it("should return correct rows count") {
                let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 1)
                
                expect(rowsCount) == policies.count
            }

            it("should return correct cell class") {
                let indexPath = IndexPath(row: 0, section: 1)
                let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                
                expect(cell).to(beAnInstanceOf(AccountTableViewCell.self))
            }
        }
        
        describe("when customer did set") {
            beforeEach {
                tableProvider.customer = Customer()
            }
            
            it("should return correct header height") {
                let headerHeight = tableProvider.tableView(tableView, heightForHeaderInSection: 0)
                
                expect(headerHeight) == kAccountLoggedHeaderViewHeight
            }
            
            it("should return correct footer height") {
                let footerHeight = tableProvider.tableView(tableView, heightForFooterInSection: 1)
                
                expect(footerHeight) == kAccountFooterViewHeight
            }
            
            it("should return correct header class type") {
                let header = tableProvider.tableView(tableView, viewForHeaderInSection: 0)
                
                expect(header).to(beAnInstanceOf(AccountLoggedHeaderView.self))
            }
            
            it("should return correct footer class type") {
                let footer = tableProvider.tableView(tableView, viewForFooterInSection: 1)
         
                expect(footer).to(beAnInstanceOf(AccountFooterView.self))
            }
            
            context("and order enabled did set") {
                context("and this value is true") {
                    it("should return correct rows count") {
                        tableProvider.isOrdersEnabled = true
                        
                        let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                        
                        expect(rowsCount) == 3
                    }
                }
                
                context("and this value is false") {
                    it("should return correct rows count") {
                        let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                        
                        expect(rowsCount) == 2
                    }
                }
            }
        }

        describe("when cell selected") {
            var delegateMock: AccountTableProviderDelegateMock!
            
            beforeEach {
                tableProvider.customer = Customer()
                
                delegateMock = AccountTableProviderDelegateMock()
                tableProvider.delegate = delegateMock
            }
            
            context("if user select customer item") {
                it("needs to open selected screen") {
                    tableProvider.isOrdersEnabled = true
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableProvider.tableView(tableView, didSelectRowAt: indexPath)
                    
                    expect(delegateMock.provider) === tableProvider
                    expect(delegateMock.type?.rawValue) === AccountCustomerSection.orders.rawValue
                }
            }
            
            context("if user select policies item") {
                it("needs to show policy") {
                    let policy = Policy()
                    let policies = [policy]
                    tableProvider.policies = policies
                    
                    let indexPath = IndexPath(row: 0, section: 1)
                    tableProvider.tableView(tableView, didSelectRowAt: indexPath)
                    
                    expect(delegateMock.provider) === tableProvider
                    expect(delegateMock.policy) === policy
                }
            }
        }
    }
}
