//
//  BasePaginationViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class BasePaginationViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: BasePaginationViewController<BasePaginationViewModel>!
        
        beforeEach {
            viewController = BasePaginationViewController()
            viewController.viewModel = BasePaginationViewModel()
            _ = viewController.view
        }
        
        describe("when view loaded") {
            it("shouldn't have refresh control") {
                expect(viewController.refreshControl).to(beNil())
            }
        }
    }
}
