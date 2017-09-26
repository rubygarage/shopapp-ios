//
//  ArticlesListViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ArticlesListViewController: UIViewController, ArticlesListTableDataSourceProtocol, ArticlesListTableDelegateProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    var tableDataSource: ArticlesListTableDataSource?
    var tableDelegate: ArticlesListTableDelegate?
    
    var articles = [Article]()
    var paginationValue: Any?
    var canLoadMore = true
    var refreshControl: UIRefreshControl?
    
    // MARK: - view controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTableView()
        setupPullToRefresh()
        setupInfinityScroll()
        loadRemoteData()
    }
    
    // MARK: - setup
    private func setupViews() {
        title = NSLocalizedString("ControllerTitle.NewInBlog", comment: String())
    }
    
    private func setupTableView() {
        let articleNib = UINib(nibName: String(describing: ArticleTableViewCell.self), bundle: nil)
        tableView.register(articleNib, forCellReuseIdentifier: String(describing: ArticleTableViewCell.self))
        
        tableDataSource = ArticlesListTableDataSource(delegate: self)
        tableView.dataSource = tableDataSource
        
        tableDelegate = ArticlesListTableDelegate(delegate: self)
        tableView.delegate = tableDelegate
    }
    
    private func setupPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(ArticlesListViewController.pullToRefreshHandler), for: UIControlEvents.valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupInfinityScroll() {
        tableView.setShouldShowInfiniteScrollHandler { [weak self] (tableView) -> Bool in
            return self?.canLoadMore ?? false
        }
        tableView.addInfiniteScroll { [weak self] (tableView) in
            self?.infinityScrollHandler()
        }
    }
    
    private func loadRemoteData() {
        ShopCoreAPI.shared.getArticleList(paginationValue: paginationValue, sortBy: SortingValue.createdAt, reverse: true) { [weak self] (articles, error) in
            if let articles = articles {
                self?.updateArticles(with: articles)
                self?.tableView.reloadData()
            }
            self?.canLoadMore = articles?.count ?? 0 == kItemsPerPage
            self?.stopLoadAnimating()
//            self?.tableView.reloadData()
        }
    }
    
    private func updateArticles(with items: [Article]) {
        if paginationValue == nil {
            articles.removeAll()
        }
        articles += items
    }
    
    @objc private func pullToRefreshHandler() {
        paginationValue = nil
        loadRemoteData()
    }
    
    public func infinityScrollHandler() {
        paginationValue = articles.last?.paginationValue
        loadRemoteData()
    }
    
    private func stopLoadAnimating() {
        refreshControl?.endRefreshing()
        tableView.finishInfiniteScroll()
    }
    
    // MARK: - ArticlesListTableDataSourceProtocol
    func articlesCount() -> Int {
        return articles.count
    }
    
    func article(at index: Int) -> Article? {
        if index < articles.count {
            return articles[index]
        }
        return nil
    }
    
    // MARK: - ArticlesListTableDelegateProtocol
}
