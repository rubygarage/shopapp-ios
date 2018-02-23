//
//  AccountAssembly.swift
//  ShopApp
//
//  Created by Mykola Voronin on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Swinject

class AccountAssembly: Assembly {
    func assemble(container: Container) {

        // MARK: - View controllers

        container.storyboardInitCompleted(AccountAddressFormViewController.self) { r, c in
            c.viewModel = r.resolve(AccountAddressFormViewModel.self)!
        }

        container.storyboardInitCompleted(AccountAddressListViewController.self) { r, c in
            c.viewModel = r.resolve(BaseAddressListViewModel.self)!
        }

        container.storyboardInitCompleted(AddressFormViewController.self) { r, c in
            c.viewModel = r.resolve(AddressFormViewModel.self)!
        }

        container.storyboardInitCompleted(ChangePasswordViewController.self) { r, c in
            c.viewModel = r.resolve(ChangePasswordViewModel.self)!
        }

        container.storyboardInitCompleted(AccountViewController.self) { r, c in
            c.viewModel = r.resolve(AccountViewModel.self)!
        }

        container.storyboardInitCompleted(ForgotPasswordViewController.self) { r, c in
            c.viewModel = r.resolve(ForgotPasswordViewModel.self)!
        }

        container.storyboardInitCompleted(LinkViewController.self) { r, c in
            c.viewModel = r.resolve(ForgotPasswordViewModel.self)!
        }

        container.storyboardInitCompleted(OrderDetailsViewController.self) { r, c in
            c.viewModel = r.resolve(OrderDetailsViewModel.self)!
            c.tableProvider = r.resolve(OrderDetailsTableProvider.self)!
        }

        container.storyboardInitCompleted(OrderListViewController.self) { r, c in
            c.viewModel = r.resolve(OrderListViewModel.self)!
            c.tableProvider = r.resolve(OrderListTableProvider.self)!
        }

        container.storyboardInitCompleted(PersonalInfoViewController.self) { r, c in
            c.viewModel = r.resolve(PersonalInfoViewModel.self)!
        }

        container.storyboardInitCompleted(SettingsViewController.self) { r, c in
            c.viewModel = r.resolve(SettingsViewModel.self)!
        }

        container.storyboardInitCompleted(SignInViewController.self) { r, c in
            c.viewModel = r.resolve(SignInViewModel.self)!
        }

        container.storyboardInitCompleted(SignUpViewController.self) { r, c in
            c.viewModel = r.resolve(SignUpViewModel.self)!
        }

        // MARK: - View models

        container.register(BaseAddressListViewModel.self) { r in
            return BaseAddressListViewModel(customerUseCase: r.resolve(CustomerUseCase.self)!,
                                            updateDefaultAddressUseCase: r.resolve(UpdateDefaultAddressUseCase.self)!,
                                            deleteAddressUseCase: r.resolve(DeleteAddressUseCase.self)!)
        }

        container.register(AccountAddressFormViewModel.self) { r in
            return AccountAddressFormViewModel(addAddressUseCase: r.resolve(AddAddressUseCase.self)!,
                                               updateAddressUseCase: r.resolve(UpdateAddressUseCase.self)!)
        }

        container.register(AddressFormViewModel.self) { r in
            return AddressFormViewModel(countriesUseCase: r.resolve(CountriesUseCase.self)!)
        }

        container.register(AccountViewModel.self) { r in
            return AccountViewModel(customerUseCase: r.resolve(CustomerUseCase.self)!,
                                    loginUseCase: r.resolve(LoginUseCase.self)!,
                                    logoutUseCase: r.resolve(LogoutUseCase.self)!,
                                    shopUseCase: r.resolve(ShopUseCase.self)!)
        }

        container.register(ChangePasswordViewModel.self) { r in
            return ChangePasswordViewModel(updateCustomerUseCase: r.resolve(UpdateCustomerUseCase.self)!)
        }

        container.register(ForgotPasswordViewModel.self) { r in
            return ForgotPasswordViewModel(resetPasswordUseCase: r.resolve(ResetPasswordUseCase.self)!)
        }

        container.register(OrderDetailsViewModel.self) { r in
            return OrderDetailsViewModel(orderUseCase: r.resolve(OrderUseCase.self)!)
        }

        container.register(OrderListViewModel.self) { r in
            return OrderListViewModel(orderListUseCase: r.resolve(OrderListUseCase.self)!)
        }

        container.register(PersonalInfoViewModel.self) { r in
            return PersonalInfoViewModel(updateCustomerUseCase: r.resolve(UpdateCustomerUseCase.self)!,
                                         loginUseCase: r.resolve(LoginUseCase.self)!,
                                         customerUseCase: r.resolve(CustomerUseCase.self)!)
        }

        container.register(SettingsViewModel.self) { r in
            return SettingsViewModel(updateCustomerUseCase: r.resolve(UpdateCustomerUseCase.self)!,
                                     loginUseCase: r.resolve(LoginUseCase.self)!,
                                     customerUseCase: r.resolve(CustomerUseCase.self)!)
        }

        container.register(SignInViewModel.self) { r in
            return SignInViewModel(loginUseCase: r.resolve(LoginUseCase.self)!)
        }

        container.register(SignUpViewModel.self) { r in
            return SignUpViewModel(shopUseCase: r.resolve(ShopUseCase.self)!,
                                   signUpUseCase: r.resolve(SignUpUseCase.self)!)
        }
        
        // MARK: - Providers
        
        container.register(OrderDetailsTableProvider.self) { _ in
            return OrderDetailsTableProvider()
        }
        
        container.register(OrderListTableProvider.self) { _ in
            return OrderListTableProvider()
        }
    }
}
