//
//  CategoryListControllerDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

import ShopApp_Gateway

@testable import ShopApp

class CategoryListControllerDelegateMock: NSObject, CategoryListControllerDelegate {
    var viewController: CategoryListViewController?
    var category: ShopApp_Gateway.Category?
    
    // MARK: - CategoryListControllerDelegate
    
    func viewController(_ viewController: CategoryListViewController, didSelect category: ShopApp_Gateway.Category) {
        self.viewController = viewController
        self.category = category
    }
}
