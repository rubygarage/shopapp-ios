//
//  CheckoutAddressFormViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/4/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class CheckoutAddressFormViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: CheckoutAddressFormViewController!
        var repositoryMock: PaymentsRepositoryMock!
        var viewModelMock: CheckoutAddressFormViewModelMock!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.checkout, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.checkoutAddressForm) as? CheckoutAddressFormViewController
            
            repositoryMock = PaymentsRepositoryMock()
            let checkoutUseCaseMock = CheckoutUseCaseMock(repository: repositoryMock)
            viewModelMock = CheckoutAddressFormViewModelMock(checkoutUseCase: checkoutUseCaseMock)
            viewController.viewModel = viewModelMock
            
            viewController.selectedAddress = Address()
            viewController.checkoutId = "Checkout id"
            viewController.addressType = .shipping
            
            _ = viewController.view
        }
        
        describe("when view loaded") {
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(CheckoutAddressFormViewModel.self))
            }
            
            it("should have correct view model properties") {
                expect(viewController.viewModel.checkoutId) == viewController.checkoutId
                expect(viewController.viewModel.addressType) == viewController.addressType
            }
            
            it("should have correct child controller properties") {
                let childController = viewController.children.first as? AddressFormViewController
                expect(childController?.address) === viewController.selectedAddress
            }
        }
        
        describe("when shipping address updated") {
            it("should notify delegate") {
                let delegateMock = CheckoutAddressFormControllerDelegateMock()
                viewController.delegate = delegateMock
                
                viewModelMock.updateShippingAddress()
                
                expect(delegateMock.controller) == viewController
            }
        }
        
        describe("when billing address updated") {
            it("should notify delegate") {
                let delegateMock = CheckoutAddressFormControllerDelegateMock()
                viewController.delegate = delegateMock
                
                let address = Address()
                viewModelMock.returnedAddress = address
                
                viewModelMock.updateBillingAddress()
                
                expect(delegateMock.controller) == viewController
                expect(delegateMock.billingAddress) === address
            }
        }
        
        describe("when address form did fill") {
            it("should update address") {
                let delegateMock = CheckoutAddressFormControllerDelegateMock()
                viewController.delegate = delegateMock
                
                let addressFormViewController = viewController.children.first as! AddressFormViewController
                let address = Address()
                
                viewController.viewController(addressFormViewController, didFill: address)
                
                
                expect(delegateMock.controller) == viewController
            }
        }
    }
}
