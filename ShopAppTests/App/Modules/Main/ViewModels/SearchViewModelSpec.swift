//
//  SearchViewModelSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/15/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift

@testable import ShopApp

class SearchViewModelSpec: QuickSpec {
    override func spec() {
        let repositoryMock = ProductRepositoryMock()
        let productsUseCaseMock = ProductsUseCaseMock(repository: repositoryMock)
        
        var viewModel: SearchViewModel!
        
        beforeEach {
            viewModel = SearchViewModel(productsUseCase: productsUseCaseMock)
        }
        
        describe("when view model initialized") {
            it("should have a correct superclass") {
                expect(viewModel).to(beAKindOf(GridCollectionViewModel.self))
            }
            
            it("should have variables with correct initial values") {
                expect(viewModel.searchPhrase.value) == ""
            }
        }
        
        describe("when first page loaded") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            
            beforeEach {
                disposeBag = DisposeBag()
                states = []
                
                productsUseCaseMock.isNeedToReturnEmptyProductList = false
                productsUseCaseMock.isNeedToReturnError = false
                viewModel.searchPhrase.value = "phrase"
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
            }
            
            context("if search phrase is empty") {
                it("needs to clear previous result") {
                    viewModel.searchPhrase.value = ""
                    viewModel.reloadData()
                    
                    expect(viewModel.products.value.isEmpty) == true
                    expect(viewModel.paginationValue).to(beNil())
                    expect(viewModel.canLoadMore) == true
                    expect(states.count) == 1
                    expect(states.first) == ViewState.content
                }
            }
            
            context("if not items in loaded page") {
                it("should present empty view") {
                    productsUseCaseMock.isNeedToReturnEmptyProductList = true
                    viewModel.reloadData()
                    
                    expect(viewModel.products.value.isEmpty) == true
                    expect(viewModel.paginationValue).to(beNil())
                    expect(viewModel.canLoadMore) == false
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.empty
                }
            }
            
            context("if not full page loaded") {
                it("should present loaded items") {
                    productsUseCaseMock.isProductCountLessThenConstant = true
                    viewModel.reloadData()
                    
                    expect(viewModel.products.value.count) != kItemsPerPage
                    expect(viewModel.paginationValue).to(beNil())
                    expect(viewModel.canLoadMore) == false
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if full page loaded") {
                it("should present loaded items") {
                    productsUseCaseMock.isProductCountLessThenConstant = false
                    viewModel.reloadData()
                    
                    expect(viewModel.products.value.count) == kItemsPerPage
                    expect(viewModel.paginationValue).to(beNil())
                    expect(viewModel.canLoadMore) == true
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if error did occured") {
                it("should not present items") {
                    productsUseCaseMock.isNeedToReturnError = true
                    viewModel.reloadData()
                    
                    expect(viewModel.products.value.count) == 0
                    expect(viewModel.paginationValue).to(beNil())
                    expect(viewModel.canLoadMore) == false
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
        
        describe("when next page loaded") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            
            beforeEach {
                disposeBag = DisposeBag()
                states = []
                
                productsUseCaseMock.isNeedToReturnEmptyProductList = false
                productsUseCaseMock.isProductCountLessThenConstant = false
                productsUseCaseMock.isNeedToReturnError = false
                viewModel.searchPhrase.value = "phrase"
            }
            
            context("if data loaded successfully") {
                it("should present loaded items") {
                    viewModel.reloadData()
                    
                    viewModel.state
                        .subscribe(onNext: { state in
                            states.append(state)
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.loadNextPage()
                    
                    expect(viewModel.products.value.count) == kItemsPerPage * 2
                    expect(viewModel.paginationValue as? String) == "pagination value"
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if error did occured") {
                it("should load first page and have error during loading next page") {
                    productsUseCaseMock.isNeedToReturnError = false
                    viewModel.reloadData()
                    
                    viewModel.state
                        .subscribe(onNext: { state in
                            states.append(state)
                        })
                        .disposed(by: disposeBag)
                    
                    productsUseCaseMock.isNeedToReturnError = true
                    viewModel.loadNextPage()
                    
                    expect(viewModel.products.value.count) == kItemsPerPage
                    expect(viewModel.paginationValue as? String) == "pagination value"
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
        
        describe("when result cleared") {
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
            
            it("needs to remove all products") {
                viewModel.clearResult()
                
                expect(viewModel.products.value.isEmpty) == true
                expect(states.count) == 1
                expect(states.first) == ViewState.content
            }
        }
        
        describe("when try again pressed") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            
            beforeEach {
                disposeBag = DisposeBag()
                states = []
                
                productsUseCaseMock.isNeedToReturnEmptyProductList = false
                productsUseCaseMock.isProductCountLessThenConstant = true
                productsUseCaseMock.isNeedToReturnError = false
                viewModel.searchPhrase.value = "phrase"
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
            }
            
            context("if data loaded successfully") {
                it("should present loaded items") {
                    viewModel.tryAgain()
                    
                    expect(viewModel.products.value.count) != kItemsPerPage
                    expect(viewModel.paginationValue).to(beNil())
                    expect(viewModel.canLoadMore) == false
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if error did occured") {
                it("should not present items") {
                    productsUseCaseMock.isNeedToReturnError = true
                    viewModel.tryAgain()
                    
                    expect(viewModel.products.value.count) == 0
                    expect(viewModel.paginationValue).to(beNil())
                    expect(viewModel.canLoadMore) == false
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
    }
}
