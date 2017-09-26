//
//  UIViewControllerSideMenu.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/18/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import SideMenu

extension UIViewController {
    public func setupSideMenu() {
        let menuController = UIStoryboard.menu().instantiateViewController(withIdentifier: ControllerIdentifier.menu) as! MenuViewController

        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: menuController)
        menuLeftNavigationController.leftSide = true

        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController

        if let navController = navigationController {
            SideMenuManager.menuAddPanGestureToPresent(toView: navController.navigationBar)
            SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: navController.view, forMenu: UIRectEdge.left)
        }
    }
    
    public func addMenuBarButton() {
        let menuButton = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(UIViewController.menuButtonHandler))
        navigationItem.leftBarButtonItem = menuButton
    }
    
    @objc private func menuButtonHandler() {
        if let menuController = SideMenuManager.menuLeftNavigationController {
            present(menuController, animated: true)
        }
    }
}
