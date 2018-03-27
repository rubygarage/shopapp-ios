//
//  HomeViewController.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 9/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import ShopApp_Gateway

class HomeViewController: BaseTableViewController<HomeViewModel>, HomeTableProviderDelegate, LastArrivalsTableCellDelegate, PopularTableCellDelegate, SeeAllHeaderViewDelegate {
    private var destinationTitle: String!
    private var sortingValue: SortingValue!
    private var selectedProduct: Product?
    private var selectedArticle: Article?
    
    var tableProvider: HomeTableProvider!
    
    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavigationBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productListViewController = segue.destination as? ProductListViewController {
            productListViewController.title = destinationTitle
            productListViewController.sortingValue = sortingValue
            destinationTitle = nil
        } else if let productDetailsViewController = segue.destination as? ProductDetailsViewController {
            productDetailsViewController.productId = selectedProduct!.id
        } else if let articleDetailsViewController = segue.destination as? ArticleDetailsViewController {
            articleDetailsViewController.articleId = selectedArticle!.id
        }
    }
    
    // MARK: - Setup
    
    fileprivate func openProductDetails(with product: Product) {
        selectedProduct = product
        performSegue(withIdentifier: SegueIdentifiers.toProductDetails, sender: self)
    }
    
    private func updateNavigationBar() {
        navigationItem.title = "ControllerTitle.Home".localizable
        addCartBarButton()
    }
    
    private func setupTableView() {
        tableView.registerNibForCell(LastArrivalsTableViewCell.self)
        tableView.registerNibForCell(PopularTableViewCell.self)
        tableView.registerNibForCell(ArticleTableViewCell.self)
                
        tableProvider.delegate = self
        tableView.dataSource = tableProvider
        tableView.delegate = tableProvider
        
        tableView.contentInset = TableView.defaultContentInsets
    }
    
    private func setupViewModel() {
        viewModel.data.asObservable()
            .subscribe(onNext: { [weak self] (latestProduct, popularProducts, articles) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.stopLoadAnimating()
                strongSelf.tableProvider.lastArrivalsProducts = latestProduct
                strongSelf.tableProvider.popularProducts = popularProducts
                strongSelf.tableProvider.articles = articles
                strongSelf.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadData()
    }
    
    // MARK: - BasePaginationViewController
    
    override func pullToRefreshHandler() {
        loadData()
    }
    
    // MARK: - HomeTableProviderDelegate
    
    func provider(_ provider: HomeTableProvider, didSelect article: Article) {
        selectedArticle = article
        performSegue(withIdentifier: SegueIdentifiers.toArticleDetails, sender: self)
    }
    
    // MARK: - LastArrivalsTableViewCellDelegate
    
    func tableViewCell(_ tableViewCell: LastArrivalsTableViewCell, didSelect product: Product) {
        openProductDetails(with: product)
    }
    
    // MARK: - PopularTableViewCellDelegate
    
    func tableViewCell(_ tableViewCell: PopularTableViewCell, didSelect product: Product) {
        openProductDetails(with: product)
    }
    
    // MARK: - SeeAllHeaderViewDelegate
    
    func headerView(_ headerView: SeeAllTableHeaderView, didTapSeeAll type: SeeAllViewType) {
        switch type {
        case .latestArrivals:
            destinationTitle = "ControllerTitle.LatestArrivals".localizable
            sortingValue = .createdAt
            performSegue(withIdentifier: SegueIdentifiers.toProductList, sender: self)
        case .blogPosts:
            performSegue(withIdentifier: SegueIdentifiers.toArticlesList, sender: self)
        default:
            return
        }
    }
}
