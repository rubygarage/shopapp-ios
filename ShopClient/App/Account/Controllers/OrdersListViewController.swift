//
//  OrdersListViewController.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class OrdersListViewController: BaseTableViewController<OrdersListViewModel> {
    private var tableDataSource: OrdersListTableDataSource!
    // swiftlint:disable weak_delegate
    private var tableDelegate: OrdersListTableDelegate!
    // swiftlint:enable weak_delegate
    
    fileprivate var selectedOrder: Order?
    fileprivate var selectedProductVariant: ProductVariant!

    // MARK: - View controller lifecycle
    
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
    
    // MARK: - Setup
    
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
    
    fileprivate func loadData() {
        viewModel.reloadData()
    }
    
    override func pullToRefreshHandler() {
        viewModel.reloadData()
    }
    
    override func infinityScrollHandler() {
        viewModel.loadNextPage()
    }
}

// MARK: - ErrorViewProtocol

extension OrdersListViewController {
    func didTapTryAgain() {
        loadData()
    }
}

// MARK: - OrdersListTableDataSourceProtocol

extension OrdersListViewController: OrdersListTableDataSourceProtocol {
    func orders() -> [Order] {
        return viewModel.items.value
    }
}

// MARK: - OrdersListTableDelegateProtocol

extension OrdersListViewController: OrdersListTableDelegateProtocol {
    func didSelectItem(at index: Int) {
        if index < viewModel.items.value.count {
            selectedOrder = viewModel.items.value[index]
            performSegue(withIdentifier: SegueIdentifiers.toOrderDetails, sender: self)
        }
    }
}

// MARK: - CheckoutCartTableViewCellDelegate

extension OrdersListViewController: CheckoutCartTableViewCellDelegate {
    func didSelectItem(with productVariantId: String, at index: Int) {
        selectedProductVariant = viewModel.productVariant(with: productVariantId, at: index)
        if selectedProductVariant != nil {
            performSegue(withIdentifier: SegueIdentifiers.toProductDetails, sender: self)
        }
    }
}
