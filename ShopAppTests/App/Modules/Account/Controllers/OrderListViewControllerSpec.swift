//
//  OrderListViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class OrderListViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: OrderListViewController!
        var tableProvider: OrderListTableProvider!
        var viewModelMock: OrderListViewModelMock!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.account, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.orderList) as! OrderListViewController
            
            let repositoryMock = OrderRepositoryMock()
            let orderListUseCaseMock = OrdersUseCaseMock(repository: repositoryMock)
            
            viewModelMock = OrderListViewModelMock(ordersUseCase: orderListUseCaseMock)
            viewController.viewModel = viewModelMock
            
            tableProvider = OrderListTableProvider()
            viewController.tableProvider = tableProvider
            
            _ = viewController.view
        }
        
        describe("when view loaded") {
            it("should have a correct superclass") {
                expect(viewController.isKind(of: BaseTableViewController<OrderListViewModel>.self)) == true
            }
            
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(OrderListViewModel.self))
            }
            
            it("should have correct title") {
                expect(viewController.title) == "ControllerTitle.MyOrders".localizable
            }
            
            it("should have empty data view with correct settings") {
                let imageView = self.findView(withAccessibilityLabel: "imageView", in: viewController.customEmptyDataView) as? UIImageView
                let label = self.findView(withAccessibilityLabel: "label", in: viewController.customEmptyDataView) as? UILabel
                let button = self.findView(withAccessibilityLabel: "button", in: viewController.customEmptyDataView) as? UIButton
                
                expect(viewController.customEmptyDataView).to(beAnInstanceOf(EmptyDataView.self))
                expect(imageView?.image) == #imageLiteral(resourceName: "orders_empty")
                expect(label?.text) == "Label.NoOrdersYet".localizable
                expect(button?.title(for: .normal)) == "Button.StartShopping".localizable.uppercased()
            }
            
            it("should have correct delegate of table provider") {
                expect(viewController.tableProvider.delegate) === viewController
            }
            
            it("should have correct data source and delegate of table view") {
                expect(viewController.tableView.dataSource) === tableProvider
                expect(viewController.tableView.delegate) === tableProvider
            }
            
            it("should have correct content inset of table view") {
                expect(viewController.tableView.contentInset) == TableView.defaultContentInsets
            }
            
            it("should start reload data") {
                expect(viewModelMock.isReloadDataStarted) == true
            }
        }
        
        describe("when data loaded") {
            context("if data is empty") {
                it("should have tableView without data") {
                    viewModelMock.isNeedToReturnData = false
                    viewModelMock.reloadData()
                    
                    expect(viewController.refreshControl?.isRefreshing) == false
                    expect(viewController.tableView.numberOfSections) == 0
                    expect(tableProvider.orders.isEmpty) == true
                }
            }
            
            context("if data isn't empty") {
                it("should have tableView with data") {
                    viewModelMock.isNeedToReturnData = true
                    viewModelMock.reloadData()
                    
                    expect(viewController.refreshControl?.isRefreshing) == false
                    expect(viewController.tableView.numberOfSections) > 0
                    expect(tableProvider.orders.isEmpty) == false
                }
            }
        }
        
        describe("when data refreshed or loaded next page") {
            it("should refresh data") {
                viewController.pullToRefreshHandler()
                
                expect(viewModelMock.isReloadDataStarted) == true
            }
            
            it("should load next page") {
                viewController.infinityScrollHandler()
                
                expect(viewModelMock.isLoadNextPageStarted) == true
            }
        }
    }
}
