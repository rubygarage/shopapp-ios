//
//  UIViewControllerChilds.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/13/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

extension UIViewController {
    func configureChildViewController(childController: UIViewController, onView: UIView?) {
        self.removeChildController(childController: childController)
        var holderView = self.view
        if let onView = onView {
            holderView = onView
        }
        self.addChildViewController(childController)
        childController.view.frame = onView!.bounds
        if let subviews = holderView?.subviews {
            for subview in subviews {
                subview.removeFromSuperview()
            }
        }
        holderView?.addSubview(childController.view)
        childController.didMove(toParentViewController: self)
    }
    
    func removeChildController(childController: UIViewController) {
        childController.willMove(toParentViewController: self)
        childController.view.removeFromSuperview()
        childController.removeFromParentViewController()
    }
}
