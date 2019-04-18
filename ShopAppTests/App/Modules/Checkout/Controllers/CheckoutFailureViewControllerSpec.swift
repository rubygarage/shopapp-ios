//
//  CheckoutFailureViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/5/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CheckoutFailureViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: CheckoutFailureViewController!
        var somethingHappendLabel: UILabel!
        var purchaseErrorLabel: UILabel!
        var tryAgainButton: BlackButton!
        var backToShopButton: UnderlinedButton!
        var backToShopUnderlineView: UIView!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.checkout, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.checkoutFailure) as? CheckoutFailureViewController
            
            somethingHappendLabel = self.findView(withAccessibilityLabel: "somethingHappendLabel", in: viewController.view) as? UILabel
            purchaseErrorLabel = self.findView(withAccessibilityLabel: "purchaseErrorLabel", in: viewController.view) as? UILabel
            tryAgainButton = self.findView(withAccessibilityLabel: "tryAgainButton", in: viewController.view) as? BlackButton
            backToShopButton = self.findView(withAccessibilityLabel: "backToShopButton", in: viewController.view) as? UnderlinedButton
            backToShopUnderlineView = self.findView(withAccessibilityLabel: "backToShopUnderlineView", in: viewController.view)
        }
        
        describe("when view loaded") {
            it("should have a correct title") {
                expect(viewController.title) == "ControllerTitle.Home".localizable
            }
            
            it("should have a correct something happend label text") {
                expect(somethingHappendLabel.text) == "Label.SomethingHappened".localizable
            }
            
            it("should have a correct purchase error label text") {
                expect(purchaseErrorLabel.text) == "Label.PurchaseCouldntBeCompleted".localizable
            }
            
            it("should have a correct try again button title") {
                expect(tryAgainButton.title(for: .normal)) == "Button.TryAgain".localizable.uppercased()
            }
            
            it("should have a correct back to shop button title") {
                expect(backToShopButton.title(for: .normal)) == "Button.BackToShop".localizable.uppercased()
            }
            
            it("should have a correct back to shop button delegate") {
                expect(backToShopButton.delegate) === viewController
            }
        }
        
        describe("when back to shop button changed state") {
            context("if state is highlighted") {
                it("should hide underline view") {
                    backToShopButton.isHighlighted = true
                    
                    expect(backToShopUnderlineView.isHidden) == true
                }
            }
            
            context("if state isn't highlighted") {
                it("should show underline view") {
                    backToShopButton.isHighlighted = false
                    
                    expect(backToShopUnderlineView.isHidden) == false
                }
            }
        }
    }
}
