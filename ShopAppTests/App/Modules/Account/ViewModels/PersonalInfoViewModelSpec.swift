//
//  PersonalInfoViewModelSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/26/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class PersonalInfoViewModelSpec: QuickSpec {
    override func spec() {
        let authentificationRepositoryMock = AuthentificationRepositoryMock()
        let customerRepositoryMock = CustomerRepositoryMock()
        let updateCustomerUseCaseMock = UpdateCustomerUseCaseMock(repository: customerRepositoryMock)
        let signInUseCaseMock = SignInUseCaseMock(repository: authentificationRepositoryMock)
        let customerUseCaseMock = CustomerUseCaseMock(repository: customerRepositoryMock)
        
        var viewModel: PersonalInfoViewModel!
        
        beforeEach {
            viewModel = PersonalInfoViewModel(updateCustomerUseCase: updateCustomerUseCaseMock, signInUseCase: signInUseCaseMock, customerUseCase: customerUseCaseMock)
        }
        
        describe("when view model initialized") {
            it("should have a correct superclass") {
                expect(viewModel).to(beAKindOf(BaseViewModel.self))
            }
            
            it("should have variables with a correct initial values") {
                expect(viewModel.customer.value).to(beNil())
                expect(viewModel.firstNameText.value) == ""
                expect(viewModel.lastNameText.value) == ""
                expect(viewModel.phoneText.value) == ""
            }
        }
        
        describe("when password text changed") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if it haven't customer") {
                it("needs to disable save changes button") {
                    viewModel.customer.value = nil
                    
                    viewModel.saveChangesButtonEnabled
                        .subscribe(onNext: { enabled in
                            expect(enabled) == false
                        })
                        .disposed(by: disposeBag)
                }
            }
            
            context("if it have customer") {
                var customer: Customer!
                
                beforeEach {
                    customer = TestHelper.customerWithoutAcceptsMarketing
                    viewModel.customer.value = customer
                }

                context("if it have some changed property") {
                    it("needs to enable save changes button") {
                        viewModel.saveChangesButtonEnabled
                            .subscribe(onNext: { enabled in
                                expect(enabled) == true
                            })
                            .disposed(by: disposeBag)
                    }
                }
                
                context("if it haven't any changed property") {
                    it("needs to disable save changes button") {
                        viewModel.firstNameText.value = customer.firstName
                        viewModel.lastNameText.value = customer.lastName
                        viewModel.phoneText.value = customer.phone!
                        
                        viewModel.saveChangesButtonEnabled
                            .subscribe(onNext: { enabled in
                                expect(enabled) == false
                            })
                            .disposed(by: disposeBag)
                    }
                }
            }
        }
        
        describe("when save changes button pressed") {
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
            
            context("and success save changes") {
                it("needs to show success toast and disable save changes button") {
                    viewModel.saveChangesSuccess
                        .subscribe(onNext: { enabled in
                            expect(viewModel.customer.value).toEventuallyNot(beNil())
                            expect(enabled).toEventually(beTrue())
                        })
                        .disposed(by: disposeBag)
                    
                    updateCustomerUseCaseMock.isNeedToReturnError = false
                    viewModel.saveChangesPressed.onNext()
                    
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("but fail save changes") {
                it("needs to show error") {
                    viewModel.saveChangesSuccess
                        .subscribe(onNext: { enabled in
                            expect(viewModel.customer.value).toEventually(beNil())
                            expect(enabled).toEventually(beFalse())
                        })
                        .disposed(by: disposeBag)
                    
                    updateCustomerUseCaseMock.isNeedToReturnError = true
                    viewModel.saveChangesPressed.onNext()
                    
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
        
        describe("when try again and it have valid email text") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if it have success save changes") {
                it("needs to show success toast and disable save changes button") {
                    updateCustomerUseCaseMock.isNeedToReturnError = false
                    
                    viewModel.saveChangesSuccess
                        .subscribe(onNext: { enabled in
                            expect(viewModel.customer.value).toEventuallyNot(beNil())
                            expect(enabled).toEventually(beTrue())
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.tryAgain()
                }
            }
            
            context("if it have fail save changes") {
                it("needs to show error") {
                    updateCustomerUseCaseMock.isNeedToReturnError = true
                    
                    viewModel.saveChangesSuccess
                        .subscribe(onNext: { enabled in
                            expect(viewModel.customer.value).toEventually(beNil())
                            expect(enabled).toEventually(beFalse())
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.tryAgain()
                }
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
                    let customer = TestHelper.customerWithoutAcceptsMarketing
                    
                    customerUseCaseMock.isNeedToReturnError = false
                    viewModel.loadCustomer()
                    
                    expect(viewModel.customer.value).toNot(beNil())
                    expect(viewModel.firstNameText.value) == customer.firstName
                    expect(viewModel.lastNameText.value) == customer.lastName
                    expect(viewModel.phoneText.value) == customer.phone
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
                    expect(viewModel.firstNameText.value) == ""
                    expect(viewModel.lastNameText.value) == ""
                    expect(viewModel.phoneText.value) == ""
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
    }
}
