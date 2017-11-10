//
//  UIViewShadow.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/9/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow() {
        layer.shadowColor = Layer.shadowColor
        layer.shadowOpacity = Layer.shadowOpacity
        layer.shadowOffset = Layer.shadowOffset
        layer.shadowRadius = Layer.shadowRadius
    }
}
