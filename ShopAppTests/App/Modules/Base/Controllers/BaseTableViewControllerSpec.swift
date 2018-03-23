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
        var viewController: BaseTableViewControllerTest!
        
        beforeEach {
            viewController = BaseTableViewControllerTest()
            _ = viewController.view
        }
        
        describe("when view loaded") {
            it("should have a correct superclass") {
                expect(viewController.isKind(of: BasePaginationViewController<BasePaginationViewModel>.self)) == true
            }
            
            it("should have refresh control") {
                expect(viewController.refreshControl).toNot(beNil())
            }
            
            it("should have table view with refresh control") {
                expect(viewController.tableView.refreshControl) === viewController.refreshControl
            }
        }
        
        describe("when load animation stopped") {
            it("needs to end refreshing") {
                viewController.refreshControl?.beginRefreshing()
                viewController.stopLoadAnimating()
                
                expect(viewController.refreshControl?.isRefreshing) == false
            }
        }
    }
}

class BaseTableViewControllerTest: BaseTableViewController<BasePaginationViewModel> {
    let testTableView = UITableView()
    
    override weak var tableView: UITableView! {
        return testTableView
    }
}
