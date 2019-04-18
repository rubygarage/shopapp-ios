//
//  InputTextFieldViewSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class InputTextFieldViewSpec: QuickSpec {
    override func spec() {
        var view: InputTextFieldView!
        var textField: UITextField!
        var errorMessageLabel: UILabel!
        var showPasswordButton: UIButton!
        var underlineView: UIView!
        var underlineViewHeightConstraint: NSLayoutConstraint!
        
        beforeEach {
            view = InputTextFieldView()
            
            textField = self.findView(withAccessibilityLabel: "textField", in: view) as? UITextField
            errorMessageLabel = self.findView(withAccessibilityLabel: "errorMessage", in: view) as? UILabel
            showPasswordButton = self.findView(withAccessibilityLabel: "showPassword", in: view) as? UIButton
            underlineView = self.findView(withAccessibilityLabel: "underline", in: view)
            underlineViewHeightConstraint = underlineView.constraints.filter({ $0.accessibilityLabel == "underlineHeight" }).first
        }
        
        describe("when view initialized") {
            it("should have correct delegate of text field") {
                expect(textField.delegate) === view
            }
            
            it("should have correct background color") {
                expect(view.backgroundColor) == .clear
            }
            
            it("should have correct text color of error message label") {
                expect(errorMessageLabel.textColor) == UIColor(displayP3Red: 0.89, green: 0.31, blue: 0.31, alpha: 1)
            }
            
            it("should have correct alpha of underline view") {
                expect(underlineView.alpha) ≈ 0.2
            }
            
            it("should have correct height of underline view") {
                expect(underlineViewHeightConstraint.constant) == 1
            }
            
            it("should have correct background color of underline view") {
                expect(underlineView.backgroundColor) == .black
            }
            
            it("should have hidden error message label") {
                expect(errorMessageLabel.isHidden) == true
            }
        }
        
        describe("when keyboard type value changed") {
            context("and it's email") {
                beforeEach {
                    view.keyboardType = InputTextFieldViewKeybordType.email.rawValue
                }
                
                it("needs to setup keyboard type of text field") {
                    expect(textField.keyboardType.rawValue) == UIKeyboardType.emailAddress.rawValue
                }
                
                it("needs to setup autocapitalization type of text field") {
                    expect(textField.autocapitalizationType.rawValue) == UITextAutocapitalizationType.none.rawValue
                }
                
                it("needs to setup secure text entry of text field") {
                    expect(textField.isSecureTextEntry) == false
                }
                
                it("needs to show/hide show password button") {
                    expect(showPasswordButton.isHidden) == true
                }
            }
            
            context("and it's cvv") {
                beforeEach {
                    view.keyboardType = InputTextFieldViewKeybordType.cvv.rawValue
                }
                
                it("needs to setup keyboard type of text field") {
                    expect(textField.keyboardType.rawValue) == UIKeyboardType.numberPad.rawValue
                }
                
                it("needs to setup autocapitalization type of text field") {
                    expect(textField.autocapitalizationType.rawValue) == UITextAutocapitalizationType.sentences.rawValue
                }
                
                it("needs to setup secure text entry of text field") {
                    expect(textField.isSecureTextEntry) == true
                }
                
                it("needs to show/hide show password button") {
                    expect(showPasswordButton.isHidden) == true
                }
            }
            
            context("and it's phone") {
                beforeEach {
                    view.keyboardType = InputTextFieldViewKeybordType.phone.rawValue
                }
                
                it("needs to setup keyboard type of text field") {
                    expect(textField.keyboardType.rawValue) == UIKeyboardType.phonePad.rawValue
                }
                
                it("needs to setup autocapitalization type of text field") {
                    expect(textField.autocapitalizationType.rawValue) == UITextAutocapitalizationType.sentences.rawValue
                }
                
                it("needs to setup secure text entry of text field") {
                    expect(textField.isSecureTextEntry) == false
                }
                
                it("needs to show/hide show password button") {
                    expect(showPasswordButton.isHidden) == true
                }
            }
            
            context("and it's name") {
                beforeEach {
                    view.keyboardType = InputTextFieldViewKeybordType.name.rawValue
                }
                
                it("needs to setup keyboard type of text field") {
                    expect(textField.keyboardType.rawValue) == UIKeyboardType.default.rawValue
                }
                
                it("needs to setup autocapitalization type of text field") {
                    expect(textField.autocapitalizationType.rawValue) == UITextAutocapitalizationType.words.rawValue
                }
                
                it("needs to setup secure text entry of text field") {
                    expect(textField.isSecureTextEntry) == false
                }
                
                it("needs to show/hide show password button") {
                    expect(showPasswordButton.isHidden) == true
                }
            }
        }
        
        describe("when hide show password button value changed") {
            beforeEach {
                view.keyboardType = InputTextFieldViewKeybordType.password.rawValue
            }
            
            context("and it's true") {
                it("needs to setup security") {
                    view.hideShowPasswordButton = true
                    
                    expect(textField.isSecureTextEntry) == true
                    expect(showPasswordButton.isHidden) == true
                }
            }
            
            context("and it's false") {
                it("needs to setup security") {
                    view.hideShowPasswordButton = false
                    
                    expect(textField.isSecureTextEntry) == true
                    expect(showPasswordButton.isHidden) == false
                }
            }
        }
        
        describe("when text of view changed") {
            context("and it's empty") {
                it("needs to change font size and text color of placeholder label") {
                    view.text = nil
                    
                    expect(view.placeholderLabel.font) == .systemFont(ofSize: 12)
                    expect(view.placeholderLabel.textColor) == .black
                }
            }
            
            context("and it's not empty") {
                it("needs to change font size and text color of placeholder label") {
                    view.text = "text"
                    
                    expect(view.placeholderLabel.font) == UIFont.systemFont(ofSize: 11)
                    expect(view.placeholderLabel.textColor) == UIColor.black.withAlphaComponent(0.5)
                }
            }
        }
        
        describe("when state of view changed") {
            beforeEach {
                view.state = .highlighted
            }
            
            it("needs to setup alpha of underline view") {
                expect(underlineView.alpha) == 1
            }
            
            it("needs to setup height of underline view") {
                expect(underlineViewHeightConstraint.constant) == 2
            }
            
            it("needs to setup background color of underline view") {
                expect(underlineView.backgroundColor) == .black
            }
            
            it("needs to hide error message label") {
                expect(errorMessageLabel.isHidden) == true
            }
        }
        
        describe("when error message changed") {
            beforeEach {
                view.errorMessage = "error"
            }
            
            it("needs to setup state of view") {
                expect(view.state.rawValue) == InputTextFieldViewState.error.rawValue
            }
            
            it("needs to setup text of error message label") {
                expect(errorMessageLabel.text) == view.errorMessage
            }
            
            it("needs to setup alpha of underline view") {
                expect(underlineView.alpha) == 1
            }
            
            it("needs to setup height of underline view") {
                expect(underlineViewHeightConstraint.constant) == 2
            }
            
            it("needs to setup background color of underline view") {
                expect(underlineView.backgroundColor) == UIColor(displayP3Red: 0.89, green: 0.31, blue: 0.31, alpha: 1)
            }
            
            it("needs to show error message label") {
                expect(errorMessageLabel.isHidden) == false
            }
        }
        
        describe("when text field editing began") {
            beforeEach {
                textField.sendActions(for: .editingDidBegin)
            }
            
            it("needs to setup correct state") {
                expect(view.state.rawValue) == InputTextFieldViewState.highlighted.rawValue
            }
            
            it("needs to change font size and text color of placeholder label") {
                expect(view.placeholderLabel.font) == UIFont.systemFont(ofSize: 11)
                expect(view.placeholderLabel.textColor) == UIColor.black.withAlphaComponent(0.5)
            }
        }
        
        describe("when text field editing changed") {
            let delegateMock = InputTextFieldViewDelegateMock()
            
            beforeEach {
                view.delegate = delegateMock

                textField.sendActions(for: .editingDidBegin)
                view.keyboardType = InputTextFieldViewKeybordType.cardNumber.rawValue
                view.state = .normal
                textField.text = "12345678"
                textField.sendActions(for: .editingChanged)
            }
            
            it("needs to setup correct state") {
                expect(view.state.rawValue) == InputTextFieldViewState.highlighted.rawValue
            }
            
            it("needs to setup text of text field in needed") {
                expect(textField.text) == "1234 5678"
            }
            
            it("needs to notify delegate") {
                expect(delegateMock.isViewDidUpdate) == true
                expect(delegateMock.view) === view
                expect(delegateMock.text) == "1234 5678"
            }
        }
        
        describe("when text field editing ended") {
            let delegateMock = InputTextFieldViewDelegateMock()
            
            beforeEach {
                view.delegate = delegateMock
                
                textField.sendActions(for: .editingDidBegin)
                textField.text = ""
                textField.sendActions(for: .editingDidEnd)
            }
            
            it("needs to setup correct state") {
                expect(view.state.rawValue) == InputTextFieldViewState.normal.rawValue
            }
            
            it("needs to notify delegate") {
                expect(delegateMock.isViewDidEndUpdate) == true
                expect(delegateMock.view) === view
                expect(delegateMock.text) == ""
            }
            
            it("needs to change font size and text color of placeholder label") {
                expect(view.placeholderLabel.font) == .systemFont(ofSize: 12)
                expect(view.placeholderLabel.textColor) == .black
            }
        }
        
        describe("when show password button pressed") {
            beforeEach {
                showPasswordButton.sendActions(for: .touchUpInside)
            }
            
            it("needs to select button") {
                expect(showPasswordButton.isSelected) == true
            }
            
            it("needs to disable secure text entry") {
                expect(textField.isSecureTextEntry) == false
            }
        }
        
        describe("when text field should change characters") {
            context("if keyboard type is not cvv and not card number") {
                it("needs to add character in any case") {
                    view.keyboardType = InputTextFieldViewKeybordType.phone.rawValue
                    
                    textField.sendActions(for: .editingDidBegin)
                    textField.text = "1"
                    
                    let range = NSRange(location: 1, length: 0)
                    let isShouldChangeCharacters = view.textField(textField, shouldChangeCharactersIn: range, replacementString: "2")
                    
                    expect(isShouldChangeCharacters) == true
                }
            }
            
            context("if keyboard type is card number") {
                it("needs to check length of text") {
                    view.keyboardType = InputTextFieldViewKeybordType.cardNumber.rawValue
                    
                    textField.sendActions(for: .editingDidBegin)
                    textField.text = "1234 5678"
                    
                    let range = NSRange(location: 9, length: 0)
                    let isShouldChangeCharacters = view.textField(textField, shouldChangeCharactersIn: range, replacementString: "9")
                    
                    expect(isShouldChangeCharacters) == true
                }
            }
            
            context("if keyboard type is cvv") {
                it("needs to check length of text") {
                    view.keyboardType = InputTextFieldViewKeybordType.cvv.rawValue
                    
                    textField.sendActions(for: .editingDidBegin)
                    textField.text = "12"
                    
                    let range = NSRange(location: 2, length: 0)
                    let isShouldChangeCharacters = view.textField(textField, shouldChangeCharactersIn: range, replacementString: "3")
                    
                    expect(isShouldChangeCharacters) == true
                }
            }
        }
        
        describe("when user press done button on keyboard when text field editing") {
            it("needs to end editing of text field") {
                textField.sendActions(for: .editingDidBegin)
                let isShouldReturn = view.textFieldShouldReturn(textField)
                
                expect(textField.isEditing) == false
                expect(isShouldReturn) == true
            }
        }
    }
}
