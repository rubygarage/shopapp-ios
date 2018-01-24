//
//  SearchViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

private let kAnimationDuration: TimeInterval = 0.3

class SearchViewController: GridCollectionViewController<SearchViewModel>, SearchTitleViewProtocol, SearchCollectionDelegateProtocol, SearchCollectionDataSourceProtocol {
    @IBOutlet private weak var categoriesCollectionView: UICollectionView!
    
    private let titleView = SearchTitleView()
    private var categoriesDataSource: SearchCollectionDataSource!
    // swiftlint:disable weak_delegate
    private var categoriesDelegate: SearchCollectionDelegate!
    // swiftlint:enable weak_delegate
    private var selectedCategory: Category?
    
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
    
    private func updateNavigationBar() {
        navigationItem.titleView = titleView
        titleView.updateCartBarItem()
    }
    
    private func setupViews() {
        titleView.delegate = self
        
        let nib = UINib(nibName: String(describing: CategoryCollectionViewCell.self), bundle: nil)
        categoriesCollectionView.register(nib, forCellWithReuseIdentifier: String(describing: CategoryCollectionViewCell.self))
        
        categoriesDataSource = SearchCollectionDataSource()
        categoriesDataSource.delegate = self
        categoriesCollectionView.dataSource = categoriesDataSource
        
        categoriesDelegate = SearchCollectionDelegate()
        categoriesDelegate.delegate = self
        categoriesCollectionView.delegate = categoriesDelegate
        
        categoriesCollectionView.contentInset = CategoryCollectionViewCell.collectionViewInsets
    }
    
    private func setupViewModel() {
        titleView.rx.value.map({ $0 ?? "" })
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
    
    // MARK: - Overriding
    
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
    
    func didTapClear() {
        viewModel.searchPhrase.value = ""
    }
    
    // MARK: - SearchCollectionDataSourceProtocol
    
    func categoriesCount() -> Int {
        return viewModel.categoriesCount()
    }
    
    func category(at index: Int) -> Category {
        return viewModel.category(at: index)
    }
    
    // MARK: - SearchCollectionDelegateProtocol
    
    func didSelectCategory(at index: Int) {
        if index < viewModel.categories.value.count {
            selectedCategory = viewModel.categories.value[index]
            performSegue(withIdentifier: SegueIdentifiers.toCategory, sender: self)
        }
    }
}
