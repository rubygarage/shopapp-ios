//
//  CartAssembly.swift
//  ShopApp
//
//  Created by Mykola Voronin on 2/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Swinject

class CartAssembly: Assembly {
    func assemble(container: Container) {

        // MARK: - View controllers

        container.storyboardInitCompleted(CartViewController.self) { r, c in
            c.viewModel = r.resolve(CartViewModel.self)!
            c.tableProvider = r.resolve(CartTableProvider.self)!
        }

        // MARK: - View models

        container.register(CartViewModel.self) { r in
            return CartViewModel(cartProductListUseCase: r.resolve(CartProductListUseCase.self)!,
                                 deleteCartProductUseCase: r.resolve(DeleteCartProductUseCase.self)!,
                                 changeCartProductUseCase: r.resolve(ChangeCartProductUseCase.self)!)
        }
        
        // MARK: - Providers
        
        container.register(CartTableProvider.self) { _ in
            return CartTableProvider()
        }
    }
}
