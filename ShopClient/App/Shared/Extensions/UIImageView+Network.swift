//
//  UIImageView+Network.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/18/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

import SDWebImage

extension UIImageView {
    func set(image: Image?, initialContentMode: UIViewContentMode = .center) {
        let imageUrl = URL(string: image?.src ?? "")
        let placeholderImage = UIImage(named: "placeholder")
        contentMode = initialContentMode
        self.image = placeholderImage
        sd_setImage(with: imageUrl, placeholderImage: placeholderImage) { [weak self] (_, error, _, _) in
            if error == nil {
                self?.contentMode = .scaleAspectFit
            }
        }
    }
}
