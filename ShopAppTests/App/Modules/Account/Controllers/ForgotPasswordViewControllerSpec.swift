//
//  ForgotPasswordViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class ForgotPasswordViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: ForgotPasswordViewController!
        var viewModelMock: ForgotPasswordViewModelMock!
        var titleLabel: UILabel!
        var descriptionLabel: UILabel!
        var emailTextFieldView: InputTextFieldView!
        var forgotPasswordButton: BlackButton!
        var linkView: UIView!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.account, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.forgotPassword) as? ForgotPasswordViewController
            
            let repositoryMock = AuthentificationRepositoryMock()
            let resetPasswordUseCaseMock = ResetPasswordUseCaseMock(repository: repositoryMock)
            viewModelMock = ForgotPasswordViewModelMock(resetPasswordUseCase: resetPasswordUseCaseMock)
            viewController.viewModel = viewModelMock
            
            titleLabel = self.findView(withAccessibilityLabel: "title", in: viewController.view) as? UILabel
            descriptionLabel = self.findView(withAccessibilityLabel: "description", in: viewController.view) as? UILabel
            emailTextFieldView = self.findView(withAccessibilityLabel: "email", in: viewController.view) as? InputTextFieldView
            forgotPasswordButton = self.findView(withAccessibilityLabel: "forgotPassword", in: viewController.view) as? BlackButton
            linkView = self.findView(withAccessibilityLabel: "link", in: viewController.view)
        }
        
        describe("when view loaded") {
            it("should have a correct superclass") {
                expect(viewController.isKind(of: BaseViewController<ForgotPasswordViewModel>.self)) == true
            }
            
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(ForgotPasswordViewModel.self))
            }
            
            it("should have a title with correct text") {
                expect(viewController.title) == "ControllerTitle.ForgotPassword".localizable
            }
            
            it("should have a close button") {
                expect(viewController.navigationItem.rightBarButtonItem?.image) == #imageLiteral(resourceName: "cross")
            }
            
            it("should have labels with correct texts") {
                expect(titleLabel.text) == "Label.ForgotPassword.PasswordTitle".localizable
                expect(descriptionLabel.text) == "Label.ForgotPassword.PasswordDescription".localizable
            }
            
            it("should have text filed views with correct placeholders") {
                expect(emailTextFieldView.placeholder) == "Placeholder.Email".localizable.required.uppercased()
            }
            
            it("should have forgot password button with correct title") {
                expect(forgotPasswordButton.title(for: .normal)) == "Button.Submit".localizable.uppercased()
            }
        }

        describe("when email text changed") {
            it("needs to update variable of view model") {
                emailTextFieldView.textField.text = "user@mail.com"
                emailTextFieldView.textField.sendActions(for: .editingChanged)
                
                expect(viewModelMock.emailText.value) == "user@mail.com"
            }
        }
        
        describe("when enabling of forgot password button changed") {
            context("if it have at least one symbol in email text field view") {
                it("needs to enable forgot password button") {
                    viewModelMock.isResetPasswordButtonEnabled.value = true
                    
                    expect(forgotPasswordButton.isEnabled) == true
                }
            }
            
            context("if it doesn't have symbols in email text field view") {
                it("needs to disable forgot password button") {
                    viewModelMock.isResetPasswordButtonEnabled.value = false
                    
                    expect(forgotPasswordButton.isEnabled) == false
                }
            }
        }
        
        describe("when update button pressed") {
            it("needs to end editing and notify view model") {
                emailTextFieldView.textField.sendActions(for: .editingDidBegin)
                forgotPasswordButton.sendActions(for: .touchUpInside)
                
                expect(viewController.isEditing) == false
                expect(viewModelMock.isResetPasswordPressed) == true
            }
        }
        
        describe("when email text is not valid") {
            it("needs to show error messages about not valid email text") {
                viewModelMock.makeNotValidEmailText()
                
                expect(emailTextFieldView.errorMessage) == "Error.InvalidEmail".localizable
            }
        }
        
        describe("when email text is valid") {
            context("if reset password successed") {
                it("needs to show link view") {
                    viewModelMock.makeResetPasswordSuccess()
                    
                    expect(linkView.isHidden) == false
                }
            }
            
            context("if reset password failed") {
                it("needs to hide link view") {
                    viewModelMock.makeResetPasswordSuccess(false)
                    
                    expect(linkView.isHidden) == true
                }
            }
        }
    }
}
