//
//  OrderDetailsViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class OrderDetailsViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: OrderDetailsViewController!
        var tableProvider: OrderDetailsTableProvider!
        var viewModelMock: OrderDetailsViewModelMock!
        var tableView: UITableView!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.account, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.orderDetails) as! OrderDetailsViewController
            viewController.orderId = "order id"
            let repository = OrderRepositoryMock()
            let orderUseCaseMock = OrderUseCaseMock(repository: repository)
            viewModelMock = OrderDetailsViewModelMock(orderUseCase: orderUseCaseMock)
            viewController.viewModel = viewModelMock
            tableProvider = OrderDetailsTableProvider()
            viewController.tableProvider = tableProvider
            tableView = self.findView(withAccessibilityLabel: "orderDetailTableView", in: viewController.view) as! UITableView            
        }
        
        describe("when view loaded") {
            it("should have a correct superclass") {
                expect(viewController.isKind(of: BaseViewController<OrderDetailsViewModel>.self)) == true
            }
            
            it("should have view model with correct type") {
                expect(viewController.viewModel).to(beAKindOf(OrderDetailsViewModel.self))
            }
            
            it("should have correct title") {
                expect(viewController.title) == "ControllerTitle.OrderDetails".localizable
            }
            
            it("should have correct view model properties") {
                expect(viewModelMock.orderId) == viewController.orderId
            }
            
            it("should have correct delegate of table provider") {
                expect(viewController.tableProvider.delegate) === viewController
            }
            
            it("should have correct data source and delegate of table view") {
                expect(tableView.dataSource) === tableProvider
                expect(tableView.delegate) === tableProvider
            }
            
            it("should have correct content inset of table view") {
                expect(tableView.contentInset) == TableView.defaultContentInsets
            }
        }
        
        describe("when data loaded") {
            it("should start loading order") {
                expect(viewModelMock.isLoadingOrderStarted) == true
            }
            
            context("if data is empty") {
                it("should have tableView without data") {
                    viewModelMock.makeEmptyData()
                    viewModelMock.loadOrder()
                    
                    expect(tableProvider.order).to(beNil())
                    expect(tableView.numberOfSections) == 0
                }
            }
            
            context("if data isn't empty") {
                it("should have tableView with data") {
                    viewModelMock.makeNotEmptyData()
                    viewModelMock.loadOrder()
                    
                    expect(tableProvider.order).toNot(beNil())
                    expect(tableView.numberOfSections) > 0
                }
            }
        }
    }
}
