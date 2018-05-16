//
//  CheckboxButtonSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/4/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CheckboxButtonSpec: QuickSpec {
    private let borderColorSelected = UIColor(displayP3Red: 0.59, green: 0.59, blue: 0.59, alpha: 1).cgColor
    
    override func spec() {
        var button: CheckboxButton!
        
        beforeEach {
            button = CheckboxButton(frame: CGRect.zero)
        }
        
        describe("when button initialized") {
            it("should have correct border width") {
                expect(button.layer.borderWidth) == 1
            }
            
            it("should have correct border color") {
                expect(button.layer.borderColor) == UIColor.red.cgColor
            }
        }
        
        describe("when 'isHighlited' property did set") {
            context("if value is true") {
                it("should correctly update border color") {
                    button.isHighlighted = true
                    
                    expect(button.layer.borderColor) == self.borderColorSelected
                }
            }
            
            context("when value is false") {
                beforeEach {
                    button.isHighlighted = false
                }
                
                context("and 'isSelected' property is true") {
                    it("should correctly update border color") {
                        button.isSelected = true
                        
                        expect(button.layer.borderColor) == self.borderColorSelected
                    }
                }
                
                context("or 'isSelected' property is false") {
                    it("should correctly update border color") {
                        button.isSelected = false
                        
                        expect(button.layer.borderColor) == UIColor(displayP3Red: 0.59, green: 0.59, blue: 0.59, alpha: 0.5).cgColor
                    }
                }
            }
        }
    }
}
