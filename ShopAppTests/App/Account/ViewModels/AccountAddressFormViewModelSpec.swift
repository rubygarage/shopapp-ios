//
//  AccountAddressFormViewModelSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift

import ShopApp_Gateway

@testable import ShopApp

class AccountAddressFormViewModelSpec: QuickSpec {
    override func spec() {
        let repositoryMock = PaymentsRepositoryMock()
        let addAddressUseCaseMock = AddAddressUseCaseMock(repository: repositoryMock)
        let updateAddressUseCaseMock = UpdateAddressUseCaseMock(repository: repositoryMock)
        let viewModel = AccountAddressFormViewModel(addAddressUseCase: addAddressUseCaseMock, updateAddressUseCase: updateAddressUseCaseMock)
        
        describe("when addresses changed") {
            var disposeBag: DisposeBag!
            var address: Address!
            var states: [ViewState]!
            
            beforeEach {
                disposeBag = DisposeBag()
                address = Address()
                address.id = "address id"
                states = []
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
            }
            
            context("if address added") {
                it("should add address") {
                    addAddressUseCaseMock.isNeedToReturnError = false
                    viewModel.addCustomerAddress(with: address)
                    
                    viewModel.filledAddress
                        .subscribe(onNext: { result in
                            expect(result) === address
                        })
                        .disposed(by: disposeBag)
                    
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
                
                it("should not add address and have error") {
                    addAddressUseCaseMock.isNeedToReturnError = true
                    viewModel.addCustomerAddress(with: address)
                    
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
            
            context("if address updated") {
                it("should update address") {
                    updateAddressUseCaseMock.isNeedToReturnError = false
                    viewModel.updateCustomerAddress(with: address)
                    
                    viewModel.filledAddress
                        .subscribe(onNext: { result in
                            expect(result) === address
                        })
                        .disposed(by: disposeBag)
                    
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
                
                it("should not update address and have error") {
                    updateAddressUseCaseMock.isNeedToReturnError = true
                    viewModel.updateCustomerAddress(with: address)
                    
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
    }
}
