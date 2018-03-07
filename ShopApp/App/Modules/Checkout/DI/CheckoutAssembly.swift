//
//  CheckoutAssembly.swift
//  ShopApp
//
//  Created by Mykola Voronin on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Swinject

class CheckoutAssembly: Assembly {
    func assemble(container: Container) {

        // MARK: - View controllers

        container.storyboardInitCompleted(CheckoutAddressFormViewController.self) { r, c in
            c.viewModel = r.resolve(CheckoutAddressFormViewModel.self)!
        }

        container.storyboardInitCompleted(CheckoutAddressListViewController.self) { r, c in
            c.viewModel = r.resolve(CheckoutAddressListViewModel.self)!
            c.tableProvider = r.resolve(BaseAddressListTableProvider.self)!
        }

        container.storyboardInitCompleted(CheckoutViewController.self) { r, c in
            c.viewModel = r.resolve(CheckoutViewModel.self)!
        }

        container.storyboardInitCompleted(CreditCardViewController.self) { r, c in
            c.viewModel = r.resolve(CreditCardViewModel.self)!
        }

        container.storyboardInitCompleted(PaymentTypeViewController.self) { r, c in
            c.viewModel = r.resolve(PaymentTypeViewModel.self)!
        }

        // MARK: - View models

        container.register(CheckoutAddressFormViewModel.self) { r in
            return CheckoutAddressFormViewModel(checkoutUseCase: r.resolve(CheckoutUseCase.self)!)
        }

        container.register(CheckoutAddressListViewModel.self) { r in
            return CheckoutAddressListViewModel(customerUseCase: r.resolve(CustomerUseCase.self)!,
                                                updateDefaultAddressUseCase: r.resolve(UpdateDefaultAddressUseCase.self)!,
                                                deleteAddressUseCase: r.resolve(DeleteAddressUseCase.self)!,
                                                checkoutUseCase: r.resolve(CheckoutUseCase.self)!)
        }

        container.register(CheckoutViewModel.self) { r in
            return CheckoutViewModel(checkoutUseCase: r.resolve(CheckoutUseCase.self)!,
                                     cartProductListUseCase: r.resolve(CartProductListUseCase.self)!,
                                     deleteCartProductsUseCase: r.resolve(DeleteCartProductsUseCase.self)!,
                                     customerUseCase: r.resolve(CustomerUseCase.self)!,
                                     loginUseCase: r.resolve(LoginUseCase.self)!)
        }

        container.register(CreditCardViewModel.self) { _ in
            return CreditCardViewModel()
        }

        container.register(PaymentTypeViewModel.self) { r in
            return PaymentTypeViewModel(checkoutUseCase: r.resolve(CheckoutUseCase.self)!)
        }
        
        // MARK: - Providers
        
        container.register(BaseAddressListTableProvider.self) { _ in
            return BaseAddressListTableProvider()
        }
    }
}
