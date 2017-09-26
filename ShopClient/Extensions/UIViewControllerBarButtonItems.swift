//
//  UIViewControllerBarButtonItems.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/26/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

extension UIViewController {
    public func addRightBarButton(with imageName: String, action: Selector?) {
        let image = UIImage(named: imageName)
        let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: action)
        navigationItem.rightBarButtonItem = barButton
    }
}
