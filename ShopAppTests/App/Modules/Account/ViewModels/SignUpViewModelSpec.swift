//
//  SignUpViewModelSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift

@testable import ShopApp

class SignUpViewModelSpec: QuickSpec {
    override func spec() {
        let shopRepositoryMock = ShopRepositoryMock()
        let authentificationRepositoryMock = AuthentificationRepositoryMock()
        let shopUseCaseMock = ShopUseCaseMock(repository: shopRepositoryMock)
        let signUpUseCaseMock = SignUpUseCaseMock(repository: authentificationRepositoryMock)
        
        var viewModel: SignUpViewModel!
        
        beforeEach {
            viewModel = SignUpViewModel(shopUseCase: shopUseCaseMock, signUpUseCase: signUpUseCaseMock)
        }
        
        describe("when view model initialized") {
            it("should have a correct superclass") {
                expect(viewModel).to(beAKindOf(BaseViewModel.self))
            }
            
            it("should have variables with a correct initial values") {
                expect(viewModel.emailText.value) == ""
                expect(viewModel.firstNameText.value) == ""
                expect(viewModel.lastNameText.value) == ""
                expect(viewModel.phoneText.value) == ""
                expect(viewModel.passwordText.value) == ""
                expect(viewModel.policies.value.privacyPolicy).to(beNil())
                expect(viewModel.policies.value.termsOfService).to(beNil())
            }
        }
        
        describe("when email and password texts changed") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
                
                viewModel.emailText.value = "e"
                viewModel.passwordText.value = ""
            }
            
            context("if it have at least one symbol in each text variable") {
                it("needs to enable sign in button") {
                    viewModel.passwordText.value = "p"
                    
                    viewModel.signUpButtonEnabled
                        .subscribe(onNext: { enabled in
                            expect(enabled) == true
                        })
                        .disposed(by: disposeBag)
                }
            }
            
            context("if it doesn't have symbols in both text variables") {
                it("needs to disable sign in button") {
                    viewModel.emailText.value = ""
                    
                    viewModel.signUpButtonEnabled
                        .subscribe(onNext: { enabled in
                            expect(enabled) == false
                        })
                        .disposed(by: disposeBag)
                }
            }
        }
        
        describe("when sign up button pressed") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if it have not valid email and password texts") {
                it("needs to show error messages about not valid email and password texts") {
                    viewModel.emailText.value = "user@mail"
                    viewModel.passwordText.value = "pass"
                    
                    viewModel.emailErrorMessage
                        .subscribe(onNext: { errorMessage in
                            expect(errorMessage).toEventually(equal("Error.InvalidEmail".localizable))
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.passwordErrorMessage
                        .subscribe(onNext: { errorMessage in
                            expect(errorMessage).toEventually(equal("Error.InvalidPassword".localizable))
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.signUpPressed.onNext()
                }
            }
            
            context("if it have valid email and password texts") {
                var states: [ViewState]!
                
                beforeEach {
                    states = []
                    
                    viewModel.emailText.value = "user@mail.com"
                    viewModel.passwordText.value = "password"
                    
                    viewModel.state
                        .subscribe(onNext: { state in
                            states.append(state)
                        })
                        .disposed(by: disposeBag)
                }
                
                context("and sign in successed") {
                    it("needs to dismiss view controller and show success toast") {
                        viewModel.signUpSuccess
                            .subscribe(onNext: { success in
                                expect(success).toEventually(beTrue())
                            })
                            .disposed(by: disposeBag)
                        
                        signUpUseCaseMock.isNeedToReturnError = false
                        viewModel.signUpPressed.onNext()
                        
                        expect(states.count) == 2
                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                        expect(states.last) == ViewState.content
                    }
                }
                
                context("but sign in failed") {
                    it("needs to show error") {
                        signUpUseCaseMock.isNeedToReturnError = true
                        viewModel.signUpPressed.onNext()
                        
                        expect(states.count) == 2
                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                        expect(states.last) == ViewState.error(error: nil)
                    }
                }
            }
        }
        
        describe("when try again and it have valid email and password texts and success sign in") {
            it("needs to dismiss view controller and show success toast") {
                let disposeBag = DisposeBag()
                signUpUseCaseMock.isNeedToReturnError = false
                viewModel.emailText.value = "user@mail.com"
                viewModel.passwordText.value = "password"
                
                viewModel.signUpSuccess
                    .subscribe(onNext: { success in
                        expect(success).toEventually(beTrue())
                    })
                    .disposed(by: disposeBag)
                
                viewModel.tryAgain()
            }
        }
        
        describe("when shop loaded") {
            it("needs to show accept policies label") {
                let disposeBag = DisposeBag()
                viewModel.loadPolicies()
                
                viewModel.policies.asObservable()
                    .subscribe(onNext: { (privacyPolicy, termsOfService) in
                        expect(privacyPolicy).toNot(beNil())
                        expect(termsOfService).toNot(beNil())
                    })
                    .disposed(by: disposeBag)
            }
        }
    }
}
