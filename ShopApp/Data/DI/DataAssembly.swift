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
        container.register(DAOInterface.self) { _ in
            return DAO()
        }

        container.register(CartRepository.self) { r in
            return AppCartRepository(dao: r.resolve(DAOInterface.self)!)
        }

        // Place repository implementation here
        // container.register(Repository.self) { _ in
        //    return nil
        //}
    }
}
