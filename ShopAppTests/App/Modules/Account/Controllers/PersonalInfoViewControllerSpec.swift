//
//  PersonalInfoViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/27/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import Toaster

@testable import ShopApp

class PersonalInfoViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: PersonalInfoViewController!
        var viewModelMock: PersonalInfoViewModelMock!
        var emailTextFieldView: InputTextFieldView!
        var nameTextFieldView: InputTextFieldView!
        var lastNameTextFieldView: InputTextFieldView!
        var phoneTextFieldView: InputTextFieldView!
        var changePasswordButton: UnderlinedButton!
        var saveChangesButton: BlackButton!
        var changePasswordUnderlineView: UIView!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.account, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.personalInfo) as! PersonalInfoViewController
            
            let repositoryMock = AuthentificationRepositoryMock()
            let updateCustomerUseCaseMock = UpdateCustomerUseCaseMock(repository: repositoryMock)
            let loginUseCaseMock = LoginUseCaseMock(repository: repositoryMock)
            let customerUseCaseMock = CustomerUseCaseMock(repository: repositoryMock)
            viewModelMock = PersonalInfoViewModelMock(updateCustomerUseCase: updateCustomerUseCaseMock, loginUseCase: loginUseCaseMock, customerUseCase: customerUseCaseMock)
            viewModelMock.isCustomerLoadingStarted = false
            viewController.viewModel = viewModelMock
            
            emailTextFieldView = self.findView(withAccessibilityLabel: "email", in: viewController.view) as! InputTextFieldView
            nameTextFieldView = self.findView(withAccessibilityLabel: "name", in: viewController.view) as! InputTextFieldView
            lastNameTextFieldView = self.findView(withAccessibilityLabel: "lastName", in: viewController.view) as! InputTextFieldView
            phoneTextFieldView = self.findView(withAccessibilityLabel: "phone", in: viewController.view) as! InputTextFieldView
            changePasswordButton = self.findView(withAccessibilityLabel: "changePassword", in: viewController.view) as! UnderlinedButton
            saveChangesButton = self.findView(withAccessibilityLabel: "saveChanges", in: viewController.view) as! BlackButton
            changePasswordUnderlineView = self.findView(withAccessibilityLabel: "resendUnderlineView", in: viewController.view)
        }
        
        describe("when view loaded") {
            it("should have a correct superclass") {
                expect(viewController.isKind(of: BaseViewController<PersonalInfoViewModel>.self)) == true
            }
            
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(PersonalInfoViewModel.self))
            }
            
            it("should have a title with correct text") {
                expect(viewController.title) == "ControllerTitle.PersonalInfo".localizable
            }
            
            it("should have text filed views with correct placeholders") {
                expect(emailTextFieldView.placeholder) == "Placeholder.Email".localizable.required.uppercased()
                expect(nameTextFieldView.placeholder) == "Placeholder.Name".localizable.uppercased()
                expect(lastNameTextFieldView.placeholder) == "Placeholder.LastName".localizable.uppercased()
                expect(phoneTextFieldView.placeholder) == "Placeholder.PhoneNumber".localizable.uppercased()
            }
            
            it("should have disabled email text field") {
                expect(emailTextFieldView.textField.isEnabled) == false
            }
            
            it("should have buttons with correct titles") {
                expect(changePasswordButton.title(for: .normal)) == "Button.ChangePassword".localizable.uppercased()
                expect(saveChangesButton.title(for: .normal)) == "Button.SaveChanges".localizable.uppercased()
            }
            
            it("should have correct delegate of change password button") {
                expect(changePasswordButton.delegate) === viewController
            }
            
            it("should have correct setup view model") {
                expect(viewModelMock.canChangeEmail) == false
            }
            
            it("should load customer") {
                expect(viewModelMock.isCustomerLoadingStarted) == true
            }
        }
        
        describe("when email text changed") {
            it("needs to update variable of view model") {
                viewModelMock.canChangeEmail = true
                emailTextFieldView.textField.text = "user@gmail.com"
                emailTextFieldView.textField.sendActions(for: .editingChanged)
                
                expect(viewModelMock.emailText.value) == "user@gmail.com"
            }
        }
        
        describe("when enabling of save changes button changed") {
            context("if it have at least one symbol in email text field view and this text not equal with customer's email") {
                it("needs to enable save changes button") {
                    viewModelMock.isSaveChangesButtonEnabled.value = true
                    
                    expect(saveChangesButton.isEnabled) == true
                }
            }
            
            context("if it doesn't have symbols in email text variables or this text equal with customer's email") {
                it("needs to disable save changes button") {
                    viewModelMock.isSaveChangesButtonEnabled.value = false
                    
                    expect(saveChangesButton.isEnabled) == false
                }
            }
        }
        
        describe("when names and phone texts changed") {
            it("needs to update variables of view model") {
                nameTextFieldView.textField.text = "Name"
                nameTextFieldView.textField.sendActions(for: .editingChanged)
                lastNameTextFieldView.textField.text = "Surname"
                lastNameTextFieldView.textField.sendActions(for: .editingChanged)
                phoneTextFieldView.textField.text = "+380500000000"
                phoneTextFieldView.textField.sendActions(for: .editingChanged)
                
                expect(viewModelMock.firstNameText.value) == "Name"
                expect(viewModelMock.lastNameText.value) == "Surname"
                expect(viewModelMock.phoneText.value) == "+380500000000"
            }
        }
        
        describe("when save changes button pressed") {
            it("needs to end editing and notify view model") {
                emailTextFieldView.textField.sendActions(for: .editingDidBegin)
                saveChangesButton.sendActions(for: .touchUpInside)
                
                expect(viewController.isEditing) == false
                expect(viewModelMock.isSaveChangesPressed) == true
            }
        }
        
        describe("when email text is not valid") {
            it("needs to show error messages about not valid email text") {
                viewModelMock.makeNotValidEmailText()
                
                expect(emailTextFieldView.errorMessage) == "Error.InvalidEmail".localizable
            }
        }
        
        describe("when email text is valid") {
            context("if save changes successed") {
                it("needs to show success toast and disable save changes button") {
                    viewModelMock.makeSaveChangesSuccess()
                    
                    expect(ToastCenter.default.currentToast?.text) == "Alert.ProfileChanged".localizable
                    expect(saveChangesButton.isEnabled) == false
                }
            }
            
            context("if save changes failed") {
                it("needs to enable save changes button") {
                    viewModelMock.makeSaveChangesSuccess(false)
                    
                    expect(ToastCenter.default.currentToast).to(beNil())
                    expect(saveChangesButton.isEnabled) == true
                }
            }
            
            afterEach {
                ToastCenter.default.cancelAll()
            }
        }
        
        describe("when change password button pressed") {
            it("needs to hide change password underline view on highlighted state") {
                changePasswordButton.isHighlighted = true
                
                expect(changePasswordUnderlineView.isHidden) == true
            }
            
            it("needs to show change password underline view on normal state") {
                changePasswordButton.isHighlighted = false
                
                expect(changePasswordUnderlineView.isHidden) == false
            }
        }
        
        describe("when customer loaded") {
            it("needs to populate text filed views with customer's data") {
                expect(nameTextFieldView.textField.text) == "First"
                expect(lastNameTextFieldView.textField.text) == "Last"
                expect(emailTextFieldView.textField.text) == "user@mail.com"
                expect(phoneTextFieldView.textField.text) == "+380990000000"
            }
        }
    }
}
