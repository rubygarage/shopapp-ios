//
//  BaseCollectionViewViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/1/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class BaseCollectionViewController<T: BasePaginationViewModel>: BasePaginationViewController<T> {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPullToRefresh()
        setupInfinityScroll()
    }
    
    private func setupPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.pullToRefreshHandler), for: UIControlEvents.valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func setupInfinityScroll() {
        collectionView.setShouldShowInfiniteScrollHandler { [weak self] (_) -> Bool in
            return self?.viewModel.canLoadMore ?? false
        }
        collectionView.addInfiniteScroll { [weak self] _ in
            self?.infinityScrollHandler()
        }
    }
    
    public func stopLoadAnimating() {
        refreshControl?.endRefreshing()
        collectionView.finishInfiniteScroll()
    }
}
