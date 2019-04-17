//
//  CheckoutAddressListViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/5/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CheckoutAddressListViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: CheckoutAddressListViewController!
        var customerRepositoryMock: CustomerRepositoryMock!
        var tableProvider: BaseAddressListTableProvider!
        var customerUseCaseMock: CustomerUseCaseMock!
        var paymentsRepositoryMock: PaymentsRepositoryMock!
        var checkoutUseCaseMock: CheckoutUseCaseMock!
        var viewModelMock: CheckoutAddressListViewModelMock!
        var address: Address!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.checkout, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.checkoutAddressList) as? CheckoutAddressListViewController
            
            customerRepositoryMock = CustomerRepositoryMock()
            customerUseCaseMock = CustomerUseCaseMock(repository: customerRepositoryMock)
            let updateDefaultAddressUseCaseMock = UpdateDefaultAddressUseCaseMock(repository: customerRepositoryMock)
            let deleteAddressUseCaseMock = DeleteAddressUseCaseMock(repository: customerRepositoryMock)
            
            paymentsRepositoryMock = PaymentsRepositoryMock()
            checkoutUseCaseMock = CheckoutUseCaseMock(repository: paymentsRepositoryMock)
            
            viewModelMock = CheckoutAddressListViewModelMock(customerUseCase: customerUseCaseMock, updateDefaultAddressUseCase: updateDefaultAddressUseCaseMock, deleteAddressUseCase: deleteAddressUseCaseMock, checkoutUseCase: checkoutUseCaseMock)
            
            viewController.viewModel = viewModelMock
            
            tableProvider = BaseAddressListTableProvider()
            viewController.tableProvider = tableProvider
            
            viewController.checkoutId = "Checkout id"
            
            address = Address()
            address.id = "Customer address id"
            address.address = "Address"
            address.secondAddress = "Second address"
            address.city = "City"
            address.zip = "Zip"
            address.country = "Country"
            
            _ = viewController.view
        }
        
        describe("when view loaded") {
            it("should have a correct superclass") {
                expect(viewController.isKind(of: BaseAddressListViewController<CheckoutAddressListViewModel>.self)) == true
            }
            
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(CheckoutAddressListViewModel.self))
            }
            
            it("should pass correct properties to view model") {
                expect(viewController.viewModel.checkoutId) == viewController.checkoutId
            }
            
            it("should have correct delegate of table provider") {
                expect(viewController.tableProvider.delegate) === viewController
            }
            
            it("should have correct data source and delegate of table view") {
                expect(viewController.tableView.dataSource) === tableProvider
                expect(viewController.tableView.delegate) === tableProvider
            }
        }
        
        describe("when update shipping address called") {
            var isSelectedAddress: Bool!
            
            context("if address selected") {
                it("should start updating shipping address") {
                    isSelectedAddress = true
                    
                    viewController.update(shippingAddress: address, isSelectedAddress: isSelectedAddress)
                    
                    expect(viewController.selectedAddress) === address
                }
            }
            
            context("when address not selected") {
                it("should start loading customer's addresses") {
                    isSelectedAddress = false
                    
                    viewController.update(shippingAddress: address, isSelectedAddress: isSelectedAddress)
                    
                    expect(viewModelMock.customerDefaultAddress.value?.id) == address.id
                }
            }
        }
        
        describe("when address did select") {
            let cell = AddressListTableViewCell()
            
            context("if address list type is shipping") {
                it("should start updating checkout shipping address") {
                    viewController.addressListType = .shipping
                    
                    viewController.tableViewCell(cell, didSelect: address)
                    
                    expect(viewController.selectedAddress) === address
                }
            }
            
            context("if address list type is billing") {
                it("should set selected address") {
                    viewController.addressListType = .billing
                    
                    viewController.tableViewCell(cell, didSelect: address)
                    
                    expect(viewController.selectedAddress) === address
                    expect(viewController.viewModel.selectedAddress) === address
                }
            }
        }
        
        describe("when billing address did select") {
            it("should update selected address") {
                viewModelMock.updateBillingAddress(address: address)
                
                expect(viewController.selectedAddress) === address
                expect(viewController.viewModel.selectedAddress) === address
            }
        }
    }
}
