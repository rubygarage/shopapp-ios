//
//  OrderListViewModelSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift

@testable import ShopApp

class OrderListViewModelSpec: QuickSpec {
    override func spec() {
        let repository = OrderRepositoryMock()
        let orderListUseCaseMock = OrderListUseCaseMock(repository: repository)
        
        var viewModel: OrderListViewModel!
        
        beforeEach {
            viewModel = OrderListViewModel(orderListUseCase: orderListUseCaseMock)
        }
        
        describe("when view model initialized") {
            it("should have a correct superclass") {
                expect(viewModel).to(beAKindOf(BasePaginationViewModel.self))
            }
            
            it("should have variables with correct initial values") {
                expect(viewModel.items.value.isEmpty) == true
            }
        }
        
        describe("when first page loaded") {
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
            
            context("if not full page loaded") {
                it("should present loaded items") {
                    orderListUseCaseMock.isOrderCountLessThenConstant = true
                    orderListUseCaseMock.isNeedToReturnError = false
                    viewModel.reloadData()
                    
                    expect(viewModel.items.value.count) != kItemsPerPage
                    expect(viewModel.paginationValue).to(beNil())
                    expect(viewModel.canLoadMore) == false
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if full page loaded") {
                it("should present loaded items") {
                    orderListUseCaseMock.isOrderCountLessThenConstant = false
                    orderListUseCaseMock.isNeedToReturnError = false
                    viewModel.reloadData()
                    
                    expect(viewModel.items.value.count) == kItemsPerPage
                    expect(viewModel.paginationValue).to(beNil())
                    expect(viewModel.canLoadMore) == true
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("but error did occured") {
                it("should not load items") {
                    orderListUseCaseMock.isNeedToReturnError = true
                    viewModel.reloadData()
                    
                    expect(viewModel.items.value.count) == 0
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
            }
            
            context("if data loaded successfully") {
                it("should present loaded items") {
                    orderListUseCaseMock.isOrderCountLessThenConstant = false
                    orderListUseCaseMock.isNeedToReturnError = false
                    viewModel.reloadData()
                    
                    viewModel.state
                        .subscribe(onNext: { state in
                            states.append(state)
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.loadNextPage()
                    
                    expect(viewModel.items.value.count) == kItemsPerPage * 2
                    expect(viewModel.paginationValue as? String) == "pagination value"
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if error did occured") {
                it("should not load any items") {
                    orderListUseCaseMock.isNeedToReturnError = true
                    viewModel.reloadData()
                    
                    viewModel.state
                        .subscribe(onNext: { state in
                            states.append(state)
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.loadNextPage()
                    
                    expect(viewModel.items.value.count) == 0
                    expect(viewModel.paginationValue).to(beNil())
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
                
                it("should load first page and have error during loading next page") {
                    orderListUseCaseMock.isNeedToReturnError = false
                    viewModel.reloadData()
                    
                    viewModel.state
                        .subscribe(onNext: { state in
                            states.append(state)
                        })
                        .disposed(by: disposeBag)
                    
                    orderListUseCaseMock.isNeedToReturnError = true
                    viewModel.loadNextPage()
                    
                    expect(viewModel.items.value.count) == kItemsPerPage
                    expect(viewModel.paginationValue as? String) == "pagination value"
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
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
            
            it("should present loaded items") {
                orderListUseCaseMock.isOrderCountLessThenConstant = true
                orderListUseCaseMock.isNeedToReturnError = false
                viewModel.tryAgain()
                
                expect(viewModel.items.value.count) != kItemsPerPage
                expect(viewModel.paginationValue).to(beNil())
                expect(viewModel.canLoadMore) == false
                expect(states.count) == 2
                expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                expect(states.last) == ViewState.content
            }
            
            it("should error did occured") {
                orderListUseCaseMock.isNeedToReturnError = true
                
                viewModel.tryAgain()
                
                expect(viewModel.items.value.count) == 0
                expect(viewModel.paginationValue).to(beNil())
                expect(viewModel.canLoadMore) == false
                expect(states.count) == 2
                expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                expect(states.last) == ViewState.error(error: nil)
            }
        }
        
        describe("when product details did press") {
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
            
            context("if product variant found") {
                it("should find correct product variant") {
                    orderListUseCaseMock.isNeedToReturnOrderWithVariant = true
                    orderListUseCaseMock.isNeedToReturnError = false
                    viewModel.reloadData()
                    
                    let variant = viewModel.productVariant(with: "product variant id", at: 0)
                    expect(variant).toNot(beNil())
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if product variant not found") {
                it("should not find correct product variant") {
                    orderListUseCaseMock.isNeedToReturnOrderWithVariant = false
                    orderListUseCaseMock.isNeedToReturnError = false
                    viewModel.reloadData()
                    
                    let variant = viewModel.productVariant(with: "product variant id", at: 0)
                    expect(variant).to(beNil())
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("but error did occured") {
                it("should have error") {
                    orderListUseCaseMock.isNeedToReturnError = true
                    viewModel.reloadData()
                    
                    expect(viewModel.items.value.count) == 0
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
    }
}
