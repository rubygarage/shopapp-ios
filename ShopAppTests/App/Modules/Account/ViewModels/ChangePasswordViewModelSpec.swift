//
//  ChangePasswordViewModelSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift

@testable import ShopApp

class ChangePasswordViewModelSpec: QuickSpec {
    override func spec() {
        let repositoryMock = CustomerRepositoryMock()
        let updateCustomerUseCaseMock = UpdateCustomerUseCaseMock(repository: repositoryMock)
        
        var viewModel: ChangePasswordViewModel!
        
        beforeEach {
            viewModel = ChangePasswordViewModel(updateCustomerUseCase: updateCustomerUseCaseMock)
        }
        
        describe("when view model initialized") {
            it("should have a correct superclass") {
                expect(viewModel).to(beAKindOf(BaseViewModel.self))
            }
            
            it("should have variables with a correct initial values") {
                expect(viewModel.newPasswordText.value) == ""
                expect(viewModel.confirmPasswordText.value) == ""
            }
        }
        
        describe("when password texts changed") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
                
                viewModel.newPasswordText.value = "p"
                viewModel.confirmPasswordText.value = ""
            }
            
            context("if it have at least one symbol in each text variable") {
                it("needs to enable update button") {
                    viewModel.confirmPasswordText.value = "p"
                    
                    viewModel.updateButtonEnabled
                        .subscribe(onNext: { enabled in
                            expect(enabled) == true
                        })
                        .disposed(by: disposeBag)
                }
            }
            
            context("if it doesn't have symbols in both text variables") {
                it("needs to disable update button") {
                    viewModel.newPasswordText.value = ""
                    
                    viewModel.updateButtonEnabled
                        .subscribe(onNext: { enabled in
                            expect(enabled) == false
                        })
                        .disposed(by: disposeBag)
                }
            }
        }
        
        describe("when update button pressed") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
                
                viewModel.newPasswordText.value = "password"
                viewModel.confirmPasswordText.value = "password"
            }
            
            context("if it have not valid password texts") {
                it("needs to show error messages about not valid password texts") {
                    viewModel.newPasswordText.value = "pass"
                    viewModel.confirmPasswordText.value = "pas"
                    
                    viewModel.newPasswordErrorMessage
                        .subscribe(onNext: { errorMessage in
                            expect(errorMessage).toEventually(equal("Error.InvalidPassword".localizable))
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.confirmPasswordErrorMessage
                        .subscribe(onNext: { errorMessage in
                            expect(errorMessage).toEventually(equal("Error.InvalidPassword".localizable))
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.updatePressed.onNext(())
                }
            }
            
            context("if it have not equals password texts") {
                it("needs to show error message about not equals password texts") {
                    viewModel.confirmPasswordText.value = "passwor"
                    
                    viewModel.confirmPasswordErrorMessage
                        .subscribe(onNext: { errorMessage in
                            expect(errorMessage).toEventually(equal("Error.PasswordsAreNotEquals".localizable))
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.updatePressed.onNext(())
                    
                    viewModel.state
                        .subscribe(onNext: { state in
                            expect(state) == ViewState.content
                        })
                        .disposed(by: disposeBag)
                }
            }
            
            context("if it have valid and equals password texts") {
                var states: [ViewState]!
                
                beforeEach {
                    states = []
                    
                    viewModel.state
                        .subscribe(onNext: { state in
                            states.append(state)
                        })
                        .disposed(by: disposeBag)
                }
                
                context("and customer's password changed") {
                    it("needs to dismiss view controller") {
                        viewModel.updateSuccess
                            .subscribe(onNext: { success in
                                expect(success).toEventually(beTrue())
                            })
                            .disposed(by: disposeBag)
                        
                        updateCustomerUseCaseMock.isNeedToReturnError = false
                        viewModel.updatePressed.onNext(())
                        
                        expect(states.count) == 2
                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                        expect(states.last) == ViewState.content
                    }
                }
                
                context("but customer's password doesn't changed") {
                    it("needs to show toast with error message") {
                        viewModel.updateSuccess
                            .subscribe(onNext: { success in
                                expect(success).toEventually(beFalse())
                            })
                            .disposed(by: disposeBag)
                        
                        updateCustomerUseCaseMock.isNeedToReturnError = true
                        viewModel.updatePressed.onNext(())
                        
                        expect(states.count) == 2
                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                        expect(states.last) == ViewState.error(error: nil)
                    }
                }
            }
        }
        
        describe("when try again and if have valid and equals password texts and success reset password") {
            it("needs to dismiss view controller") {
                let disposeBag = DisposeBag()
                viewModel.newPasswordText.value = "password"
                viewModel.confirmPasswordText.value = "password"
                updateCustomerUseCaseMock.isNeedToReturnError = false
                
                viewModel.updateSuccess
                    .subscribe(onNext: { success in
                        expect(success).toEventually(beTrue())
                    })
                    .disposed(by: disposeBag)
                
                viewModel.tryAgain()
            }
        }
    }
}
