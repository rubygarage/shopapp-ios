//
//  SearchViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

private let kTitleViewAlphaDefault: CGFloat = 1
private let kTitleViewAlphaHidded: CGFloat = 0
private let kTitleViewInset: CGFloat = 8
private let kTitleViewHeight: CGFloat = 44
private let kAnimationDuration: TimeInterval = 0.3

/*
 private let kUnderlineViewAlphaDefault: CGFloat = 0.2
 private let kUnderlineViewAlphaHighlighted: CGFloat = 1
 private let kUnderlineViewHeightDefault: CGFloat = 1
 private let kUnderlineViewHeightHighlighted: CGFloat = 2
 private let kErrorColor = UIColor(displayP3Red: 0.89, green: 0.31, blue: 0.31, alpha: 1)
 private let kPlaceholderAnimationDuration: TimeInterval = 0.15
 */

class SearchViewController: GridCollectionViewController<SearchViewModel> {
    @IBOutlet private weak var categoryListContainerView: UIView!
    
    private let titleView = SearchTitleView()
    
    fileprivate var selectedCategory: Category?
    
    override var customEmptyDataView: UIView {
        return SearchEmptyDataView(frame: view.frame)
    }
    
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
        showTitleViewIfNeeded()
        
        navigationController?.removeShadow()
        navigationController?.navigationBar.barTintColor = UIColor.backgroundDefault
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
        titleView.updateCartBarItem()
        guard titleView.superview == nil else {
            return
        }
        titleView.frame.origin = CGPoint(x: kTitleViewInset, y: 0)
        titleView.frame.size = CGSize(width: view.frame.size.width - kTitleViewInset * 2, height: kTitleViewHeight)
        self.navigationController?.navigationBar.addSubview(self.titleView)
        titleView.alpha = kTitleViewAlphaDefault
    }
    
    private func showTitleViewIfNeeded() {
        guard titleView.alpha == kTitleViewAlphaHidded else {
            return
        }
        UIView.animate(withDuration: kAnimationDuration, animations: {
            self.titleView.alpha = kTitleViewAlphaDefault
        })
    }
    
    private func hideTitleViewIfNeeded() {
        guard titleView.alpha == kTitleViewAlphaDefault else {
            return
        }
        UIView.animate(withDuration: kAnimationDuration, animations: {
            self.titleView.alpha = kTitleViewAlphaHidded
        })
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

// MARK: - CategoryListControllerDelegate

extension SearchViewController: CategoryListControllerDelegate {
    func viewController(_ viewController: CategoryListViewController, didSelect category: Category) {
        selectedCategory = category
        performSegue(withIdentifier: SegueIdentifiers.toCategory, sender: self)
    }
}

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
