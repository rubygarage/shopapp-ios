//
//  BaseAddressListViewModelSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/1/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class BaseAddressListViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: BaseAddressListViewModel!
        var customerUseCaseMock: CustomerUseCaseMock!
        var deleteAddressUseCaseMock: DeleteAddressUseCaseMock!
        var updateDefaultAddressUseCaseMock: UpdateDefaultAddressUseCaseMock!
        
        beforeEach {
            let authenticationRepositoryMock = AuthentificationRepositoryMock()
            customerUseCaseMock = CustomerUseCaseMock(repository: authenticationRepositoryMock)
            let paymentsRepositoryMock = PaymentsRepositoryMock()
            updateDefaultAddressUseCaseMock = UpdateDefaultAddressUseCaseMock(repository: paymentsRepositoryMock)
            deleteAddressUseCaseMock = DeleteAddressUseCaseMock(repository: paymentsRepositoryMock)
            viewModel = BaseAddressListViewModel(customerUseCase: customerUseCaseMock, updateDefaultAddressUseCase: updateDefaultAddressUseCaseMock, deleteAddressUseCase: deleteAddressUseCaseMock)
        }
        
        describe("when view model initialized") {
            it("should have a correct superclass") {
                expect(viewModel).to(beAKindOf(BaseViewModel.self))
            }
            
            it("should have variables with correct initial values") {
                expect(viewModel.selectedAddress).to(beNil())
                expect(viewModel.customerAddresses.value.isEmpty) == true
                expect(viewModel.customerDefaultAddress.value).to(beNil())
            }
        }
        
        describe("when data loaded") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            
            beforeEach {
                disposeBag = DisposeBag()
                states = []
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
            }
            
            context("if data load successfully") {
                it("should load customer addresses") {
                    customerUseCaseMock.isNeedToReturnError = false
                    viewModel.loadCustomerAddresses()
                    
                    expect(viewModel.customerAddresses.value.count) == 1
                    expect(viewModel.customerAddresses.value.first?.id) == "Customer address id"
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if error occured") {
                it("should have an error", closure: {
                    customerUseCaseMock.isNeedToReturnError = true
                    viewModel.loadCustomerAddresses()
                    
                    expect(viewModel.customerAddresses.value.count) == 0
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                })
            }
        }
        
        describe("when address deleted") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            
            beforeEach {
                disposeBag = DisposeBag()
                states = []
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
            }
            
            context("if address deleted successfully") {
                it("should delete address succesfully") {
                    deleteAddressUseCaseMock.isNeedToReturnError = false
                    customerUseCaseMock.isNeedToReturnError = false
                    viewModel.deleteCustomerAddress(with: Address(), type: .shipping)
                    
                    expect(viewModel.customerAddresses.value.count) == 1
                    expect(viewModel.customerAddresses.value.first?.id) == "Customer address id"
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: true)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if address deleted successfully, but loading addresess failed") {
                it("should delete address successfully, but have error during reloading addresses") {
                    deleteAddressUseCaseMock.isNeedToReturnError = false
                    customerUseCaseMock.isNeedToReturnError = true
                    viewModel.deleteCustomerAddress(with: Address(), type: .shipping)
                    
                    expect(viewModel.customerAddresses.value.count) == 0
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: true)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if deleting address failed") {
                it("should have error during deletion") {
                    deleteAddressUseCaseMock.isNeedToReturnError = true
                    customerUseCaseMock.isNeedToReturnError = true
                    viewModel.deleteCustomerAddress(with: Address(), type: .shipping)
                    
                    expect(viewModel.customerAddresses.value.count) == 0
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: true)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
        
        describe("when address updated") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            
            beforeEach {
                disposeBag = DisposeBag()
                states = []
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
            }
            
            context("if address updated successfully") {
                it("should update address") {
                    updateDefaultAddressUseCaseMock.isNeedToReturnError = false
                    viewModel.updateCustomerDefaultAddress(with: Address())
                    
                    expect(viewModel.customerDefaultAddress.value?.id) == "Customer default address id"
                    expect(viewModel.customerAddresses.value.count) == 1
                    expect(viewModel.customerAddresses.value.first?.id) == "Customer address id"
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: true)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("or failed") {
                it("should have error") {
                    updateDefaultAddressUseCaseMock.isNeedToReturnError = true
                    viewModel.updateCustomerDefaultAddress(with: Address())
                    
                    expect(viewModel.customerDefaultAddress.value).to(beNil())
                    expect(viewModel.customerAddresses.value.count) == 0
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: true)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
        
        describe("when address tuple created") {
            let address = Address()
            
            context("if address not selected and not default") {
                beforeEach {
                    viewModel.selectedAddress = nil
                    viewModel.customerDefaultAddress.value = nil
                }
                
                it("should create address tuple from address") {
                    let addressTuple = viewModel.addressTuple(with: address)
                    
                    expect(addressTuple.isSelected) == false
                    expect(addressTuple.isDefault) == false
                    expect(addressTuple.address) === address
                }
            }
            
            context("if address selected and default", {
                beforeEach {
                    viewModel.selectedAddress = address
                    viewModel.customerDefaultAddress.value = address
                }
                
                it("should create address tuple from address") {
                    address.firstName = "address first name"
                    address.lastName = "address last name"
                    address.address = "address"
                    address.phone = "address phone"
                    
                    let addressTuple = viewModel.addressTuple(with: address)
                    
                    expect(addressTuple.isSelected) == true
                    expect(addressTuple.isDefault) == true
                    expect(addressTuple.address) === address
                }
            })
        }
        
        describe("when check address equality") {
            let address = Address()
            let otherAddress = Address()
            
            beforeEach {
                address.firstName = "first name"
                address.lastName = "address last name"
                address.address = "address"
                address.phone = "address phone"
            }
            
            context("if addresses equal") {
                beforeEach {
                    otherAddress.firstName = "first name"
                    otherAddress.lastName = "address last name"
                    otherAddress.address = "address"
                    otherAddress.phone = "address phone"
                }
                
                it("should be equal") {
                    expect(address.isEqual(to: otherAddress)) == true
                }
            }
            
            context("if addresses is not equal") {
                beforeEach {
                    otherAddress.firstName = "first name other"
                    otherAddress.lastName = "address last name other"
                    otherAddress.address = "address other"
                    otherAddress.phone = "address phone other"
                }
                
                it("should not be equal") {
                    expect(address.isEqual(to: otherAddress)) == false
                }
            }
        }
    }
}
