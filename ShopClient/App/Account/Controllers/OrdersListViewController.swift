//
//  OrdersListViewController.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class OrdersListViewController: BaseTableViewController<OrdersListViewModel>, OrdersListTableDataSourceProtocol, OrdersListTableDelegateProtocol, CheckoutCartTableViewCellDelegate {
    
    private var tableDataSource: OrdersListTableDataSource!
    // swiftlint:disable weak_delegate
    private var tableDelegate: OrdersListTableDelegate!
    // swiftlint:enable weak_delegate
    private var selectedOrder: Order?
    private var selectedProductVariant: ProductVariant!

    // MARK: - view controller lifecycle
    override func viewDidLoad() {
        viewModel = OrdersListViewModel()
        super.viewDidLoad()
        
        setupViews()
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let orderDetailsViewController = segue.destination as? OrderDetailsViewController {
            orderDetailsViewController.orderId = selectedOrder!.id
        } else if let productDetailsViewController = segue.destination as? ProductDetailsViewController {
            productDetailsViewController.productVariant = selectedProductVariant
        }
    }
    
    // MARK: - setup
    private func setupViews() {
        title = "ControllerTitle.MyOrders".localizable
    }
    
    private func setupViewModel() {
        viewModel?.items.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.stopLoadAnimating()
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.reloadData()
    }
    
    private func setupTableView() {
        let cartNib = UINib(nibName: String(describing: CheckoutCartTableViewCell.self), bundle: nil)
        tableView?.register(cartNib, forCellReuseIdentifier: String(describing: CheckoutCartTableViewCell.self))
        
        tableDataSource = OrdersListTableDataSource()
        tableDataSource.delegate = self
        tableView?.dataSource = tableDataSource
        
        tableDelegate = OrdersListTableDelegate()
        tableDelegate.delegate = self
        tableView?.delegate = tableDelegate
        
        tableView?.contentInset = TableView.defaultContentInsets
    }
    
    override func pullToRefreshHandler() {
        viewModel.reloadData()
    }
    
    override func infinityScrollHandler() {
        viewModel.loadNextPage()
    }
    
    // MARK: - OrdersListTableDataSourceProtocol
    func orders() -> [Order] {
        return viewModel.items.value
    }
    
    // MARK: - OrdersListTableDelegateProtocol
    func didSelectItem(at index: Int) {
        if index < viewModel.items.value.count {
            selectedOrder = viewModel.items.value[index]
            performSegue(withIdentifier: SegueIdentifiers.toOrderDetails, sender: self)
        }
    }
    
    // MARK: - CheckoutCartTableViewCellDelegate
    func didSelectItem(with productVariantId: String, at index: Int) {
        selectedProductVariant = viewModel.productVariant(with: productVariantId, at: index)
        performSegue(withIdentifier: SegueIdentifiers.toProductDetails, sender: self)
    }
    
    // MARK: - ErrorViewProtocol
    func didTapTryAgain() {
        loadData()
    }
}
