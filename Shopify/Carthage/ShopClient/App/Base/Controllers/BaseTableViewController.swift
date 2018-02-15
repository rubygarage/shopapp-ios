//
//  BaseTableViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/1/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class BaseTableViewController<T: BasePaginationViewModel>: BasePaginationViewController<T> {
    // swiftlint:disable private_outlet
    @IBOutlet private(set) weak var tableView: UITableView!
    // swiftlint:enable private_outlet
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPullToRefresh()
        setupInfinityScroll()
    }
    
    // MARK: - Setup
    
    func stopLoadAnimating() {
        refreshControl?.endRefreshing()
        tableView.finishInfiniteScroll()
    }
    
    private func setupPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(pullToRefreshHandler), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupInfinityScroll() {
        tableView.setShouldShowInfiniteScrollHandler { [weak self] _ -> Bool in
            guard let strongSelf = self else {
                return false
            }
            return strongSelf.viewModel.canLoadMore
        }
        tableView.addInfiniteScroll { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.infinityScrollHandler()
        }
    }
}
