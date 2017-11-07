//
//  UIViewControllerBarButtonItems.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/26/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

extension UIViewController {
    public func searchBarItem() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.seachButtonHandler))
    }
    
    public func cartBarItem() -> UIBarButtonItem? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.backgroundColor = UIColor.red
        view.isUserInteractionEnabled = false
        
        let button = UIButton(frame: view.frame)
        button.addSubview(view)
        button.addTarget(self, action: #selector(self.cartButtonHandler), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    public func addRightBarButton(with imageName: String, action: Selector?) {
        let image = UIImage(named: imageName)
        let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: action)
        navigationItem.rightBarButtonItem = barButton
    }
    
    public func addCartBarButtonIfNeeded(action: Selector?) {
        if let cartButton = cartBarItem() {
            navigationItem.backBarButtonItem = cartButton
        }
    }
    
    // MARK: - actions
    @objc private func seachButtonHandler() {
        pushSearchController()
    }
    
    @objc private func cartButtonHandler() {
        // TODO:
    }
}
