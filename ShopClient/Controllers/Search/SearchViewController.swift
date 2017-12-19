//
//  SearchViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

private let kAnimationDuration: TimeInterval = 0.3

class SearchViewController: GridCollectionViewController<SearchViewModel>, SearchTitleViewProtocol, SearchCollectionDataSourceProtocol {
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    let titleView = SearchTitleView()
    var categoriesDataSource: SearchCollectionDataSource!
    var categoriesDelegate: SearchCollectionDelegate!
    
    override func viewDidLoad() {
        viewModel = SearchViewModel()
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
        loadCategories()
        collectionView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavigationBar()
        
        tabBarController?.navigationController?.removeShadow()
        tabBarController?.navigationController?.navigationBar.barTintColor = UIColor.backgroundDefault
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.navigationController?.addShadow()
        tabBarController?.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    private func updateNavigationBar() {
        tabBarController?.navigationItem.rightBarButtonItem = nil
        tabBarController?.navigationItem.titleView = titleView
        
        Repository.shared.getCartProductList { [weak self] (products, error) in
            let cartItemsCount = products?.count ?? 0
            self?.titleView.cartItemsCount = cartItemsCount
        }
    }
    
    private func setupViews() {
        titleView.delegate = self
        
        let nib = UINib(nibName: String(describing: CategoryCollectionViewCell.self), bundle: nil)
        categoriesCollectionView.register(nib, forCellWithReuseIdentifier: String(describing: CategoryCollectionViewCell.self))
        
        categoriesDataSource = SearchCollectionDataSource(delegate: self)
        categoriesCollectionView.dataSource = categoriesDataSource
        
        categoriesDelegate = SearchCollectionDelegate()
        categoriesCollectionView.delegate = categoriesDelegate
        
        categoriesCollectionView.contentInset = CategoryCollectionViewCell.collectionViewInsets
    }
    
    private func setupViewModel() {
        titleView.searchTextField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.searchPhrase)
            .disposed(by: disposeBag)
        
        viewModel.products.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.stopLoadAnimating()
                self?.collectionView.reloadData()
                self?.updateCollectionViewsIfNeeded(categoriesViewHidden: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.categories.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.categoriesCollectionView.reloadData()
                self?.updateCollectionViewsIfNeeded(categoriesViewHidden: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadCategories() {
        viewModel.loadCategories()
    }
    
    private func loadData() {
        viewModel.reloadData()
    }
    
    private func updateCollectionViewsIfNeeded(categoriesViewHidden: Bool) {
        if categoriesCollectionView.isHidden != categoriesViewHidden {
            UIView.transition(with: view, duration: kAnimationDuration, options: .transitionCrossDissolve, animations: {
                self.categoriesCollectionView.isHidden = categoriesViewHidden
                self.collectionView.isHidden = !categoriesViewHidden
            })
        }
    }
    
    // MARK: - overriding
    override func pullToRefreshHandler() {
        viewModel.reloadData()
    }
    
    override func infinityScrollHandler() {
        viewModel.loadNextPage()
    }
    
    override func didSelectItem(at index: Int) {
        titleView.endEditing(true)
        super.didSelectItem(at: index)
    }
    
    // MARK: - SearchTitleViewProtocol
    func didTapSearch() {
        viewModel.reloadData()
    }
    
    func didTapCart() {
        showCartController()
    }
    
    func didTapBack() {
        viewModel.clearResult()
        updateCollectionViewsIfNeeded(categoriesViewHidden: false)
    }
    
    func didStartEditing() {
        updateCollectionViewsIfNeeded(categoriesViewHidden: true)
    }
    
    // MARK: - SearchCollectionDataSourceProtocol
    func categoriesCount() -> Int {
        return viewModel.categoriesCount()
    }
    
    func category(at index: Int) -> Category {
        return viewModel.category(at: index)
    }
    
    // MARK: - ErrorViewProtocol
    func didTapTryAgain() {
        loadData()
    }
}
