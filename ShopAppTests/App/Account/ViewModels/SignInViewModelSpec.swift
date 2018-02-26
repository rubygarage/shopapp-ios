//
//  SignInViewModelSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift

@testable import ShopApp

class SignInViewModelSpec: QuickSpec {
    override func spec() {
        let repositoryMock = AuthentificationRepositoryMock()
        let loginUseCaseMock = LoginUseCaseMock(repository: repositoryMock)
        
        var viewModel: SignInViewModel!
        
        beforeEach {
            viewModel = SignInViewModel(loginUseCase: loginUseCaseMock)
        }
        
        describe("when view model initialized") {
            it("should have variables with a correct initial values") {
                expect(viewModel.emailText.value) == ""
                expect(viewModel.passwordText.value) == ""
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
                    
                    viewModel.signInButtonEnabled
                        .subscribe(onNext: { enabled in
                            expect(enabled) == true
                        })
                        .disposed(by: disposeBag)
                }
            }
            
            context("if it doesn't have symbols in both text variables") {
                it("needs to disable sign in button") {
                    viewModel.emailText.value = ""
                    
                    viewModel.signInButtonEnabled
                        .subscribe(onNext: { enabled in
                            expect(enabled) == false
                        })
                        .disposed(by: disposeBag)
                }
            }
        }
        
        describe("when sign in button pressed") {
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
                    
                    viewModel.loginPressed.onNext()
                }
            }
            
            context("if it have valid email and password texts and success sign in") {
                it("needs to dismiss view controller and show success toast") {
                    viewModel.emailText.value = "user@mail.com"
                    viewModel.passwordText.value = "password"
                    
                    viewModel.signInSuccess
                        .subscribe({ event in
                            expect(event.element).toEventuallyNot(beNil())
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.loginPressed.onNext()
                }
            }
        }
        
        describe("when try again and it have valid email and password texts and success sign in") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
                
                viewModel.emailText.value = "user@mail.com"
                viewModel.passwordText.value = "password"
            }
            
            it("needs to dismiss view controller and show success toast") {
                viewModel.signInSuccess
                    .subscribe({ event in
                        expect(event.element).toEventuallyNot(beNil())
                    })
                    .disposed(by: disposeBag)
                
                viewModel.tryAgain()
            }
        }
    }
}
