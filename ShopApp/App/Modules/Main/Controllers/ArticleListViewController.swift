//
//  ArticleListViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

class ArticleListViewController: BaseTableViewController<ArticleListViewModel>, ArticleListTableProviderDelegate {
    fileprivate var selectedArticle: Article?
    
    var tableProvider: ArticleListTableProvider!
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
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
    
    // MARK: - Setup
    
    private func setupViews() {
        title = "ControllerTitle.BlogPosts".localizable
    }
    
    private func setupViewModel() {
        viewModel.items.asObservable()
            .subscribe(onNext: { [weak self] articles in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.stopLoadAnimating()
                strongSelf.tableProvider.articles = articles
                strongSelf.tableView.reloadData()
            })
            .disposed(by: disposeBag)        
    }
    
    private func loadData() {
        viewModel.reloadData()
    }
    
    private func setupTableView() {
        tableView.registerNibForCell(ArticleTableViewCell.self)
        
        tableProvider.delegate = self
        tableView.dataSource = tableProvider
        tableView.delegate = tableProvider
    }
    
    // MARK: - BasePaginationViewController
    
    override func pullToRefreshHandler() {
        viewModel.reloadData()
    }
    
    override func infinityScrollHandler() {
        viewModel.loadNextPage()
    }

    // MARK: - ArticleListTableProviderDelegate

    func provider(_ provider: ArticleListTableProvider, didSelect article: Article) {
        selectedArticle = article
        performSegue(withIdentifier: SegueIdentifiers.toArticleDetails, sender: self)
    }
}
