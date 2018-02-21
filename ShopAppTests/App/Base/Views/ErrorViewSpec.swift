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
        
        describe("") {
            it("") {
                view.error = NetworkError()
                expect(errorImageView.isHidden).to(beFalse())
                expect(errorTextLabel.text).to(equal("Error.Unknown".localizable))
            }
            
            it("") {
                view.error = RepoError()
                expect(errorImageView.isHidden).to(beTrue())
                expect(errorTextLabel.text).to(equal("Error.NoConnection".localizable))
            }
        }
        
        describe("") {
            it("") {
                class DelegateMock: ErrorViewDelegate {
                    private var view: ErrorView!
                    
                    init(view: ErrorView) {
                        self.view = view
                    }
                    
                    func viewDidTapTryAgain(_ view: ErrorView) {
                        expect(view).toEventually(equal(self.view))
                    }
                }
                
                let delegateMock = DelegateMock(view: view)
                view.delegate = delegateMock
                tryAgainButton.sendActions(for: .touchUpInside)
            }
        }
    }
}
