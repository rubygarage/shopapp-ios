//
//  ProductDetailsViewModelSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class ProductDetailsViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: ProductDetailsViewModel!
        var addCartProductUseCaseMock: AddCartProductUseCaseMock!
        var productUseCaseMock: ProductUseCaseMock!
        var productsUseCaseMock: ProductsUseCaseMock!
        
        beforeEach {
            let cartRepositoryMock = CartRepositoryMock()
            addCartProductUseCaseMock = AddCartProductUseCaseMock(repository: cartRepositoryMock)
            
            let productRepositoryMock = ProductRepositoryMock()
            productUseCaseMock = ProductUseCaseMock(repository: productRepositoryMock)
            productsUseCaseMock = ProductsUseCaseMock(repository: productRepositoryMock)
            
            viewModel = ProductDetailsViewModel(addCartProductUseCase: addCartProductUseCaseMock, productUseCase: productUseCaseMock, productsUseCase: productsUseCaseMock)
        }
        
        describe("when view model initialized") {
            it("should have correct superclass") {
                expect(viewModel).to(beAKindOf(BaseViewModel.self))
            }
            
            it("should have correct initial values") {
                expect(viewModel.productId).to(beNil())
                expect(viewModel.product.value).to(beNil())
                expect(viewModel.relatedItems.value.isEmpty) == true
                expect(viewModel.quantity.value) == 1
                expect(viewModel.currency).to(beNil())
            }
        }
        
        describe("when data loaded") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            var product: Product!
            
            beforeEach {
                viewModel.productId = "Product id"
                
                disposeBag = DisposeBag()
                states = []
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
            }
            
            context("if data loaded successfully") {
                beforeEach {
                    product = TestHelper.productWithoutAlternativePrice
                }
                
                context("and products hasn't options and variants") {
                    beforeEach {
                        productUseCaseMock.returnedValue = product
                        productUseCaseMock.isNeedToReturnError = false
                        productsUseCaseMock.isNeedToReturnError = false
                    }
                    
                    it("should load product and related products") {
                        viewModel.loadData()
                        
                        expect(viewModel.currency) == product.currency
                        expect(viewModel.product.value).toNot(beNil())
                        expect(viewModel.relatedItems.value.isEmpty) == false
                        expect(states.count) == 2
                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                        expect(states.last) == ViewState.content
                    }
                }
                
                context("if product has options and variants and selected options") {
                    beforeEach {
                        viewModel.productVariant = TestHelper.productVariantWithoutSelectedOptions
                        
                        productUseCaseMock.returnedValue = product
                        productUseCaseMock.isNeedToReturnError = false
                        productsUseCaseMock.isNeedToReturnError = false
                    }
                    
                    it("should load product and related products") {
                        viewModel.loadData()
                        
                        expect(viewModel.currency) == product.currency
                        expect(viewModel.product.value).toNot(beNil())
                        expect(viewModel.relatedItems.value.isEmpty) == false
                        expect(states.count) == 2
                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                        expect(states.last) == ViewState.content
                    }
                }
                
                context("if product has options and variants without selected options") {
                    beforeEach {
                        viewModel.productVariant = TestHelper.productVariantWithoutSelectedOptions

                        productUseCaseMock.returnedValue = product
                        productUseCaseMock.isNeedToReturnError = false
                        productsUseCaseMock.isNeedToReturnError = false
                    }
                    
                    it("should load product and related products") {
                        viewModel.loadData()
                        
                        expect(viewModel.currency) == product.currency
                        expect(viewModel.product.value).toNot(beNil())
                        expect(viewModel.relatedItems.value.isEmpty) == false
                        expect(states.count) == 2
                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                        expect(states.last) == ViewState.content
                    }
                }
            }
            
            context("if error occured") {
                context("if product loaded successfully, but load related items failed") {
                    beforeEach {
                        productUseCaseMock.returnedValue = product
                        productUseCaseMock.isNeedToReturnError = false
                        productsUseCaseMock.isNeedToReturnError = true
                    }
                    
                    it("should load product but shouldn't load related items") {
                        viewModel.loadData()
                        
                        expect(viewModel.currency) == product.currency
                        expect(viewModel.product.value).toNot(beNil())
                        expect(viewModel.relatedItems.value.isEmpty) == true
                        expect(states.count) == 2
                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                        expect(states.last) == ViewState.error(error: nil)
                    }
                }
                
                context("and if product loaded with error") {
                    beforeEach {
                        productUseCaseMock.isNeedToReturnError = true
                        productsUseCaseMock.isNeedToReturnError = false
                    }
                    
                    it("shouldn't load product and related items") {
                        viewModel.loadData()
                        
                        expect(viewModel.currency).to(beNil())
                        expect(viewModel.product.value).to(beNil())
                        expect(viewModel.relatedItems.value.isEmpty) == true
                        expect(states.count) == 2
                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                        expect(states.last) == ViewState.error(error: nil)
                    }
                }
            }
        }
        
        describe("when product added to cart") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if product doesn't exist") {
                beforeEach {
                    addCartProductUseCaseMock.isNeedToReturnError = true
                }
                
                it("shouldn't add product to cart") {
                    viewModel.addToCart
                        .subscribe(onNext: { success in
                            expect(success).toEventually(beFalse())
                        })
                        .disposed(by: disposeBag)
                }
            }
            
            context("if product exist") {
                var product: Product!
                
                beforeEach {
                    product = TestHelper.productWithoutAlternativePrice
                    
                    viewModel.productId = product.id
                    viewModel.product.value = product
                    viewModel.quantity.value = 5
                }
                
                context("and added successfully") {
                    beforeEach {
                        productUseCaseMock.returnedValue = product
                        addCartProductUseCaseMock.isNeedToReturnError = false
                    }
                    
                    it("should add product to cart") {
                        viewModel.loadData()
                        
                        viewModel.addToCart
                            .subscribe(onNext: { success in
                                expect(success).toEventually(beTrue())
                            })
                            .disposed(by: disposeBag)
                    }
                }
                
                context("or error occured") {
                    beforeEach {
                        addCartProductUseCaseMock.isNeedToReturnError = true
                    }
                    
                    it("shouldn't add product to cart") {
                        viewModel.loadData()
                        
                        viewModel.addToCart
                            .subscribe(onNext: { success in
                                expect(success).toEventually(beFalse())
                            })
                            .disposed(by: disposeBag)
                    }
                }
            }
        }
        
        describe("when option did select") {
            var product: Product!
            var productOption: ProductOption!
            var disposeBag: DisposeBag!
            
            beforeEach {
                product = TestHelper.productWithoutAlternativePrice
                productOption = product.options.first!
                
                viewModel.productId = product.id
                viewModel.quantity.value = 5
                viewModel.product.value = product
                
                productUseCaseMock.isNeedToReturnError = false
                productUseCaseMock.returnedValue = product
                
                disposeBag = DisposeBag()
            }
            
            it("should select option") {
                viewModel.loadData()
                
                viewModel.selectedVariant
                    .subscribe(onNext: { variant in
                        expect(variant.selectedOptions.first?.name) == productOption.name
                        expect(variant.selectedOptions.first?.value) == productOption.values.first
                    })
                    .disposed(by: disposeBag)
                
                viewModel.selectOption(TestHelper.variantOption)
            }
        }
        
        describe("when try again did press") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            var product: Product!
            
            beforeEach {
                disposeBag = DisposeBag()
                states = []
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
                
                viewModel.productId = "Product id"
                
                product = TestHelper.productWithoutAlternativePrice
                
                productUseCaseMock.isNeedToReturnError = false
                productUseCaseMock.returnedValue = product
            }
            
            it("should start load data") {
                viewModel.tryAgain()
                
                expect(viewModel.product.value) == product
                expect(states.count) == 2
                expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                expect(states.last) == ViewState.content
            }
        }
    }
}
