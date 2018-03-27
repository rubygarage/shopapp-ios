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

        container.register(LoginUseCase.self) { r in
            return LoginUseCase(repository: r.resolve(AuthentificationRepository.self)!)
        }

        container.register(LogoutUseCase.self) { r in
            return LogoutUseCase(repository: r.resolve(AuthentificationRepository.self)!)
        }

        container.register(OrderUseCase.self) { r in
            return OrderUseCase(repository: r.resolve(OrderRepository.self)!)
        }

        container.register(OrderListUseCase.self) { r in
            return OrderListUseCase(repository: r.resolve(OrderRepository.self)!)
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
            return CheckoutUseCase(repository: r.resolve(PaymentsRepository.self)!)
        }

        container.register(DeleteCartProductsUseCase.self) { r in
            return DeleteCartProductsUseCase(repository: r.resolve(CartRepository.self)!)
        }

        // MARK: - Main

        container.register(AddCartProductUseCase.self) { r in
            return AddCartProductUseCase(repository: r.resolve(CartRepository.self)!)
        }

        container.register(ArticleListUseCase.self) { r in
            return ArticleListUseCase(repository: r.resolve(ArticleRepository.self)!)
        }

        container.register(ArticleUseCase.self) { r in
            return ArticleUseCase(repository: r.resolve(ArticleRepository.self)!)
        }

        container.register(CategoryListUseCase.self) { r in
            return CategoryListUseCase(repository: r.resolve(CategoryRepository.self)!)
        }

        container.register(CategoryUseCase.self) { r in
            return CategoryUseCase(repository: r.resolve(CategoryRepository.self)!)
        }

        container.register(ProductListUseCase.self) { r in
            return ProductListUseCase(repository: r.resolve(ProductRepository.self)!)
        }

        container.register(ProductUseCase.self) { r in
            return ProductUseCase(repository: r.resolve(ProductRepository.self)!)
        }

        // MARK: - Shared

        container.register(AddAddressUseCase.self) { r in
            return AddAddressUseCase(repository: r.resolve(CustomerRepository.self)!)
        }

        container.register(CartProductListUseCase.self) { r in
            return CartProductListUseCase(repository: r.resolve(CartRepository.self)!)
        }

        container.register(CountriesUseCase.self) { r in
            return CountriesUseCase(repository: r.resolve(PaymentsRepository.self)!)
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
