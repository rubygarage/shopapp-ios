//
//  HomeViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController<HomeViewModel>, HomeTableDataSourceProtocol, HomeTableDelegateProtocol, LastArrivalsCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: HomeTableDataSource?
    var delegate: HomeTableDelegate?
    
    override func viewDidLoad() {
        viewModel = HomeViewModel()
        super.viewDidLoad()
        
        setupTitle()
        setupSideMenu()
        addMenuBarButton()
        updateBarItems()
        setupTableView()
        loadData()
    }
    
    private func setupTitle() {
        title = NSLocalizedString("ControllerTitle.Home", comment: String())
    }
    
    private func setupTableView() {
        let lastArrivalsNib = UINib(nibName: String(describing: LastArrivalsTableViewCell.self), bundle: nil)
        tableView.register(lastArrivalsNib, forCellReuseIdentifier: String(describing: LastArrivalsTableViewCell.self))
        
        let newInBlogNib = UINib(nibName: String(describing: ArticleTableViewCell.self), bundle: nil)
        tableView.register(newInBlogNib, forCellReuseIdentifier: String(describing: ArticleTableViewCell.self))
        
        let newInBlogLoadMoreNib = UINib(nibName: String(describing: ArticleLoadMoreCell.self), bundle: nil)
        tableView.register(newInBlogLoadMoreNib, forCellReuseIdentifier: String(describing: ArticleLoadMoreCell.self))
        
        dataSource = HomeTableDataSource(delegate: self)
        tableView.dataSource = dataSource
        
        delegate = HomeTableDelegate(delegate: self)
        tableView.delegate = delegate
    }
    
    private func updateBarItems() {
        if let cartButton = cartBarItem() {
            navigationItem.rightBarButtonItems = [cartButton, searchBarItem()]
        } else {
            navigationItem.rightBarButtonItem = searchBarItem()
        }
        
    }
    
    private func loadData() {
        viewModel.data.subscribe(onSuccess: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    // MARK: - override
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        tableView.reloadData()
    }
    
    // MARK: - HomeTableDataSourceProtocol
    func lastArrivalsObjects() -> [Product] {
        return viewModel.lastArrivalsProducts.value
    }
    
    func didSelectProduct(at index: Int) {
        if index < viewModel.lastArrivalsProducts.value.count {
            let selectedProduct = viewModel.lastArrivalsProducts.value[index]
            pushDetailController(with: selectedProduct)
        }
    }
    
    func articlesCount() -> Int {
        return viewModel.newInBlogArticles.value.count
    }
    
    func article(at index: Int) -> Article? {
        if index < viewModel.newInBlogArticles.value.count {
            return viewModel.newInBlogArticles.value[index]
        }
        return nil
    }
    
    // MARK: - HomeTableDelegateProtocol
    func didSelectArticle(at index: Int) {
        if index < viewModel.newInBlogArticles.value.count {
            let article = viewModel.newInBlogArticles.value[index]
            pushArticleDetailsController(with: article.id)
        }
    }
    
    func didTapLoadMore() {
        pushArticlesListController()
    }
    
    // MARK: - LastArrivalsCellDelegate
    func didTapLastArrivalsLoadMore() {
        pushLastArrivalsController()
    }
    
    // MARK: - ErrorViewProtocol
    func didTapTryAgain() {
        loadData()
    }
}
