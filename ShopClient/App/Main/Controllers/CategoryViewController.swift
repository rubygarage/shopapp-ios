//
//  CategoryViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

private let kSortByViewChangesAnimationDuration: TimeInterval = 0.3

class CategoryViewController: GridCollectionViewController<CategoryViewModel> {
    @IBOutlet private weak var sortByLabel: UILabel!
    @IBOutlet private weak var sortByViewTopLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var sortByView: UIView!
    
    fileprivate var lastScrollOffset: CGFloat?
    fileprivate var positiveScrollOffset: CGFloat = 0
    fileprivate var negativeScrollOffset: CGFloat = 0
    fileprivate var isSortByViewCollapsed = false
    
    var categoryId: String!
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = CategoryViewModel()
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavigationBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sortVariantsViewController = segue.destination as? SortVariantsViewController {
            sortVariantsViewController.delegate = self
            sortVariantsViewController.selectedSortingValue = viewModel.selectedSortingValue
        }
    }
    
    // MARK: - Setup
    
    fileprivate func loadData() {
        viewModel.reloadData()
    }
    
    fileprivate func updateSortByView(isHidden: Bool) {
        sortByViewTopLayoutConstraint.constant = isHidden ? -sortByView.frame.size.height : 0
        UIView.animate(withDuration: kSortByViewChangesAnimationDuration, animations: {
            self.view.layoutIfNeeded()
        })
        isSortByViewCollapsed = !isSortByViewCollapsed
    }
    
    private func setupViews() {
        sortByLabel.text = "Label.SortBy".localizable.uppercased()
        collectionView.contentInset = GridCollectionViewCell.sortableCollectionViewInsets
    }
    
    private func updateNavigationBar() {
        addCartBarButton()
    }
    
    private func setupViewModel() {
        viewModel.categoryId = categoryId
        
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
    
    // MARK: - Actions
    
    @IBAction func sortByViewDidTap(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: SegueIdentifiers.toSortVariants, sender: self)
    }
    
    // MARK: - BasePaginationViewController
    
    override func pullToRefreshHandler() {
        viewModel.reloadData()
    }
    
    override func infinityScrollHandler() {
        viewModel.loadNextPage()
    }
    
    // MARK: - GridCollectionProviderDelegate
    
    override func provider(_ provider: GridCollectionProvider, didScroll scrollView: UIScrollView) {
        guard (scrollView.contentSize.height - scrollView.frame.size.height >= scrollView.contentOffset.y) && (scrollView.contentInset.top + scrollView.contentOffset.y > 0) else {
            return
        }
        if lastScrollOffset == nil {
            lastScrollOffset = scrollView.contentOffset.y
        }
        let delta = scrollView.contentOffset.y - lastScrollOffset!
        lastScrollOffset = scrollView.contentOffset.y
        if delta > 0 {
            positiveScrollOffset += delta
            negativeScrollOffset = 0
        } else {
            negativeScrollOffset += delta
            positiveScrollOffset = 0
        }
        if positiveScrollOffset >= sortByView.frame.size.height && !isSortByViewCollapsed {
            updateSortByView(isHidden: true)
        } else if abs(negativeScrollOffset) >= sortByView.frame.size.height && isSortByViewCollapsed {
            updateSortByView(isHidden: false)
        }
    }
}

// MARK: - SortVariantsControllerDelegate

extension CategoryViewController: SortVariantsControllerDelegate {
    func viewController(_ viewController: SortVariantsViewController, didSelect sortingValue: SortingValue) {
        viewModel.selectedSortingValue = sortingValue
        viewModel.clearResult()
        loadData()
    }
}
