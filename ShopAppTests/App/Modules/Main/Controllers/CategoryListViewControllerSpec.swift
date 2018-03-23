//
//  CategoryListViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class CategoryListViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: CategoryListViewController!
        var collectionProvider: CategoryListCollectionProvider!
        var viewModelMock: CategoryListViewModelMock!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.main, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.categoryList) as! CategoryListViewController
            
            let repository = CategoryRepositoryMock()
            let categoryListUseCaseMock = CategoryListUseCaseMock(repository: repository)
            
            viewModelMock = CategoryListViewModelMock(categoryListUseCase: categoryListUseCaseMock)
            viewController.viewModel = viewModelMock
            
            collectionProvider = CategoryListCollectionProvider()
            viewController.collectionProvider = collectionProvider
            
            _ = viewController.view
        }
        
        describe("when view loaded") {
            it("should have a correct superclass") {
                expect(viewController.isKind(of: BaseCollectionViewController<CategoryListViewModel>.self)) == true
            }
            
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(CategoryListViewModel.self))
            }
            
            it("should have correct delegate of collection provider") {
                expect(viewController.collectionProvider.delegate) === viewController
            }
            
            it("should have correct data source and delegate of collection view") {
                expect(viewController.collectionView.dataSource) === collectionProvider
                expect(viewController.collectionView.delegate) === collectionProvider
            }
            
            it("should have correct content inset of collection viwe") {
                expect(viewController.collectionView.contentInset) == CategoryCollectionViewCell.collectionViewInsets
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
                    expect(viewController.collectionView.numberOfItems(inSection: 0)) == 0
                    expect(collectionProvider.categories.isEmpty) == true
                }
            }
            
            context("if data isn't empty") {
                it("should have tableView with data") {
                    viewModelMock.isNeedToReturnData = true
                    viewModelMock.reloadData()
                    
                    expect(viewController.refreshControl?.isRefreshing) == false
                    expect(viewController.collectionView.numberOfItems(inSection: 0)) > 0
                    expect(collectionProvider.categories.isEmpty) == false
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
        
        describe("when collection view item selected") {
            it("needs to select category") {
                let delegateMock = CategoryListControllerDelegateMock()
                viewController.delegate = delegateMock
                
                viewModelMock.isNeedToReturnData = true
                viewModelMock.reloadData()
                
                let indexPath = IndexPath(item: 0, section: 0)
                viewController.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
                viewController.collectionView.delegate!.collectionView!(viewController.collectionView, didSelectItemAt: indexPath)
                
                expect(delegateMock.viewController) === viewController
                expect(delegateMock.category).toNot(beNil())
            }
        }
    }
}
