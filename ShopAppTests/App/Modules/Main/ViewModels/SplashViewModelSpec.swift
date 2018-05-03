//
//  SplashViewModelSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 4/25/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift

@testable import ShopApp

class SplashViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: SplashViewModel!
        var cartProductListUseCaseMock: CartProductListUseCaseMock!
        var cartValidationUseCaseMock: CartValidationUseCaseMock!
        var deleteCartProductUseCaseMock: DeleteCartProductUseCaseMock!
        
        beforeEach {
            let cartRepositoryMock = CartRepositoryMock()
            cartProductListUseCaseMock = CartProductListUseCaseMock(repository: cartRepositoryMock)
            deleteCartProductUseCaseMock = DeleteCartProductUseCaseMock(repository: cartRepositoryMock)
            
            let productRepositoryMock = ProductRepositoryMock()
            cartValidationUseCaseMock = CartValidationUseCaseMock(repository: productRepositoryMock)
            
            viewModel = SplashViewModel(cartProductListUseCase: cartProductListUseCaseMock, cartValidationUseCase: cartValidationUseCaseMock, deleteCartProductUseCase: deleteCartProductUseCaseMock)
        }
        
        describe("when view model initialized") {
            it("should have correct superclass") {
                expect(viewModel).to(beAKindOf(BaseViewModel.self))
            }
        }
        
        describe("when data loaded") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if data loaded succesfully") {
                it("should notify about finish loading") {
                    cartProductListUseCaseMock.isNeedToReturnError = false
                    cartValidationUseCaseMock.isNeedToReturnError = false
                    deleteCartProductUseCaseMock.isNeedToReturnError = false
                    
                    viewModel.dataLoaded
                        .subscribe(onNext: { event in
                            expect(event).toNotEventually(beNil())
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.loadData()
                }
            }
            
            context("if error occured") {
                context("during 'get cart product list' step") {
                    it("should notify about finish loading") {
                        cartProductListUseCaseMock.isNeedToReturnError = true
                        cartValidationUseCaseMock.isNeedToReturnError = false
                        deleteCartProductUseCaseMock.isNeedToReturnError = false
                        
                        viewModel.dataLoaded
                            .subscribe(onNext: { event in
                                expect(event).toNotEventually(beNil())
                            })
                            .disposed(by: disposeBag)
                        
                        viewModel.loadData()
                    }
                }
                
                context("during 'get product variant list' step") {
                    it("should notify about finish loading") {
                        cartProductListUseCaseMock.isNeedToReturnError = false
                        cartValidationUseCaseMock.isNeedToReturnError = true
                        deleteCartProductUseCaseMock.isNeedToReturnError = false
                        
                        viewModel.dataLoaded
                            .subscribe(onNext: { event in
                                expect(event).toNotEventually(beNil())
                            })
                            .disposed(by: disposeBag)
                        
                        viewModel.loadData()
                    }
                }
                
                context("during 'delete products from cart' step ") {
                    it("should notify about finish loading") {
                        cartProductListUseCaseMock.isNeedToReturnError = false
                        cartValidationUseCaseMock.isNeedToReturnError = false
                        deleteCartProductUseCaseMock.isNeedToReturnError = true
                        
                        viewModel.dataLoaded
                            .subscribe(onNext: { event in
                                expect(event).toNotEventually(beNil())
                            })
                            .disposed(by: disposeBag)
                        
                        viewModel.loadData()
                    }
                }
            }
        }
        
        describe("when try again did press") {
            it("should start data loading") {
                let disposeBag = DisposeBag()
                
                cartProductListUseCaseMock.isNeedToReturnError = false
                cartValidationUseCaseMock.isNeedToReturnError = false
                deleteCartProductUseCaseMock.isNeedToReturnError = false
                
                viewModel.dataLoaded
                    .subscribe(onNext: { event in
                        expect(event).toNotEventually(beNil())
                    })
                .disposed(by: disposeBag)
                
                viewModel.tryAgain()
            }
        }
    }
}
