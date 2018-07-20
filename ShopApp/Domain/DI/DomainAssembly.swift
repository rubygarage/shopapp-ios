//
//  DomainAssembly.swift
//  ShopApp
//
//  Created by Mykola Voronin on 2/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Swinject

class DomainAssembly: Assembly {
    func assemble(container: Container) {

        // MARK: - Account

        container.register(SignInUseCase.self) { r in
            return SignInUseCase(repository: r.resolve(AuthentificationRepository.self)!)
        }

        container.register(SignOutUseCase.self) { r in
            return SignOutUseCase(repository: r.resolve(AuthentificationRepository.self)!)
        }

        container.register(OrderUseCase.self) { r in
            return OrderUseCase(repository: r.resolve(OrderRepository.self)!)
        }

        container.register(OrdersUseCase.self) { r in
            return OrdersUseCase(repository: r.resolve(OrderRepository.self)!)
        }

        container.register(ResetPasswordUseCase.self) { r in
            return ResetPasswordUseCase(repository: r.resolve(AuthentificationRepository.self)!)
        }

        container.register(ShopUseCase.self) { r in
            return ShopUseCase(repository: r.resolve(ShopRepository.self)!)
        }

        container.register(SignUpUseCase.self) { r in
            return SignUpUseCase(repository: r.resolve(AuthentificationRepository.self)!)
        }

        container.register(UpdateCustomerUseCase.self) { r in
            return UpdateCustomerUseCase(repository: r.resolve(CustomerRepository.self)!)
        }

        // MARK: - Cart

        container.register(ChangeCartProductUseCase.self) { r in
            return ChangeCartProductUseCase(repository: r.resolve(CartRepository.self)!)
        }

        container.register(DeleteCartProductUseCase.self) { r in
            return DeleteCartProductUseCase(repository: r.resolve(CartRepository.self)!)
        }

        // MARK: - Checkout

        container.register(CheckoutUseCase.self) { r in
            return CheckoutUseCase(repository: r.resolve(PaymentRepository.self)!)
        }

        container.register(DeleteCartProductsUseCase.self) { r in
            return DeleteCartProductsUseCase(repository: r.resolve(CartRepository.self)!)
        }

        // MARK: - Main

        container.register(AddCartProductUseCase.self) { r in
            return AddCartProductUseCase(repository: r.resolve(CartRepository.self)!)
        }

        container.register(ArticlesUseCase.self) { r in
            return ArticlesUseCase(repository: r.resolve(ArticleRepository.self)!)
        }

        container.register(ArticleUseCase.self) { r in
            return ArticleUseCase(repository: r.resolve(ArticleRepository.self)!)
        }

        container.register(CategoriesUseCase.self) { r in
            return CategoriesUseCase(repository: r.resolve(CategoryRepository.self)!)
        }

        container.register(CategoryUseCase.self) { r in
            return CategoryUseCase(repository: r.resolve(CategoryRepository.self)!)
        }

        container.register(ProductsUseCase.self) { r in
            return ProductsUseCase(repository: r.resolve(ProductRepository.self)!)
        }

        container.register(ProductUseCase.self) { r in
            return ProductUseCase(repository: r.resolve(ProductRepository.self)!)
        }
        
        container.register(SetupProviderUseCase.self) { r in
            return SetupProviderUseCase(repository: r.resolve(SetupProviderRepository.self)!)
        }

        // MARK: - Shared

        container.register(AddAddressUseCase.self) { r in
            return AddAddressUseCase(repository: r.resolve(CustomerRepository.self)!)
        }

        container.register(CartProductsUseCase.self) { r in
            return CartProductsUseCase(repository: r.resolve(CartRepository.self)!)
        }

        container.register(CountriesUseCase.self) { r in
            return CountriesUseCase(repository: r.resolve(CountryRepository.self)!)
        }

        container.register(CustomerUseCase.self) { r in
            return CustomerUseCase(repository: r.resolve(CustomerRepository.self)!)
        }

        container.register(UpdateAddressUseCase.self) { r in
            return UpdateAddressUseCase(repository: r.resolve(CustomerRepository.self)!)
        }

        container.register(DeleteAddressUseCase.self) { r in
            return DeleteAddressUseCase(repository: r.resolve(CustomerRepository.self)!)
        }

        container.register(UpdateDefaultAddressUseCase.self) { r in
            return UpdateDefaultAddressUseCase(repository: r.resolve(CustomerRepository.self)!)
        }
    }
}
