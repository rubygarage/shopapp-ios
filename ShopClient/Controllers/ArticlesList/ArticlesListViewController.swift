//
//  ArticlesListViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ArticlesListViewController: BaseTableViewController, ArticlesListTableDataSourceProtocol, ArticlesListTableDelegateProtocol {
    var tableDataSource: ArticlesListTableDataSource?
    var tableDelegate: ArticlesListTableDelegate?
    
    var articles = [Article]()
    
    // MARK: - view controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTableView()
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
    
    private func loadRemoteData() {
        Repository.shared.getArticleList(paginationValue: paginationValue, sortBy: SortingValue.createdAt, reverse: true) { [weak self] (articles, error) in
            if let articles = articles {
                self?.updateArticles(with: articles)
                self?.tableView.reloadData()
            }
            self?.canLoadMore = articles?.count ?? 0 == kItemsPerPage
            self?.stopLoadAnimating()
        }
    }
    
    private func updateArticles(with items: [Article]) {
        if paginationValue == nil {
            articles.removeAll()
        }
        articles += items
    }
    
    override func pullToRefreshHandler() {
        paginationValue = nil
        loadRemoteData()
    }
    
    override func infinityScrollHandler() {
        paginationValue = articles.last?.paginationValue
        loadRemoteData()
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
    func didSelectItem(at index: Int) {
        if index < articles.count {
            let article = articles[index]
            pushArticleDetailsController(with: article)
        }
    }
}
