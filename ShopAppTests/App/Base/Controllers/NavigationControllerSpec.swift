//
//  NavigationControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import UIImage_Additions

@testable import ShopApp

class NavigationControllerSpec: QuickSpec {
    override func spec() {
        var navigationController: NavigationController!
        
        beforeEach {
            navigationController = NavigationController()
            _ = navigationController.view
        }
        
        describe("when view loaded") {
            it("should have correct tint colors in navigation bar") {
                expect(navigationController.navigationBar.tintColor).to(equal(.black))
                expect(navigationController.navigationBar.barTintColor).to(equal(.white))
            }
            
            it("should have correct images in navigation bar") {
                let shadowColor = UIColor.black.withAlphaComponent(0.12)
                let shadowImage = UIImage.add_image(with: shadowColor)
                let backgroundImage = UIImage.add_image(with: .white)
                expect(navigationController.navigationBar.shadowImage).to(equal(shadowImage))
                expect(navigationController.navigationBar.backgroundImage(for: .default)).to(equal(backgroundImage))
            }
            
            it("should have correct translucency in navigation bar") {
                expect(navigationController.navigationBar.isTranslucent).to(beFalse())
            }
        }
    }
}
