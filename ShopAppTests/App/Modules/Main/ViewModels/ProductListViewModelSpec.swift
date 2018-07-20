//
//  ProductListViewModelSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class ProductListViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: ProductListViewModel!
        var productsUseCase: ProductsUseCaseMock!
        
        beforeEach {
            let productRepositoryMock = ProductRepositoryMock()
            productsUseCase = ProductsUseCaseMock(repository: productRepositoryMock)
            viewModel = ProductListViewModel(productsUseCase: productsUseCase)
        }
        
        describe("when view model initialized") {
            it("should have correct super class") {
                expect(viewModel).to(beAKindOf(GridCollectionViewModel.self))
            }
            
            it("should have correct initial values") {
                expect(viewModel.sortType).to(beNil())
                expect(viewModel.keyword).to(beNil())
                expect(viewModel.excludeKeyword).to(beNil())
            }
        }
        
        describe("when data loaded") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            
            beforeEach {
                viewModel.sortType = .recent
                
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
                    productsUseCase.isNeedToReturnError = false
                }
                
                it("should load data") {
                    viewModel.reloadData()
                    
                    expect(viewModel.products.value.isEmpty) == false
                    expect(viewModel.paginationValue).to(beNil())
                    expect(viewModel.canLoadMore) == false
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if error did occured") {
                beforeEach {
                    productsUseCase.isNeedToReturnError = true
                }
                
                it("shouldn't load data") {
                    viewModel.reloadData()
                    
                    expect(viewModel.products.value.isEmpty) == true
                    expect(viewModel.paginationValue).to(beNil())
                    expect(viewModel.canLoadMore) == false
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
        
        describe("when loaded next page") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            
            beforeEach {
                viewModel.sortType = .recent
                viewModel.products.value = [TestHelper.productWithoutAlternativePrice]
                
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
                    productsUseCase.isNeedToReturnError = false
                }
                
                it("should load data") {
                    viewModel.loadNextPage()
                    
                    expect(viewModel.products.value.isEmpty) == false
                    expect(viewModel.paginationValue as? String) == TestHelper.productWithoutAlternativePrice.paginationValue
                    expect(viewModel.canLoadMore) == false
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if error did occured") {
                beforeEach {
                    productsUseCase.isNeedToReturnError = true
                }
                
                it("shouldn't load data") {
                    viewModel.loadNextPage()
                    
                    expect(viewModel.products.value.count) == 1
                    expect(viewModel.paginationValue as? String) == TestHelper.productWithoutAlternativePrice.paginationValue
                    expect(viewModel.canLoadMore) == false
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
        
        describe("when try again did press") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            
            beforeEach {
                viewModel.sortType = .recent
                
                disposeBag = DisposeBag()
                states = []
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
            }
            
            it("should load data") {
                productsUseCase.isNeedToReturnError = false
                viewModel.tryAgain()
                
                expect(viewModel.products.value.isEmpty) == false
                expect(viewModel.paginationValue).to(beNil())
                expect(viewModel.canLoadMore) == false
                expect(states.count) == 2
                expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                expect(states.last) == ViewState.content
            }
        }
    }
}
