//
//  CheckoutAddressListViewModelSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/5/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class CheckoutAddressListViewModelSpec: QuickSpec {
    override func spec() {
        let customerRepositoryMock = CustomerRepositoryMock()
        let customerUseCaseMock = CustomerUseCaseMock(repository: customerRepositoryMock)
        let updateDefaultAddressUseCaseMock = UpdateDefaultAddressUseCaseMock(repository: customerRepositoryMock)
        let deleteAddressUseCaseMock = DeleteAddressUseCaseMock(repository: customerRepositoryMock)
        
        let paymentsRepositoryMock = PaymentsRepositoryMock()
        let checkoutUseCaseMock = CheckoutUseCaseMock(repository: paymentsRepositoryMock)
        
        let viewModel = CheckoutAddressListViewModel(customerUseCase: customerUseCaseMock, updateDefaultAddressUseCase: updateDefaultAddressUseCaseMock, deleteAddressUseCase: deleteAddressUseCaseMock, checkoutUseCase: checkoutUseCaseMock)
        
        let address = Address()
        
        beforeEach {
            viewModel.checkoutId = "Checkout id"
        }
        
        describe("when view model initialized") {
            it("should have a correct superclass") {
                expect(viewModel).to(beAKindOf(BaseAddressListViewModel.self))
            }
        }
        
        describe("when checkout shipping address updated") {
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
            
            context("if response success") {
                it("should select address") {
                    checkoutUseCaseMock.isUpdateCheckoutShippingAddressNeedToReturnError = false
                    
                    viewModel.didSelectAddress
                        .subscribe(onNext: { result in
                            expect(result) === address
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.updateCheckoutShippingAddress(with: address)
                    
                    expect(states.count) == 3
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states[1]) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                    
                    expect(viewModel.selectedAddress) === address
                    
                    expect(customerUseCaseMock.isGetCustomerStarted) == true
                }
            }
            
            context("if response failed") {
                it("should return error") {
                    checkoutUseCaseMock.isUpdateCheckoutShippingAddressNeedToReturnError = true
                    
                    viewModel.updateCheckoutShippingAddress(with: address)
                    
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
        
        describe("when delete address called") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            var selected: Bool!
            var type: AddressListType!
            
            beforeEach {
                disposeBag = DisposeBag()
                states = []
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
            }
            
            context("if address selected and customer has default address") {
                beforeEach {
                    selected = true
                    viewModel.customerDefaultAddress.value = address
                    checkoutUseCaseMock.isUpdateCheckoutShippingAddressNeedToReturnError = false
                }
                
                context("and address list type is shipping") {
                    it("should set customer default address as selected") {
                        type = .shipping
                        
                        viewModel.processDeleteAddressResponse(with: selected, type: type)
                        
                        expect(states.count) == 3
                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                        expect(states[1]) == ViewState.loading(showHud: true, isTranslucent: false)
                        expect(states.last) == ViewState.content
                        
                        expect(viewModel.selectedAddress) === address
                        
                        expect(customerUseCaseMock.isGetCustomerStarted) == true
                    }
                }
                
                context("or address list type is billing") {
                    it("should update billing address and start loading customer addresses") {
                        type = .billing
                        
                        viewModel.didSelectBillingAddress
                            .subscribe(onNext: { result in
                                expect(result) === address
                            })
                            .disposed(by: disposeBag)
                        
                        viewModel.processDeleteAddressResponse(with: selected, type: type)
                        
                        expect(states.count) == 2
                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                        expect(states.last) == ViewState.content
                        
                        expect(customerUseCaseMock.isGetCustomerStarted) == true
                    }
                }
            }
            
            context("if address not selected and customer hasn't default address") {
                it("should start loading customer addresses") {
                    selected = false
                    viewModel.customerDefaultAddress.value = nil
                    type = .shipping
                    
                    viewModel.processDeleteAddressResponse(with: selected, type: type)
                    
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                    
                    expect(customerUseCaseMock.isGetCustomerStarted) == true
                }
            }
        }
    }
}
