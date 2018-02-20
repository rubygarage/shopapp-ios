//
//  OrderListViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift

@testable import ShopApp

class OrderListViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: OrdersListViewController!
        var navigationController: NavigationController!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.account, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.orderList) as! OrdersListViewController
            navigationController = NavigationController(rootViewController: UIViewController())
            navigationController.pushViewController(viewController, animated: false)
            _ = viewController.view
        }
        
        describe("when view loaded") {
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAnInstanceOf(OrdersListViewModel.self))
            }
            
            it("should have correct title") {
                expect(viewController.title) == "ControllerTitle.MyOrders".localizable
            }
            
            it("should have correct back button image") {
                expect(viewController.navigationItem.leftBarButtonItem?.image) == #imageLiteral(resourceName: "arrow_left")
            }
            
            it("should have refresh control") {
                expect(viewController.refreshControl).toNot(beNil())
            }
        }
    }
}
