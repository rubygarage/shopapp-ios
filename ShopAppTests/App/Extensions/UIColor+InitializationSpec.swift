//
//  UIColor+InitializationSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class UIColor_InitializationSpec: QuickSpec {
    override func spec() {
        describe("when color initialized") {
            var color: UIColor!
            var components: [CGFloat]!
            
            beforeEach {
                color = UIColor(red: 100, green: 150, blue: 200)
                components = color.cgColor.components
            }
            
            it("should have correct red value") {
                let redValue = components[0]
                
                expect(redValue) == 100 / 255
            }
            
            it("should have correct green value") {
                let redValue = components[1]
                
                expect(redValue) == 150 / 255
            }
            
            it("should have correct blue value") {
                let redValue = components[2]
                
                expect(redValue) == 200 / 255
            }
            
            it("should have correct alpha value") {
                let alphaValue = components[3]
                
                expect(alphaValue) == 1
            }
        }
    }
}
