//
//  AccountViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/5/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import Toaster

@testable import ShopApp

class AccountViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: AccountViewController!
        var viewModelMock: AccountViewModelMock!
        var tableProvider: AccountTableProvider!
        var tableView: UITableView!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.account, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.account) as! AccountViewController
            
            let authentificationRepositoryMock = AuthentificationRepositoryMock()
            let customerRepositoryMock = CustomerRepositoryMock()
            let shopRepositoryMock = ShopRepositoryMock()
            let customerUseCaseMock = CustomerUseCaseMock(repository: customerRepositoryMock)
            let loginUseCaseMock = LoginUseCaseMock(repository: authentificationRepositoryMock)
            let logoutUseCaseMock = LogoutUseCaseMock(repository: authentificationRepositoryMock)
            let shopUseCaseMock = ShopUseCaseMock(repository: shopRepositoryMock)
            viewModelMock = AccountViewModelMock(customerUseCase: customerUseCaseMock, loginUseCase: loginUseCaseMock, logoutUseCase: logoutUseCaseMock, shopUseCase: shopUseCaseMock)
            viewController.viewModel = viewModelMock
            
            tableProvider = AccountTableProvider()
            viewController.tableProvider = tableProvider
            
            tableView = self.findView(withAccessibilityLabel: "tableView", in: viewController.view) as! UITableView
        }
        
        describe("when view loaded") {
            beforeEach {
                viewModelMock.isNeedToReturnCustomer = false
                viewController.viewWillAppear(false)
            }
            
            it("should have a correct superclass") {
                expect(viewController.isKind(of: BaseViewController<AccountViewModel>.self)) == true
            }
            
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(AccountViewModel.self))
            }
            
            it("should have correct title") {
                expect(viewController.navigationItem.title) == "ControllerTitle.Account".localizable
            }
            
            it("should haven't settings button") {
                expect(viewController.navigationItem.rightBarButtonItem).to(beNil())
            }
            
            it("should have correct delegate of table provider") {
                expect(tableProvider.delegate) === viewController
            }
            
            it("should have correct data source and delegate of table view") {
                expect(tableView.dataSource) === tableProvider
                expect(tableView.delegate) === tableProvider
            }
            
            it("should load customer and policies") {
                expect(viewModelMock.isCustomerLoadingStarted) == true
                expect(viewModelMock.isPoliciesLoadingStarted) == true
            }
        }
        
        describe("when customer loaded") {
            beforeEach {
                viewModelMock.isNeedToReturnCustomer = true
                viewModelMock.loadCustomer()
            }
            
            it("should haven correct settings button image") {
                expect(viewController.navigationItem.rightBarButtonItem?.image) == #imageLiteral(resourceName: "settings")
            }

            it("needs to set provider's customer") {
                expect(viewController.tableProvider.customer).toNot(beNil())
            }
            
            it("needs to reload table view") {
                expect(tableView.rectForHeader(inSection: 0).size.height) == kAccountLoggedHeaderViewHeight
                expect(tableView.rectForFooter(inSection: 0).size.height) == kAccountFooterViewHeight
            }
        }
        
        describe("when policies loaded") {
            beforeEach {
                viewModelMock.loadPolicies()
            }

            it("needs to set provider's policies") {
                expect(viewController.tableProvider.policies).toNot(beNil())
            }

            it("needs to reload table view") {
                expect(tableView.visibleCells.isEmpty) == false
            }
        }
        
        describe("when logout tapped") {
            it("needs to logout and show toast") {
                viewModelMock.isNeedToReturnCustomer = true
                viewModelMock.loadCustomer()

                tableView.beginUpdates()
                tableView.endUpdates()

                let footerView = tableView.footerView(forSection: 0) as! AccountFooterView
                let logoutButton = self.findView(withAccessibilityLabel: "logout", in: footerView) as! UIButton
                logoutButton.sendActions(for: .touchUpInside)
                
                expect(viewModelMock.isLogoutStarted) == true
                expect(viewController.navigationItem.rightBarButtonItem).to(beNil())
                expect(ToastCenter.default.currentToast?.text) == "Alert.LoggedOut".localizable
            }
            
            afterEach {
                ToastCenter.default.cancelAll()
            }
        }
    }
}
