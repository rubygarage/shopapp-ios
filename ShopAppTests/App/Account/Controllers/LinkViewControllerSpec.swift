//
//  LinkViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/26/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift

@testable import ShopApp

class LinkViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: LinkViewController!
        var viewModelMock: ForgotPasswordViewModelMock!
        var titleLabel: UILabel!
        var emailLabel: UILabel!
        var descriptionLabel: UILabel!
        var additionalTitleLabel: UILabel!
        var additionalDescriptionLabel: UILabel!
        var resendButton: UnderlinedButton!
        var resendUnderlineView: UIView!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.account, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.link) as! LinkViewController
            
            let repositoryMock = AuthentificationRepositoryMock()
            let resetPasswordUseCaseMock = ResetPasswordUseCaseMock(repository: repositoryMock)
            viewModelMock = ForgotPasswordViewModelMock(resetPasswordUseCase: resetPasswordUseCaseMock)
            viewController.viewModel = viewModelMock
            
            titleLabel = self.findView(withAccessibilityLabel: "title", in: viewController.view) as! UILabel
            emailLabel = self.findView(withAccessibilityLabel: "email", in: viewController.view) as! UILabel
            descriptionLabel = self.findView(withAccessibilityLabel: "description", in: viewController.view) as! UILabel
            additionalTitleLabel = self.findView(withAccessibilityLabel: "additionalTitle", in: viewController.view) as! UILabel
            additionalDescriptionLabel = self.findView(withAccessibilityLabel: "additionalDescription", in: viewController.view) as! UILabel
            resendButton = self.findView(withAccessibilityLabel: "resend", in: viewController.view) as! UnderlinedButton
            resendUnderlineView = self.findView(withAccessibilityLabel: "resendUnderlineView", in: viewController.view)
        }
        
        describe("when view loaded") {
            it("should have a correct superclass") {
                expect(viewController.isKind(of: BaseViewController<ForgotPasswordViewModel>.self)) == true
            }
            
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(ForgotPasswordViewModel.self))
            }
            
            it("should have labels with correct texts") {
                expect(titleLabel.text) == "Label.ForgotPassword.LinkTitle".localizable
                expect(descriptionLabel.text) == "Label.ForgotPassword.LinkDescription".localizable
                expect(additionalTitleLabel.text) == "Label.ForgotPassword.LinkAdditionalTitle".localizable
                expect(additionalDescriptionLabel.text) == "Label.ForgotPassword.LinkAdditionalDescription".localizable
            }
            
            it("should have resend button with correct title and delegate") {
                expect(resendButton.title(for: .normal)) == "Button.Resend".localizable.uppercased()
                expect(resendButton.delegate) === viewController
            }
            
            it("should have email label with correct title") {
                expect(emailLabel.text) == ""
            }
        }
        
        describe("when email text changed") {
            beforeEach {
                viewController.emailText.value = "user@mail.com"
            }
            
            it("need to change title of email label") {
                expect(emailLabel.text) == "user@mail.com"
            }
            
            it("need to change value of view model") {
                expect(viewModelMock.emailText.value) == "user@mail.com"
            }
        }
        
        describe("when resend button pressed") {
            it("needs to notify view model") {
                resendButton.sendActions(for: .touchUpInside)
                
                expect(viewModelMock.isResetPasswordPressed) == true
            }
            
            it("needs to hide resend underline view on highlighte state") {
                resendButton.isHighlighted = true
                
                expect(resendUnderlineView.isHidden) == true
            }
            
            it("needs to show resend underline view on normal state") {
                resendButton.isHighlighted = false
                
                expect(resendUnderlineView.isHidden) == false
            }
        }
    }
}
