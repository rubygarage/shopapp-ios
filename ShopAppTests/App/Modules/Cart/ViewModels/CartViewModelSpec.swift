//
//  CartViewModelSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/7/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class CartViewModelSpec: QuickSpec {
    override func spec() {
        var cartProductsUseCaseMock: CartProductsUseCaseMock!
        var deleteCartProductUseCaseMock: DeleteCartProductUseCaseMock!
        var changeCartProductUseCaseMock: ChangeCartProductUseCaseMock!
        var viewModel: CartViewModel!
        
        beforeEach {
            let repositoryMock = CartRepositoryMock()
            cartProductsUseCaseMock = CartProductsUseCaseMock(repository: repositoryMock)
            deleteCartProductUseCaseMock = DeleteCartProductUseCaseMock(repository: repositoryMock)
            changeCartProductUseCaseMock = ChangeCartProductUseCaseMock(repository: repositoryMock)
            viewModel = CartViewModel(cartProductsUseCase: cartProductsUseCaseMock, deleteCartProductUseCase: deleteCartProductUseCaseMock, changeCartProductUseCase: changeCartProductUseCaseMock)
        }
        
        describe("when view model imitialized") {
            it("should have correct initial properties") {
                expect(viewModel.data.value.isEmpty) == true
            }
        }
        
        describe("when data loaded") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            
            beforeEach {
                disposeBag = DisposeBag()
                states = []
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
            }
            
            context("if data loaded successfully") {
                it("should load data") {
                    cartProductsUseCaseMock.isNeedToReturnError = false
                    cartProductsUseCaseMock.isNeedToReturnEmptyData = false
                    viewModel.loadData()
                    
                    expect(viewModel.data.value.count) == 1
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if data loaded successfully but have empty result") {
                it("should load data and show empty view") {
                    cartProductsUseCaseMock.isNeedToReturnError = false
                    cartProductsUseCaseMock.isNeedToReturnEmptyData = true
                    viewModel.loadData()
                    
                    expect(viewModel.data.value.count) == 0
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.empty
                }
            }
            
            context("if error occured") {
                it("should not load data") {
                    cartProductsUseCaseMock.isNeedToReturnError = true
                    viewModel.loadData()
                    
                    expect(viewModel.data.value.count) == 0
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
        
        describe("when card product removed") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            let cartProduct = TestHelper.cartProductWithQuantityOne
            
            beforeEach {
                disposeBag = DisposeBag()
                states = []
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
            }
            
            context("if cart product removed successfully") {
                it("should remove cart product") {
                    let secondCartProduct = TestHelper.cartProductWithQuantityTwo
                    viewModel.data.value = [cartProduct, secondCartProduct]
                    deleteCartProductUseCaseMock.isNeedToReturnError = false
                    viewModel.removeCardProduct(at: 0)
                    
                    let isContains = viewModel.data.value.contains(where: { $0 == cartProduct })
                    expect(isContains) == false
                    expect(viewModel.data.value.count) == 1
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if last cart product removed successfully") {
                it("should remove cart product and show empty view") {
                    viewModel.data.value = [cartProduct]
                    deleteCartProductUseCaseMock.isNeedToReturnError = false
                    viewModel.removeCardProduct(at: 0)
                    
                    let isContains = viewModel.data.value.contains(where: { $0 == cartProduct })
                    expect(isContains) == false
                    expect(viewModel.data.value.count) == 0
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.empty
                }
            }
            
            context("if cart product removing failed") {
                it("should have error") {
                    viewModel.data.value = [cartProduct, cartProduct]
                    deleteCartProductUseCaseMock.isNeedToReturnError = true
                    viewModel.removeCardProduct(at: 0)
                    
                    let isContains = viewModel.data.value.contains(where: { $0 == cartProduct })
                    expect(isContains) == true
                    expect(viewModel.data.value.count) == 2
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
        
        describe("when cart product updated") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            let cartProduct = TestHelper.cartProductWithQuantityOne
            
            beforeEach {
                viewModel.data.value = [cartProduct]
                disposeBag = DisposeBag()
                states = []
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
            }
            
            context("if cart product updated successfully") {
                it("should update cart product") {
                    changeCartProductUseCaseMock.isNeedToReturnError = false
                    cartProductsUseCaseMock.isNeedToReturnError = false
                    cartProductsUseCaseMock.isNeedToReturnQuantity = true
                    viewModel.update(cartProduct: cartProduct, quantity: 5)
                    
                    expect(viewModel.data.value.count) == 1
                    expect(viewModel.data.value.first?.quantity) == TestHelper.cartProductWithQuantityTwo.quantity
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if cart product updated but error occured during loading cart products") {
                it("should have error") {
                    changeCartProductUseCaseMock.isNeedToReturnError = false
                    cartProductsUseCaseMock.isNeedToReturnError = true
                    cartProductsUseCaseMock.isNeedToReturnQuantity = false
                    
                    viewModel.update(cartProduct: cartProduct, quantity: 5)
                    
                    expect(viewModel.data.value.count) == 1
                    expect(viewModel.data.value.first?.quantity) == cartProduct.quantity
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
            
            context("if cart product didn't update") {
                it("should have error") {
                    changeCartProductUseCaseMock.isNeedToReturnError = true
                    cartProductsUseCaseMock.isNeedToReturnError = true
                    cartProductsUseCaseMock.isNeedToReturnQuantity = false
                    
                    viewModel.update(cartProduct: cartProduct, quantity: 5)
                    
                    expect(viewModel.data.value.count) == 1
                    expect(viewModel.data.value.first?.quantity) == cartProduct.quantity
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
        
        describe("when total price calculated") {
            it("should calculate total price") {
                let cartProductFirst = TestHelper.cartProductWithQuantityOne
                let cartProductSecond = TestHelper.cartProductWithQuantityTwo
                
                viewModel.data.value = [cartProductFirst, cartProductSecond]
                let totalPrice = viewModel.calculateTotalPrice()
                
                expect(totalPrice) == 30 // 1 * 10 + 2 * 10
            }
        }
        
        describe("when try again pressed") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            
            beforeEach {
                disposeBag = DisposeBag()
                states = []
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
            }
            
            it("should load cart product items") {
                cartProductsUseCaseMock.isNeedToReturnError = false
                viewModel.tryAgain()
                
                expect(viewModel.data.value.count) == 1
                expect(states.count) == 2
                expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                expect(states.last) == ViewState.content
            }
        }
    }
}
