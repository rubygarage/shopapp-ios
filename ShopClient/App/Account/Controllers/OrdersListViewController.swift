//
//  OrdersListViewController.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class OrdersListViewController: BaseTableViewController<OrdersListViewModel>, OrdersListTableDataSourceProtocol, OrdersListTableDelegateProtocol {
    
    private var tableDataSource: OrdersListTableDataSource!
    private var tableDelegate: OrdersListTableDelegate!
    private var selectedOrder: Order?

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
        }
    }
    
    // MARK: - setup
    private func setupViews() {
        title = NSLocalizedString("ControllerTitle.MyOrders", comment: String())
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
        
        tableDataSource = OrdersListTableDataSource(delegate: self)
        tableView?.dataSource = tableDataSource
        
        tableDelegate = OrdersListTableDelegate(delegate: self)
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
    
    // MARK: - ErrorViewProtocol
    func didTapTryAgain() {
        loadData()
    }
}
