//
//  NavigationControllerShadow.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import UIImage_Additions

private let kShadowImageColor = UIColor.black.withAlphaComponent(0.12)

extension UINavigationController {
    public func addShadow() {
        navigationBar.shadowImage = UIImage.add_image(with: kShadowImageColor)
    }
    
    public func removeShadow() {
        navigationBar.shadowImage = UIImage()
    }
}
