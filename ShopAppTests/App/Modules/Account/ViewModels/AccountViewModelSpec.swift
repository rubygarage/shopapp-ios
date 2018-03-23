//
//  AccountViewModelSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/5/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift

@testable import ShopApp

class AccountViewModelSpec: QuickSpec {
    override func spec() {
        let authentificationRepositoryMock = AuthentificationRepositoryMock()
        let shopRepositoryMock = ShopRepositoryMock()
        let customerUseCaseMock = CustomerUseCaseMock(repository: authentificationRepositoryMock)
        let loginUseCaseMock = LoginUseCaseMock(repository: authentificationRepositoryMock)
        let logoutUseCaseMock = LogoutUseCaseMock(repository: authentificationRepositoryMock)
        let shopUseCaseMock = ShopUseCaseMock(repository: shopRepositoryMock)
        
        var viewModel: AccountViewModel!
        
        beforeEach {
            viewModel = AccountViewModel(customerUseCase: customerUseCaseMock, loginUseCase: loginUseCaseMock, logoutUseCase: logoutUseCaseMock, shopUseCase: shopUseCaseMock)
        }
        
        describe("when view model initialized") {
            it("should have a correct superclass") {
                expect(viewModel).to(beAKindOf(BaseViewModel.self))
            }
            
            it("should have variables with a correct initial values") {
                expect(viewModel.policies.value.isEmpty) == true
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
                it("should have customer variable with a correct value") {
                    customerUseCaseMock.isNeedToReturnError = false
                    viewModel.loadCustomer()
                    
                    expect(viewModel.customer.value).toNot(beNil())
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if it have fail customer load") {
                it("should have customer variable with a correct value") {
                    customerUseCaseMock.isNeedToReturnError = true
                    viewModel.loadCustomer()
                    
                    expect(viewModel.customer.value).to(beNil())
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
        
        describe("when policies loaded") {
            it("should have policies variable with a correct value") {
                viewModel.loadPolicies()
                
                expect(viewModel.policies.value.isEmpty) == false
            }
        }
        
        describe("when logged out") {
            beforeEach {
                customerUseCaseMock.isNeedToReturnError = false
                viewModel.loadCustomer()
            }
            
            context("when log out successed") {
                it("should have customer variable with a correct value") {
                    logoutUseCaseMock.isNeedToReturnError = false
                    viewModel.logout()
                    
                    expect(viewModel.customer.value).to(beNil())
                }
            }
            
            context("when log out failed") {
                it("should have customer variable with a correct value") {
                    logoutUseCaseMock.isNeedToReturnError = true
                    viewModel.logout()
                    
                    expect(viewModel.customer.value).toNot(beNil())
                }
            }
        }
    }
}
