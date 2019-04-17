//
//  CheckoutSuccessViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/5/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CheckoutSuccessViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: CheckoutSuccessViewController!
        var thanksForShoppingLabel: UILabel!
        var orderNumberLabel: UILabel!
        var viewOrderDetailsButton: BlackButton!
        var continueShoppingButton: UnderlinedButton!
        var continueShoppingUnderlineView: UIView!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.checkout, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.checkoutSuccess) as? CheckoutSuccessViewController
            
            viewController.orderId = "Order id"
            viewController.orderNumber = 5
            
            thanksForShoppingLabel = self.findView(withAccessibilityLabel: "thanksForShoppingLabel", in: viewController.view) as? UILabel
            orderNumberLabel = self.findView(withAccessibilityLabel: "orderNumberLabel", in: viewController.view) as? UILabel
            viewOrderDetailsButton = self.findView(withAccessibilityLabel: "viewOrderDetailsButton", in: viewController.view) as? BlackButton
            continueShoppingButton = self.findView(withAccessibilityLabel: "continueShoppingButton", in: viewController.view) as? UnderlinedButton
            continueShoppingUnderlineView = self.findView(withAccessibilityLabel: "continueShoppingUnderlineView", in: viewController.view)
        }
        
        describe("when view loaded") {
            it("should have a correct title") {
                expect(viewController.title) == "ControllerTitle.Home".localizable
            }
            
            it("should have a correct thanks for shopping label text") {
                expect(thanksForShoppingLabel.text) == "Label.ThanksForShopping".localizable
            }
            
            it("should have a correct order number label text") {
                let orderNumber = 5
                let orderNumberLocalizable = "Label.YourOrderNumber".localizable
                let orderNumberLocalized = String.localizedStringWithFormat(orderNumberLocalizable, String(orderNumber))
                let attributed = NSMutableAttributedString(string: orderNumberLocalized)
                let highlightedText = String(orderNumber)
                let range = (orderNumberLocalized as NSString).range(of: highlightedText)
                attributed.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 0, green: 0.48, blue: 1, alpha: 1), range: range)
                
                expect(orderNumberLabel.attributedText) == attributed
            }
            
            it("should have a correct view order details button title") {
                expect(viewOrderDetailsButton.title(for: .normal)) == "Button.ViewOrderDetails".localizable.uppercased()
            }
            
            it("should have a correct continue shopping button title") {
                expect(continueShoppingButton.title(for: .normal)) == "Button.ContinueShopping".localizable.uppercased()
            }
        }
        
        describe("when continue shopping button changed state") {
            context("if state is highlighted") {
                it("should hide underline view") {
                    continueShoppingButton.isHighlighted = true
                    
                    expect(continueShoppingUnderlineView.isHidden) == true
                }
            }
            
            context("if state isn't highlighted") {
                it("should show underline view") {
                    continueShoppingButton.isHighlighted = false
                    
                    expect(continueShoppingUnderlineView.isHidden) == false
                }
            }
        }
    }
}
