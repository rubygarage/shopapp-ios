//
//  SettingsViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class SettingsViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: SettingsViewController!
        var viewModelMock: SettingsViewModelMock!
        var tableProvider: SettingsTableProvider!
        var tableView: UITableView!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.account, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.settings) as! SettingsViewController
            
            let authentificationRepositoryMock = AuthentificationRepositoryMock()
            let customerRepositoryMock = CustomerRepositoryMock()
            let updateCustomerUseCaseMock = UpdateCustomerUseCaseMock(repository: customerRepositoryMock)
            let loginUseCaseMock = LoginUseCaseMock(repository: authentificationRepositoryMock)
            let customerUseCaseMock = CustomerUseCaseMock(repository: customerRepositoryMock)
            viewModelMock = SettingsViewModelMock(updateCustomerUseCase: updateCustomerUseCaseMock, loginUseCase: loginUseCaseMock, customerUseCase: customerUseCaseMock)
            viewModelMock.isCustomerLoadingStarted = false
            viewController.viewModel = viewModelMock
            
            tableProvider = SettingsTableProvider()
            viewController.tableProvider = tableProvider
            
            tableView = self.findView(withAccessibilityLabel: "tableView", in: viewController.view) as! UITableView
        }
        
        describe("when view loaded") {
            it("should have a correct superclass") {
                expect(viewController.isKind(of: BaseViewController<SettingsViewModel>.self)) == true
            }
            
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(SettingsViewModel.self))
            }
            
            it("should have correct title") {
                expect(viewController.title) == "ControllerTitle.Settings".localizable
            }
            
            it("should have correct delegate of table provider") {
                expect(tableProvider.delegate) === viewController
            }
            
            it("should have correct data source of table view") {
                expect(tableView.dataSource) === tableProvider
            }
            
            it("should have correct content inset of table view") {
                expect(tableView.contentInset) == TableView.defaultContentInsets
            }
            
            it("should load customer") {
                expect(viewModelMock.isCustomerLoadingStarted) == true
            }
        }
        
        describe("when customer did load") {
            context("if it have data") {
                it("needs to present settings variants") {
                    let customer = viewModelMock.customer.value!
                    
                    expect(tableProvider.promo?.description) == "Label.Promo".localizable
                    expect(tableProvider.promo?.state) == customer.promo
                    expect(tableView.numberOfSections) == 1
                }
            }
            
            context("if it haven't data") {
                it("needs to present empty view") {
                    viewModelMock.isNeedToReturnData = false
                    viewModelMock.loadCustomer()
                    
                    expect(tableProvider.promo).to(beNil())
                    expect(tableView.numberOfSections) == 0
                }
            }
        }
        
        describe("when promo switch value changed") {
            it("needs to update customer data") {
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = tableView.cellForRow(at: indexPath)!
                let switchControl = self.findView(withAccessibilityLabel: "switch", in: cell) as! UISwitch
                switchControl.isOn = true
                switchControl.sendActions(for: .valueChanged)
                
                expect(viewModelMock.promo).toEventually(equal(true), timeout: 1, pollInterval: 0.3)
            }
        }
    }
}
