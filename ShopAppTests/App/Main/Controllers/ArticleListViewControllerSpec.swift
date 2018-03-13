//
//  ArticleListViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class ArticleListViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: ArticleListViewController!
        var tableProvider: ArticleListTableProvider!
        var viewModelMock: ArticleListViewModelMock!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.main, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.articleList) as! ArticleListViewController
            
            let repository = ArticleRepositoryMock()
            let articleListUseCaseMock = ArticleListUseCaseMock(repository: repository)
            
            viewModelMock = ArticleListViewModelMock(articleListUseCase: articleListUseCaseMock)
            viewController.viewModel = viewModelMock
            
            tableProvider = ArticleListTableProvider()
            viewController.tableProvider = tableProvider
            
            _ = viewController.view
        }
        
        describe("when view loaded") {
            it("should have a correct superclass") {
                expect(viewController.isKind(of: BaseTableViewController<ArticleListViewModel>.self)) == true
            }
            
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(ArticleListViewModel.self))
            }
            
            it("should have correct title") {
                expect(viewController.title) == "ControllerTitle.BlogPosts".localizable
            }
            
            it("should have correct delegate of table provider") {
                expect(viewController.tableProvider.delegate) === viewController
            }
            
            it("should have correct data source and delegate of table view") {
                expect(viewController.tableView.dataSource) === tableProvider
                expect(viewController.tableView.delegate) === tableProvider
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
                    expect(viewController.tableView.numberOfRows(inSection: 0)) == 0
                    expect(tableProvider.articles.isEmpty) == true
                }
            }
            
            context("if data isn't empty") {
                it("should have tableView with data") {
                    viewModelMock.isNeedToReturnData = true
                    viewModelMock.reloadData()
                    
                    expect(viewController.refreshControl?.isRefreshing) == false
                    expect(viewController.tableView.numberOfRows(inSection: 0)) > 0
                    expect(tableProvider.articles.isEmpty) == false
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
