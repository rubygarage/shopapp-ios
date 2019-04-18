//
//  BasePaginationViewController.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 10/31/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class BasePaginationViewController<T: BasePaginationViewModel>: BaseViewController<T> {
    var refreshControl: UIRefreshControl?
    
    // MARK: - Methods to override
    
    @objc func pullToRefreshHandler() {
        assert(false, "'pulltoRefreshHandler' method not implemented")
    }
    
    func infinityScrollHandler() {
        assert(false, "'infinityScrollHandler' method not implemented")
    }
}
