//
//  SearchViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/15/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class SearchViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: SearchViewController!
        var viewModelMock: SearchViewModelMock!
        var categoryListContainerView: UIView!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.main, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.search) as! SearchViewController
            
            _ = NavigationController(rootViewController: viewController)
            
            let repositoryMock = ProductRepositoryMock()
            let productListUseCaseMock = ProductListUseCaseMock(repository: repositoryMock)
            
            viewModelMock = SearchViewModelMock(productListUseCase: productListUseCaseMock)
            viewController.viewModel = viewModelMock
          
            categoryListContainerView = self.findView(withAccessibilityLabel: "categoryList", in: viewController.view)
        }
     
        describe("when view loaded") {
            it("should have a correct superclass") {
                expect(viewController.isKind(of: GridCollectionViewController<SearchViewModel>.self)) == true
            }
            
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(SearchViewModel.self))
            }
            
            it("should have default empty data view") {
                expect(viewController.customEmptyDataView).to(beAnInstanceOf(SearchEmptyDataView.self))
            }
            
            it("should have correct content inset of collection view") {
                expect(viewController.collectionView.contentInset) == GridCollectionViewCell.searchCollectionViewInsets
            }
            
            it("should have correct content keyboard dismiss mode of collection viwe") {
                expect(viewController.collectionView.keyboardDismissMode.rawValue) == UIScrollViewKeyboardDismissMode.onDrag.rawValue
            }
        }
        
        describe("when view appeared") {
            var titleView: SearchTitleView!
            
            beforeEach {
                viewController.viewWillAppear(false)
                
                titleView = viewController.navigationController!.navigationBar.subviews.last! as! SearchTitleView
            }
            
            it("needs to setup title view's delegate") {
                expect(titleView.delegate) === viewController
            }
            
            it("needs to setup title view's frame") {
                expect(titleView.frame.origin) == CGPoint(x: 8, y: 0)
                expect(titleView.frame.size) == CGSize(width: viewController.view.frame.size.width - 8 * 2, height: 44)
            }
            
            it("needs to setup title view's alpha") {
                expect(titleView.alpha) == 1
            }
            
            it("needs to setup correct title bar tint color") {
                expect(viewController.navigationController?.navigationBar.barTintColor) == Colors.backgroundDefault
            }
        }
            
        describe("when view disappeared") {
            beforeEach {
                viewController.viewWillAppear(false)
                viewController.viewWillDisappear(false)
            }
            
            it("needs to setup correct title bar tint color") {
                expect(viewController.navigationController?.navigationBar.barTintColor) == UIColor.white
            }
        }
        
        describe("when title view's text changed") {
            it("needs to setup search phrase of view model") {
                viewController.viewWillAppear(false)
                
                let titleView = viewController.navigationController!.navigationBar.subviews.last! as! SearchTitleView
                titleView.textField.text = "phrase"
                titleView.textField.sendActions(for: .editingChanged)
                
                expect(viewModelMock.searchPhrase.value) == titleView.text
            }
        }
        
        describe("when data loaded") {
            context("if data is empty") {
                it("should have collection view without data") {
                    viewModelMock.isNeedToReturnData = false
                    viewModelMock.reloadData()
                    
                    expect(viewController.refreshControl?.isRefreshing) == false
                    expect(viewController.collectionView.numberOfItems(inSection: 0)) == 0
                    expect(viewController.collectionProvider.products.isEmpty) == true
                }
            }
            
            context("if data isn't empty") {
                it("should have collection view with data") {
                    viewModelMock.isNeedToReturnData = true
                    viewModelMock.reloadData()
                    
                    expect(viewController.refreshControl?.isRefreshing) == false
                    expect(viewController.collectionView.numberOfItems(inSection: 0)) > 0
                    expect(viewController.collectionProvider.products.isEmpty) == false
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
            var titleView: SearchTitleView!
            
            beforeEach {
                viewController.viewWillAppear(false)
                
                viewModelMock.isNeedToReturnData = true
                viewModelMock.reloadData()
                
                titleView = viewController.navigationController!.navigationBar.subviews.last! as! SearchTitleView
                titleView.textField.sendActions(for: .editingDidBegin)
                
                let indexPath = IndexPath(item: 0, section: 0)
                viewController.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
                viewController.collectionView.delegate!.collectionView!(viewController.collectionView, didSelectItemAt: indexPath)
            }
            
            it("needs to end editing view") {
                expect(titleView.textField.isEditing) == false
            }
            
            it("needs to setup title view's alpha") {
                expect(titleView.alpha) == 0
            }
            
            it("needs to setup title view's alpha when user returns back") {
                viewController.viewWillAppear(false)
                
                expect(titleView.alpha) == 1
            }
        }
        
        describe("when category selected") {
            it("needs to setup title view's alpha") {
                viewController.viewWillAppear(false)
                
                let categoryListViewController = viewController.childViewControllers.first! as! CategoryListViewController
                categoryListViewController.collectionProvider = CategoryListCollectionProvider()
                categoryListViewController.collectionProvider.delegate = categoryListViewController
                categoryListViewController.collectionView.dataSource = categoryListViewController.collectionProvider
                categoryListViewController.collectionView.delegate = categoryListViewController.collectionProvider
                
                let repositoryMock = CategoryRepositoryMock()
                let categoryListUseCaseMock = CategoryListUseCaseMock(repository: repositoryMock)
                let viewModelMock = CategoryListViewModelMock(categoryListUseCase: categoryListUseCaseMock)
                categoryListViewController.viewModel = viewModelMock
                viewModelMock.isNeedToReturnData = true
                viewModelMock.reloadData()
                
                categoryListViewController.collectionProvider.categories = viewModelMock.items.value
                categoryListViewController.collectionView.reloadData()
                
                let indexPath = IndexPath(item: 0, section: 0)
                categoryListViewController.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
                categoryListViewController.collectionView.delegate!.collectionView!(viewController.collectionView, didSelectItemAt: indexPath)
                
                let titleView = viewController.navigationController!.navigationBar.subviews.last! as! SearchTitleView
                
                expect(titleView.alpha) == 0
            }
        }
        
        describe("when title view editing begined") {
            it("needs to hide category list") {
                viewController.viewWillAppear(false)
                
                let titleView = viewController.navigationController!.navigationBar.subviews.last! as! SearchTitleView
                titleView.textField.sendActions(for: .editingDidBegin)
                
                expect(categoryListContainerView.alpha) == 0
            }
        }
        
        describe("when title view editing changed") {
            it("needs to reload search items") {
                viewController.viewWillAppear(false)
                
                let titleView = viewController.navigationController!.navigationBar.subviews.last! as! SearchTitleView
                titleView.textField.sendActions(for: .editingDidBegin)
                
                waitUntil(timeout: 2) { done in
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        done()
                    })
                }
                
                titleView.textField.text = "phrase"
                titleView.textField.sendActions(for: .editingChanged)
                
                expect(viewModelMock.isReloadDataStarted).toEventually(equal(true), timeout: 1, pollInterval: 0.3)
            }
        }
        
        describe("when title view's clear button pressed") {
            it("needs to clear search result") {
                viewController.viewWillAppear(false)
                
                let titleView = viewController.navigationController!.navigationBar.subviews.last! as! SearchTitleView
                let clearButton = self.findView(withAccessibilityLabel: "clear", in: titleView) as! UIButton
                clearButton.sendActions(for: .touchUpInside)
                
                expect(viewModelMock.isResultCleared) == true
            }
        }
        
        describe("when title view's back button pressed") {
            it("needs to clear search result and show category list") {
                viewController.viewWillAppear(false)
                
                let titleView = viewController.navigationController!.navigationBar.subviews.last! as! SearchTitleView
                let backButton = self.findView(withAccessibilityLabel: "back", in: titleView) as! UIButton
                backButton.sendActions(for: .touchUpInside)
                
                expect(viewModelMock.isResultCleared) == true
                expect(categoryListContainerView.alpha) == 1
            }
        }
    }
}
