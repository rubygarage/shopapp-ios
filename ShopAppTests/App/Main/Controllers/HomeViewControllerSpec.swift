//
//  HomeViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class HomeViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: HomeViewController!
        var viewModelMock: HomeViewModelMock!
        var tableProvider: HomeTableProvider!
        var tableView: UITableView!

        beforeEach {
            viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.home) as! HomeViewController
            
            let articleRepositoryMock = ArticleRepositoryMock()
            let articleListUseCaseMock = ArticleListUseCaseMock(repository: articleRepositoryMock)
            let productRepositoryMock = ProductRepositoryMock()
            let productListUseCaseMock = ProductListUseCaseMock(repository: productRepositoryMock)
            viewModelMock = HomeViewModelMock(articleListUseCase: articleListUseCaseMock, productListUseCase: productListUseCaseMock)
            viewController.viewModel = viewModelMock
            
            tableProvider = HomeTableProvider()
            viewController.tableProvider = tableProvider
            
            tableView = self.findView(withAccessibilityLabel: "tableView", in: viewController.view) as! UITableView
            
            _ = viewController.view
        }
        
        describe("when view loaded") {
            beforeEach {
                viewController.viewWillAppear(false)
            }
            
            it("should have correct superclass") {
                expect(viewController).to(beAKindOf(BaseTableViewController<HomeViewModel>.self))
            }
            
            it("should have correct table provider class") {
                expect(viewController.tableProvider).to(beAnInstanceOf(HomeTableProvider.self))
            }
            
            it("should have correct delegate of table provider") {
                expect(tableProvider.delegate) === viewController
            }
            
            it("should have correct data source and delegate of table view") {
                expect(tableView.dataSource) === tableProvider
                expect(tableView.delegate) === tableProvider
            }
            
            it("should have correct table view insets") {
                expect(tableView.contentInset) == TableView.defaultContentInsets
            }
            
            it("should have correct title") {
                expect(viewController.navigationItem.title) == "ControllerTitle.Home".localizable
            }
            
            it("should have cart button") {
                expect(viewController.navigationItem.rightBarButtonItem).toNot(beNil())
            }
            
            it("should start loading data") {
                expect(viewModelMock.isDataLoadingStarted) == true
            }
        }
        
        describe("when data loaded") {
            beforeEach {
                viewModelMock.isNeedsToReturnError = false
                viewModelMock.loadData()
            }
            
            it("should have correct table provider properties") {
                expect(viewController.tableProvider.lastArrivalsProducts.count) > 0
                expect(viewController.tableProvider.popularProducts.count) > 0
                expect(viewController.tableProvider.articles.count) > 0
            }
            
            it("should reload table view", closure: {
                expect(tableView.visibleCells.isEmpty) == false
                expect(tableView.numberOfSections) == 3
                expect(tableView.numberOfRows(inSection: 0)) == 1
                expect(tableView.numberOfRows(inSection: 1)) == 1
                expect(tableView.numberOfRows(inSection: 2)) == 1
            })
            
            it("should stop show hud", closure: {
                expect(viewController.refreshControl?.isRefreshing) == false
            })
        }
        
        describe("when data refreshed") {
            it("should start loading data", closure: {
                viewController.pullToRefreshHandler()
                
                expect(viewModelMock.isDataLoadingStarted) == true
            })
        }
    }
}
