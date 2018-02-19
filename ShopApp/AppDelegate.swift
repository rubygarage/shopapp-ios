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
import ShopApp_Shopify

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

    private func setupRepository() {
        let shopifyAdminApiKey = "d64eae31336ae451296daf24f52b0327"
        let shopifyAdminPassword = "b54086c46fe6825198e4542a96499d51"
        let shopifyStorefrontAccessToken = "2098ab2fb06659df83ccf0f6df678dc6"
        let shopifyStorefrontURL = "palkomin.myshopify.com"
        let merchantID = "merchant.com.rubygarage.shopclient.test.temp"
        
        repository = ShopifyRepository(apiKey: shopifyStorefrontAccessToken, shopDomain: shopifyStorefrontURL, adminApiKey: shopifyAdminApiKey, adminPassword: shopifyAdminPassword, applePayMerchantId: merchantID)
    }

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
