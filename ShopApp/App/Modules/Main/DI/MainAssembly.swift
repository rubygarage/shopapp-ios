//
//  MainAssembly.swift
//  ShopApp
//
//  Created by Mykola Voronin on 2/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Swinject

class MainAssembly: Assembly {
    func assemble(container: Container) {

        // MARK: - View controllers

        container.storyboardInitCompleted(ArticleDetailsViewController.self) { r, c in
            c.viewModel = r.resolve(ArticleDetailsViewModel.self)!
        }

        container.storyboardInitCompleted(ArticleListViewController.self) { r, c in
            c.viewModel = r.resolve(ArticleListViewModel.self)!
            c.tableProvider = r.resolve(ArticleListTableProvider.self)!
        }

        container.storyboardInitCompleted(CategoryListViewController.self) { r, c in
            c.viewModel = r.resolve(CategoryListViewModel.self)!
        }

        container.storyboardInitCompleted(CategoryViewController.self) { r, c in
            c.viewModel = r.resolve(CategoryViewModel.self)!
        }

        container.storyboardInitCompleted(HomeViewController.self) { r, c in
            c.viewModel = r.resolve(HomeViewModel.self)!
        }

        container.storyboardInitCompleted(ProductDetailsViewController.self) { r, c in
            c.viewModel = r.resolve(ProductDetailsViewModel.self)!
        }

        container.storyboardInitCompleted(ProductsListViewController.self) { r, c in
            c.viewModel = r.resolve(ProductsListViewModel.self)!
        }

        container.storyboardInitCompleted(SearchViewController.self) { r, c in
            c.viewModel = r.resolve(SearchViewModel.self)!
        }

        // MARK: - View models

        container.register(ArticleDetailsViewModel.self) { r in
            return ArticleDetailsViewModel(articleUseCase: r.resolve(ArticleUseCase.self)!)
        }

        container.register(ArticleListViewModel.self) { r in
            return ArticleListViewModel(articleListUseCase: r.resolve(ArticleListUseCase.self)!)
        }

        container.register(CategoryListViewModel.self) { r in
            return CategoryListViewModel(categoryListUseCase: r.resolve(CategoryListUseCase.self)!)
        }

        container.register(CategoryViewModel.self) { r in
            return CategoryViewModel(categoryUseCase: r.resolve(CategoryUseCase.self)!)
        }

        container.register(HomeViewModel.self) { r in
            return HomeViewModel(articleListUseCase: r.resolve(ArticleListUseCase.self)!,
                                 productListUseCase: r.resolve(ProductListUseCase.self)!)
        }

        container.register(ProductDetailsViewModel.self) { r in
            return ProductDetailsViewModel(addCartProductUseCase: r.resolve(AddCartProductUseCase.self)!,
                                           productUseCase: r.resolve(ProductUseCase.self)!,
                                           productListUseCase: r.resolve(ProductListUseCase.self)!)
        }

        container.register(ProductsListViewModel.self) { r in
            return ProductsListViewModel(productListUseCase: r.resolve(ProductListUseCase.self)!)
        }

        container.register(SearchViewModel.self) { r in
            return SearchViewModel(productListUseCase: r.resolve(ProductListUseCase.self)!)
        }

        container.register(CartButtonViewModel.self) { r in
            return CartButtonViewModel(cartProductListUseCase: r.resolve(CartProductListUseCase.self)!)
        }
        
        // MARK: - Providers
        
        container.register(ArticleListTableProvider.self) { _ in
            return ArticleListTableProvider()
        }
    }
}
