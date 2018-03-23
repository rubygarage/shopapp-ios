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
        var cartProductListUseCaseMock: CartProductListUseCaseMock!
        var deleteCartProductUseCaseMock: DeleteCartProductUseCaseMock!
        var changeCartProductUseCaseMock: ChangeCartProductUseCaseMock!
        var viewModel: CartViewModel!
        
        beforeEach {
            let repositoryMock = CartRepositoryMock()
            cartProductListUseCaseMock = CartProductListUseCaseMock(repository: repositoryMock)
            deleteCartProductUseCaseMock = DeleteCartProductUseCaseMock(repository: repositoryMock)
            changeCartProductUseCaseMock = ChangeCartProductUseCaseMock(repository: repositoryMock)
            viewModel = CartViewModel(cartProductListUseCase: cartProductListUseCaseMock, deleteCartProductUseCase: deleteCartProductUseCaseMock, changeCartProductUseCase: changeCartProductUseCaseMock)
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
                    cartProductListUseCaseMock.isNeedToReturnError = false
                    cartProductListUseCaseMock.isNeedToReturnEmptyData = false
                    viewModel.loadData()
                    
                    expect(viewModel.data.value.count) == 1
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if data loaded successfully but have empty result") {
                it("should load data and show empty view") {
                    cartProductListUseCaseMock.isNeedToReturnError = false
                    cartProductListUseCaseMock.isNeedToReturnEmptyData = true
                    viewModel.loadData()
                    
                    expect(viewModel.data.value.count) == 0
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.empty
                }
            }
            
            context("if error occured") {
                it("should not load data") {
                    cartProductListUseCaseMock.isNeedToReturnError = true
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
            let cartProduct = CartProduct()
            
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
                    viewModel.data.value = [cartProduct, CartProduct()]
                    deleteCartProductUseCaseMock.isNeedToReturnError = false
                    viewModel.removeCardProduct(at: 0)
                    
                    let isContains = viewModel.data.value.contains(where: { $0 === cartProduct })
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
                    
                    let isContains = viewModel.data.value.contains(where: { $0 === cartProduct })
                    expect(isContains) == false
                    expect(viewModel.data.value.count) == 0
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.empty
                }
            }
            
            context("if cart product removing failed") {
                it("should have error") {
                    viewModel.data.value = [cartProduct, CartProduct()]
                    deleteCartProductUseCaseMock.isNeedToReturnError = true
                    viewModel.removeCardProduct(at: 0)
                    
                    let isContains = viewModel.data.value.contains(where: { $0 === cartProduct })
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
            let cartProduct = CartProduct()
            
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
                    cartProductListUseCaseMock.isNeedToReturnError = false
                    cartProductListUseCaseMock.isNeedToReturnQuantity = true
                    viewModel.update(cartProduct: cartProduct, quantity: 5)
                    
                    expect(viewModel.data.value.count) == 1
                    expect(viewModel.data.value.first?.quantity) == 5
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if cart product updated but error occured during loading cart products") {
                it("should have error") {
                    changeCartProductUseCaseMock.isNeedToReturnError = false
                    cartProductListUseCaseMock.isNeedToReturnError = true
                    cartProductListUseCaseMock.isNeedToReturnQuantity = false
                    
                    viewModel.update(cartProduct: cartProduct, quantity: 5)
                    
                    expect(viewModel.data.value.count) == 1
                    expect(viewModel.data.value.first?.quantity) == 0
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
            
            context("if cart product didn't update") {
                it("should have error") {
                    changeCartProductUseCaseMock.isNeedToReturnError = true
                    cartProductListUseCaseMock.isNeedToReturnError = true
                    cartProductListUseCaseMock.isNeedToReturnQuantity = false
                    
                    viewModel.update(cartProduct: cartProduct, quantity: 5)
                    
                    expect(viewModel.data.value.count) == 1
                    expect(viewModel.data.value.first?.quantity) == 0
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
        
        describe("when total price calculated") {
            var cartProductFirst: CartProduct!
            var cartProductSecond: CartProduct!
            
            beforeEach {
                cartProductFirst = CartProduct()
                cartProductFirst.quantity = 5
                
                let productVariantFirst = ProductVariant()
                productVariantFirst.price = Decimal(floatLiteral: 10)
                cartProductFirst.productVariant = productVariantFirst
                
                cartProductSecond = CartProduct()
                cartProductSecond.quantity = 10
                
                let productVariantSecond = ProductVariant()
                productVariantSecond.price = Decimal(floatLiteral: 15)
                cartProductSecond.productVariant = productVariantSecond
            }
            
            it("should calculate total price") {
                viewModel.data.value = [cartProductFirst, cartProductSecond]
                let totalPrice = viewModel.calculateTotalPrice()
                
                expect(totalPrice) == 200 // 5 * 10 + 10 * 15
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
                cartProductListUseCaseMock.isNeedToReturnError = false
                viewModel.tryAgain()
                
                expect(viewModel.data.value.count) == 1
                expect(states.count) == 2
                expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                expect(states.last) == ViewState.content
            }
        }
    }
}
