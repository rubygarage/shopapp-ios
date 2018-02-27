//
//  BaseAddressFormViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/26/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class BaseAddressFormViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: BaseAddressFormViewController<BaseViewModel>!
        
        beforeEach {
            viewController = BaseAddressFormViewController()
        }
        
        describe("when view controller initialized") {
            context("if action type adding") {
                it("should have a correct title") {
                    viewController.addressAction = .add
                    _ = viewController.view
                    
                    expect(viewController.title) == "ControllerTitle.AddNewAddress".localizable
                }
            }
            
            
            context("if action type editing") {
                it("should have correct title") {
                    viewController.addressAction = .edit
                    _ = viewController.view
                    
                    expect(viewController.title) == "ControllerTitle.EditAddress".localizable
                }
            }
        }
    }
}
