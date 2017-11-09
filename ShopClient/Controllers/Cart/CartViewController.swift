//
//  CartViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CartViewController: BaseViewController<CartViewModel>, CartTableDataSourceProtocol, CartTableCellProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: CartTableDataSource?
    
    override func viewDidLoad() {
        viewModel = CartViewModel()
        super.viewDidLoad()

        setupTitle()
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    private func setupTitle() {
        title = NSLocalizedString("ControllerTitle.Cart", comment: String())
    }
    
    private func setupTableView() {
        let cartCellNib = UINib(nibName: String(describing: CartTableViewCell.self), bundle: nil)
        tableView.register(cartCellNib, forCellReuseIdentifier: String(describing: CartTableViewCell.self))
        
        dataSource = CartTableDataSource(delegate: self)
        tableView.dataSource = dataSource
    }
    
    private func setupViewModel() {
        viewModel.data.asObservable()
            .subscribe(onNext: { [weak self] products in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadData()
    }
    
    // MARK: - CartTableDataSourceProtocol
    func itemsCount() -> Int {
        return viewModel.data.value.count
    }
    
    func item(for index: Int) -> CartProduct? {
        if index < viewModel.data.value.count {
            return viewModel.data.value[index]
        }
        return nil
    }
    
    // MARK: - CartTableCellProtocol
    func didTapRemove(with item: CartProduct) {
        viewModel.remove(cartProduct: item)
    }
    
    func didUpdate(cartProduct: CartProduct, quantity: Int) {
        viewModel.update(cartProduct: cartProduct, quantity: quantity)
    }
}
