//
//  NavigationController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        navigationBar.tintColor = UIColor.black
    }
}
