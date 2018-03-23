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
                let shadowImage = UIImage.add_image(with: Colors.shadowImage)
                let backgroundImage = UIImage.add_image(with: Colors.barBackground)
                expect(UITabBar.appearance().shadowImage) == shadowImage
                expect(UITabBar.appearance().backgroundImage) == backgroundImage
            }
        }
    }
}
