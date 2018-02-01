//
//  SearchViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

private let kAnimationDuration: TimeInterval = 0.3

class SearchViewController: GridCollectionViewController<SearchViewModel> {
    @IBOutlet private weak var categoriesCollectionView: UICollectionView!
    
    private let titleView = SearchTitleView()
    
    private var categoriesProvider: SearchCollectionProvider!
    
    fileprivate var selectedCategory: Category?
    
    // MARK: - View controller lifecycle
    
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
        
        navigationController?.removeShadow()
        navigationController?.navigationBar.barTintColor = UIColor.backgroundDefault
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.addShadow()
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let categoryViewController = segue.destination as? CategoryViewController {
            categoryViewController.title = selectedCategory!.title
            categoryViewController.categoryId = selectedCategory!.id
        } else if let productDetailsViewController = segue.destination as? ProductDetailsViewController {
            productDetailsViewController.productId = selectedProduct!.id
        }
    }
    
    // MARK: - Setup
    
    fileprivate func updateCollectionViewsIfNeeded(categoriesViewHidden: Bool) {
        guard categoriesCollectionView.isHidden != categoriesViewHidden else {
            return
        }
        UIView.transition(with: view, duration: kAnimationDuration, options: .transitionCrossDissolve, animations: {
            self.categoriesCollectionView.isHidden = categoriesViewHidden
        })
    }
    
    private func updateNavigationBar() {
        navigationItem.titleView = titleView
        titleView.updateCartBarItem()
    }
    
    private func setupViews() {
        titleView.delegate = self
        
        let cellName = String(describing: CategoryCollectionViewCell.self)
        let nib = UINib(nibName: cellName, bundle: nil)
        categoriesCollectionView.register(nib, forCellWithReuseIdentifier: cellName)
        
        categoriesProvider = SearchCollectionProvider()
        categoriesProvider.delegate = self
        categoriesCollectionView.dataSource = categoriesProvider
        categoriesCollectionView.delegate = categoriesProvider
        
        categoriesCollectionView.contentInset = CategoryCollectionViewCell.collectionViewInsets
    }
    
    private func setupViewModel() {
        titleView.rx.value.map({ $0 ?? "" })
            .bind(to: viewModel.searchPhrase)
            .disposed(by: disposeBag)
        
        viewModel.products.asObservable()
            .subscribe(onNext: { [weak self] products in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.stopLoadAnimating()
                strongSelf.collectionProvider.products = products
                strongSelf.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.categories.asObservable()
            .subscribe(onNext: { [weak self] categories in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.categoriesProvider.categories = categories
                strongSelf.categoriesCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadCategories() {
        viewModel.loadCategories()
    }
    
    private func loadData() {
        viewModel.reloadData()
    }
    
    // MARK: - BasePaginationViewController
    
    override func pullToRefreshHandler() {
        viewModel.reloadData()
    }
    
    override func infinityScrollHandler() {
        viewModel.loadNextPage()
    }
    
    // MARK: - GridCollectionProviderDelegate
    
    override func provider(_ provider: GridCollectionProvider, didSelect product: Product) {
        titleView.endEditing(true)
        super.provider(provider, didSelect: product)
    }
}

// MARK: - SearchCollectionProviderDelegate

extension SearchViewController: SearchCollectionProviderDelegate {
    func provider(_ provider: SearchCollectionProvider, didSelect category: Category) {
        selectedCategory = category
        performSegue(withIdentifier: SegueIdentifiers.toCategory, sender: self)
    }
}

// MARK: - SearchTitleViewDelegate

extension SearchViewController: SearchTitleViewDelegate {
    func viewDidBeginEditing(_ view: SearchTitleView) {
        updateCollectionViewsIfNeeded(categoriesViewHidden: true)
    }
    
    func viewDidChangeSearchPhrase(_ view: SearchTitleView) {
        viewModel.reloadData()
    }
    
    func viewDidTapClear(_ view: SearchTitleView) {
        viewModel.clearResult()
    }
    
    func viewDidTapBack(_ view: SearchTitleView) {
        viewModel.clearResult()
        updateCollectionViewsIfNeeded(categoriesViewHidden: false)
    }
    
    func viewDidTapCart(_ view: SearchTitleView) {
        showCartController()
    }
}
