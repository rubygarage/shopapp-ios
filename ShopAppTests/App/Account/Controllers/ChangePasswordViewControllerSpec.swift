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
        var viewModelMock: ChangePasswordViewModelMock!
        var newPasswordTextFieldView: InputTextFieldView!
        var confirmPasswordTextFieldView: InputTextFieldView!
        var updateButton: BlackButton!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.account, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.changePassword) as! ChangePasswordViewController
            
            let repository = AuthentificationRepositoryMock()
            let updateCustomerUseCaseMock = UpdateCustomerUseCaseMock(repository: repository)
            viewModelMock = ChangePasswordViewModelMock(updateCustomerUseCase: updateCustomerUseCaseMock)
            viewController.viewModel = viewModelMock
            
            newPasswordTextFieldView = self.findView(withAccessibilityLabel: "newPassword", in: viewController.view) as! InputTextFieldView
            confirmPasswordTextFieldView = self.findView(withAccessibilityLabel: "confirmPassword", in: viewController.view) as! InputTextFieldView
            updateButton = self.findView(withAccessibilityLabel: "update", in: viewController.view) as! BlackButton
            
            _ = viewController.view
        }
        
        describe("when view loaded") {
            it("should have a title with correct text") {
                expect(viewController.title) == "ControllerTitle.SetNewPassword".localizable
            }
            
            it("should have a close button") {
                expect(viewController.navigationItem.rightBarButtonItem?.image) == #imageLiteral(resourceName: "cross")
            }
            
            it("should have text filed views with correct placeholders") {
                expect(newPasswordTextFieldView.placeholder) == "Placeholder.NewPassword".localizable.required.uppercased()
                expect(confirmPasswordTextFieldView.placeholder) == "Placeholder.ConfirmPassword".localizable.required.uppercased()
            }
            
            it("should have an update button with correct title") {
                expect(updateButton.title(for: .normal)) == "Button.Update".localizable.uppercased()
            }
        }
        
        describe("when password texts changed") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if it have at least one symbol in each text field view") {
                it("needs to enable update button") {
                    viewModelMock.makeUpdateButtonEnabled()
                    
                    viewController.viewModel.updateButtonEnabled
                        .subscribe(onNext: { _ in
                            expect(updateButton.isEnabled) == true
                        })
                        .disposed(by: disposeBag)
                }
            }
            
            context("if it doesn't have symbols in both text variables") {
                it("needs to disable update button") {
                    viewModelMock.makeUpdateButtonDisabled()
                    
                    viewController.viewModel.updateButtonEnabled
                        .subscribe(onNext: { _ in
                            expect(updateButton.isEnabled) == false
                        })
                        .disposed(by: disposeBag)
                }
            }
        }

        describe("when update button pressed") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if it have not valid password texts") {
                it("needs to show error messages about not valid password texts") {
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
                    
                    viewModelMock.makeNotValidPasswordTexts()
                }
            }
            
            context("if it have not equals password texts") {
                it("needs to show error message about not equals password texts") {
                    viewController.viewModel.confirmPasswordErrorMessage
                        .subscribe(onNext: { _ in
                            expect(confirmPasswordTextFieldView.errorMessage).toEventually(equal("Error.PasswordsAreNotEquals".localizable))
                        })
                        .disposed(by: disposeBag)
                    
                    viewModelMock.makeNotEqualsPasswordTexts()
                }
            }
        }
    }
}
