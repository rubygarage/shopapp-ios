//
//  ProductOptionsControllerDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

@testable import ShopApp

class ProductOptionsControllerDelegateMock: ProductOptionsControllerDelegate {
    var viewController: ProductOptionsViewController?
    var height: CGFloat?
    var option: SelectedOption?
    
    func viewController(_ viewController: ProductOptionsViewController, didCalculate height: CGFloat) {
        self.viewController = viewController
        self.height = height
    }
    
    func viewController(_ viewController: ProductOptionsViewController, didSelect option: SelectedOption) {
        self.viewController = viewController
        self.option = option
    }
}
