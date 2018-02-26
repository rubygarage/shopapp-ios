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
            viewController = UIStoryboard(name: StoryboardNames.account, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.forgotPassword) as! ForgotPasswordViewController
            
            let repositoryMock = AuthentificationRepositoryMock()
            let resetPasswordUseCaseMock = ResetPasswordUseCaseMock(repository: repositoryMock)
            viewModelMock = ForgotPasswordViewModelMock(resetPasswordUseCase: resetPasswordUseCaseMock)
            viewController.viewModel = viewModelMock
            
            titleLabel = self.findView(withAccessibilityLabel: "title", in: viewController.view) as! UILabel
            descriptionLabel = self.findView(withAccessibilityLabel: "description", in: viewController.view) as! UILabel
            emailTextFieldView = self.findView(withAccessibilityLabel: "email", in: viewController.view) as! InputTextFieldView
            forgotPasswordButton = self.findView(withAccessibilityLabel: "forgotPassword", in: viewController.view) as! BlackButton
            linkView = self.findView(withAccessibilityLabel: "link", in: viewController.view)
        }
        
        describe("when view loaded") {
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
            context("if it have at least one symbol in text field view") {
                it("needs to enable forgot password button") {
                    viewModelMock.makeForgotPasswordButtonEnabled()
                    
                    expect(forgotPasswordButton.isEnabled) == true
                }
            }
            
            context("if it doesn't have symbols in text variable") {
                it("needs to disable forgot password button") {
                    viewModelMock.makeForgotPasswordButtonDisabled()
                    
                    expect(forgotPasswordButton.isEnabled) == false
                }
            }
        }
        
        describe("when update button pressed") {
            it("needs to end editing") {
                emailTextFieldView.textField.sendActions(for: .editingDidBegin)
                forgotPasswordButton.sendActions(for: .touchUpInside)
                
                expect(viewController.isEditing) == false
            }
            
            context("if it have not valid email text") {
                it("needs to show error messages about not valid email texts") {
                    viewModelMock.makeNotValidEmailText()
                    
                    expect(emailTextFieldView.errorMessage) == "Error.InvalidEmail".localizable
                }
            }
            
            context("if it have valid email text") {
                it("needs to reset password and show link view") {
                    viewModelMock.makeSuccessResetPassword()
                    
                    expect(linkView.isHidden) == false
                }
            }
        }
    }
}
