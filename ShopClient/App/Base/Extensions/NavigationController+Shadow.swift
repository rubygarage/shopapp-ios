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
    }
    
    func removeShadow() {
        navigationBar.shadowImage = UIImage()
    }
}
