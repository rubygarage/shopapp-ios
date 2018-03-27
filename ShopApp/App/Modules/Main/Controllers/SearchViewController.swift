//
//  SearchViewController.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 9/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

class SearchViewController: GridCollectionViewController<SearchViewModel>, CategoryListControllerDelegate, SearchTitleViewDelegate {
    @IBOutlet private weak var categoryListContainerView: UIView!
    
    private let titleViewAlphaDefault: CGFloat = 1
    private let titleViewAlphaHidden: CGFloat = 0
    private let titleViewInset: CGFloat = 8
    private let titleViewHeight: CGFloat = 44
    private let animationDuration: TimeInterval = 0.3
    private let titleView = SearchTitleView()
    
    private var selectedCategory: ShopApp_Gateway.Category?
    
    override var customEmptyDataView: UIView {
        return SearchEmptyDataView(frame: view.frame)
    }
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
        collectionView.keyboardDismissMode = .onDrag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavigationBar()
        showTitleViewIfNeeded()
        
        navigationController?.removeShadow()
        navigationController?.navigationBar.barTintColor = Colors.backgroundDefault
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.addShadow()
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let categoryListViewController = segue.destination as? CategoryListViewController {
            categoryListViewController.delegate = self
        } else if let categoryViewController = segue.destination as? CategoryViewController {
            categoryViewController.title = selectedCategory!.title
            categoryViewController.categoryId = selectedCategory!.id
            hideTitleViewIfNeeded()
        } else if let productDetailsViewController = segue.destination as? ProductDetailsViewController {
            productDetailsViewController.productId = selectedProduct!.id
            hideTitleViewIfNeeded()
        }
    }
    
    // MARK: - Setup
    
    private func updateCategoryListIfNeeded(isHidden: Bool) {
        let alpha: CGFloat = isHidden ? 0 : 1
        guard categoryListContainerView.alpha != alpha else {
            return
        }
        UIView.animate(withDuration: animationDuration) {
            self.categoryListContainerView.alpha = alpha
        }
    }
    
    private func updateNavigationBar() {
        titleView.updateCartBarItem()
        guard titleView.superview == nil else {
            return
        }
        titleView.frame.origin = CGPoint(x: titleViewInset, y: 0)
        titleView.frame.size = CGSize(width: view.frame.size.width - titleViewInset * 2, height: titleViewHeight)
        navigationController?.navigationBar.addSubview(titleView)
        titleView.alpha = titleViewAlphaDefault
    }
    
    private func showTitleViewIfNeeded() {
        guard titleView.alpha == titleViewAlphaHidden else {
            return
        }
        UIView.animate(withDuration: animationDuration, animations: {
            self.titleView.alpha = self.titleViewAlphaDefault
        })
    }
    
    private func hideTitleViewIfNeeded() {
        guard titleView.alpha == titleViewAlphaDefault else {
            return
        }
        UIView.animate(withDuration: animationDuration, animations: {
            self.titleView.alpha = self.titleViewAlphaHidden
        })
    }
    
    private func setupViews() {
        titleView.delegate = self
        
        collectionView.contentInset = GridCollectionViewCell.searchCollectionViewInsets
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

    // MARK: - CategoryListControllerDelegate

    func viewController(_ viewController: CategoryListViewController, didSelect category: ShopApp_Gateway.Category) {
        selectedCategory = category
        performSegue(withIdentifier: SegueIdentifiers.toCategory, sender: self)
    }

    // MARK: - SearchTitleViewDelegate

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
