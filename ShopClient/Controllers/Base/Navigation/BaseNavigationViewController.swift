//
//  BaseNavigationViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/4/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        viewControllers.append(rootViewController())
    }
    
    // MARK: - method to override
    func rootViewController() -> UIViewController {
        assert(false, "rootViewController method not implemented")
    }
}
