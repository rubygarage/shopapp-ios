//
//  UIView+NameOfClassSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class UIView_NameOfClassSpec: QuickSpec {
    override func spec() {
        describe("when class name called") {
            context("if method of object") {
                it("should return correct name") {
                    let label = UILabel()
                    
                    expect(label.nameOfClass) == String(describing: type(of: label))
                }
            }
            
            context("if method of class") {
                it("should return correct name") {
                    expect(UILabel.nameOfClass) == String(describing: UILabel.self)
                }
            }
        }
    }
}
