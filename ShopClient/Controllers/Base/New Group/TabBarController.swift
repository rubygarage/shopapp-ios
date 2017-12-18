//
//  TabBarController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

private let kBackgroundColor = UIColor(displayP3Red: 0.9765, green: 0.9765, blue: 0.9765, alpha: 0.9)
private let kShadowImageColor = UIColor.black.withAlphaComponent(0.12)

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        UITabBar.appearance().backgroundImage = UIImage.add_image(with: kBackgroundColor)
        UITabBar.appearance().shadowImage = UIImage.add_image(with: kShadowImageColor)
    }
}
