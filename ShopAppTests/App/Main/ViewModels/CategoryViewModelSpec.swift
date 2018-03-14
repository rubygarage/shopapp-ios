//
//  CategoryViewModelSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class CategoryViewModelSpec: QuickSpec {
    override func spec() {
        let repository = CategoryRepositoryMock()
        let categoryUseCaseMock = CategoryUseCaseMock(repository: repository)
        
        var viewModel: CategoryViewModel!
        
        beforeEach {
            viewModel = CategoryViewModel(categoryUseCase: categoryUseCaseMock)
        }
        
        describe("when view model initialized") {
            it("should have a correct superclass") {
                expect(viewModel).to(beAKindOf(GridCollectionViewModel.self))
            }
            
            it("should have correct initial values") {
                expect(viewModel.categoryId).to(beNil())
                expect(viewModel.selectedSortingValue.rawValue) == SortingValue.name.rawValue
            }
        }
        
        describe("when first page loaded") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            
            beforeEach {
                disposeBag = DisposeBag()
                states = []
                viewModel.categoryId = "id"
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
            }
            
            context("if not full page loaded") {
                it("should present loaded items") {
                    categoryUseCaseMock.isProductCountLessThenConstant = true
                    categoryUseCaseMock.isNeedToReturnError = false
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
                    categoryUseCaseMock.isProductCountLessThenConstant = false
                    categoryUseCaseMock.isNeedToReturnError = false
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
                    categoryUseCaseMock.isNeedToReturnError = true
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
                viewModel.categoryId = "id"
            }
            
            context("if data loaded successfully") {
                it("should present loaded items") {
                    categoryUseCaseMock.isProductCountLessThenConstant = false
                    categoryUseCaseMock.isNeedToReturnError = false
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
                    categoryUseCaseMock.isProductCountLessThenConstant = false
                    categoryUseCaseMock.isNeedToReturnError = false
                    viewModel.reloadData()
                    
                    viewModel.state
                        .subscribe(onNext: { state in
                            states.append(state)
                        })
                        .disposed(by: disposeBag)
                    
                    categoryUseCaseMock.isNeedToReturnError = true
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
            it("needs to remove all products") {
                viewModel.clearResult()
                
                expect(viewModel.products.value.isEmpty) == true
            }
        }
        
        describe("when try again pressed") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            
            beforeEach {
                disposeBag = DisposeBag()
                states = []
                viewModel.categoryId = "id"
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
            }
            
            context("if data loaded successfully") {
                it("should present loaded items") {
                    categoryUseCaseMock.isProductCountLessThenConstant = true
                    categoryUseCaseMock.isNeedToReturnError = false
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
                    categoryUseCaseMock.isNeedToReturnError = true
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
