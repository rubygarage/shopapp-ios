//
//  CheckoutViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/10/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CheckoutViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: CheckoutViewController!
        var checkoutUseCaseMock: CheckoutUseCaseMock!
        var cartProductListUseCaseMock: CartProductListUseCaseMock!
        var deleteCartProductsUseCase: DeleteCartProductsUseCase!
        var customerUseCaseMock: CustomerUseCaseMock!
        var loginUseCaseMock: LoginUseCaseMock!
        var viewModelMock: CheckoutViewModelMock!
        var tableProvider: CheckoutTableProvider!
        var tableView: UITableView!
        var placeOrderButton: UIButton!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.checkout, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.checkout) as? CheckoutViewController
            
            let paymentsRepositoryMock = PaymentsRepositoryMock()
            checkoutUseCaseMock = CheckoutUseCaseMock(repository: paymentsRepositoryMock)
            
            let cartRepositoryMock = CartRepositoryMock()
            cartProductListUseCaseMock = CartProductListUseCaseMock(repository: cartRepositoryMock)
            deleteCartProductsUseCase = DeleteCartProductsUseCase(repository: cartRepositoryMock)
            
            let customerRepositoryMock = CustomerRepositoryMock()
            customerUseCaseMock = CustomerUseCaseMock(repository: customerRepositoryMock)
            
            let authentificationRepositoryMock = AuthentificationRepositoryMock()
            loginUseCaseMock = LoginUseCaseMock(repository: authentificationRepositoryMock)
            
            viewModelMock = CheckoutViewModelMock(checkoutUseCase: checkoutUseCaseMock, cartProductListUseCase: cartProductListUseCaseMock, deleteCartProductsUseCase: deleteCartProductsUseCase, customerUseCase: customerUseCaseMock, loginUseCase: loginUseCaseMock)
            viewController.viewModel = viewModelMock
            
            tableProvider = CheckoutTableProvider()
            viewController.tableProvider = tableProvider
            
            tableView = self.findView(withAccessibilityLabel: "tableView", in: viewController.view) as? UITableView
            placeOrderButton = self.findView(withAccessibilityLabel: "placeOrderButton", in: viewController.view) as? UIButton
        }
        
        describe("when view loaded") {
            it("should have a correct superclass") {
                expect(viewController.isKind(of: BaseViewController<CheckoutViewModel>.self)) == true
            }
            
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(CheckoutViewModel.self))
            }
            
            it("should have a correct title") {
                expect(viewController.title) == "ControllerTitle.Checkout".localizable
            }
            
            it("should have a correct place order button title") {
                expect(placeOrderButton.title(for: .normal)) == "Button.PlaceOrder".localizable.uppercased()
            }
            
            it("should have correct delegate of table provider") {
                expect(tableProvider.delegate) === viewController
            }
            
            it("should have correct data source and delegate of table view") {
                expect(tableView.dataSource) === tableProvider
                expect(tableView.delegate) === tableProvider
            }
            
            it("should have correct content inset of table view") {
                expect(tableView.contentInset) == TableView.defaultContentInsets
            }
            
            it("should start loading data") {
                expect(loginUseCaseMock.isGetLoginStatusStarted) == true
            }
        }
        
        describe("when view will appear called") {
            it("should start load checkout") {
                viewController.viewWillAppear(false)
                
                expect(viewModelMock.isGetCheckoutStarted) == true
            }
        }
        
        describe("when checkout did update") {
            it("should pass checkout to table provider and reload table") {
                tableProvider.selectedPaymentType = .creditCard
                
                let checkout = Checkout()
                let shippingRate = ShippingRate()
                let shippingRates = [shippingRate, shippingRate]
                checkout.availableShippingRates = shippingRates
                
                viewModelMock.generateCheckout(checkout)
                
                let section = CheckoutSection.shippingOptions.rawValue
                expect(viewController.tableProvider.checkout) === checkout
                expect(tableView.numberOfRows(inSection: section)) == shippingRates.count
            }
        }
        
        describe("when is checkoud valid updated") {
            context("if true") {
                it("should enable place order button") {
                    viewModelMock.generateIsCheckoutValid(true)
                    _ = viewModelMock.isCheckoutValid.do()
                    
                    expect(placeOrderButton.isEnabled) == true
                    expect(placeOrderButton.backgroundColor) == UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
                }
            }
            
            context("if false") {
                it("should disable place order button") {
                    viewModelMock.generateIsCheckoutValid(false)
                    _ = viewModelMock.isCheckoutValid.do()
                    
                    expect(placeOrderButton.isEnabled) == false
                    expect(placeOrderButton.backgroundColor) == UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
                }
            }
        }
        
        describe("when cart items updated") {
            it("should pass data to table provider") {
                let cartItems = [CartProduct()]
                viewModelMock.generateCartItems(cartItems)
                
                expect(viewController.tableProvider.cartProducts) === cartItems
            }
        }
        
        describe("when customer has email changed") {
            it("should pass data to table provider and reload table") {
                let customerHasEmail = true
                viewModelMock.generateCustomerHasEmail(customerHasEmail)
                
                expect(viewController.tableProvider.customerHasEmail) == customerHasEmail
                
                let section = CheckoutSection.customerEmail.rawValue
                expect(tableView.numberOfRows(inSection: section)) == 0
            }
        }
        
        describe("when customer email changed") {
            it("should pass email to table provider") {
                let customerEmail = "customer@mail.com"
                viewModelMock.generateCustomerEmail(customerEmail)
                
                expect(viewController.tableProvider.customerEmail) == customerEmail
            }
        }
        
        describe("when place order button did press") {
            it("should start setup apple pay") {
                viewController.viewModel.checkout.value = Checkout()
                viewController.viewModel.selectedType.value = .applePay
                placeOrderButton.sendActions(for: .touchUpInside)
                
                expect(checkoutUseCaseMock.isSetupApplePayStarted) == true
            }
        }
        
        describe("when customer email changed") {
            it("should pass data to view model and table provider") {
                let inputTextFieldView = InputTextFieldView()
                let text = "Customer email"
                viewController.textFieldView(inputTextFieldView, didEndUpdate: text)
                
                expect(viewController.viewModel.customerEmail.value) == text
                expect(viewController.tableProvider.customerEmail) == text
            }
        }
        
        describe("when product variant did select") {
            it("should set variant to view model") {
                let variantId = "Selected variant id"
                
                let productVariant = ProductVariant()
                productVariant.id = variantId
                
                let cartItem = CartProduct()
                cartItem.productVariant = productVariant
                
                viewController.viewModel.cartItems.value = [cartItem]
                
                let cell = CheckoutCartTableViewCell()
                let index = 0
                
                viewController.tableViewCell(cell, didSelect: variantId, at: index)
                
                expect(viewController.viewModel.selectedProductVariant) === productVariant
            }
        }
        
        describe("when shipping rate did select") {
            it("should start updating shipping rate") {
                let cell = CheckoutShippingOptionsEnabledTableViewCell()
                let shippingRate = ShippingRate()
                
                viewController.tableViewCell(cell, didSelect: shippingRate)
                
                expect(viewModelMock.isUpdateShippingRateStarted) == true
            }
        }
        
        describe("when payment type did select") {
            it("should set type to view model, table provider and reload data") {
                let controller = PaymentTypeViewController()
                let paymentType: PaymentType = .creditCard
                
                viewController.viewController(controller, didSelect: paymentType)
                
                expect(viewController.viewModel.selectedType.value) == paymentType
                expect(viewController.tableProvider.selectedPaymentType) == paymentType
                expect(tableView.numberOfSections) == CheckoutSection.allValues.count
            }
        }
        
        describe("when shipping address updated") {
            it("should start loading checkout") {
                let controller = CheckoutAddressFormViewController()
                
                viewController.viewControllerDidUpdateShippingAddress(controller)
                
                expect(viewModelMock.isGetCheckoutStarted) == true
            }
        }
        
        describe("when billing address did fill") {
            it("should set billing address to view model, table provider and reload data") {
                let controller = CheckoutAddressFormViewController()
                let address = Address()
                address.address = "Address"
                
                viewController.viewController(controller, didFill: address)
                
                expect(viewController.viewModel.billingAddress.value) === address
                expect(viewController.tableProvider.billingAddress) === address
                
                let row = PaymentAddCellType.billingAddress.rawValue
                let section = CheckoutSection.payment.rawValue
                let indexPath = IndexPath(row: row, section: section)
                let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                expect(cell).to(beAnInstanceOf(ShopApp.CheckoutBillingAddressEditTableViewCell.self))
            }
        }
        
        describe("when billing address did select") {
            it("should set billing address to view model, table provider and reload data") {
                let address = Address()
                address.address = "Address"
                
                viewController.viewController(didSelectBillingAddress: address)
                
                expect(viewController.viewModel.billingAddress.value) === address
                expect(viewController.tableProvider.billingAddress) === address
                
                let row = PaymentAddCellType.billingAddress.rawValue
                let section = CheckoutSection.payment.rawValue
                let indexPath = IndexPath(row: row, section: section)
                let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                expect(cell).to(beAnInstanceOf(ShopApp.CheckoutBillingAddressEditTableViewCell.self))
            }
        }
        
        describe("when credit card did fill") {
            it("should set card to view model, table provider and reload data") {
                let controller = CreditCardViewController()
                let creditCard = CreditCard()
                
                viewController.viewController(controller, didFilled: creditCard)
                
                expect(viewController.viewModel.creditCard.value) === creditCard
                expect(viewController.tableProvider.creditCard) === creditCard
                
                let row = PaymentAddCellType.card.rawValue
                let section = CheckoutSection.payment.rawValue
                let indexPath = IndexPath(row: row, section: section)
                let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                
                expect(cell).to(beAnInstanceOf(CheckoutCreditCardEditTableViewCell.self))
            }
        }
        
        describe("when try again on failure view controller did press") {
            it("should start place order action") {
                viewController.viewModel.checkout.value = Checkout()
                viewController.viewModel.selectedType.value = .applePay
                
                let controller = CheckoutFailureViewController()
                viewController.viewControllerDidTapTryAgain(controller)
                
                expect(checkoutUseCaseMock.isSetupApplePayStarted) == true
            }
        }
    }
}
