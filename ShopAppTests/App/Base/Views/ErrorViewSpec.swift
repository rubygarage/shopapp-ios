//
//  ErrorViewSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ErrorViewSpec: QuickSpec {
    override func spec() {
        var view: ErrorView!
        var errorTextLabel: UILabel!
        var errorImageView: UIImageView!
        var tryAgainButton: UIButton!
        
        beforeEach {
            view = ErrorView(frame: UIScreen.main.bounds)
            
            errorTextLabel = self.findView(withAccessibilityLabel: "errorText", in: view) as! UILabel
            errorImageView = self.findView(withAccessibilityLabel: "errorImage", in: view) as! UIImageView
            tryAgainButton = self.findView(withAccessibilityLabel: "tryAgain", in: view) as! UIButton
        }
        
        describe("when error set") {
            context("with type network") {
                it("needs to hide image and setup text") {
                    view.error = NetworkError()
                    expect(errorImageView.isHidden) == false
                    expect(errorTextLabel.text) == "Error.Unknown".localizable
                }
            }
            
            context("with type not network") {
                it("needs to show image and setup text") {
                    view.error = RepoError()
                    expect(errorImageView.isHidden) == true
                    expect(errorTextLabel.text) == "Error.NoConnection".localizable
                }
            }
        }
        
        describe("when try again pressed") {
            it("needs to perform delegate method") {
                let delegateMock = ErrorViewDelegateMock()
                view.delegate = delegateMock
                tryAgainButton.sendActions(for: .touchUpInside)
                
                expect(delegateMock.view) === view
            }
        }
    }
}
