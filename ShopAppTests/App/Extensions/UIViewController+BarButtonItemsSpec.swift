//
//  UIViewController+BarButtonItemsSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/24/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class UIViewController_BarButtonItemsSpec: QuickSpec {
    override func spec() {
        var viewController: UIViewController!
        
        beforeEach {
            viewController = UIViewController()
        }
        
        describe("when cart button added") {
            var cartBarButton: UIBarButtonItem!
            
            beforeEach {
                viewController.addCartBarButton()
                cartBarButton = viewController.navigationItem.rightBarButtonItem
            }
            
            it("should have custom view") {
                expect(cartBarButton.customView).to(beAnInstanceOf(UIButton.self))
            }
            
            it("should have cart subview") {
                let button = cartBarButton.customView as! UIButton
                let cartView = button.subviews.first!
                
                expect(cartView).to(beAnInstanceOf(CartButtonView.self))
                expect(cartView.frame) == CGRect(x: 0, y: 0, width: 32, height: 32)
            }
            
            it("should have correct action name") {
                let button = cartBarButton.customView as! UIButton
                let action = button.actions(forTarget: viewController, forControlEvent: .touchUpInside)?.first
                
                expect(action) == "cartButtonDidPress"
            }
        }
        
        describe("when back button added") {
            context("if view controller has navigation controller") {
                context("if view controller is first from navigation controller") {
                    beforeEach {
                        _ = UINavigationController(rootViewController: viewController)
                        viewController.addBackButtonIfNeeded()
                    }
                    
                    it("shouldn't have back button") {
                        expect(viewController.navigationItem.leftBarButtonItem).to(beNil())
                    }
                }
                
                context("and if not first") {
                    var backButton: UIBarButtonItem!
                    
                    beforeEach {
                        let navigation = UINavigationController(rootViewController: UIViewController())
                        navigation.viewControllers.append(viewController)
                        viewController.addBackButtonIfNeeded()
                        backButton = viewController.navigationItem.leftBarButtonItem
                    }
                    
                    it("shouldn't have right bar button item") {
                        expect(backButton).to(beAnInstanceOf(UIBarButtonItem.self))
                    }
                    
                    it("should have correct image") {
                        expect(backButton.image) == #imageLiteral(resourceName: "arrow_left")
                    }
                    
                    it("should have correct target") {
                        expect(backButton.target) === viewController
                    }
                    
                    it("should have correct action name") {
                        expect(backButton.action?.description) == "backButtonDidPress"
                    }
                }
            }
            
            context("if view controller hasn't navigation controller") {
                beforeEach {
                    viewController.addBackButtonIfNeeded()
                }
                
                it("shouldn't have back button") {
                    expect(viewController.navigationItem.leftBarButtonItem).to(beNil())
                }
            }
        }
        
        describe("when close button added") {
            var closeButton: UIBarButtonItem!
            
            beforeEach {
                viewController.addCloseButton()
                closeButton = viewController.navigationItem.rightBarButtonItem
            }
            
            it("should have right bar button item") {
                expect(closeButton).to(beAnInstanceOf(UIBarButtonItem.self))
            }
            
            it("should have correct image") {
                expect(closeButton.image) == #imageLiteral(resourceName: "cross")
            }
            
            it("should have correct target") {
                expect(closeButton.target) === viewController
            }
            
            it("should have correct action name") {
                expect(closeButton.action?.description) == "closeButtonDidPress"
            }
        }
    }
}
