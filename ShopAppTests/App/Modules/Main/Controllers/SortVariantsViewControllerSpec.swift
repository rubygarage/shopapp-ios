//
//  SortVariantsViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class SortVariantsViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: SortVariantsViewController!
        var tableProvider: SortVariantsTableProvider!
        var tableView: UITableView!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.main, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.sortModal) as! SortVariantsViewController
            
            tableProvider = SortVariantsTableProvider()
            viewController.tableProvider = tableProvider
            viewController.selectedSortingValue = .name
            
            tableView = self.findView(withAccessibilityLabel: "tableView", in: viewController.view) as! UITableView
        }
        
        describe("when view loaded") {
            it("hould have tap gesture recognizers") {
                expect(viewController.view.gestureRecognizers?.first?.delegate) === viewController
            }
            
            it("should have correct delegate of table provider") {
                expect(viewController.tableProvider.delegate) === viewController
            }
            
            it("should have correct data source and delegate of table view") {
                expect(tableView.dataSource) === tableProvider
                expect(tableView.delegate) === tableProvider
            }
            
            it("should have correct data in provider") {
                expect(tableProvider.variants) == ["SortingValue.CreatedAt".localizable, "SortingValue.PriceHighToLow".localizable, "SortingValue.PriceLowToHigh".localizable]
                expect(tableProvider.selectedVariant) == "SortingValue.Name".localizable
            }
            
            it("should have reloaded table view") {
                expect(tableView.numberOfRows(inSection: 0)) > 0
            }
        }
        
        describe("when variant selected") {
            var delegateMock: SortVariantsControllerDelegateMock!
            
            beforeEach {
                delegateMock = SortVariantsControllerDelegateMock()
                viewController.delegate = delegateMock
            }
            
            context("if user selects variant that hasn't been selected") {
                it("needs to select variant") {
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
                    tableView.delegate!.tableView!(tableView, didSelectRowAt: indexPath)
                    
                    expect(delegateMock.viewController) === viewController
                    expect(delegateMock.sortingValue?.rawValue) == SortingValue.createdAt.rawValue
                }
            }
            
            context("if user selects variant that has been selected") {
                it("needs to deselect variant") {
                    tableProvider.selectedVariant = "SortingValue.CreatedAt".localizable
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
                    tableView.delegate!.tableView!(tableView, didSelectRowAt: indexPath)
                    
                    expect(delegateMock.viewController) === viewController
                    expect(delegateMock.sortingValue?.rawValue) == SortingValue.name.rawValue
                }
            }
        }
    }
}
