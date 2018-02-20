//
//  TabBarControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import UIImage_Additions

@testable import ShopApp

class TabBarControllerSpec: QuickSpec {
    override func spec() {
        var tabBarController: TabBarController!
        
        beforeEach {
            tabBarController = TabBarController()
            _ = tabBarController.view
        }
        
        describe("when view loaded") {
            it("should have correct images in tab bar's appearance") {
                let shadowColor = UIColor.black.withAlphaComponent(0.12)
                let backgroundColor = UIColor(displayP3Red: 0.9765, green: 0.9765, blue: 0.9765, alpha: 0.9)
                let shadowImage = UIImage.add_image(with: shadowColor)
                let backgroundImage = UIImage.add_image(with: backgroundColor)
                expect(UITabBar.appearance().shadowImage).to(equal(shadowImage))
                expect(UITabBar.appearance().backgroundImage).to(equal(backgroundImage))
            }
        }
    }
}
