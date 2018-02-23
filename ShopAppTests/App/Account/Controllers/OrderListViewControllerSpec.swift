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
        var viewModel: OrderListViewModelMock!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.account, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.orderList) as! OrderListViewController
            let repository = OrderRepositoryMock()
            let orderListUseCaseMock = OrderListUseCaseMock(repository: repository)
            viewModel = OrderListViewModelMock(orderListUseCase: orderListUseCaseMock)
            viewController.viewModel = viewModel
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
        }
        
        describe("when data loaded") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if data is empty") {
                it("should have tableView without data") {
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
                    viewModel.isNeedToReturnData = true
                    viewModel.reloadData()
                    
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
    }
}
