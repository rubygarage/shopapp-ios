//
//  UIViewController+Routes.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 9/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import SwinjectStoryboard

extension UIViewController {
    func setHomeController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabbarController = appDelegate.window?.rootViewController as? UITabBarController
        tabbarController?.selectedIndex = 0
        
        if let navigationController = tabbarController?.viewControllers?.first as? NavigationController {
            navigationController.popToRootViewController(animated: false)
        }
    }
    
    func dismissModalStack() {
        var controller = presentingViewController
        while controller?.presentingViewController != nil {
            controller = controller?.presentingViewController
        }
        controller?.dismiss(animated: true)
    }
    
    func showCartController() {
        let storyboard = SwinjectStoryboard.create(name: StoryboardNames.cart, bundle: nil, container: AppDelegate.getAssembler().resolver)
        let cartNavigationController = storyboard.instantiateInitialViewController()!
        present(cartNavigationController, animated: true)
    }
}
