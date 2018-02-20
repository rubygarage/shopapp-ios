//
//  DomainAssembly.swift
//  ShopApp
//
//  Created by Mykola Voronin on 2/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Swinject
import ShopApp_Gateway

class DomainAssembly: Assembly {
    func assemble(container: Container) {

        // Account

        container.register(LoginUseCase.self) { r in
            return LoginUseCase(repository: r.resolve(Repository.self)!)
        }

        container.register(LogoutUseCase.self) { r in
            return LogoutUseCase(repository: r.resolve(Repository.self)!)
        }

        container.register(OrderUseCase.self) { r in
            return OrderUseCase(repository: r.resolve(Repository.self)!)
        }

        container.register(OrderListUseCase.self) { r in
            return OrderListUseCase(repository: r.resolve(Repository.self)!)
        }

        container.register(ResetPasswordUseCase.self) { r in
            return ResetPasswordUseCase(repository: r.resolve(Repository.self)!)
        }

        container.register(ShopUseCase.self) { r in
            return ShopUseCase(repository: r.resolve(Repository.self)!)
        }

        container.register(SignUpUseCase.self) { r in
            return SignUpUseCase(repository: r.resolve(Repository.self)!)
        }

        container.register(UpdateCustomerUseCase.self) { r in
            return UpdateCustomerUseCase(repository: r.resolve(Repository.self)!)
        }

        // Cart

        container.register(ChangeCartProductUseCase.self) { r in
            return ChangeCartProductUseCase(repository: r.resolve(CartRepository.self)!)
        }

        container.register(DeleteCartProductUseCase.self) { r in
            return DeleteCartProductUseCase(repository: r.resolve(CartRepository.self)!)
        }

        // Checkout

        container.register(CheckoutUseCase.self) { r in
            return CheckoutUseCase(repository: r.resolve(Repository.self)!)
        }

        container.register(DeleteCartProductsUseCase.self) { r in
            return DeleteCartProductsUseCase(repository: r.resolve(CartRepository.self)!)
        }

        // Main

        container.register(AddCartProductUseCase.self) { r in
            return AddCartProductUseCase(repository: r.resolve(CartRepository.self)!)
        }

        container.register(ArticleListUseCase.self) { r in
            return ArticleListUseCase(repository: r.resolve(Repository.self)!)
        }

        container.register(ArticleUseCase.self) { r in
            return ArticleUseCase(repository: r.resolve(Repository.self)!)
        }

        container.register(CategoryListUseCase.self) { r in
            return CategoryListUseCase(repository: r.resolve(Repository.self)!)
        }

        container.register(CategoryUseCase.self) { r in
            return CategoryUseCase(repository: r.resolve(Repository.self)!)
        }

        container.register(ProductListUseCase.self) { r in
            return ProductListUseCase(repository: r.resolve(Repository.self)!)
        }

        container.register(ProductUseCase.self) { r in
            return ProductUseCase(repository: r.resolve(Repository.self)!)
        }

        // Shared

        container.register(AddAddressUseCase.self) { r in
            return AddAddressUseCase(repository: r.resolve(Repository.self)!)
        }

        container.register(CartProductListUseCase.self) { r in
            return CartProductListUseCase(repository: r.resolve(CartRepository.self)!)
        }

        container.register(CountriesUseCase.self) { r in
            return CountriesUseCase(repository: r.resolve(Repository.self)!)
        }

        container.register(CustomerUseCase.self) { r in
            return CustomerUseCase(repository: r.resolve(Repository.self)!)
        }

        container.register(UpdateAddressUseCase.self) { r in
            return UpdateAddressUseCase(repository: r.resolve(Repository.self)!)
        }

        container.register(DeleteAddressUseCase.self) { r in
            return DeleteAddressUseCase(repository: r.resolve(Repository.self)!)
        }

        container.register(UpdateDefaultAddressUseCase.self) { r in
            return UpdateDefaultAddressUseCase(repository: r.resolve(Repository.self)!)
        }
    }
}
