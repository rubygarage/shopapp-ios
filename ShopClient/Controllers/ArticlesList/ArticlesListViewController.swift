//
//  ArticlesListViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ArticlesListViewController: BaseTableViewController<ArticlesListViewModel>, ArticlesListTableDataSourceProtocol, ArticlesListTableDelegateProtocol {
    var tableDataSource: ArticlesListTableDataSource?
    var tableDelegate: ArticlesListTableDelegate?
    
    // MARK: - view controller lifecycle
    override func viewDidLoad() {
        viewModel = ArticlesListViewModel()
        super.viewDidLoad()

        setupViews()
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    // MARK: - setup
    private func setupViews() {
        title = NSLocalizedString("ControllerTitle.NewInBlog", comment: String())
    }
    
    private func setupViewModel() {
        viewModel?.items.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.stopLoadAnimating()
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)        
    }
    
    private func loadData() {
        viewModel.reloadData()
    }
    
    private func setupTableView() {
        let articleNib = UINib(nibName: String(describing: ArticleTableViewCell.self), bundle: nil)
        tableView.register(articleNib, forCellReuseIdentifier: String(describing: ArticleTableViewCell.self))
        
        tableDataSource = ArticlesListTableDataSource(delegate: self)
        tableView.dataSource = tableDataSource
        
        tableDelegate = ArticlesListTableDelegate(delegate: self)
        tableView.delegate = tableDelegate
    }
    
    override func pullToRefreshHandler() {
        viewModel.reloadData()
    }
    
    override func infinityScrollHandler() {
        viewModel.loadNextPage()
    }
    
    // MARK: - ArticlesListTableDataSourceProtocol
    func articlesCount() -> Int {
        return viewModel.items.value.count
    }
    
    func article(at index: Int) -> Article? {
        if index < viewModel.items.value.count {
            return viewModel.items.value[index]
        }
        return nil
    }
    
    // MARK: - ArticlesListTableDelegateProtocol
    func didSelectItem(at index: Int) {
        if index < viewModel.items.value.count {
            let article = viewModel.items.value[index]
            pushArticleDetailsController(with: article.id)
        }
    }
    
    // MARK: - ErrorViewProtocol
    func didTapTryAgain() {
        loadData()
    }
}
