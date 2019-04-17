//
//  ProductListViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class ProductListViewViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: ProductListViewController!
        var viewModelMock: ProductListViewModelMock!
        var collectionView: UICollectionView!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.main, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.productList) as? ProductListViewController
            
            let productRepositoryMock = ProductRepositoryMock()
            let productListUseCase = ProductListUseCaseMock(repository: productRepositoryMock)
            viewModelMock = ProductListViewModelMock(productListUseCase: productListUseCase)
            viewController.viewModel = viewModelMock
            
            collectionView = self.findView(withAccessibilityLabel: "collectionView", in: viewController.view) as? UICollectionView            
        }
        
        describe("when view loaded") {
            beforeEach {
                viewController.viewWillAppear(false)
            }
            
            it("should have correct superclass") {
                expect(viewController).to(beAKindOf(GridCollectionViewController<ProductListViewModel>.self))
            }
            
            it("should have correct initial values") {
                expect(viewController.sortingValue).to(beNil())
                expect(viewController.keyPhrase).to(beNil())
                expect(viewController.excludePhrase).to(beNil())
            }
            
            it("should setup view model") {
                expect(viewController.viewModel.sortingValue).to(beNil())
                expect(viewController.viewModel.keyPhrase).to(beNil())
                expect(viewController.viewModel.excludePhrase).to(beNil())
            }
            
            it("should have cart button") {
                expect(viewController.navigationItem.rightBarButtonItem?.customView?.subviews.first).to(beAKindOf(CartButtonView.self))
            }
            
            it("should start load data") {
                expect(viewModelMock.isReloadDataStarted) == true
            }
        }
        
        describe("when data loaded") {
            context("if data loaded successfully") {
                beforeEach {
                    viewModelMock.isNeedToReturnData = true
                }
                
                it("should load data") {
                    viewController.viewModel.reloadData()
                    
                    expect(viewModelMock.isReloadDataStarted) == true
                    expect(viewController.collectionProvider.products.isEmpty) == false
                    expect(viewController.refreshControl?.isRefreshing) == false
                    expect(collectionView.numberOfItems(inSection: 0)) == 1
                }
            }
            
            context("if error did occured") {
                beforeEach {
                    viewModelMock.isNeedToReturnData = false
                }
                
                it("shouldn't load data") {
                    viewController.viewModel.reloadData()
                    
                    expect(viewModelMock.isReloadDataStarted) == true
                    expect(viewController.collectionProvider.products.isEmpty) == true
                    expect(viewController.refreshControl?.isRefreshing) == false
                    expect(collectionView.numberOfItems(inSection: 0)) == 0
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
