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
            
            textField = self.findView(withAccessibilityLabel: "text", in: view) as? UITextField
            placeholderLabel = self.findView(withAccessibilityLabel: "placeholder", in: view) as? UILabel
            underlineView = self.findView(withAccessibilityLabel: "underline", in: view)
        }
        
        describe("when view initialized") {
            it("should have correct picker view") {
                expect(view.pickerView.backgroundColor) == .white
                expect(view.pickerView.numberOfComponents) == 1
                expect(view.pickerView.numberOfRows(inComponent: 0)) == 0
            }
            
            it("should have correct text filed") {
                expect(textField.tintColor) == .clear
                expect(textField.inputView) === view.pickerView
            }
            
            it("should have correct placeholder") {
                expect(placeholderLabel.text) == ""
            }
            
            it("should have correct underline view") {
                expect(underlineView.alpha) ≈ 0.2
            }
            
            it("should have correct tool bar for text field") {
                let toolBar = textField.inputAccessoryView as! UIToolbar
                
                expect(toolBar.barStyle.rawValue) == UIBarStyle.default.rawValue
                expect(toolBar.isTranslucent) == false
                expect(toolBar.backgroundColor) == .white
                expect(toolBar.tintColor) == .black
                expect(toolBar.items?.last?.title) == "Button.Done".localizable
                expect(toolBar.isUserInteractionEnabled) == true
            }
        }
        
        describe("when custom data set") {
            context("if it haven't text") {
                it("needs to update picker components") {
                    view.text = nil
                    view.customData = ["first"]
                    
                    expect(view.pickerView.numberOfRows(inComponent: 0)) == 1
                    expect(view.pickerView.selectedRow(inComponent: 0)) == 0
                }
            }
            
            context("if it have text") {
                it("needs to update picker components and select needed row") {
                    view.text = "second"
                    view.customData = ["first", "second"]
                    
                    expect(view.pickerView.numberOfRows(inComponent: 0)) == 2
                    expect(view.pickerView.selectedRow(inComponent: 0)) == 1
                }
            }
        }
        
        describe("when text changed") {
            beforeEach {
                view.customData = ["first", "second"]
            }
            
            context("if it haven't text in data") {
                it("needs to select first row") {
                    view.text = "third"
                    
                    expect(view.pickerView.selectedRow(inComponent: 0)) == 0
                }
            }
            
            context("if it have text in data") {
                it("needs to select needed row") {
                    view.text = "second"
                    
                    expect(view.pickerView.selectedRow(inComponent: 0)) == 1
                }
            }
        }
        
        describe("when text field editing changed") {
            beforeEach {
                textField.sendActions(for: .editingDidBegin)
            }
            
            context("if it have to begin") {
                it("needs to setup underline view") {
                    view.layoutIfNeeded() // calls layoutSubviews, that calls updateConstraintsIfNeeded
                    
                    expect(underlineView.alpha) == 1
                    expect(underlineView.frame.size.height) == 2
                }
            }
            
            context("if it have to end") {
                it("needs to setup underline view") {
                    textField.sendActions(for: .editingDidEnd)
                    view.layoutIfNeeded() // calls layoutSubviews, that calls updateConstraintsIfNeeded
                    
                    expect(underlineView.alpha) ≈ 0.2
                    expect(underlineView.frame.size.height) == 1
                }
            }
        }
        
        describe("when done pressed") {
            it("needs to setup text field") {
                view.customData = ["first", "second"]
                view.pickerView.selectRow(1, inComponent: 0, animated: false)
                
                let toolBar = textField.inputAccessoryView as! UIToolbar
                let doneItem = toolBar.items?.last
                view.perform(doneItem?.action)
                
                expect(textField.text) == "second"
                expect(textField.isEditing) == false
            }
        }
    }
}
