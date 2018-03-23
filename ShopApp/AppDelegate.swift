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
import Swinject
import SwinjectStoryboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let assembler = Assembler()

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Prevent launching app in unit tests
        if ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil {
            return false
        }
        
        #if !DEV
            Fabric.with([Crashlytics.self])
        #endif
        
        do {
            try CoreStore.addStorageAndWait()
        } catch {
            print(error)
        }

        // Disabled logging due errors with Swift 3
        // https://github.com/Swinject/Swinject/issues/218
        Container.loggingFunction = nil

        assembler.apply(assemblies: [
            DataAssembly(),
            DomainAssembly(),
            MainAssembly(),
            AccountAssembly(),
            CartAssembly(),
            CheckoutAssembly()
        ])

        window = UIWindow(frame: UIScreen.main.bounds)

        let storyboard = SwinjectStoryboard.create(name: StoryboardNames.navigation, bundle: nil, container: assembler.resolver)
        let rootViewController = storyboard.instantiateInitialViewController()

        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        return true
    }

    // MARK: - Public static

    static func getAssembler() -> Assembler {
        return (UIApplication.shared.delegate as! AppDelegate).assembler
    }
}
