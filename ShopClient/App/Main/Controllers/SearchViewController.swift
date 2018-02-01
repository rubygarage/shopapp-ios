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
    @IBOutlet private weak var categoryListContainerView: UIView!
    
    private let titleView = SearchTitleView()
    
    //fileprivate var selectedCategory: Category?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = SearchViewModel()
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
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
        /*
        if let categoryViewController = segue.destination as? CategoryViewController {
            categoryViewController.title = selectedCategory!.title
            categoryViewController.categoryId = selectedCategory!.id
        } else if
    */
        if let productDetailsViewController = segue.destination as? ProductDetailsViewController {
            productDetailsViewController.productId = selectedProduct!.id
        }
    }
    
    // MARK: - Setup
    
    fileprivate func updateCategoryListIfNeeded(isHidden: Bool) {
        let alpha: CGFloat = isHidden ? 0 : 1
        guard categoryListContainerView.alpha != alpha else {
            return
        }
        UIView.animate(withDuration: kAnimationDuration) {
            self.categoryListContainerView.alpha = alpha
        }
    }
    
    private func updateNavigationBar() {
        navigationItem.titleView = titleView
        titleView.updateCartBarItem()
    }
    
    private func setupViews() {
        titleView.delegate = self
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

/*
// MARK: - SearchCollectionProviderDelegate

extension SearchViewController: SearchCollectionProviderDelegate {
    func provider(_ provider: SearchCollectionProvider, didSelect category: Category) {
        selectedCategory = category
        performSegue(withIdentifier: SegueIdentifiers.toCategory, sender: self)
    }
}
*/

// MARK: - SearchTitleViewDelegate

extension SearchViewController: SearchTitleViewDelegate {
    func viewDidBeginEditing(_ view: SearchTitleView) {
        updateCategoryListIfNeeded(isHidden: true)
    }
    
    func viewDidChangeSearchPhrase(_ view: SearchTitleView) {
        viewModel.reloadData()
    }
    
    func viewDidTapClear(_ view: SearchTitleView) {
        viewModel.clearResult()
    }
    
    func viewDidTapBack(_ view: SearchTitleView) {
        viewModel.clearResult()
        updateCategoryListIfNeeded(isHidden: false)
    }
    
    func viewDidTapCart(_ view: SearchTitleView) {
        showCartController()
    }
}
