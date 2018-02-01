//
//  UIViewControllerImageViewer.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import SKPhotoBrowser

extension UIViewController {
    func pushImageViewer(with product: Product, initialIndex: Int) {
        guard let items = product.images else {
            return
        }
        var images: [SKPhoto] = []
        items.forEach { images.append(SKPhoto.photoWithImageURL($0.src ?? "")) }
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(initialIndex)
        present(browser, animated: true)
    }
}
