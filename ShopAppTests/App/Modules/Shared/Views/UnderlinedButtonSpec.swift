//
//  UnderlinedButtonSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class UnderlinedButtonSpec: QuickSpec {
    override func spec() {
        var view: UnderlinedButton!
        
        beforeEach {
            view = UnderlinedButton()
        }
        
        describe("when view initialized") {
            it("should have correct color of title") {
                expect(view.titleColor(for: .normal)) == .black
            }
        }
        
        describe("when highlighted state changed") {
            it("needs to notify to delegate") {
                let delegateMock = UnderlinedButtonDelegateMock()
                view.delegate = delegateMock
                view.isHighlighted = true
                
                expect(delegateMock.button) === view
                expect(delegateMock.isHighlighted) === view.isHighlighted
            }
        }
        
        describe("when enabled state changed") {
            context("and it's true") {
                it("needs to setup correct title color") {
                    view.isEnabled = true
                    
                    expect(view.titleColor(for: .normal)) == .black
                }
            }
            
            context("and it's false") {
                it("needs to setup correct title color") {
                    view.isEnabled = false
                    
                    expect(view.titleColor(for: .normal)) == .gray
                }
            }
        }
    }
}
