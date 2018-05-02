//
//  QuantityDropDownViewSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class QuantityDropDownViewSpec: QuickSpec {
    override func spec() {
        var view: QuantityDropDownView!
        var textField: UITextField!
        var underlineView: UIView!
        
        beforeEach {
            view = QuantityDropDownView()
            
            textField = self.findView(withAccessibilityLabel: "textField", in: view) as! UITextField
            underlineView = self.findView(withAccessibilityLabel: "underlineView", in: view)
        }
        
        describe("when view initialized") {
            it("should have correcti initial properties") {
                expect(underlineView.backgroundColor) == UIColor.black
            }
        }
        
        describe("when editing of text field ended") {
            beforeEach {
                textField.sendActions(for: .editingDidBegin)
            }
            
            it("needs to correct text of text field if needed") {
                textField.text = "0"
                textField.sendActions(for: .editingDidEnd)
                
                expect(textField.text) == "1"
            }
            
            it("needs to notify delegate") {
                let delegateMock = QuantityDropDownViewDelegateMock()
                view.delegate = delegateMock
                
                textField.text = "1"
                textField.sendActions(for: .editingDidEnd)
                
                expect(delegateMock.view) === view
                expect(delegateMock.quantity) == 1
            }
        }
    }
}
