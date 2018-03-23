//
//  SortVariantsTableProviderSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class SortVariantsTableProviderSpec: QuickSpec {
    override func spec() {
        var tableProvider: SortVariantsTableProvider!
        var tableView: UITableView!
        
        beforeEach {
            tableProvider = SortVariantsTableProvider()
            tableView = UITableView()
            tableView.registerNibForCell(SortVariantTableViewCell.self)
            tableView.dataSource = tableProvider
            tableView.delegate = tableProvider
        }
        
        describe("when provider created") {
            it("should return correct rows count") {
                let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                
                expect(rowsCount) == 0
            }
        }
        
        describe("when variants did set") {
            beforeEach {
                tableProvider.variants = ["first", "second"]
            }
            
            it("should return correct rows count") {
                let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                
                expect(rowsCount) == tableProvider.variants.count
            }
            
            it("should return correct cell class") {
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                
                expect(cell).to(beAnInstanceOf(SortVariantTableViewCell.self))
            }
        }
        
        describe("when variant selected") {
            var providerDelegateMock: SortVariantsTableProviderDelegateMock!
            
            beforeEach {
                providerDelegateMock = SortVariantsTableProviderDelegateMock()
                tableProvider.delegate = providerDelegateMock
                tableProvider.variants = ["first", "second"]
            }
            
            context("if user selects variant that hasn't been selected") {
                it("needs to select variant") {
                    tableProvider.selectedVariant = "second"
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableProvider.tableView(tableView, didSelectRowAt: indexPath)
                    
                    expect(providerDelegateMock.provider) === tableProvider
                    expect(providerDelegateMock.variant) == "first"
                }
            }
            
            context("if user selects variant that has been selected") {
                it("needs to deselect variant") {
                    tableProvider.selectedVariant = "first"
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableProvider.tableView(tableView, didSelectRowAt: indexPath)
                    
                    expect(providerDelegateMock.provider) === tableProvider
                    expect(providerDelegateMock.variant).to(beNil())
                }
            }
        }
    }
}
