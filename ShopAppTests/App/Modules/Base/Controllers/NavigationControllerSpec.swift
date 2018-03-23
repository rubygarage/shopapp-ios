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
                expect(navigationController.navigationBar.tintColor) == .black
                expect(navigationController.navigationBar.barTintColor) == .white
            }
            
            it("should have correct images in navigation bar") {
                let shadowImage = UIImage.add_image(with: Colors.shadowImage)
                let backgroundImage = UIImage.add_image(with: .white)
                expect(navigationController.navigationBar.shadowImage) == shadowImage
                expect(navigationController.navigationBar.backgroundImage(for: .default)) == backgroundImage
            }
            
            it("should have correct translucency in navigation bar") {
                expect(navigationController.navigationBar.isTranslucent) == false
            }
        }
    }
}
