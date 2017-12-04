//
//  SearchNavigationViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/4/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class SearchNavigationViewController: BaseNavigationViewController {
    override func rootViewController() -> UIViewController {
        return UIStoryboard.search().instantiateViewController(withIdentifier: ControllerIdentifier.search)
    }
}
