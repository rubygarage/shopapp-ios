//
//  NavigationController+Shadow.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import UIImage_Additions

extension UINavigationController {
    func addShadow() {
        navigationBar.shadowImage = UIImage.add_image(with: Colors.shadowImage)
        navigationBar.setBackgroundImage(UIImage.add_image(with: .white), for: .default)
        navigationBar.isTranslucent = false
    }
    
    func removeShadow() {
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}
