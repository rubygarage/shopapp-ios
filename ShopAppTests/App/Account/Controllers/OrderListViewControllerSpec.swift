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
        var viewController: OrderListViewController!
        var navigationController: NavigationController!
        var tableProvider: OrderListTableProvider!
        var viewModelMock: OrderListViewModelMock!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.account, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.orderList) as! OrderListViewController
            
            let repositoryMock = OrderRepositoryMock()
            let orderListUseCaseMock = OrderListUseCaseMock(repository: repositoryMock)
            
            viewModelMock = OrderListViewModelMock(orderListUseCase: orderListUseCaseMock)
            viewController.viewModel = viewModelMock
            
            tableProvider = OrderListTableProvider()
            viewController.tableProvider = tableProvider

            navigationController = NavigationController(rootViewController: UIViewController())
            navigationController.pushViewController(viewController, animated: false)
            
            _ = viewController.view
        }
        
        describe("when view loaded") {
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(OrderListViewModel.self))
            }
            
            it("should have correct title") {
                expect(viewController.title) == "ControllerTitle.MyOrders".localizable
            }
            
            it("should have correct back button image") {
                expect(viewController.navigationItem.leftBarButtonItem?.image) == #imageLiteral(resourceName: "arrow_left")
            }
            
            it("should have default empty data view") {
                expect(viewController.customEmptyDataView).to(beAnInstanceOf(OrderListEmptyDataView.self))
            }
            
            it("should have correct content inset of table view") {
                expect(viewController.tableView.contentInset) == TableView.defaultContentInsets
            }
            
            it("should start reload data") {
                expect(viewModelMock.isReloadDataStarted) == true
            }
        }
        
        describe("when data loaded") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if data is empty") {
                it("should have tableView without data") {
                    viewModelMock.isNeedToReturnData = false
                    viewModelMock.reloadData()
                    
                    viewController.viewModel.items.asObservable()
                        .subscribe(onNext: { items in
                            expect(viewController.refreshControl?.isRefreshing) == false
                            expect(viewController.tableView.numberOfSections) == 0
                            expect(tableProvider.orders) === items
                        })
                        .disposed(by: disposeBag)
                }
            }
            
            context("if data isn't empty") {
                it("should have tableView with data") {
                    viewModelMock.isNeedToReturnData = true
                    viewModelMock.reloadData()
                    
                    viewController.viewModel.items.asObservable()
                        .subscribe(onNext: { items in
                            expect(viewController.refreshControl?.isRefreshing) == false
                            expect(viewController.tableView.numberOfSections) == items.count
                            expect(tableProvider.orders) === items
                        })
                        .disposed(by: disposeBag)
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
