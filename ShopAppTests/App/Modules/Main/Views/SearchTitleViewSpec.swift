//
//  SearchTitleViewSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class SearchTitleViewSpec: QuickSpec {
    override func spec() {
        var view: SearchTitleView!
        var textField: UITextField!
        var underLineView: UIView!
        var backButton: UIButton!
        var cartButtonView: UIView!
        var clearButton: UIButton!
        var underlineLeftMargin: NSLayoutConstraint!
        var underlineRightMargin: NSLayoutConstraint!
        
        beforeEach {
            view = SearchTitleView()
            
            textField = self.findView(withAccessibilityLabel: "textField", in: view) as! UITextField
            underLineView = self.findView(withAccessibilityLabel: "underline", in: view)
            backButton = self.findView(withAccessibilityLabel: "back", in: view) as! UIButton
            cartButtonView = self.findView(withAccessibilityLabel: "cart", in: view)
            clearButton = self.findView(withAccessibilityLabel: "clear", in: view) as! UIButton
            underlineLeftMargin = underLineView.superview!.constraints.filter({ $0.accessibilityLabel == "underlineLeft" }).first
            underlineRightMargin = underLineView.superview!.constraints.filter({ $0.accessibilityLabel == "underlineRight" }).first
        }
        
        describe("when view initialized") {
            it("should have correct intrinsic content size") {
                expect(view.intrinsicContentSize) == UILayoutFittingExpandedSize
            }
            
            it("should have correct title of clear button") {
                expect(clearButton.title(for: .normal)) == "Button.Clear".localizable
            }
            
            it("should have correct attributed placeholder of text field") {
                expect(textField.attributedPlaceholder?.string.hasSuffix("Placeholder.Search".localizable)) == true
            }
            
            it("should have correct text alignment of text field") {
                expect(textField.textAlignment) == NSTextAlignment.center
            }
            
            it("should have correct background color of underline view") {
                expect(underLineView.backgroundColor) == Colors.underlineDefault
            }
            
            it("should have correct constants of underline view's constraints") {
                expect(underlineLeftMargin.constant) == 55
                expect(underlineRightMargin.constant) == 55
            }
            
            it("should have hidden back button") {
                expect(backButton.isHidden) == true
            }
            
            it("should have unhidden cart button view") {
                expect(cartButtonView.isHidden) == false
            }
            
            it("should have hidden clear button") {
                expect(clearButton.isHidden) == true
            }
            
            it("should have cart button view without button") {
                expect(cartButtonView.subviews.isEmpty) == true
            }
        }
        
        describe("when cart bar button item updated") {
            beforeEach {
                view.updateCartBarItem()
            }
            
            it("needs to add button to cart button view") {
                expect(cartButtonView.subviews.count) == 1
            }
            
            it("needs to remove old button and add new one to cart button view on next time") {
                view.updateCartBarItem()
                
                expect(cartButtonView.subviews.count) == 1
            }
        }
        
        describe("when text of text field changed") {
            it("needs to notify delegate of view") {
                let delegateMock = SearchTitleViewDelegateMock()
                view.delegate = delegateMock
                
                textField.sendActions(for: .editingDidBegin)
                
                waitUntil(timeout: 2) { done in
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        done()
                    })
                }
                
                textField.text = "phrase"
                textField.sendActions(for: .editingChanged)
                
                expect(delegateMock.isViewDidChangeSearchPhrase).toEventually(equal(true), timeout: 1, pollInterval: 0.3)
            }
        }
        
        describe("when editing of text field began") {
            var delegateMock: SearchTitleViewDelegateMock!
            
            beforeEach {
                delegateMock = SearchTitleViewDelegateMock()
                view.delegate = delegateMock
                
                textField.sendActions(for: .editingDidBegin)
            }
            
            it("need to change attributed placeholder of text field") {
                expect(textField.attributedPlaceholder?.string) == "Placeholder.Search".localizable
            }
            
            it("need to change text alignment of text field") {
                expect(textField.textAlignment) == NSTextAlignment.left
            }
            
            it("need to change background color of underline view") {
                expect(underLineView.backgroundColor) == .black
            }
            
            it("need to change constants of underline view's constraints") {
                expect(underlineLeftMargin.constant) == 40
                expect(underlineRightMargin.constant) == 10
            }
            
            it("needs to show back button") {
                expect(backButton.isHidden) == false
            }
            
            it("needs to hide cart button view") {
                expect(cartButtonView.isHidden) == true
            }

            it("needs to hide clear button") {
                expect(clearButton.isHidden) == true
            }
            
            it("needs to notify delegate of view") {
                expect(delegateMock.isViewDidBeginEditing) == true
            }
        }
        
        describe("when editing of text field changed") {
            beforeEach {
                textField.sendActions(for: .editingDidBegin)
            }
            
            context("and text field has empty text") {
                it("needs to hide clear button") {
                    textField.text = ""
                    textField.sendActions(for: .editingChanged)
                    
                    expect(clearButton.isHidden) == true
                }
            }
            
            context("and text field has not empty text") {
                it("needs to show clear button") {
                    textField.text = "phrase"
                    textField.sendActions(for: .editingChanged)
                    
                    expect(clearButton.isHidden) == false
                }
            }
        }
        
        describe("when editing of text field ended") {
            beforeEach {
                textField.sendActions(for: .editingDidBegin)
            }
            
            context("and text field has empty text") {
                it("needs to hide clear button") {
                    textField.text = ""
                    textField.sendActions(for: .editingDidEnd)
                    
                    expect(clearButton.isHidden) == true
                }
            }
            
            context("and text field has not empty text") {
                it("needs to show clear button") {
                    textField.text = "phrase"
                    textField.sendActions(for: .editingDidEnd)
                    
                    expect(clearButton.isHidden) == false
                }
            }
        }
        
        describe("when back button pressed") {
            var delegateMock: SearchTitleViewDelegateMock!
            
            beforeEach {
                delegateMock = SearchTitleViewDelegateMock()
                view.delegate = delegateMock
                
                textField.sendActions(for: .editingDidBegin)
                backButton.sendActions(for: .touchUpInside)
            }
            
            it("need to change attributed placeholder of text field") {
                expect(textField.attributedPlaceholder?.string.hasSuffix("Placeholder.Search".localizable)) == true
            }
            
            it("need to change text alignment of text field") {
                expect(textField.textAlignment) == NSTextAlignment.center
            }
            
            it("need to change background color of underline view") {
                expect(underLineView.backgroundColor) == Colors.underlineDefault
            }
            
            it("need to changet constants of underline view's constraints") {
                expect(underlineLeftMargin.constant) == 55
                expect(underlineRightMargin.constant) == 55
            }
            
            it("needs to hide back button") {
                expect(backButton.isHidden) == true
            }
            
            it("needs to show cart button view") {
                expect(cartButtonView.isHidden) == false
            }
            
            it("needs to hide clear button") {
                expect(clearButton.isHidden) == true
            }
            
            it("needs to end editing") {
                expect(textField.isEditing) == false
            }
            
            it("needs to clear text of text field") {
                expect(textField.text?.isEmpty) == true
            }
            
            it("needs to notify delegate of view") {
                expect(delegateMock.isViewDidTapBack) == true
            }
        }
        
        describe("wned clear button pressed") {
            var delegateMock: SearchTitleViewDelegateMock!
            
            beforeEach {
                delegateMock = SearchTitleViewDelegateMock()
                view.delegate = delegateMock
                
                textField.sendActions(for: .editingDidBegin)
                clearButton.sendActions(for: .touchUpInside)
            }
            
            it("needs to clear text of text field") {
                expect(textField.text?.isEmpty) == true
            }
            
            it("needs to hide clear button") {
                expect(clearButton.isHidden) == true
            }
            
            it("needs to notify delegate of view") {
                expect(delegateMock.isViewDidTapClear) == true
            }
        }
        
        describe("wned cart button pressed") {
            var delegateMock: SearchTitleViewDelegateMock!
            
            beforeEach {
                delegateMock = SearchTitleViewDelegateMock()
                view.delegate = delegateMock
                view.updateCartBarItem()
                
                textField.sendActions(for: .editingDidBegin)
                (cartButtonView.subviews.first! as! UIButton).sendActions(for: .touchUpInside)
            }
            
            it("needs to notify delegate of view") {
                expect(delegateMock.isViewDidTapCart) == true
            }
        }
    }
}
