//
//  ArticlesListViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ArticlesListViewController: BaseTableViewController<ArticlesListViewModel>, ArticlesListTableDataSourceProtocol, ArticlesListTableDelegateProtocol {
    private var tableDataSource: ArticlesListTableDataSource?
    private var tableDelegate: ArticlesListTableDelegate?
    private var selectedArticle: Article?
    
    // MARK: - view controller lifecycle
    override func viewDidLoad() {
        viewModel = ArticlesListViewModel()
        super.viewDidLoad()

        setupViews()
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleDetailsViewController = segue.destination as? ArticleDetailsViewController {
            articleDetailsViewController.articleId = selectedArticle!.id
        }
    }
    
    // MARK: - setup
    private func setupViews() {
        title = "ControllerTitle.BlogPosts".localizable
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
            selectedArticle = viewModel.items.value[index]
            performSegue(withIdentifier: SegueIdentifiers.toArticleDetails, sender: self)
        }
    }
    
    // MARK: - ErrorViewProtocol
    func didTapTryAgain() {
        loadData()
    }
}
