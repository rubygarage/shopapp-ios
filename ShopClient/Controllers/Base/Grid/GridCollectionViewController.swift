//
//  GridViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll

class GridCollectionViewController: UIViewController, GridCollectionDataSourceProtocol, GridCollectionDelegateProtocol {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionDataSource: GridCollectionDataSource?
    var collectionDelegate: GridCollectionDelegate?
    var products = [Product]()
    var refreshControl: UIRefreshControl?
    var paginationValue: Any?
    var canLoadMore = true
    
    // MARK: - view controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupPullToRefresh()
        setupInfinityScroll()
    }
    
    // MARK: - setup
    private func setupCollectionView() {
        let nib = UINib(nibName: String(describing: GridCollectionViewCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: String(describing: GridCollectionViewCell.self))
        
        collectionDataSource = GridCollectionDataSource(delegate: self)
        collectionView.dataSource = collectionDataSource
        
        collectionDelegate = GridCollectionDelegate(delegate: self)
        collectionView.delegate = collectionDelegate
    }
    
    private func setupPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(GridCollectionViewController.pullToRefreshHandler), for: UIControlEvents.valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func setupInfinityScroll() {
        collectionView.setShouldShowInfiniteScrollHandler { [weak self] (collectionView) -> Bool in
            return self?.canLoadMore ?? false
        }
        collectionView.addInfiniteScroll { [weak self] (collectionView) in
            self?.infinityScrollHandler()
        }
    }
    
    public func stopLoadAnimating() {
        refreshControl?.endRefreshing()
        collectionView.finishInfiniteScroll()
    }
    
    // MARK: - methods to override
    public func pullToRefreshHandler() {
        assert(false, "'pulltoRefreshHandler' method not implemented")
    }
    
    public func infinityScrollHandler() {
        assert(false, "'infinityScrollHandler' method not implemented")
    }
    
    // MARK: - override
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
    }
    
    // MARK: - GridCollectionDataSourceProtocol
    func numberOfItems() -> Int {
        return products.count
    }
    
    func item(for indexPath: IndexPath) -> Product {
        return products[indexPath.row]
    }
    
    // MARK: - GridCollectionDelegateProtocol
    func didSelectItem(at index: Int) {
        if index < products.count {
            let product = products[index]
            pushDetailController(with: product)
        }
    }
}
