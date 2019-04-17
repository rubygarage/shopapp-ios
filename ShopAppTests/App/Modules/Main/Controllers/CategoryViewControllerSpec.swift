//
//  CategoryViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CategoryViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: CategoryViewController!
        var viewModelMock: CategoryViewModelMock!
        var sortByLabel: UILabel!
        var sortByView: UIView!
        var sortByViewTopLayoutConstraint: NSLayoutConstraint!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.main, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.category) as? CategoryViewController
            viewController.categoryId = "id"
            
            let repository = CategoryRepositoryMock()
            let categoryUseCaseMock = CategoryUseCaseMock(repository: repository)
            
            viewModelMock = CategoryViewModelMock(categoryUseCase: categoryUseCaseMock)
            viewController.viewModel = viewModelMock
            
            sortByLabel = self.findView(withAccessibilityLabel: "sortByLabel", in: viewController.view) as? UILabel
            sortByView = self.findView(withAccessibilityLabel: "sortByView", in: viewController.view)
            sortByViewTopLayoutConstraint = sortByView.superview!.constraints.filter({ $0.accessibilityLabel == "sortByViewTop" }).first
        }
        
        describe("when view loaded") {
            beforeEach {
                viewController.viewWillAppear(false)
            }
            
            it("should have a correct superclass") {
                expect(viewController.isKind(of: GridCollectionViewController<CategoryViewModel>.self)) == true
            }
            
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(CategoryViewModel.self))
            }
            
            it("should have default empty data view") {
                expect(viewController.customEmptyDataView).to(beAnInstanceOf(CategoryEmptyDataView.self))
            }
            
            it("should have correct text sort by label") {
                expect(sortByLabel.text) == "Label.SortBy".localizable.uppercased()
            }
            
            it("should have correct content inset of collection viwe") {
                expect(viewController.collectionView.contentInset) == GridCollectionViewCell.sortableCollectionViewInsets
            }
            
            it("should setup view model with correct id") {
                expect(viewModelMock.categoryId) == viewController.categoryId
            }
            
            it("should start reload data") {
                expect(viewModelMock.isReloadDataStarted) == true
            }
            
            it("should have cart button") {
                expect(viewController.navigationItem.rightBarButtonItem?.customView?.subviews.first).to(beAKindOf(CartButtonView.self))
            }
        }
        
        describe("when data loaded") {
            context("if data is empty") {
                it("should have tableView without data") {
                    viewModelMock.isNeedToReturnData = false
                    viewModelMock.reloadData()
                    
                    expect(viewController.refreshControl?.isRefreshing) == false
                    expect(viewController.collectionView.numberOfItems(inSection: 0)) == 0
                    expect(viewController.collectionProvider.products.isEmpty) == true
                }
            }
            
            context("if data isn't empty") {
                it("should have tableView with data") {
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

        describe("when collection view scrolled") {
            beforeEach {
                viewController.view.layoutIfNeeded()
                
                viewModelMock.isNeedToReturnData = true
                viewModelMock.reloadData()
                viewController.collectionView.layoutIfNeeded()
            }
            
            context("if user scrolls to down") {
                it("needs to hide sort by view") {
                    var contentOffset = CGPoint(x: 0, y: 0)
                    viewController.collectionView.setContentOffset(contentOffset, animated: false)
                    contentOffset.y = sortByView.frame.size.height
                    viewController.collectionView.setContentOffset(contentOffset, animated: false)
                    
                    expect(sortByViewTopLayoutConstraint.constant) == -sortByView.frame.size.height
                }
            }
            
            context("if user scrolls to top") {
                it("needs to show sort by view") {
                    var contentOffset = CGPoint(x: 0, y: 0)
                    viewController.collectionView.setContentOffset(contentOffset, animated: false)
                    contentOffset.y = sortByView.frame.size.height
                    viewController.collectionView.setContentOffset(contentOffset, animated: false)
                    contentOffset.y = 0
                    viewController.collectionView.setContentOffset(contentOffset, animated: false)
                    
                    expect(sortByViewTopLayoutConstraint.constant) == 0
                }
            }
        }
        
        describe("when sort variant selected") {
            it("needs to reload data with selected sorting value") {
                let sortVariantsViewController = SortVariantsViewController()
                viewController.viewController(sortVariantsViewController, didSelect: .createdAt)
                
                expect(viewModelMock.selectedSortingValue.rawValue) == SortingValue.createdAt.rawValue
                expect(viewModelMock.isResultCleared) == true
                expect(viewModelMock.isReloadDataStarted) == true
            }
        }
    }
}
