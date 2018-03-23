//
//  TextFieldWrapperSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/7/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class TextFieldWrapperSpec: QuickSpec {
    override func spec() {
        var view: TextFieldWrapperTest!
        
        beforeEach {
            view = TextFieldWrapperTest()
        }
        
        describe("when text of view used") {
            beforeEach {
                view.textField.text = "initial text"
            }
            
            it("should return text of text field") {
                expect(view.text) == "initial text"
            }
            
            it("should set text to text field") {
                view.text = "new text"
                
                expect(view.textField.text) == "new text"
            }
        }
        
        describe("when enabled of text field changed") {
            it("needs to change text field enabled") {
                view.setTextFieldEnabled(false)
                
                expect(view.textField.isEnabled) == false
            }
        }
    }
}

class TextFieldWrapperTest: TextFieldWrapper {
    let testTextField = UITextField()
    
    override weak var textField: UITextField! {
        return testTextField
    }
}
