//
//  BasePaginationViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/31/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class BasePaginationViewController: UIViewController {
    var paginationValue: Any?
    var canLoadMore = true
    var refreshControl: UIRefreshControl?
    
    // MARK: - methods to override
    public func pullToRefreshHandler() {
        assert(false, "'pulltoRefreshHandler' method not implemented")
    }
    
    public func infinityScrollHandler() {
        assert(false, "'infinityScrollHandler' method not implemented")
    }
}
