//
//  NavigationController+ShadowSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class NavigationController_ShadowSpec: QuickSpec {
    override func spec() {
        var navigation: UINavigationController!
        
        beforeEach {
            navigation = UINavigationController()
        }
        
        describe("when shadow added") {
            beforeEach {
                navigation.addShadow()
            }
            
            it("should have shadow image") {
                expect(navigation.navigationBar.shadowImage) == UIImage.add_image(with: Colors.shadowImage)
            }
            
            it("should have background image") {
                expect(navigation.navigationBar.backgroundImage(for: .default)) == UIImage.add_image(with: .white)
            }
            
            it("should set translicent") {
                expect(navigation.navigationBar.isTranslucent) == false
            }
        }
        
        describe("when shadow removed") {
            beforeEach {
                navigation.addShadow()
                navigation.removeShadow()
            }
            
            it("should have empty shadow image") {
                expect(navigation.navigationBar.shadowImage?.hash) == UIImage().hash
            }
            
            it("should have empty background image") {
                expect(navigation.navigationBar.backgroundImage(for: .default)?.hash) == UIImage().hash
            }
        }
    }
}
