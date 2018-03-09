//
//  OrderDetailsViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift

@testable import ShopApp

class OrderDetailsViewControllerSpec: QuickSpec {
    private let numberOfSections = 3
    
    override func spec() {
        var viewController: OrderDetailsViewController!
        var navigationController: NavigationController!
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
            navigationController = NavigationController(rootViewController: UIViewController())
            navigationController.pushViewController(viewController, animated: false)
            tableView = self.findView(withAccessibilityLabel: "orderDetailTableView", in: viewController.view) as! UITableView
            
            _ = viewController.view
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
            
            it("should have a back button") {
                expect(viewController.navigationItem.leftBarButtonItem?.image) == #imageLiteral(resourceName: "arrow_left")
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
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            it("should start loading order") {
                expect(viewModelMock.isLoadingOrderStarted) == true
            }
            
            context("if data is empty") {
                it("should have tableView without data") {
                    viewModelMock.makeEmptyData()
                    viewModelMock.loadOrder()
                    
                    viewController.viewModel.data.asObservable()
                        .subscribe(onNext: { _ in
                            expect(tableView.numberOfSections) == 0
                        })
                        .disposed(by: disposeBag)
                }
            }

            context("if data isn't empty") {
                it("should have tableView with data") {
                    viewModelMock.makeNotEmptyData()
                    viewModelMock.loadOrder()
                    
                    viewController.viewModel.data.asObservable()
                        .subscribe(onNext: { order in
                            expect(order) === tableProvider.order
                            expect(tableView.numberOfSections) == self.numberOfSections
                        })
                        .disposed(by: disposeBag)
                }
            }
        }
    }
}
