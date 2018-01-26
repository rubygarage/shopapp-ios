//
//  UIViewController+BarButtonItems.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/26/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

private let kCustomBarItemWidth: CGFloat = 32

extension UIViewController {
    func addCartBarButton() {
        navigationItem.rightBarButtonItem = cartBarItem()
    }
    
    func addBackButtonIfNeeded() {
        if navigationController?.viewControllers.first != self {
            navigationItem.leftBarButtonItem = backButton()
        }
    }
    
    func addCloseButton() {
        navigationItem.rightBarButtonItem = closeButton()
    }
    
    private func cartBarItem() -> UIBarButtonItem {
        let cartView = CartButtonView(frame: CGRect(x: 0, y: 0, width: kCustomBarItemWidth, height: kCustomBarItemWidth))
        cartView.isUserInteractionEnabled = false
        
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
    
    // MARK: - Actions
    
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
