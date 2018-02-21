//
//  BasePickerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class BasePickerSpec: QuickSpec {
    override func spec() {
        var view: BasePicker!
        var textField: UITextField!
        var placeholderLabel: UILabel!
        var underlineView: UIView!
        
        beforeEach {
            view = BasePicker()
            
            textField = self.findView(withAccessibilityLabel: "text", in: view) as! UITextField
            placeholderLabel = self.findView(withAccessibilityLabel: "placeholder", in: view) as! UILabel
            underlineView = self.findView(withAccessibilityLabel: "underline", in: view)
        }
        
        describe("") {
            it("") {
                expect(view.pickerView.backgroundColor) == .white
                expect(view.pickerView.numberOfComponents) == 1
                expect(view.pickerView.numberOfRows(inComponent: 0)) == 0
            }
            
            it("") {
                expect(textField.tintColor) == .clear
                expect(textField.inputView) === view.pickerView
            }
            
            it("") {
                expect(placeholderLabel.text) == ""
            }
            
            it("") {
                expect(underlineView.alpha) ≈ 0.2
            }
            
            it("") {
                let toolBar = textField.inputAccessoryView as! UIToolbar
                
                expect(toolBar.barStyle.rawValue) == UIBarStyle.default.rawValue
                expect(toolBar.isTranslucent) == false
                expect(toolBar.backgroundColor) == .white
                expect(toolBar.tintColor) == .black
                expect(toolBar.items?.last?.title) == "Button.Done".localizable
                expect(toolBar.isUserInteractionEnabled) == true
            }
        }
        
        describe("") {
            context("") {
                it("") {
                    view.text = nil
                    view.customData = ["first"]
                    
                    expect(view.pickerView.numberOfRows(inComponent: 0)) == 1
                    expect(view.pickerView.selectedRow(inComponent: 0)) == 0
                }
            }
            
            context("") {
                it("") {
                    view.text = "second"
                    view.customData = ["first", "second"]
                    
                    expect(view.pickerView.numberOfRows(inComponent: 0)) == 2
                    expect(view.pickerView.selectedRow(inComponent: 0)) == 1
                }
            }
        }
        
        describe("") {
            it("") {
                view.customData = ["first", "second"]
                view.text = "second"
                
                expect(view.pickerView.selectedRow(inComponent: 0)) == 1
            }
        }
        
        describe("") {
            beforeEach {
                textField.sendActions(for: .editingDidBegin)
            }
            
            context("") {
                it("") {
                    view.layoutIfNeeded() // calls layoutSubviews, that calls updateConstraintsIfNeeded
                    
                    expect(underlineView.alpha) == 1
                    expect(underlineView.frame.size.height) == 2
                }
            }
            
            context("") {
                it("") {
                    textField.sendActions(for: .editingDidEnd)
                    view.layoutIfNeeded() // calls layoutSubviews, that calls updateConstraintsIfNeeded
                    
                    expect(underlineView.alpha) ≈ 0.2
                    expect(underlineView.frame.size.height) == 1
                }
            }
        }
        
        describe("") {
            it("") {
                view.text = "second"
                view.customData = ["first", "second"]
                
                let toolBar = textField.inputAccessoryView as! UIToolbar
                let doneItem = toolBar.items?.last
                view.perform(doneItem?.action)
                
                expect(textField.text) == "second"
                expect(textField.isEditing) == false
            }
        }
    }
}
