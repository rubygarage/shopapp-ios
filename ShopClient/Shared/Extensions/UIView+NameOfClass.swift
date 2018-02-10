//
//  UIView+NameOfClass.swift
//  ShopClient
//
//  Created by Mykola Voronin on 2/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

extension UIView {
    static var nameOfClass: String {
        return String(describing: self)
    }

    var nameOfClass: String {
        return String(describing: self)
    }
}
