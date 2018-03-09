//
//  BaseAddressListViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class BaseAddressListViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: BaseAddressListViewControllerTest!
        var viewModelMock: BaseAddressListViewModelMock!
        var delegateMock: BaseAddressListControllerDelegateMock!
        var tableProvider: BaseAddressListTableProvider!
        
        beforeEach {
            viewController = BaseAddressListViewControllerTest()
            
            let authenticationRepositoryMock = AuthentificationRepositoryMock()
            let customerUseCaseMock = CustomerUseCaseMock(repository: authenticationRepositoryMock)
            let paymentsRepositoryMock = PaymentsRepositoryMock()
            let updateDefaultAddressUseCaseMock = UpdateDefaultAddressUseCaseMock(repository: paymentsRepositoryMock)
            let deleteAddressUseCaseMock = DeleteAddressUseCaseMock(repository: paymentsRepositoryMock)
            
            viewController.tableView.registerNibForCell(AddressListTableViewCell.self)
            
            viewModelMock = BaseAddressListViewModelMock(customerUseCase: customerUseCaseMock, updateDefaultAddressUseCase: updateDefaultAddressUseCaseMock, deleteAddressUseCase: deleteAddressUseCaseMock)
            viewController.viewModel = viewModelMock
            
            delegateMock = BaseAddressListControllerDelegateMock()
            viewController.delegate = delegateMock
            
            tableProvider = BaseAddressListTableProvider()
            viewController.tableProvider = tableProvider
            
            viewController.tableView.dataSource = tableProvider
            viewController.tableView.delegate = tableProvider
        }
        
        describe("when view controller initialized") {
            it("should have a correct superclass") {
                expect(viewController.isKind(of: BaseViewController<BaseAddressListViewModel>.self)) == true
            }
            
            it("should have a correct view model type") {
                viewController.selectedAddress = Address()
                _ = viewController.view
                
                expect(viewController.viewModel).to(beAKindOf(BaseAddressListViewModel.self))
                expect(viewController.viewModel.selectedAddress) === viewController.selectedAddress
                expect(viewController.tableProvider.showSelectionButton) == false
            }
            
            it("should have default empty data view") {
                expect(viewController.customEmptyDataView).to(beAnInstanceOf(UIView.self))
            }
            
            it("should start loading customer addresses") {
                _ = viewController.view
                
                expect(viewModelMock.isLoadCustomerAddressesStarted) == true
            }
            
            it("should have correct content inset of table view") {
                expect(viewController.tableView.contentInset) == UIEdgeInsets.zero
            }
            
            context("if address type is shipping") {
                it("should have correct title") {
                    viewController.addressListType = .shipping
                    _ = viewController.view
                    
                    expect(viewController.title) == "ControllerTitle.ShippingAddress".localizable
                }
            }
            
            context("if address type is biling") {
                it("should have correct title") {
                    viewController.addressListType = .billing
                    _ = viewController.view
                    
                    expect(viewController.title) == "ControllerTitle.BillingAddress".localizable
                }
            }
        }
        
        describe("when data loaded") {
            beforeEach {
                _ = viewController.view
            }
            
            context("if data is empty") {
                beforeEach {
                    viewModelMock.isNeedsToReturnAddresses = false
                    viewModelMock.loadCustomerAddresses()
                }
                
                it("should have provider without data") {
                    expect(tableProvider.addresses.isEmpty) == true
                }
                
                it("should have correct number of rows in table view") {
                    expect(viewController.tableView.numberOfRows(inSection: 0)) == 0
                }
            }
            
            context("if data isn't empty") {
                beforeEach {
                    viewModelMock.isNeedsToReturnAddresses = true
                    viewModelMock.loadCustomerAddresses()
                }
                
                it("should have provider with data") {
                    expect(tableProvider.addresses.isEmpty) == false
                }
                
                it("should have correct number of rows in table view") {
                    expect(viewController.tableView.numberOfRows(inSection: 0)) == 1
                }
            }
        }
        
        describe("when new shipping address selected") {
            it("should start loading customer addresses") {
                viewController.update(shippingAddress: Address(), isSelectedAddress: false)
                
                expect(viewModelMock.isLoadCustomerAddressesStarted) == true
            }
        }
        
        describe("when new billing address selected") {
            let address = Address()
            
            context("if address selected") {
                it("should set selected address and start loading customer addresses") {
                    viewController.update(billingAddress: address, isSelectedAddress: true)
                    
                    expect(viewController.selectedAddress) === address
                    expect(viewController.viewModel.selectedAddress) === address
                    expect(delegateMock.selectedAddress) === address
                    expect(viewModelMock.isLoadCustomerAddressesStarted) == true
                }
            }
            
            context("if address not selected") {
                it("should start loading customer addresses") {
                    viewController.update(billingAddress: address, isSelectedAddress: false)
                    
                    expect(viewController.selectedAddress).to(beNil())
                    expect(viewController.viewModel.selectedAddress).to(beNil())
                    expect(delegateMock.selectedAddress).to(beNil())
                    expect(viewModelMock.isLoadCustomerAddressesStarted) == true
                }
            }
        }
        
        describe("when billing address selected") {
            let address = Address()
            
            it("should notify delegate about selection billing address") {
                viewController.addressListType = .billing
                _ = viewController.view
                viewModelMock.makeSelectedAddress(address: address)
                
                expect(delegateMock.selectedAddress) === address
            }
        }
        
        describe("when delete address did press") {
            let address = Address()
            
            beforeEach {
                _ = viewController.view
                viewModelMock.isNeedsToReturnAddresses = true
                viewModelMock.loadCustomerAddresses()
            }
            
            it("should delete address and load customer addresses") {
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = tableProvider.tableView(viewController.tableView, cellForRowAt: indexPath) as! AddressListTableViewCell
                cell.delegate?.tableViewCell(cell, didTapDelete: address)
                
                expect(viewModelMock.isDeleteCustomerAddressStarted) == true
            }
        }
        
        describe("when address set as default did press") {
            let address = Address()
            
            beforeEach {
                _ = viewController.view
                viewModelMock.isNeedsToReturnAddresses = true
                viewModelMock.loadCustomerAddresses()
            }
            
            it("should set address as default") {
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = tableProvider.tableView(viewController.tableView, cellForRowAt: indexPath) as! AddressListTableViewCell
                cell.delegate?.tableViewCell(cell, didTapDefault: address)
                
                expect(viewModelMock.isUpdateCustomerDefaultAddressStarted) == true
            }
        }
        
        describe("when address form submit button did press") {
            let address = Address()
            var accountAddressFormController: AccountAddressFormViewController!
            
            beforeEach {
                _ = viewController.view

                accountAddressFormController = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.accountAddressForm) as! AccountAddressFormViewController
                accountAddressFormController.delegate = viewController
            }
            
            it("should have correct delegate class type of presented controller") {
                expect(accountAddressFormController.delegate) === viewController
            }
            
            context("if address action is add") {
                it("should start load customer addresses") {
                    viewController.viewController(accountAddressFormController, didAdd: address)
                    
                    expect(viewController.selectedAddress).to(beNil())
                    expect(viewController.viewModel.selectedAddress).to(beNil())
                    expect(viewModelMock.isLoadCustomerAddressesStarted) == true
                }
            }
            
            describe("when address action is update") {
                context("if address type is shipping address not selected") {
                    it("should start loading customer addresses") {
                        viewController.addressListType = .shipping
                        viewController.viewController(accountAddressFormController, didUpdate: address, isSelectedAddress: false)
                        
                        expect(viewController.selectedAddress).to(beNil())
                        expect(viewController.viewModel.selectedAddress).to(beNil())
                        expect(viewModelMock.isLoadCustomerAddressesStarted) == true
                    }
                }
                
                context("if address type is shipping address selected") {
                    it("should start loading customer addresses") {
                        viewController.addressListType = .shipping
                        viewController.viewController(accountAddressFormController, didUpdate: address, isSelectedAddress: true)
                        
                        expect(viewController.selectedAddress).to(beNil())
                        expect(viewController.viewModel.selectedAddress).to(beNil())
                        expect(viewModelMock.isLoadCustomerAddressesStarted) == true
                    }
                }
                
                context("if address type is billing address not selected") {
                    it("should start loading customer addresses") {
                        viewController.addressListType = .billing
                        viewController.viewController(accountAddressFormController, didUpdate: address, isSelectedAddress: false)
                        
                        expect(viewController.selectedAddress).to(beNil())
                        expect(viewController.viewModel.selectedAddress).to(beNil())
                        expect(viewModelMock.isLoadCustomerAddressesStarted) == true
                    }
                }
                
                context("if address type is billing address selected") {
                    it("should start loading customer addresses") {
                        viewController.addressListType = .billing
                        viewController.viewController(accountAddressFormController, didUpdate: address, isSelectedAddress: true)
                        
                        expect(viewController.selectedAddress) === address
                        expect(viewController.viewModel.selectedAddress) === address
                        expect(viewModelMock.isLoadCustomerAddressesStarted) == true
                    }
                }
            }
        }
    }
}

class BaseAddressListViewControllerTest: BaseAddressListViewController<BaseAddressListViewModel> {
    let testTableView = UITableView()
    
    override weak var tableView: UITableView! {
        get {
            return testTableView
        }
    }
}
