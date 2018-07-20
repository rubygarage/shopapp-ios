//
//  DataAssembly.swift
//  ShopApp
//
//  Created by Mykola Voronin on 2/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Swinject
import ShopApp_Gateway

class DataAssembly: Assembly {
    func assemble(container: Container) {
        
        // MARK: - Data
        
        container.register(API.self) { _ in
            return MagentoAPI(shopDomain: "http://10.14.14.187/")
            }
            .inObjectScope(.container)
        
        container.register(Config.self) { r in
            return r.resolve(API.self)!.getConfig()
            }
            .inObjectScope(.container)

        // MARK: - Repositories
        
        container.register(ArticleRepository.self) { r in
            return ShopAppArticleRepository(api: r.resolve(API.self)!)
            }
            .inObjectScope(.container)
        
        container.register(AuthentificationRepository.self) { r in
            return ShopAppAuthentificationRepository(api: r.resolve(API.self)!)
            }
            .inObjectScope(.container)
        
        container.register(CartRepository.self) { r in
            return ShopAppCartRepository(api: r.resolve(API.self)!)
            }
            .inObjectScope(.container)
        
        container.register(CategoryRepository.self) { r in
            return ShopAppCategoryRepository(api: r.resolve(API.self)!)
            }
            .inObjectScope(.container)
        
        container.register(CustomerRepository.self) { r in
            return ShopAppCustomerRepository(api: r.resolve(API.self)!)
            }
            .inObjectScope(.container)
        
        container.register(OrderRepository.self) { r in
            return ShopAppOrderRepository(api: r.resolve(API.self)!)
            }
            .inObjectScope(.container)
        
        container.register(PaymentRepository.self) { r in
            return ShopAppPaymentRepository(api: r.resolve(API.self)!)
            }
            .inObjectScope(.container)
        
        container.register(ProductRepository.self) { r in
            return ShopAppProductRepository(api: r.resolve(API.self)!)
            }
            .inObjectScope(.container)
        
        container.register(ShopRepository.self) { r in
            return ShopAppShopRepository(api: r.resolve(API.self)!)
            }
            .inObjectScope(.container)

        container.register(CountryRepository.self) { r in
            return ShopAppCountryRepository(api: r.resolve(API.self)!)
            }
            .inObjectScope(.container)
        
        container.register(SetupProviderRepository.self) { r in
            return ShopAppSetupProviderRepository(api: r.resolve(API.self)!)
        }
    }
}
