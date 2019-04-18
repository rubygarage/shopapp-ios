//
//  CriticalErrorViewSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CriticalErrorViewSpec: QuickSpec {
    override func spec() {
        var view: CriticalErrorView!
        var errorTitleLabel: UILabel!
        var backButton: UIButton!
        
        beforeEach {
            view = CriticalErrorView()
            errorTitleLabel = self.findView(withAccessibilityLabel: "errorTitleLabel", in: view) as? UILabel
            backButton = self.findView(withAccessibilityLabel: "backButton", in: view) as? UIButton
        }
        
        describe("when view created") {
            it("should have correct back button title") {
                expect(backButton.titleLabel?.text) == "Button.Back".localizable.uppercased()
            }
            
            it("should have correct title") {
                expect(errorTitleLabel.text) == "Label.CouldNotFind".localizable
            }
        }
        
        describe("when item type set") {
            context("if itemType exist") {
                it("should set title with item type") {
                    let errorItemType: ErrorItemType = .product
                    view.itemType = errorItemType
                    expect(errorTitleLabel.text) == String.localizedStringWithFormat("Label.CouldNotFindItem".localizable, errorItemType.rawValue)
                }
            }
            
            context("and if doesn't exist") {
                it("should set title without item type") {
                    expect(errorTitleLabel.text) == "Label.CouldNotFind".localizable
                }
            }
        }
        
        describe("when back button did press") {
            it("should notify delegate") {
                let delegateMock = CriticalErrorViewDelegateMock()
                view.delegate = delegateMock
                backButton.sendActions(for: .touchUpInside)
                
                expect(delegateMock.view) === view
            }
        }
    }
}
