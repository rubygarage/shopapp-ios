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
        
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCartBarItem()
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
    
    private func updateCartBarItem() {
        Repository.shared.getCartProductList { [weak self] (products, error) in
            let cartItemsCount = products?.count ?? 0
            self?.addCartBarButton(with: cartItemsCount)
        }
    }
    
    private func setupViewModel() {
        viewModel.data.asObservable().subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
            self?.updateCartBarItem()
        }).disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadData(with: disposeBag)
    }
    
    // MARK: - override
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        tableView.reloadData()
    }
    
    // MARK: - HomeTableDataSourceProtocol
    func lastArrivalsObjects() -> [Product] {
        return viewModel.data.value.products
    }
    
    func didSelectProduct(at index: Int) {
        if index < viewModel.data.value.products.count {
            let selectedProduct = viewModel.data.value.products[index]
            pushDetailController(with: selectedProduct)
        }
    }
    
    func articlesCount() -> Int {
        return viewModel.data.value.articles.count
    }
    
    func article(at index: Int) -> Article? {
        if index < viewModel.data.value.articles.count {
            return viewModel.data.value.articles[index]
        }
        return nil
    }
    
    // MARK: - HomeTableDelegateProtocol
    func didSelectArticle(at index: Int) {
        if index < viewModel.data.value.articles.count {
            let article = viewModel.data.value.articles[index]
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
        viewModel.loadData(with: disposeBag)
    }
}
