//
//  CheckoutAddressFormViewModelSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/4/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class CheckoutAddressFormViewModelSpec: QuickSpec {
    override func spec() {
        let repositoryMock = PaymentsRepositoryMock()
        let checkoutUseCaseMock = CheckoutUseCaseMock(repository: repositoryMock)
        let viewModel = CheckoutAddressFormViewModel(checkoutUseCase: checkoutUseCaseMock)
        
        beforeEach {
            viewModel.checkoutId = "Checkout id"
        }
        
        describe("when view model initialized") {
            it("should have a correct superclass") {
                expect(viewModel).to(beAKindOf(BaseViewModel.self))
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
            
            context("if address type is shipping") {
                beforeEach {
                    viewModel.addressType = .shipping
                }
                
                context("and response success") {
                    it("should update checkout shipping address") {
                        checkoutUseCaseMock.isUpdateCheckoutShippingAddressNeedToReturnError = false
                        
                        viewModel.updatedShippingAddress
                            .subscribe(onNext: { result in
                                expect(result).to(beAKindOf(Void.self))
                            })
                            .disposed(by: disposeBag)
                        
                        viewModel.updateAddress(with: Address())
                        
                        expect(states.count) == 1
                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    }
                }
                
                context("or failure") {
                    it("should return error") {
                        checkoutUseCaseMock.isUpdateCheckoutShippingAddressNeedToReturnError = true
                        
                        viewModel.updateAddress(with: Address())
                        
                        expect(states.count) == 2
                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                        expect(states.last) == ViewState.error(error: nil)
                    }
                }
            }
            
            context("if address type is billing") {
                it("should return success response") {
                    viewModel.addressType = .billing
                    let address = Address()
                    checkoutUseCaseMock.isNeedToReturnError = false
                    
                    viewModel.filledBillingAddress
                        .subscribe(onNext: { result in
                            expect(result) === address
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.updateAddress(with: address)
                }
            }
        }
    }
}
