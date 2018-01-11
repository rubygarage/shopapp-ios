//
//  UIViewControllerRoutes.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

extension UIViewController {

    // MARK: - set
    func setHomeController() {
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let navigationController = appDelegate.window?.rootViewController as? NavigationController
        let tabbarController = navigationController?.viewControllers.first as? UITabBarController
        tabbarController?.selectedIndex = 0
    }
    
    // MARK: - present
    func showCategorySortingController(with items:[String], selectedItem: String, delegate: SortModalControllerProtocol?) {
        let sortController = UIStoryboard.sortModal().instantiateViewController(withIdentifier: ControllerIdentifier.sortModal) as! SortModalViewController
        sortController.sortItems = items
        sortController.selectedSortItem = selectedItem
        sortController.delegate = delegate
        
        sortController.modalPresentationStyle = .overCurrentContext
        sortController.modalTransitionStyle = .crossDissolve
        present(sortController, animated: true)
    }
    
    func showCartController() {
        let cartController = UIStoryboard.cart().instantiateViewController(withIdentifier: ControllerIdentifier.cart)
        showNavigationController(with: cartController)
    }
    
    func showCheckoutController() {
        let checkoutController = UIStoryboard.checkout().instantiateViewController(withIdentifier: ControllerIdentifier.checkout)
        showNavigationController(with: checkoutController)
    }
    
    // MARK: - private
    private func showNavigationController(with rootController: UIViewController) {
        let navigationController = NavigationController(rootViewController: rootController)
        present(navigationController, animated: true)
    }
}
