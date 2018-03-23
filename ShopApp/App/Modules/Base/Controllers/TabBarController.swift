//
//  TabBarController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        UITabBar.appearance().backgroundImage = UIImage.add_image(with: Colors.barBackground)
        UITabBar.appearance().shadowImage = UIImage.add_image(with: Colors.shadowImage)
    }
}
