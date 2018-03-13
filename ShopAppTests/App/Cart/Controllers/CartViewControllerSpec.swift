//
//  CartViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway
import SwipeCellKit

@testable import ShopApp

class CartViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: CartViewController!
        var viewModelMock: CartViewModelMock!
        var tableProvider: CartTableProvider!
        var tableView: UITableView!
        var checkoutButton: BlackButton!
        
        beforeEach {
            viewController = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.cart) as! CartViewController
            
            let repositoryMock = CartRepositoryMock()
            let cartProductListUseCaseMock = CartProductListUseCaseMock(repository: repositoryMock)
            let deleteCartProductUseCaseMock = DeleteCartProductUseCaseMock(repository: repositoryMock)
            let changeCartProductUseCaseMock = ChangeCartProductUseCaseMock(repository: repositoryMock)
            viewModelMock = CartViewModelMock(cartProductListUseCase: cartProductListUseCaseMock, deleteCartProductUseCase: deleteCartProductUseCaseMock, changeCartProductUseCase: changeCartProductUseCaseMock)
            viewController.viewModel = viewModelMock
            
            tableProvider = CartTableProvider()
            viewController.tableProvider = tableProvider
            
            tableView = self.findView(withAccessibilityLabel: "tableView", in: viewController.view) as! UITableView
            
            checkoutButton = self.findView(withAccessibilityLabel: "checkoutButton", in: viewController.view) as! BlackButton
        }
        
        describe("when view loaded") {
            beforeEach {
                _ = viewController.view
            }
            
            it("should have correct subclass type") {
                expect(viewController.isKind(of: BaseViewController<CartViewModel>.self)) == true
            }
            
            it("should have correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(CartViewModel.self))
            }
            
            it("should have correct provider type") {
                expect(viewController.tableProvider).to(beAKindOf(CartTableProvider.self))
            }
            
            it("should have corect title") {
                expect(viewController.title) == "ControllerTitle.Cart".localizable
            }
            
            it("should have close button") {
                expect(viewController.navigationItem.rightBarButtonItem?.image) == #imageLiteral(resourceName: "cross")
            }
            
            it("should have correct delegate of table provider") {
                expect(tableProvider.delegate) === viewController
            }
            
            it("should have correct data source and delegate of table view") {
                expect(tableView.dataSource) === tableProvider
                expect(tableView.delegate) === tableProvider
            }
            
            it("should have correct checkout button", closure: {
                expect(checkoutButton.title(for: .normal)) == "Button.Checkout".localizable.uppercased()
            })
            
            it("should have default empty data view") {
                expect(viewController.customEmptyDataView).to(beAnInstanceOf(CartEmptyDataView.self))
            }
            
            it("should start loading data") {
                expect(viewModelMock.isLoadDataStarted) == true
            }
        }
        
        describe("when data loaded") {
            beforeEach {
                _ = viewController.view
            }
            
            context("if data is empty") {
                beforeEach {
                    viewModelMock.isNeedToReturnData = false
                    viewModelMock.loadData(showLoading: false)
                }
                
                it("should have table view without data") {
                    expect(tableProvider.cartProducts.isEmpty) == true
                    expect(tableProvider.totalPrice) == 0
                    expect(tableProvider.currency) == ""
                }
                
                it("should have correct rows count") {
                    expect(tableView.numberOfRows(inSection: 0)) == 0
                }
                
                it("should have header view height") {
                    expect(tableView.rectForHeader(inSection: 0).size.height) == tableProvider.cartHeaderViewHeight
                }
            }
            
            context("if data isn't empty") {
                beforeEach {
                    viewModelMock.isNeedToReturnData = true
                    viewModelMock.loadData(showLoading: false)
                }
                
                it("should have correct roes count") {
                    expect(tableView.numberOfRows(inSection: 0)) == 1
                }
                
                it("should have table view with data") {
                    expect(tableProvider.cartProducts.count) == 1
                    expect(tableProvider.totalPrice) == 50
                    expect(tableProvider.currency) == "Currency"
                }
                
                it("should have header view height") {
                    expect(tableView.rectForHeader(inSection: 0).size.height) == tableProvider.cartHeaderViewHeight
                }
            }
        }
        
        describe("when cart product quantity updated") {
            it("should update cart product quantity", closure: {
                _ = viewController.view
                
                let cartProduct = CartProduct()
                viewController.viewModel.data.value = [cartProduct]
                
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath) as! CartTableViewCell
                viewController.tableViewCell(cell, didUpdateCartProduct: cartProduct, with: 10)
                
                let item = viewController.viewModel.data.value.first
                expect(item?.quantity) == 10
                expect(viewModelMock.isUpdateCartProductStarted) == true
                expect(viewModelMock.isLoadDataStarted) == true
                
            })
        }
        
        describe("when delete cart product did press") {
            beforeEach {
                _ = viewController.view
                
                viewModelMock.isNeedToReturnData = true
                viewModelMock.loadData(showLoading: false)
            }
            
            it("should have correct delete action") {
                let indexPath = IndexPath(row: 0, section: 0)
                let action = viewController.tableView(tableView, editActionsForRowAt: indexPath, for: .right)?.first
                
                expect(action?.title) == "Button.Remove".localizable
                expect(action?.style) == .destructive
                expect(action?.backgroundColor) == TableView.removeActionBackgroundColor
                expect(action?.image) == #imageLiteral(resourceName: "trash")
                expect(action?.font) == TableView.removeActionFont
                expect(action?.textColor) == .black
                expect(action?.hidesWhenSelected) == true
                expect(action?.handler).toNot(beNil())
            }
        }
    }
}
