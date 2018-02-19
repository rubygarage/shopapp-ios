//
//  AppDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 8/30/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import CoreStore
import Fabric
import Crashlytics
import ShopApp_Gateway

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var repository: Repository!
    private var cartRepository: CartRepository!

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        #if !DEV
            Fabric.with([Crashlytics.self])
        #endif
        
        do {
            try CoreStore.addStorageAndWait()
        } catch {
            print(error)
        }

        setupCartRepository()
        setupRepository()

        return true
    }

    // MARK: - Private

    private func setupRepository() {}

    private func setupCartRepository() {
        cartRepository = AppCartRepository(dao: DAO())
    }

    // MARK: - Public static

    static func getRepository() -> Repository {
        return (UIApplication.shared.delegate as! AppDelegate).repository
    }

    static func getCartRepository() -> CartRepository {
        return (UIApplication.shared.delegate as! AppDelegate).cartRepository
    }
}
