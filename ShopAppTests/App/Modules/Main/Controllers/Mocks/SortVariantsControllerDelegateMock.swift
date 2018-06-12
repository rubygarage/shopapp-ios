//
//  SortVariantsControllerDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

import ShopApp_Gateway

@testable import ShopApp

class SortVariantsControllerDelegateMock: NSObject, SortVariantsControllerDelegate {
    var viewController: SortVariantsViewController?
    var sortType: SortType?
    
    // MARK: - SortVariantsControllerDelegate
    
    func viewController(_ viewController: SortVariantsViewController, didSelect sortType: SortType) {
        self.viewController = viewController
        self.sortType = sortType
    }
}
