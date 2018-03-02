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
        let repositoryMock = AuthentificationRepositoryMock()
        let updateCustomerUseCaseMock = UpdateCustomerUseCaseMock(repository: repositoryMock)
        let loginUseCaseMock = LoginUseCaseMock(repository: repositoryMock)
        let customerUseCaseMock = CustomerUseCaseMock(repository: repositoryMock)
        
        var viewModel: PersonalInfoViewModel!
        
        beforeEach {
            viewModel = PersonalInfoViewModel(updateCustomerUseCase: updateCustomerUseCaseMock, loginUseCase: loginUseCaseMock, customerUseCase: customerUseCaseMock)
        }
        
        describe("when view model initialized") {
            it("should have variables with a correct initial values") {
                expect(viewModel.canChangeEmail) == true
                expect(viewModel.customer.value).to(beNil())
                expect(viewModel.emailText.value) == ""
                expect(viewModel.firstNameText.value) == ""
                expect(viewModel.lastNameText.value) == ""
                expect(viewModel.phoneText.value) == ""
            }
        }
        
        describe("when email and password texts changed") {
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
                beforeEach {
                    let customer = Customer()
                    customer.email = "user@mail.com"
                    viewModel.customer.value = customer
                }
                
                context("and can change email") {
                    beforeEach {
                        viewModel.canChangeEmail = true
                    }
                    
                    context("if it have changed empty email") {
                        it("needs to disable save changes button") {
                            viewModel.emailText.value = ""
                            
                            viewModel.saveChangesButtonEnabled
                                .subscribe(onNext: { enabled in
                                    expect(enabled) == false
                                })
                                .disposed(by: disposeBag)
                        }
                    }
                    
                    context("if it have changed not empty email") {
                        it("needs to enable save changes button") {
                            viewModel.emailText.value = "user"
                            
                            viewModel.saveChangesButtonEnabled
                                .subscribe(onNext: { enabled in
                                    expect(enabled) == true
                                })
                                .disposed(by: disposeBag)
                        }
                    }
                    
                    context("if it haven't changed email") {
                        it("needs to disable save changes button") {
                            viewModel.emailText.value = "user"
                            viewModel.emailText.value = "user@mail.com"
                            
                            viewModel.saveChangesButtonEnabled
                                .subscribe(onNext: { enabled in
                                    expect(enabled) == false
                                })
                                .disposed(by: disposeBag)
                        }
                    }
                }
                
                context("but can not change email") {
                    beforeEach {
                        viewModel.canChangeEmail = false
                    }
                    
                    context("if it have some changed property") {
                        it("needs to enable save changes button") {
                            viewModel.firstNameText.value = "First"
                            
                            viewModel.saveChangesButtonEnabled
                                .subscribe(onNext: { enabled in
                                    expect(enabled) == true
                                })
                                .disposed(by: disposeBag)
                        }
                    }
                    
                    context("if it haven't any changed property") {
                        it("needs to disable save changes button") {
                            viewModel.firstNameText.value = "First"
                            viewModel.firstNameText.value = ""
                            
                            viewModel.saveChangesButtonEnabled
                                .subscribe(onNext: { enabled in
                                    expect(enabled) == false
                                })
                                .disposed(by: disposeBag)
                        }
                    }
                }
            }
        }
        
        describe("when save changes button pressed") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if it have not valid email text") {
                it("needs to show error messages about not valid email text") {
                    viewModel.emailText.value = "user@mail"
                    
                    viewModel.emailErrorMessage
                        .subscribe(onNext: { errorMessage in
                            expect(errorMessage).toEventually(equal("Error.InvalidEmail".localizable))
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.saveChangesPressed.onNext()
                }
            }
            
            context("if it have valid email text") {
                var states: [ViewState]!
                
                beforeEach {
                    states = []
                    
                    viewModel.emailText.value = "user@mail.com"
                    
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
        }
        
        describe("when try again and it have valid email text") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
                
                viewModel.emailText.value = "user@mail.com"
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
                it("needs to show errpr") {
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
                    customerUseCaseMock.isNeedToReturnError = false
                    viewModel.loadCustomer()
                    
                    expect(viewModel.customer.value).toNot(beNil())
                    expect(viewModel.firstNameText.value) == "First"
                    expect(viewModel.lastNameText.value) == "Last"
                    expect(viewModel.emailText.value) == "user@mail.com"
                    expect(viewModel.phoneText.value) == "+380990000000"
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
                    expect(viewModel.emailText.value) == ""
                    expect(viewModel.phoneText.value) == ""
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
    }
}
