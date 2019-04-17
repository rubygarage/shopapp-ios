//
//  UIImageView+Network.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/18/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

import SDWebImage
import ShopApp_Gateway

extension UIImageView {
    func set(image remoteImage: Image?, initialContentMode: UIView.ContentMode = .center) {
        let imageUrl = URL(string: remoteImage?.src ?? "")
        let placeholderImage = #imageLiteral(resourceName: "placeholder")
        contentMode = initialContentMode
        image = placeholderImage
        sd_setImage(with: imageUrl, placeholderImage: placeholderImage) { [weak self] (_, error, _, _) in
            if error == nil {
                self?.contentMode = .scaleAspectFit
            }
        }
    }
}
