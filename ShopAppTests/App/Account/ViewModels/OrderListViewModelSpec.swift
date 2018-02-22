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
        
        var viewModel: OrdersListViewModel!
        
        beforeEach {
            viewModel = OrdersListViewModel(orderListUseCase: orderListUseCaseMock)
        }
        
        describe("when view model initialized") {
            it("should have variables with correct initial values") {
                expect(viewModel.items.value.isEmpty) == true
            }
        }
        
        describe("when first page loaded") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if not full page loaded") {
                it("should present loaded items") {
                    orderListUseCaseMock.isOrderCountLessThenConstant = true
                    viewModel.reloadData()
                    
                    viewModel.items.asObservable()
                        .subscribe(onNext: { orders in
                            expect(orders.count) != kItemsPerPage
                            expect(viewModel.paginationValue).to(beNil())
                            expect(viewModel.canLoadMore) == false
                        })
                        .disposed(by: disposeBag)
                }
            }
            
            context("if full page loaded") {
                it("should present loaded items") {
                    orderListUseCaseMock.isOrderCountLessThenConstant = false
                    viewModel.reloadData()
                    
                    viewModel.items.asObservable()
                        .subscribe(onNext: { orders in
                            expect(orders.count) == kItemsPerPage
                            expect(viewModel.paginationValue).to(beNil())
                            expect(viewModel.canLoadMore) == true
                        })
                        .disposed(by: disposeBag)
                }
            }
        }
        
        describe("when next page loaded") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            it("should present loaded items") {
                orderListUseCaseMock.isOrderCountLessThenConstant = false
                viewModel.reloadData()
                viewModel.loadNextPage()
                
                viewModel.items.asObservable()
                    .subscribe(onNext: { orders in
                        expect(orders.count) == kItemsPerPage * 2
                        expect(viewModel.paginationValue as? String) == "pagination value"
                    })
                    .disposed(by: disposeBag)
            }
        }
        
        describe("when try again pressed") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            it("should present loaded items") {
                orderListUseCaseMock.isOrderCountLessThenConstant = true
                viewModel.tryAgain()
                
                viewModel.items.asObservable()
                    .subscribe(onNext: { orders in
                        expect(orders.count) != kItemsPerPage
                        expect(viewModel.paginationValue).to(beNil())
                        expect(viewModel.canLoadMore) == false
                    })
                    .disposed(by: disposeBag)
            }
        }
        
        describe("when product details did press") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if product variant found") {
                it("should find correct product variant") {
                    orderListUseCaseMock.returnOrderWithVariant = true
                    viewModel.reloadData()
                    
                    viewModel.items.asObservable()
                        .subscribe(onNext: { _ in
                            let variant = viewModel.productVariant(with: "product variant id", at: 0)
                            expect(variant).toNot(beNil())
                        })
                        .disposed(by: disposeBag)
                }
            }
            
            context("if product variant not found") {
                it("should not find correct product variant") {
                    orderListUseCaseMock.returnOrderWithVariant = false
                    viewModel.reloadData()
                    
                    viewModel.items.asObservable()
                        .subscribe(onNext: { _ in
                            let variant = viewModel.productVariant(with: "product variant id", at: 0)
                            expect(variant).to(beNil())
                        })
                        .disposed(by: disposeBag)
                }
            }
        }
    }
}
