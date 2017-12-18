//
//  SearchViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/7/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class SearchViewController: GridCollectionViewController<SearchViewModel>, SearchTitleViewProtocol {
    let titleView = SearchTitleView()
    
    override func viewDidLoad() {
        viewModel = SearchViewModel()
        super.viewDidLoad()
        
        setupViews()
        setupViewModel()
        loadData()
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
    }
    
    private func setupViews() {
        titleView.delegate = self
    }
    
    private func setupViewModel() {
        titleView.searchTextField.rx.text.map({ $0 ?? String() })
            .bind(to: viewModel.searchPhrase)
            .disposed(by: disposeBag)
        
        viewModel.products.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.stopLoadAnimating()
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.reloadData()
    }
    
    // MARK: - overriding
    override func pullToRefreshHandler() {
        viewModel.reloadData()
    }
    
    override func infinityScrollHandler() {
        viewModel.loadNextPage()
    }
    
    // MARK: - SearchTitleViewProtocol
    func didTapSearch() {
        viewModel.reloadData()
    }
    
    // MARK: - ErrorViewProtocol
    func didTapTryAgain() {
        loadData()
    }
}
