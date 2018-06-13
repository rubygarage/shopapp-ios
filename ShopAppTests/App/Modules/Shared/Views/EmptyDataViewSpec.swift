//
//  EmptyDataViewSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 6/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class EmptyDataViewSpec: QuickSpec {
    override func spec() {
        var view: EmptyDataView!
        var imageView: UIImageView!
        var label: UILabel!
        var button: UIButton!
        var delegateMock: EmptyDataViewDelegateMock!
        
        beforeEach {
            view = EmptyDataView()
            imageView = self.findView(withAccessibilityLabel: "imageView", in: view) as! UIImageView
            label = self.findView(withAccessibilityLabel: "label", in: view) as! UILabel
            button = self.findView(withAccessibilityLabel: "button", in: view) as! UIButton
        }
        
        describe("when view set up") {
            var image: UIImage!
            var text: String!
            var buttonTitle: String!
            
            beforeEach {
                image = #imageLiteral(resourceName: "cart_empty")
                text = "text"
                buttonTitle = "button title"
            }
            
            context("and button title is nil") {
                it("should have correct ui element settings") {
                    view.setup(image: image, text: text)
                    
                    expect(imageView.image) === image
                    expect(label.text) == text
                    expect(button.isHidden) == true
                }
            }
            
            context("and button title isn't nil") {
                it("should have correct ui element settings") {
                    view.setup(image: image, text: text, buttonTitle: buttonTitle)
                    
                    expect(imageView.image) === image
                    expect(label.text) == text
                    expect(button.isHidden) == false
                    expect(button.title(for: .normal)) == buttonTitle
                }
            }
        }
        
        describe("when button did press") {
            it("needs to notify delegate") {
                delegateMock = EmptyDataViewDelegateMock()
                view.delegate = delegateMock
                button.sendActions(for: .touchUpInside)
                
                expect(delegateMock.view) === view
            }
        }
    }
}

