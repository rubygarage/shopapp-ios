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
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let tabbarController = appDelegate.window?.rootViewController as? UITabBarController
        tabbarController?.selectedIndex = 0
    }

    func showCategorySortingController(with items: [String], selectedItem: String, delegate: SortModalControllerProtocol?) {
        let sortController = UIStoryboard.sortModal().instantiateViewController(withIdentifier: ControllerIdentifier.sortModal) as! SortModalViewController
        sortController.sortItems = items
        sortController.selectedSortItem = selectedItem
        sortController.delegate = delegate
        
        sortController.modalPresentationStyle = .overCurrentContext
        sortController.modalTransitionStyle = .crossDissolve
        present(sortController, animated: true)
    }
    
    func showCartController() {
        let cartNavigationController = UIStoryboard.cart().instantiateInitialViewController()!
        present(cartNavigationController, animated: true)
    }
}
