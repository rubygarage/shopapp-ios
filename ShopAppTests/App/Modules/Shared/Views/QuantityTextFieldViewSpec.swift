//
//  QuantityTextFieldViewSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class QuantityTextFieldViewSpec: QuickSpec {
    override func spec() {
        var view: QuantityTextFieldView!
        var textField: UITextField!
        var underlineView: UIView!
        
        beforeEach {
            view = QuantityTextFieldView()
            
            textField = self.findView(withAccessibilityLabel: "textField", in: view) as! UITextField
            underlineView = self.findView(withAccessibilityLabel: "underline", in: view)
        }
        
        describe("when view initialized") {
            it("should have correct delegate of text field") {
                expect(textField.delegate) === view
            }
        }
        
        describe("when editing of text field began") {
            it("needs to setup correct background color") {
                textField.sendActions(for: .editingDidBegin)
                
                expect(underlineView.backgroundColor) == .black
            }
        }
        
        describe("when editing of text field ended") {
            beforeEach {
                textField.sendActions(for: .editingDidBegin)
            }
            
            it("needs to setup correct background color") {
                textField.sendActions(for: .editingDidEnd)
                
                expect(underlineView.backgroundColor) == UIColor(displayP3Red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
            }
            
            it("needs to correct text of text field if needed") {
                textField.text = "0"
                textField.sendActions(for: .editingDidEnd)
                
                expect(textField.text) == "1"
            }
            
            it("needs to notify delegate") {
                let delegateMock = QuantityTextFieldViewDelegateMock()
                view.delegate = delegateMock
                
                textField.text = "1"
                textField.sendActions(for: .editingDidEnd)
                
                expect(delegateMock.view) === view
                expect(delegateMock.quantity) == 1
            }
        }
        
        describe("when text field should change characters") {
            it("needs to check length of text") {
                textField.sendActions(for: .editingDidBegin)
                textField.text = "100"
                
                let range = NSRange(location: 3, length: 0)
                let isShouldChangeCharacters = view.textField(textField, shouldChangeCharactersIn: range, replacementString: "0")
                
                expect(isShouldChangeCharacters) == false
            }
        }
    }
}
