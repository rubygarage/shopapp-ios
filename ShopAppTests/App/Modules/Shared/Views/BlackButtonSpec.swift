//
//  BlackButtonSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class BlackButtonSpec: QuickSpec {
    override func spec() {
        var view: BlackButton!
        
        beforeEach {
            view = BlackButton()
        }
        
        describe("when view initialized") {
            it("should have correct color of title") {
                expect(view.backgroundColor) == .black
            }
        }
        
        describe("when highlighted state changed") {
            context("and it's true") {
                it("needs to setup correct background color") {
                    view.isHighlighted = true
                    
                    expect(view.backgroundColor) == UIColor.black.withAlphaComponent(0.8)
                }
            }
            
            context("and it's false") {
                it("needs to setup correct background color") {
                    view.isHighlighted = false
                    
                    expect(view.backgroundColor) == .black
                }
            }
        }
        
        describe("when enabled state changed") {
            context("and it's true") {
                it("needs to setup correct title and background colors") {
                    view.isEnabled = true
                    
                    expect(view.backgroundColor) == .black
                    expect(view.titleColor(for: .normal)) == .white
                }
            }
            
            context("and it's false") {
                it("needs to setup correct title and background colors") {
                    view.isEnabled = false
                    
                    expect(view.backgroundColor) == UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
                    expect(view.titleColor(for: .normal)) == .gray
                }
            }
        }
    }
}
