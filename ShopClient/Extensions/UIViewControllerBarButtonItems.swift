//
//  UIViewControllerBarButtonItems.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/26/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

private let kCustomBarItemWidth: CGFloat = 32

extension UIViewController {    
    public func addCartBarButton(with itemsCount: Int) {
        if let tabController = tabBarController {
            tabController.navigationItem.rightBarButtonItem = cartBarItem(with: itemsCount)
        } else {
            navigationItem.rightBarButtonItem = cartBarItem(with: itemsCount)
        }
    }
    
    public func addBackButtonIfNeeded() {
        if navigationController?.viewControllers.first != self {
            navigationItem.leftBarButtonItem = backButton()
        }
    }
    
    public func addCloseButton() {
        navigationItem.rightBarButtonItem = closeButton()
    }
    
    public func sortBarItem(with action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "sort"), style: .plain, target: self, action: action)
    }
    
    // MARK: - private
    private func cartBarItem(with cartItemsCount: Int) -> UIBarButtonItem {
        let cartView = CartButtonView(frame: CGRect(x: 0, y: 0, width: kCustomBarItemWidth, height: kCustomBarItemWidth))
        cartView.isUserInteractionEnabled = false
        cartView.itemsCount = cartItemsCount
        
        let button = UIButton(frame: cartView.frame)
        button.addSubview(cartView)
        button.addTarget(self, action: #selector(self.cartButtonHandler), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    private func backButton() -> UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "arrow_left"), style: .plain, target: self, action: #selector(self.backButtonHandler))
    }
    
    private func closeButton() -> UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "cross"), style: .plain, target: self, action: #selector(self.closeButtonHandler))
    }
    
    // MARK: - actions
    @objc private func seachButtonHandler() {
        pushSearchController()
    }
    
    @objc private func cartButtonHandler() {
        showCartController()
    }
    
    @objc private func backButtonHandler() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func closeButtonHandler() {
        dismiss(animated: true)
    }
}
