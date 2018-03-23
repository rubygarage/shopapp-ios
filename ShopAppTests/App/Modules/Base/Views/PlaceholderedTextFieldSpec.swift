//
//  PlaceholderedTextFieldSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/7/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class PlaceholderedTextFieldSpec: QuickSpec {
     override func spec() {
        var view: PlaceholderedTextFieldTest!
        
        beforeEach {
            view = PlaceholderedTextFieldTest()
        }
        
        describe("when view initialized") {
            it("should have a correct superclass") {
                expect(view).to(beAKindOf(TextFieldWrapper.self))
            }
        }
        
        describe("when placeholder of view set") {
            it("needs to update text of placeholder label") {
                view.placeholder = "placeholder"
                
                expect(view.placeholderLabel.text) == "placeholder"
            }
        }
        
        describe("when placeholder position changed") {
            context("if it needs to set placeholder to default position") {
                it("needs to change font size and text color of placeholder label") {
                    view.text = nil
                    view.setPlaceholderPosition()
                    
                    expect(view.placeholderLabel.font) == .systemFont(ofSize: 12)
                    expect(view.placeholderLabel.textColor) == .black
                }
            }
            
            context("if it needs to set placeholder to top") {
                it("needs to change font size and text color of placeholder label") {
                    view.text = "text"
                    view.setPlaceholderPosition()
                    
                    expect(view.placeholderLabel.font) == UIFont.systemFont(ofSize: 11)
                    expect(view.placeholderLabel.textColor) == UIColor.black.withAlphaComponent(0.5)
                }
            }
        }
    }
}

class PlaceholderedTextFieldTest: PlaceholderedTextField {
    let testTextField = UITextField()
    let testPlaceholderLabel = UILabel()
    
    override weak var textField: UITextField! {
        return testTextField
    }
    override weak var placeholderLabel: UILabel! {
        return testPlaceholderLabel
    }
}
