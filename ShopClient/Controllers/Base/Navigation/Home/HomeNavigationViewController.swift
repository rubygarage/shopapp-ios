//
//  HomeNavigationViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/4/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class HomeNavigationViewController: BaseNavigationViewController {
    override func rootViewController() -> UIViewController {
        let rootController = UIStoryboard.home().instantiateViewController(withIdentifier: ControllerIdentifier.home)
        rootController.title = NSLocalizedString("ControllerTitle.Home", comment: String())
        return rootController
    }
}
