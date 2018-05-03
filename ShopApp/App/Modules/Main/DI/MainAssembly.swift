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
            c.collectionProvider = r.resolve(CategoryListCollectionProvider.self)!
        }

        container.storyboardInitCompleted(CategoryViewController.self) { r, c in
            c.viewModel = r.resolve(CategoryViewModel.self)!
        }

        container.storyboardInitCompleted(HomeViewController.self) { r, c in
            c.viewModel = r.resolve(HomeViewModel.self)!
            c.tableProvider = r.resolve(HomeTableProvider.self)!

        }

        container.storyboardInitCompleted(ProductDetailsViewController.self) { r, c in
            c.viewModel = r.resolve(ProductDetailsViewModel.self)!
        }

        container.storyboardInitCompleted(ProductListViewController.self) { r, c in
            c.viewModel = r.resolve(ProductListViewModel.self)!
        }

        container.storyboardInitCompleted(SearchViewController.self) { r, c in
            c.viewModel = r.resolve(SearchViewModel.self)!
        }
        
        container.storyboardInitCompleted(SortVariantsViewController.self) { r, c in
            c.tableProvider = r.resolve(SortVariantsTableProvider.self)!
        }
        
        container.storyboardInitCompleted(ImagesCarouselViewController.self) { r, c in
            c.collectionProvider = r.resolve(ImagesCarouselCollectionProvider.self)!
        }
        
        container.storyboardInitCompleted(ProductOptionsViewController.self) { r, c in
            c.collectionProvider = r.resolve(ProductOptionsCollectionProvider.self)
        }
        
        container.storyboardInitCompleted(SplashViewController.self) { (r, c) in
            c.viewModel = r.resolve(SplashViewModel.self)!
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

        container.register(ProductListViewModel.self) { r in
            return ProductListViewModel(productListUseCase: r.resolve(ProductListUseCase.self)!)
        }

        container.register(SearchViewModel.self) { r in
            return SearchViewModel(productListUseCase: r.resolve(ProductListUseCase.self)!)
        }

        container.register(CartButtonViewModel.self) { r in
            return CartButtonViewModel(cartProductListUseCase: r.resolve(CartProductListUseCase.self)!)
        }
        
        container.register(SplashViewModel.self) { r in
            return SplashViewModel(cartProductListUseCase: r.resolve(CartProductListUseCase.self)!,
                                   cartValidationUseCase: r.resolve(CartValidationUseCase.self)!,
                                   deleteCartProductUseCase: r.resolve(DeleteCartProductUseCase.self)!)
        }
        
        // MARK: - Providers
        
        container.register(ArticleListTableProvider.self) { _ in
            return ArticleListTableProvider()
        }
        
        container.register(CategoryListCollectionProvider.self) { _ in
            return CategoryListCollectionProvider()
        }

        container.register(HomeTableProvider.self) { _ in
            return HomeTableProvider()
        }
        
        container.register(SortVariantsTableProvider.self) { _ in
            return SortVariantsTableProvider()
        }
        
        container.register(ImagesCarouselCollectionProvider.self) { _ in
            return ImagesCarouselCollectionProvider()
        }
        
        container.register(ProductOptionsCollectionProvider.self) { _ in
            return ProductOptionsCollectionProvider()
        }
    }
}
