//
//  BaseTableViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class BaseTableViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: BaseTableViewController<BasePaginationViewModel>!
        
        beforeEach {
            viewController = BaseTableViewController()
            viewController.viewModel = BasePaginationViewModel()
            _ = viewController.view
        }
        
        describe("when view loaded") {
            it("should have refresh control") {
                expect(viewController.refreshControl).toNot(beNil())
            }
        }
        
        describe("when load animation stopped") {
            it("needs to end refreshing") {
                viewController.refreshControl?.beginRefreshing()
                viewController.stopLoadAnimating()
                
                expect(viewController.refreshControl?.isRefreshing).to(beFalse())
            }
        }
    }
}
