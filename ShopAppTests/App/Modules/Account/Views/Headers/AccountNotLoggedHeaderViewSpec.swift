//
//  AccountNotLoggedHeaderViewSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/6/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class AccountNotLoggedHeaderViewSpec: QuickSpec {
    override func spec() {
        var view: AccountNotLoggedHeaderView!
        var delegateMock: AccountNotLoggedHeaderDelegateMock!
        var signInButton: BlackButton!
        var signInLabel: UILabel!
        var createNewAccountButton: UnderlinedButton!
        var createAccountUnderlinedView: UIView!
        
        beforeEach {
            view = AccountNotLoggedHeaderView(frame: CGRect.zero)
            
            signInButton = self.findView(withAccessibilityLabel: "signInButton", in: view) as? BlackButton
            signInLabel = self.findView(withAccessibilityLabel: "signInLabel", in: view) as? UILabel
            createNewAccountButton = self.findView(withAccessibilityLabel: "createNewAccountButton", in: view) as? UnderlinedButton
            createAccountUnderlinedView = self.findView(withAccessibilityLabel: "createAccountUnderline", in: view)
        }
        
        describe("when view initialized") {
            it("should have correct sign in button title") {
                expect(signInButton.title(for: .normal)) == "Button.SignIn".localizable.uppercased()
            }
            
            it("should have correct sign in label text") {
                expect(signInLabel.text) == "Label.SignInToShop".localizable
            }
            
            it("should have correct create new account button title") {
                expect(createNewAccountButton.title(for: .normal)) == "Button.CreateNewAccount".localizable.uppercased()
            }
            
            it("should have create new account button delegate") {
                expect(createNewAccountButton.delegate) === view
            }
        }
        
        describe("when sign in button pressed") {
            it("needs to show sign in screen") {
                delegateMock = AccountNotLoggedHeaderDelegateMock()
                view.delegate = delegateMock
                signInButton.sendActions(for: .touchUpInside)
                
                expect(delegateMock.isSignInTapped) == true
                expect(delegateMock.headerView) === view
            }
        }
        
        describe("when create new account button pressed") {
            it("needs to hide underline view on highlighted state") {
                createNewAccountButton.isHighlighted = true
                
                expect(createAccountUnderlinedView.isHidden) == true
            }
            
            it("needs to show underline view on normal state") {
                createNewAccountButton.isHighlighted = false
                
                expect(createAccountUnderlinedView.isHidden) == false
            }
            
            it("needs to show sign up screen") {
                delegateMock = AccountNotLoggedHeaderDelegateMock()
                view.delegate = delegateMock
                createNewAccountButton.sendActions(for: .touchUpInside)
                
                expect(delegateMock.isCreateNewAccountTapped) == true
                expect(delegateMock.headerView) === view
            }
        }
    }
}
