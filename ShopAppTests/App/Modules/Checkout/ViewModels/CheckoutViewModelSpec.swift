//
//  CheckoutViewModelSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class CheckoutViewModelSpec: QuickSpec {
    override func spec() {
        var viewModel: CheckoutViewModel!
        var checkoutUseCaseMock: CheckoutUseCaseMock!
        var cartProductListUseCaseMock: CartProductsUseCaseMock!
        var deleteCartProductsUseCase: DeleteCartProductsUseCase!
        var customerUseCaseMock: CustomerUseCaseMock!
        var signInUseCaseMock: SignInUseCaseMock!
        
        beforeEach {
            let paymentRepositoryMock = PaymentRepositoryMock()
            checkoutUseCaseMock = CheckoutUseCaseMock(repository: paymentRepositoryMock)
            
            let cartRepositoryMock = CartRepositoryMock()
            cartProductListUseCaseMock = CartProductsUseCaseMock(repository: cartRepositoryMock)
            deleteCartProductsUseCase = DeleteCartProductsUseCase(repository: cartRepositoryMock)
            
            let customerRepositoryMock = CustomerRepositoryMock()
            customerUseCaseMock = CustomerUseCaseMock(repository: customerRepositoryMock)
            
            let authentificationRepositoryMock = AuthentificationRepositoryMock()
            signInUseCaseMock = SignInUseCaseMock(repository: authentificationRepositoryMock)
            
            viewModel = CheckoutViewModel(checkoutUseCase: checkoutUseCaseMock, cartProductsUseCase: cartProductListUseCaseMock, deleteCartProductsUseCase: deleteCartProductsUseCase, customerUseCase: customerUseCaseMock, signInUseCase: signInUseCaseMock)
        }
        
        describe("when view model initialized") {
            it("should have a correct superclass") {
                expect(viewModel).to(beAKindOf(BaseViewModel.self))
            }
        }
        
        describe("when place order called") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            
            beforeEach {
                viewModel.checkout.value = TestHelper.checkoutWithShippingAddress
                viewModel.creditCard.value = TestHelper.card
                viewModel.billingAddress.value = TestHelper.fullAddress
                
                disposeBag = DisposeBag()
                states = []
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
            }
            
            context("if selected type is credit card") {
                beforeEach {
                    viewModel.selectedType.value = .creditCard
                }
                
                context("and response success") {
                    it("should start pay by credit card") {
                        let order = TestHelper.orderWithProducts
                        checkoutUseCaseMock.returnedOrder = order
                        checkoutUseCaseMock.isNeedToReturnError = false
                        
                        viewModel.checkoutSucceeded
                            .subscribe(onNext: { result in
                                expect(result) == true
                            })
                        .disposed(by: disposeBag)
                        
                        viewModel.placeOrderPressed.onNext()
                        
                        expect(checkoutUseCaseMock.isPayWithCreditCardStarted) == true
                        expect(viewModel.order) == order
                        
                        expect(states.count) == 2
                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                        expect(states.last) == ViewState.content
                    }
                }
                
                context("or response failure") {
                    it("should notify about failing") {
                        checkoutUseCaseMock.isNeedToReturnError = true
                        
                        viewModel.checkoutSucceeded
                            .subscribe(onNext: { result in
                                expect(result) == false
                            })
                            .disposed(by: disposeBag)
                        
                        viewModel.placeOrderPressed.onNext()
                        
                        expect(checkoutUseCaseMock.isPayWithCreditCardStarted) == true
                        expect(viewModel.order).to(beNil())
                        
                        expect(states.count) == 2
                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                        expect(states.last) == ViewState.content
                    }
                }
            }
            
            context("if selected type is apple pay") {
                beforeEach {
                    viewModel.selectedType.value = .applePay
                }
                
                context("and response success") {
                    it("should start setup apple pay") {
                        let order = TestHelper.orderWithProducts
                        checkoutUseCaseMock.returnedOrder = order
                        checkoutUseCaseMock.isNeedToReturnError = false
                        
                        viewModel.checkoutSucceeded
                            .subscribe(onNext: { result in
                                expect(result) == true
                            })
                            .disposed(by: disposeBag)
                        
                        viewModel.placeOrderPressed.onNext()
                        
                        expect(checkoutUseCaseMock.isSetupApplePayStarted) == true
                        expect(viewModel.order) == order
                        
                        expect(states.count) == 2
                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                        expect(states.last) == ViewState.content
                    }
                }
                
                context("or response failure") {
                    it("should notify about failing") {
                        checkoutUseCaseMock.isNeedToReturnError = true
                        
                        viewModel.checkoutSucceeded
                            .subscribe(onNext: { result in
                                expect(result) == false
                            })
                            .disposed(by: disposeBag)
                        
                        viewModel.placeOrderPressed.onNext()
                        
                        expect(checkoutUseCaseMock.isSetupApplePayStarted) == true
                        expect(viewModel.order).to(beNil())
                        
                        expect(states.count) == 2
                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                        expect(states.last) == ViewState.content
                    }
                }
            }
            
            context("if event not 'next'") {
                it("shouldn't start pay with credit card or setup apple pay") {
                    viewModel.placeOrderPressed.onCompleted()
                    
                    expect(checkoutUseCaseMock.isPayWithCreditCardStarted) == false
                    expect(checkoutUseCaseMock.isSetupApplePayStarted) == false
                }
            }
        }
        
        describe("when is checkout valid called") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if apple pay condition success") {
                it("should return true") {
                    viewModel.selectedType.value = .applePay
                    viewModel.customerEmail.value = "customer@mail.com"
                    
                    viewModel.isCheckoutValid
                        .subscribe(onNext: { result in
                            expect(result) == true
                        })
                    .disposed(by: disposeBag)
                }
            }
            
            context("if credit card condition success") {
                it("should return true") {
                    viewModel.checkout.value = TestHelper.checkoutWithShippingAddress
                    viewModel.creditCard.value = TestHelper.card
                    viewModel.billingAddress.value = TestHelper.fullAddress
                    viewModel.customerEmail.value = "customer@mail.com"
                    viewModel.selectedType.value = .creditCard
                    
                    viewModel.isCheckoutValid
                        .subscribe(onNext: { result in
                            expect(result) == true
                        })
                        .disposed(by: disposeBag)
                }
            }
            
            context("if all conditions are failure") {
                it("should return false") {
                    viewModel.isCheckoutValid
                        .subscribe(onNext: { result in
                            expect(result) == false
                        })
                        .disposed(by: disposeBag)
                }
            }
        }
        
        describe("when load data called") {
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
            
            context("if user isn't logged in") {
                it("should return false") {
                    signInUseCaseMock.isNeedToReturnError = true
                    cartProductListUseCaseMock.isNeedToReturnError = true
                    
                    viewModel.loadData()
                    
                    expect(viewModel.customerLogged.value) == false
                    
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
            
            context("if user is logged in") {
                beforeEach {
                    signInUseCaseMock.isNeedToReturnError = false
                }
                
                context("and 'get cart products list' success") {
                    beforeEach {
                        cartProductListUseCaseMock.isNeedToReturnError = false
                        cartProductListUseCaseMock.isNeedToReturnEmptyData = false
                    }
                    
                    context("and 'create checkout' success") {
                        var checkout: Checkout!
                        
                        beforeEach {
                            checkoutUseCaseMock.isNeedToReturnError = false
                            checkout = TestHelper.checkoutWithShippingAddress
                            checkoutUseCaseMock.returnedCheckout = checkout
                        }
                        
                        context("and 'get customer' response has customer default address") {
                            beforeEach {
                                customerUseCaseMock.isNeedToReturnError = false
                            }
                            
                            context("and 'update checkout shipping address' success") {
                                beforeEach {
                                    checkoutUseCaseMock.isUpdateCheckoutShippingAddressNeedToReturnError = false
                                }
                                
                                context("and 'get checkout' success") {
                                    it("should return checkout") {
                                        checkoutUseCaseMock.isGetCheckoutNeedToReturnError = false
                                        
                                        viewModel.loadData()
                                        
                                        expect(viewModel.customerLogged.value) == true
                                        expect(viewModel.cartItems.value.isEmpty) == false
                                        expect(viewModel.checkout.value) == checkout
                                        
                                        expect(states.count) == 4
                                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                                        expect(states[1]) == ViewState.loading(showHud: true, isTranslucent: false)
                                        expect(states[2]) == ViewState.loading(showHud: true, isTranslucent: false)
                                        expect(states.last) == ViewState.content
                                    }
                                }
                                
                                context("and 'get checkout' failed") {
                                    it("should return error") {
                                        checkoutUseCaseMock.isGetCheckoutNeedToReturnError = true
                                        
                                        viewModel.loadData()
                                        
                                        expect(viewModel.customerLogged.value) == true
                                        expect(viewModel.cartItems.value.isEmpty) == false
                                        expect(viewModel.checkout.value) == checkout
                                        
                                        expect(states.count) == 4
                                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                                        expect(states[1]) == ViewState.loading(showHud: true, isTranslucent: false)
                                        expect(states[2]) == ViewState.loading(showHud: true, isTranslucent: false)
                                        expect(states.last) == ViewState.error(error: nil)
                                    }
                                }
                            }
                            
                            context("and 'update checkout shipping address' failed") {
                                it("should return false") {
                                    checkoutUseCaseMock.isUpdateCheckoutShippingAddressNeedToReturnError = true
                                    
                                    viewModel.loadData()
                                    
                                    expect(viewModel.customerLogged.value) == true
                                    expect(viewModel.cartItems.value.isEmpty) == false
                                    expect(viewModel.checkout.value) == checkout
                                    
                                    expect(states.count) == 3
                                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                                    expect(states[1]) == ViewState.loading(showHud: true, isTranslucent: false)
                                    expect(states.last) == ViewState.error(error: nil)
                                }
                            }
                        }
                        
                        context("or 'get customer' response hasn't customer default address") {
                            it("should set content state") {
                                customerUseCaseMock.isNeedToReturnError = true
                                
                                viewModel.loadData()
                                
                                expect(viewModel.customerLogged.value) == true
                                expect(viewModel.cartItems.value.isEmpty) == false
                                expect(viewModel.checkout.value) == checkout
                                
                                expect(states.count) == 2
                                expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                                expect(states.last) == ViewState.content
                            }
                        }
                    }
                    
                    context("or 'create checkout' failure") {
                        it("shouldn't create checkout") {
                            checkoutUseCaseMock.isNeedToReturnError = true
                            
                            viewModel.loadData()
                            
                            expect(viewModel.customerLogged.value) == true
                            expect(viewModel.cartItems.value.isEmpty) == false
                            
                            expect(states.count) == 2
                            expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                            expect(states.last) == ViewState.error(error: nil)
                        }
                    }
                }
                
                context("or 'get cart products list' failed") {
                    it("should return error") {
                        cartProductListUseCaseMock.isNeedToReturnError = true
                        
                        viewModel.loadData()
                        
                        expect(viewModel.customerLogged.value) == true
                        
                        expect(states.count) == 2
                        expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                        expect(states.last) == ViewState.error(error: nil)
                    }
                }
            }
        }
        
        describe("when 'product variant' called") {
            var cartProduct: CartProduct!
            
            beforeEach {
                cartProduct = TestHelper.cartProductWithQuantityOne
                viewModel.cartItems.value = [cartProduct]
            }
            
            context("and product variant id exist") {
                it("should return product variant") {
                    let result = viewModel.productVariant(with: cartProduct.productVariant!.id)
                    expect(result).toNot(beNil())
                }
            }
            
            context("or product variant id doesn't exist") {
                it("should return product variant") {
                    let result = viewModel.productVariant(with: "Another id")
                    expect(result).to(beNil())
                }
            }
        }
        
        describe("when 'update shipping rate' called") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            var checkout: Checkout!
            
            beforeEach {
                disposeBag = DisposeBag()
                states = []
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
                
                checkout = TestHelper.checkoutWithShippingAddress
                viewModel.checkout.value = checkout
            }
            
            context("if response success") {
                it("should return updated checkout") {
                    checkoutUseCaseMock.returnedCheckout = checkout
                    checkoutUseCaseMock.isNeedToReturnError = false
                    
                    viewModel.updateShippingRate(with: TestHelper.shippingRate)
                    
                    expect(viewModel.checkout.value) == checkout
                    
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if response failed") {
                it("should return error") {
                    checkoutUseCaseMock.isNeedToReturnError = true
                    
                    viewModel.updateShippingRate(with: TestHelper.shippingRate)
                    
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
    }
}
