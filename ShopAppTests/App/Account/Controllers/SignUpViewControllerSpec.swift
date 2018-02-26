//
//  SignUpViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import Toaster
import TTTAttributedLabel

@testable import ShopApp

class SignUpViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: SignUpViewController!
        var viewModelMock: SignUpViewModelMock!
        var emailTextFieldView: InputTextFieldView!
        var nameTextFieldView: InputTextFieldView!
        var lastNameTextFieldView: InputTextFieldView!
        var phoneTextFieldView: InputTextFieldView!
        var passwordTextFieldView: InputTextFieldView!
        var signUpButton: BlackButton!
        var acceptPoliciesLabel: TTTAttributedLabel!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.account, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.signUp) as! SignUpViewController
            
            let shopRepositoryMock = ShopRepositoryMock()
            let authentificationRepositoryMock = AuthentificationRepositoryMock()
            let shopUseCase = ShopUseCaseMock(repository: shopRepositoryMock)
            let signUpUseCase = SignUpUseCaseMock(repository: authentificationRepositoryMock)
            viewModelMock = SignUpViewModelMock(shopUseCase: shopUseCase, signUpUseCase: signUpUseCase)
            viewController.viewModel = viewModelMock
            
            emailTextFieldView = self.findView(withAccessibilityLabel: "email", in: viewController.view) as! InputTextFieldView
            nameTextFieldView = self.findView(withAccessibilityLabel: "name", in: viewController.view) as! InputTextFieldView
            lastNameTextFieldView = self.findView(withAccessibilityLabel: "lastName", in: viewController.view) as! InputTextFieldView
            phoneTextFieldView = self.findView(withAccessibilityLabel: "phone", in: viewController.view) as! InputTextFieldView
            passwordTextFieldView = self.findView(withAccessibilityLabel: "password", in: viewController.view) as! InputTextFieldView
            signUpButton = self.findView(withAccessibilityLabel: "signUp", in: viewController.view) as! BlackButton
            acceptPoliciesLabel = self.findView(withAccessibilityLabel: "acceptPolicies", in: viewController.view) as! TTTAttributedLabel
        }
        
        describe("when view loaded") {
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(SignUpViewModel.self))
            }
            
            it("should have a title with correct text") {
                expect(viewController.title) == "ControllerTitle.SignUp".localizable
            }
            
            it("should have a close button") {
                expect(viewController.navigationItem.rightBarButtonItem?.image) == #imageLiteral(resourceName: "cross")
            }
            
            it("should have text filed views with correct placeholders") {
                expect(emailTextFieldView.placeholder) == "Placeholder.Email".localizable.required.uppercased()
                expect(nameTextFieldView.placeholder) == "Placeholder.Name".localizable.uppercased()
                expect(lastNameTextFieldView.placeholder) == "Placeholder.LastName".localizable.uppercased()
                expect(phoneTextFieldView.placeholder) == "Placeholder.PhoneNumber".localizable.uppercased()
                expect(passwordTextFieldView.placeholder) == "Placeholder.CreatePassword".localizable.required.uppercased()
            }
            
            it("should have sign up button with correct title") {
                expect(signUpButton.title(for: .normal)) == "Button.CreateNewAccount".localizable.uppercased()
            }
            
            it("should have accept policies label with correct text") {
                expect(acceptPoliciesLabel.text) == "Label.AcceptPoliciesAttributed".localizable
            }
        }
        
        describe("when email and password texts changed") {
            context("if it have at least one symbol in each text field view") {
                it("needs to enable sign up button") {
                    viewModelMock.makeSignUpButtonEnabled()
                    
                    expect(signUpButton.isEnabled) == true
                }
            }
            
            context("if it doesn't have symbols in both text variables") {
                it("needs to disable sign up button") {
                    viewModelMock.makeSignUpButtonDisabled()
                    
                    expect(signUpButton.isEnabled) == false
                }
            }
        }
        
        describe("when sign up button pressed") {
            it("needs to end editing") {
                emailTextFieldView.textField.sendActions(for: .editingDidBegin)
                signUpButton.sendActions(for: .touchUpInside)
                
                expect(viewController.isEditing) == false
            }
            
            context("if it have not valid email and password texts") {
                it("needs to show error messages about not valid email and password texts") {
                    viewModelMock.makeNotValidEmailAndPasswordTexts()
                    
                    expect(emailTextFieldView.errorMessage).toEventually(equal("Error.InvalidEmail".localizable))
                    expect(passwordTextFieldView.errorMessage).toEventually(equal("Error.InvalidPassword".localizable))
                }
            }
            
            context("if it have valid email and password texts") {
                it("needs to sign in and show success toast") {
                    viewModelMock.makeSuccessSignUp()
                    
                    expect(ToastCenter.default.currentToast).toEventuallyNot(beNil())
                }
            }
        }
        
        describe("when shop loaded") {
            context("if it have policies") {
                it("needs to show accept policies label") {
                    viewModelMock.isNeedToReturnPolicies = true
                    viewModelMock.loadPolicies()
                    
                    expect(acceptPoliciesLabel.isHidden) == false
                }
            }
            
            context("if it haven't policies") {
                it("needs to hide accept policies label") {
                    viewModelMock.isNeedToReturnPolicies = false
                    viewModelMock.loadPolicies()
                    
                    expect(acceptPoliciesLabel.isHidden) == true
                }
            }
        }
    }
}
