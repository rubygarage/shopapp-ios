//
//  UIViewControllerBarButtonItems.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/26/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

let kCustomBarItemWidth: CGFloat = 32

extension UIViewController {
    public func searchBarItem() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.seachButtonHandler))
    }
    
    public func cartBarItem(with cartItemsCount: Int) -> UIBarButtonItem {
        let cartView = CartButtonView(frame: CGRect(x: 0, y: 0, width: kCustomBarItemWidth, height: kCustomBarItemWidth))
        cartView.isUserInteractionEnabled = false
        cartView.itemsCount = cartItemsCount
        
        let button = UIButton(frame: cartView.frame)
        button.addSubview(cartView)
        button.addTarget(self, action: #selector(self.cartButtonHandler), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    public func sortBarItem(with action: Selector) -> UIBarButtonItem {
        let image = UIImage(named: ImageName.sort)
        return UIBarButtonItem(image: image, style: .plain, target: self, action: action)
    }
    
    // MARK: - private
    private func addRightBarButton(with imageName: String, action: Selector?) {
        let image = UIImage(named: imageName)
        let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: action)
        navigationItem.rightBarButtonItem = barButton
    }
    
    // MARK: - actions
    @objc private func seachButtonHandler() {
        pushSearchController()
    }
    
    @objc private func cartButtonHandler() {
        pushCartViewController()
    }
}
