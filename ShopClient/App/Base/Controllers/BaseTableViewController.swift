//
//  BaseTableViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/1/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class BaseTableViewController<T: BasePaginationViewModel>: BasePaginationViewController<T> {
    @IBOutlet weak var tableView: UITableView!
    
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
