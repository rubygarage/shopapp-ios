//
//  SettingsViewModelSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/28/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift

@testable import ShopApp

class SettingsViewModelSpec: QuickSpec {
    override func spec() {
        let authentificationRepositoryMock = AuthentificationRepositoryMock()
        let customerRepositoryMock = CustomerRepositoryMock()
        let updateCustomerUseCaseMock = UpdateCustomerUseCaseMock(repository: customerRepositoryMock)
        let signInUseCaseMock = SignInUseCaseMock(repository: authentificationRepositoryMock)
        let customerUseCaseMock = CustomerUseCaseMock(repository: customerRepositoryMock)
        
        var viewModel: SettingsViewModel!
        
        beforeEach {
            viewModel = SettingsViewModel(updateCustomerUseCase: updateCustomerUseCaseMock, signInUseCase: signInUseCaseMock, customerUseCase: customerUseCaseMock)
        }
        
        describe("when view model initialized") {
            it("should have a correct superclass") {
                expect(viewModel).to(beAKindOf(BaseViewModel.self))
            }
            
            it("should have variable with correct initial value") {
                expect(viewModel.customer.value).to(beNil())
            }
        }
        
        describe("when customer loaded") {
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
            
            context("if it have success customer load") {
                it("should have variables with a correct values") {
                    customerUseCaseMock.isNeedToReturnError = false
                    viewModel.loadCustomer()
                    
                    expect(viewModel.customer.value).toNot(beNil())
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if it have fail customer load") {
                it("should have variables with a correct values") {
                    customerUseCaseMock.isNeedToReturnError = true
                    viewModel.loadCustomer()
                    
                    expect(viewModel.customer.value).to(beNil())
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
        
        describe("when settings changed") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            
            beforeEach {
                disposeBag = DisposeBag()
                states = []
                
                customerUseCaseMock.isNeedToReturnError = false
                viewModel.loadCustomer()
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
            }
            context("and it failed") {
                it("needs to show error") {
                    updateCustomerUseCaseMock.isNeedToReturnError = true
                    updateCustomerUseCaseMock.isNeedToReturnCustomerWithAcceptsMarketing = false
                    viewModel.setPromo(true)
                    
                    expect(viewModel.customer.value?.isAcceptsMarketing) == false
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
            
            context("and it successed") {
                it("needs to show content of screen") {
                    updateCustomerUseCaseMock.isNeedToReturnError = false
                    updateCustomerUseCaseMock.isNeedToReturnCustomerWithAcceptsMarketing = true
                    viewModel.setPromo(true)
                    
                    expect(viewModel.customer.value?.isAcceptsMarketing) == false
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
        }
    }
}
