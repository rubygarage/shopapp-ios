//
//  SignInViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import Toaster

@testable import ShopApp

class SignInViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: SignInViewController!
        var viewModelMock: SignInViewModelMock!
        var emailTextFieldView: InputTextFieldView!
        var passwordTextFieldView: InputTextFieldView!
        var forgotButton: UIButton!
        var signInButton: BlackButton!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.account, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.signIn) as! SignInViewController
            
            let repositoryMock = AuthentificationRepositoryMock()
            let loginUseCaseMock = LoginUseCaseMock(repository: repositoryMock)
            viewModelMock = SignInViewModelMock(loginUseCase: loginUseCaseMock)
            viewController.viewModel = viewModelMock
            
            emailTextFieldView = self.findView(withAccessibilityLabel: "email", in: viewController.view) as! InputTextFieldView
            passwordTextFieldView = self.findView(withAccessibilityLabel: "password", in: viewController.view) as! InputTextFieldView
            forgotButton = self.findView(withAccessibilityLabel: "forgot", in: viewController.view) as! UIButton
            signInButton = self.findView(withAccessibilityLabel: "signIn", in: viewController.view) as! BlackButton
        }
        
        describe("when view loaded") {
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(SignInViewModel.self))
            }
            
            it("should have a title with correct text") {
                expect(viewController.title) == "ControllerTitle.SignIn".localizable
            }
            
            it("should have a close button") {
                expect(viewController.navigationItem.rightBarButtonItem?.image) == #imageLiteral(resourceName: "cross")
            }
            
            it("should have text filed views with correct placeholders") {
                expect(emailTextFieldView.placeholder) == "Placeholder.Email".localizable.required.uppercased()
                expect(passwordTextFieldView.placeholder) == "Placeholder.Password".localizable.required.uppercased()
            }
            
            it("should have buttons with correct titles") {
                expect(forgotButton.title(for: .normal)) == "Button.Forgot".localizable
                expect(signInButton.title(for: .normal)) == "Button.SignIn".localizable.uppercased()
            }
        }
        
        describe("when email and password texts changed") {
            it("needs to update variable of view model") {
                emailTextFieldView.textField.text = "user@mail.com"
                emailTextFieldView.textField.sendActions(for: .editingChanged)
                passwordTextFieldView.textField.text = "password"
                passwordTextFieldView.textField.sendActions(for: .editingChanged)
                
                expect(viewModelMock.emailText.value) == "user@mail.com"
                expect(viewModelMock.passwordText.value) == "password"
            }
            
            context("if it have at least one symbol in each text field view") {
                it("needs to enable sign in button") {
                    viewModelMock.makeSignInButtonEnabled()
                    
                    expect(signInButton.isEnabled) == true
                }
            }
            
            context("if it doesn't have symbols in both text variables") {
                it("needs to disable sign in button") {
                    viewModelMock.makeSignInButtonDisabled()
                    
                    expect(signInButton.isEnabled) == false
                }
            }
        }
        
        describe("when sign in button pressed") {
            it("needs to end editing") {
                emailTextFieldView.textField.sendActions(for: .editingDidBegin)
                signInButton.sendActions(for: .touchUpInside)
                
                expect(viewController.isEditing) == false
            }
            
            context("if it have not valid email and password texts") {
                it("needs to show error messages about not valid email and password texts") {
                    viewModelMock.makeNotValidEmailAndPasswordTexts()
                    signInButton.sendActions(for: .touchUpInside)
                    
                    expect(emailTextFieldView.errorMessage) == "Error.InvalidEmail".localizable
                    expect(passwordTextFieldView.errorMessage) == "Error.InvalidPassword".localizable
                }
            }
            
            context("if it have valid email and password texts") {
                it("needs to sign in and show success toast") {
                    viewModelMock.makeValidEmailAndPasswordTexts()
                    signInButton.sendActions(for: .touchUpInside)
                    
                    expect(ToastCenter.default.currentToast).toNot(beNil())
                }
            }
        }
    }
}
