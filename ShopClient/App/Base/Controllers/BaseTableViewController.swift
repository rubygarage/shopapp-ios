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
    
    private func setupPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.pullToRefreshHandler), for: UIControlEvents.valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupInfinityScroll() {
        tableView.setShouldShowInfiniteScrollHandler { [weak self] _ -> Bool in
            return self?.viewModel.canLoadMore ?? false
        }
        tableView.addInfiniteScroll { [weak self] _ in
            self?.infinityScrollHandler()
        }
    }
    
    func stopLoadAnimating() {
        refreshControl?.endRefreshing()
        tableView.finishInfiniteScroll()
    }
}
