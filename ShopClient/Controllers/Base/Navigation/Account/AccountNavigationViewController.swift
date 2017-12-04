//
//  AccountNavigationViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/4/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class AccountNavigationViewController: BaseNavigationViewController {
    override func rootViewController() -> UIViewController {
        let rootController = UIStoryboard.account().instantiateViewController(withIdentifier: ControllerIdentifier.account)
        rootController.title = NSLocalizedString("ControllerTitle.Account", comment: String())
        return rootController
    }
}
