//
//  UIViewController+Routes.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

extension UIViewController {
    func setHomeController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabbarController = appDelegate.window?.rootViewController as? UITabBarController
        tabbarController?.selectedIndex = 0
        
        if let navigationController = tabbarController?.viewControllers?.first as? NavigationController {
            navigationController.popToRootViewController(animated: false)
        }
    }
    
    func showCartController() {
        let cartNavigationController = UIStoryboard.cart().instantiateInitialViewController()!
        present(cartNavigationController, animated: true)
    }
}
