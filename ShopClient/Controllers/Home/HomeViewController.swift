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

class HomeViewController: UIViewController, HomeTableDataSourceProtocol, HomeTableDelegateProtocol, LastArrivalsCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var homeViewModel = HomeViewModel()
    var disposeBag = DisposeBag()
    
    var dataSource: HomeTableDataSource?
    var delegate: HomeTableDelegate?
    
    var lastArrivalsProducts = [Product]()
    var newInBlogArticles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        setupSideMenu()
        addMenuBarButton()
        addSearchButton()
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
    
    private func addSearchButton() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(HomeViewController.seachButtonHandler))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc private func seachButtonHandler() {
        pushSearchController()
    }
    
    private func loadData() {
        homeViewModel.data.subscribe(onSuccess: { [weak self] (products, articles) in
            if let items = products {
                self?.lastArrivalsProducts = items
            }
            if let items = articles {
                self?.newInBlogArticles = items
            }
            self?.tableView.reloadData()
        }, onError: { [weak self] (error) in
            self?.showErrorAlert(with: error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - override
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        tableView.reloadData()
    }
    
    // MARK: - HomeTableDataSourceProtocol
    func lastArrivalsObjects() -> [Product] {
        return lastArrivalsProducts
    }
    
    func didSelectProduct(at index: Int) {
        if index < lastArrivalsProducts.count {
            let selectedProduct = lastArrivalsProducts[index]
            pushDetailController(with: selectedProduct)
        }
    }
    
    func articlesCount() -> Int {
        return newInBlogArticles.count
    }
    
    func article(at index: Int) -> Article? {
        if index < newInBlogArticles.count {
            return newInBlogArticles[index]
        }
        return nil
    }
    
    // MARK: - HomeTableDelegateProtocol
    func didSelectArticle(at index: Int) {
        if index < newInBlogArticles.count {
            let article = newInBlogArticles[index]
            pushArticleDetailsController(with: article)
        }
    }
    
    func didTapLoadMore() {
        pushArticlesListController()
    }
    
    // MARK: - LastArrivalsCellDelegate
    func didTapLastArrivalsLoadMore() {
        pushLastArrivalsController()
    }
}
