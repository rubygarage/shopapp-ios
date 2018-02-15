//
//  NavigationController+Shadow.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import UIImage_Additions

private let kShadowImageColor = UIColor.black.withAlphaComponent(0.12)

extension UINavigationController {
    func addShadow() {
        navigationBar.shadowImage = UIImage.add_image(with: kShadowImageColor)
        navigationBar.setBackgroundImage(UIImage.add_image(with: UIColor.white), for: .default)
        navigationBar.isTranslucent = false
    }
    
    func removeShadow() {
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}
