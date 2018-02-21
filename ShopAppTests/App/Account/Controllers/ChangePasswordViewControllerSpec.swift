//
//  ChangePasswordViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift

@testable import ShopApp

class ChangePasswordViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: ChangePasswordViewController!
        var newPasswordTextFieldView: InputTextFieldView!
        var confirmPasswordTextFieldView: InputTextFieldView!
        var updateButton: BlackButton!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.account, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.changePassword) as! ChangePasswordViewController
            let repository = AuthentificationRepositoryMock()
            let updateCustomerUseCaseMock = UpdateCustomerUseCaseMock(repository: repository)
            viewController.viewModel = ChangePasswordViewModel(updateCustomerUseCase: updateCustomerUseCaseMock)
            
            newPasswordTextFieldView = self.findView(withAccessibilityLabel: "newPassword", in: viewController.view) as! InputTextFieldView
            confirmPasswordTextFieldView = self.findView(withAccessibilityLabel: "confirmPassword", in: viewController.view) as! InputTextFieldView
            updateButton = self.findView(withAccessibilityLabel: "update", in: viewController.view) as! BlackButton
            
            _ = viewController.view
        }
        
        describe("when view loaded") {
            it("should have a view model with correct type") {
                expect(viewController.viewModel).to(beAnInstanceOf(ChangePasswordViewModel.self))
            }
            
            it("should have a title with correct text") {
                expect(viewController.title).to(equal("ControllerTitle.SetNewPassword".localizable))
            }
            
            it("should have a close button") {
                expect(viewController.navigationItem.rightBarButtonItem?.image).to(equal(#imageLiteral(resourceName: "cross")))
            }
            
            it("should have text filed views with correct placeholders") {
                expect(newPasswordTextFieldView.placeholder).to(equal("Placeholder.NewPassword".localizable.required.uppercased()))
                expect(confirmPasswordTextFieldView.placeholder).to(equal("Placeholder.ConfirmPassword".localizable.required.uppercased()))
            }
            
            it("should have an update button with correct title") {
                expect(updateButton.title(for: .normal)).to(equal("Button.Update".localizable.uppercased()))
            }
        }
        
        describe("when password texts changed") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
                
                newPasswordTextFieldView.textField.text = "p"
                newPasswordTextFieldView.textField.sendActions(for: .editingChanged)
                confirmPasswordTextFieldView.textField.text = ""
                confirmPasswordTextFieldView.textField.sendActions(for: .editingChanged)
            }
            
            context("if it have at least one symbol in each text field view") {
                it("needs to enable update button") {
                    confirmPasswordTextFieldView.textField.text = "p"
                    confirmPasswordTextFieldView.textField.sendActions(for: .editingChanged)
                    
                    viewController.viewModel.updateButtonEnabled
                        .subscribe(onNext: { _ in
                            expect(updateButton.isEnabled).toEventually(beTrue())
                        })
                        .disposed(by: disposeBag)
                }
            }
            
            context("if it doesn't have symbols in both text variables") {
                it("needs to disable update button") {
                    newPasswordTextFieldView.textField.text = ""
                    newPasswordTextFieldView.textField.sendActions(for: .editingChanged)
                    
                    viewController.viewModel.updateButtonEnabled
                        .subscribe(onNext: { _ in
                            expect(updateButton.isEnabled).toEventually(beFalse())
                        })
                        .disposed(by: disposeBag)
                }
            }
        }
        
        describe("when update button pressed") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
                
                newPasswordTextFieldView.textField.text = "password"
                confirmPasswordTextFieldView.textField.text = "password"
            }
            
            context("if it have not valid password texts") {
                it("needs to show error messages about not valid password texts") {
                    newPasswordTextFieldView.textField.text = "pass"
                    newPasswordTextFieldView.textField.sendActions(for: .editingChanged)
                    confirmPasswordTextFieldView.textField.text = "pas"
                    confirmPasswordTextFieldView.textField.sendActions(for: .editingChanged)
                    
                    viewController.viewModel.newPasswordErrorMessage
                        .subscribe(onNext: { _ in
                            expect(newPasswordTextFieldView.errorMessage).toEventually(equal("Error.InvalidPassword".localizable))
                        })
                        .disposed(by: disposeBag)
                    
                    viewController.viewModel.confirmPasswordErrorMessage
                        .subscribe(onNext: { _ in
                            expect(confirmPasswordTextFieldView.errorMessage).toEventually(equal("Error.InvalidPassword".localizable))
                        })
                        .disposed(by: disposeBag)
                    
                    updateButton.sendActions(for: .touchUpInside)
                }
            }
            
            context("if it have not equals password texts") {
                it("needs to show error message about not equals password texts") {
                    confirmPasswordTextFieldView.textField.text = "passwor"
                    confirmPasswordTextFieldView.textField.sendActions(for: .editingChanged)
                    
                    viewController.viewModel.confirmPasswordErrorMessage
                        .subscribe(onNext: { _ in
                            expect(confirmPasswordTextFieldView.errorMessage).toEventually(equal("Error.PasswordsAreNotEquals".localizable))
                        })
                        .disposed(by: disposeBag)
                    
                    updateButton.sendActions(for: .touchUpInside)
                }
            }
        }
    }
}
