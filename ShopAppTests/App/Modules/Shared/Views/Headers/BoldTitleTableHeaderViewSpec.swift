//
//  BoldTitleTableHeaderViewSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class BoldTitleTableHeaderViewSpec: QuickSpec {
    override func spec() {
        var view: BoldTitleTableHeaderView!
        var headerTitleLabel: UILabel!
        var topView: UIView!
        var topMarginConstraint: NSLayoutConstraint!
        
        func setupViews() {
            headerTitleLabel = self.findView(withAccessibilityLabel: "title", in: view) as? UILabel
            topView = self.findView(withAccessibilityLabel: "top", in: view)
            topMarginConstraint = topView.constraints.filter({ $0.accessibilityLabel == "topMargin" }).first
        }
        
        describe("when view initialized") {
            context("if type is payment or shippingOptions") {
                it("needs to setup min top margin") {
                    view = BoldTitleTableHeaderView(type: .payment)
                    setupViews()
                    
                    expect(topMarginConstraint.constant) == 4
                }
            }
            
            context("if type is other") {
                it("needs to setup max top margin") {
                    view = BoldTitleTableHeaderView(type: .customerEmail)
                    setupViews()
                    
                    expect(topMarginConstraint.constant) == 15
                }
            }
            
            context("if type is customerEmail") {
                it("needs to setup title with correct text") {
                    view = BoldTitleTableHeaderView(type: .customerEmail)
                    setupViews()
                    
                    expect(headerTitleLabel.text) == "Label.CustomerEmail".localizable
                }
            }
            
            context("if type is shippingAddress") {
                it("needs to setup title with correct text") {
                    view = BoldTitleTableHeaderView(type: .shippingAddress)
                    setupViews()
                    
                    expect(headerTitleLabel.text) == "Label.ShippingAddress".localizable
                }
            }
            
            context("if type is details") {
                it("needs to setup title with correct text") {
                    view = BoldTitleTableHeaderView(type: .details)
                    setupViews()
                    
                    expect(headerTitleLabel.text) == "Label.Details".localizable
                }
            }
            
            context("if type is payment") {
                it("needs to setup title with correct text") {
                    view = BoldTitleTableHeaderView(type: .payment)
                    setupViews()
                    
                    expect(headerTitleLabel.text) == "Label.Payment".localizable
                }
            }
            
            context("if type is shippingOptions") {
                it("needs to setup title with correct text") {
                    view = BoldTitleTableHeaderView(type: .shippingOptions)
                    setupViews()
                    
                    expect(headerTitleLabel.text) == "Label.ShippingOptions".localizable
                }
            }
            
            context("if disabled is false") {
                it("needs to setup text color of title with correct value") {
                    view = BoldTitleTableHeaderView(type: .customerEmail)
                    setupViews()
                    
                    expect(headerTitleLabel.textColor) == .black
                }
            }
            
            context("if disabled is true") {
                it("needs to setup text color of title with correct value") {
                    view = BoldTitleTableHeaderView(type: .customerEmail, disabled: true)
                    setupViews()
                    
                    expect(headerTitleLabel.textColor) == .gray
                }
            }
        }
    }
}
