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

class HomeViewController: BaseViewController<HomeViewModel>, HomeTableDataSourceProtocol, HomeTableDelegateProtocol, LastArrivalsCellDelegate, PopularCellDelegate, SeeAllHeaderViewProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: HomeTableDataSource?
    private var delegate: HomeTableDelegate?
    
    override func viewDidLoad() {
        viewModel = HomeViewModel()
        super.viewDidLoad()
        
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavigationBar()
    }
    
    private func updateNavigationBar() {
        navigationItem.title = NSLocalizedString("ControllerTitle.Home", comment: String())
        updateCartBarItem()
    }
    
    private func setupTableView() {
        let lastArrivalsNib = UINib(nibName: String(describing: LastArrivalsTableViewCell.self), bundle: nil)
        tableView?.register(lastArrivalsNib, forCellReuseIdentifier: String(describing: LastArrivalsTableViewCell.self))
        
        let popularNib = UINib(nibName: String(describing: PopularTableViewCell.self), bundle: nil)
        tableView?.register(popularNib, forCellReuseIdentifier: String(describing: PopularTableViewCell.self))
        
        let newInBlogNib = UINib(nibName: String(describing: ArticleTableViewCell.self), bundle: nil)
        tableView?.register(newInBlogNib, forCellReuseIdentifier: String(describing: ArticleTableViewCell.self))
                
        dataSource = HomeTableDataSource(delegate: self)
        tableView?.dataSource = dataSource
        
        delegate = HomeTableDelegate(delegate: self)
        tableView?.delegate = delegate
        
        tableView?.contentInset = TableView.defaultContentInsets
    }
    
    private func updateCartBarItem() {
        viewModel.getCartItemsCount()
    }
    
    private func setupViewModel() {
        viewModel.data.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.cartItemsCount.asObservable()
            .subscribe(onNext: { [weak self] cartItemsCount in
                self?.addCartBarButton(with: cartItemsCount)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadData(with: disposeBag)
    }
    
    // MARK: - HomeTableDataSourceProtocol
    func lastArrivalsObjects() -> [Product] {
        return viewModel.data.value.latestProducts
    }
    
    func popularObjects() -> [Product] {
        return viewModel.data.value.popularProducts
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
    
    // MARK: - LastArrivalsCellDelegate
    func didSelectLastArrivalsProduct(at index: Int) {
        openProductDetails(with: viewModel.data.value.latestProducts, index: index)
    }
    
    // MARK: - PopularCellDelegate
    func didSelectPopularProduct(at index: Int) {
        openProductDetails(with: viewModel.data.value.popularProducts, index: index)
    }
    
    private func openProductDetails(with products: [Product], index: Int) {
        if index < products.count {
            let selectedProduct = products[index]
            pushDetailController(with: selectedProduct)
        }
    }
    
    // MARK: - SeeAllHeaderViewProtocol
    func didTapSeeAll(type: SeeAllViewType) {
        switch type {
        case .latestArrivals:
            let title = NSLocalizedString("ControllerTitle.LatestArrivals", comment: String())
            pushProductsListController(with: title, sortingValue: .createdAt)
        case .popular:
            let title = NSLocalizedString("ControllerTitle.Popular", comment: String())
            pushProductsListController(with: title, sortingValue: .popular)
        case .blogPosts:
            pushArticlesListController()
        default:
            return
        }
    }
    
    // MARK: - ErrorViewProtocol
    func didTapTryAgain() {
        viewModel.loadData(with: disposeBag)
    }
}
