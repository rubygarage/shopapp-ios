//
//  HomeViewModelSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class HomeViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: HomeViewModel!
        var articleListUseCaseMock: ArticleListUseCaseMock!
        var productListUseCaseMock: ProductListUseCaseMock!
        
        beforeEach {
            let articleRepositoryMock = ArticleRepositoryMock()
            articleListUseCaseMock = ArticleListUseCaseMock(repository: articleRepositoryMock)
            let productRepositoryMock = ProductRepositoryMock()
            productListUseCaseMock = ProductListUseCaseMock(repository: productRepositoryMock)
            viewModel = HomeViewModel(articleListUseCase: articleListUseCaseMock, productListUseCase: productListUseCaseMock)
        }
        
        describe("when view initialized") {
            it("should have correct superclass") {
                expect(viewModel).to(beAKindOf(BasePaginationViewModel.self))
            }
            
            it("should have correct properties") {
                expect(viewModel.canLoadMore) == false
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
            
            context("if all data loaded successfully") {
                it("should load data successfully", closure: {
                    productListUseCaseMock.isNeedToReturnError = false
                    articleListUseCaseMock.isNeedToReturnError = false
                    articleListUseCaseMock.isArticleCountLessThenConstant = false
                    viewModel.loadData()
                    
                    expect(viewModel.data.value.latestProducts.count) == 1
                    expect(viewModel.data.value.popularProducts.count) == 1
                    expect(viewModel.data.value.articles.count) == 10
                    
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                })
            }
            
            context("if all data loaded with error") {
                it("shouldn't load data") {
                    productListUseCaseMock.isNeedToReturnError = true
                    articleListUseCaseMock.isNeedToReturnError = true
                    viewModel.loadData()
                    
                    expect(viewModel.data.value.latestProducts.count) == 0
                    expect(viewModel.data.value.popularProducts.count) == 0
                    expect(viewModel.data.value.articles.count) == 0
                    
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
            
            context("if products loaded successfully but articles loaded with error") {
                it("shouldn't load data") {
                    productListUseCaseMock.isNeedToReturnError = false
                    articleListUseCaseMock.isNeedToReturnError = true
                    viewModel.loadData()
                    
                    expect(viewModel.data.value.latestProducts.count) == 0
                    expect(viewModel.data.value.popularProducts.count) == 0
                    expect(viewModel.data.value.articles.count) == 0
                    
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
            
            context("if articles loaded successfully but products loaded with error") {
                it("shouldn't load data") {
                    productListUseCaseMock.isNeedToReturnError = true
                    articleListUseCaseMock.isNeedToReturnError = false
                    viewModel.loadData()
                    
                    expect(viewModel.data.value.latestProducts.count) == 0
                    expect(viewModel.data.value.popularProducts.count) == 0
                    expect(viewModel.data.value.articles.count) == 0
                    
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
                disposeBag = DisposeBag()
                states = []
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
            }
            
            it("should load data") {
                productListUseCaseMock.isNeedToReturnError = false
                articleListUseCaseMock.isNeedToReturnError = false
                articleListUseCaseMock.isArticleCountLessThenConstant = true
                viewModel.loadData()
                
                expect(viewModel.data.value.latestProducts.count) == 1
                expect(viewModel.data.value.popularProducts.count) == 1
                expect(viewModel.data.value.articles.count) == 5
                
                expect(states.count) == 2
                expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                expect(states.last) == ViewState.content
            }
        }
    }
}
