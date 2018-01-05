//
//  OrderDetailsViewController.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class OrderDetailsViewController: BaseViewController<OrderDetailsViewModel>, OrdersDetailsTableDataSourceProtocol, OrdersDetailsTableDelegateProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    private var tableDataSource: OrdersDetailsTableDataSource!
    private var tableDelegate: OrdersDetailsTableDelegate!
    
    var orderId: String!
    
    // MARK: - view controller lifecycle
    override func viewDidLoad() {
        viewModel = OrderDetailsViewModel()
        super.viewDidLoad()
        
        setupViews()
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    // MARK: - setup
    private func setupViews() {
        title = NSLocalizedString("ControllerTitle.OrderDetails", comment: String())
    }
    
    private func setupTableView() {
        /*
        let cartCellNib = UINib(nibName: String(describing: CartTableViewCell.self), bundle: nil)
        tableView.register(cartCellNib, forCellReuseIdentifier: String(describing: CartTableViewCell.self))
        */
        
        let shippingAddressEditNib = UINib(nibName: String(describing: CheckoutShippingAddressEditTableCell.self), bundle: nil)
        tableView.register(shippingAddressEditNib, forCellReuseIdentifier: String(describing: CheckoutShippingAddressEditTableCell.self))
        
        tableDataSource = OrdersDetailsTableDataSource(delegate: self)
        tableView.dataSource = tableDataSource
        
        tableDelegate = OrdersDetailsTableDelegate(delegate: self)
        tableView.delegate = tableDelegate
        
        tableView?.contentInset = TableView.defaultContentInsets
    }
    
    private func setupViewModel() {
        viewModel.orderId = orderId
        
        errorView.tryAgainButton.rx.tap
            .bind(to: viewModel.loadData)
            .disposed(by: disposeBag)
        
        viewModel.data.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadOrder()
    }
    
    // MARK: - OrdersDetailsTableDataSourceProtocol
    func order() -> Order? {
        return viewModel.data.value
    }
}
