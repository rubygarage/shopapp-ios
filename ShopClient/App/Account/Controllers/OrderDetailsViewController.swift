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
    
    // swiftlint:disable weak_delegate
    private var tableDelegate: OrdersDetailsTableDelegate!
    // swiftlint:enable weak_delegate
    
    var orderId: String!
    
    private var selectedProductVariant: ProductVariant!
    
    // MARK: - view controller lifecycle
    override func viewDidLoad() {
        viewModel = OrderDetailsViewModel()
        super.viewDidLoad()
        
        setupViews()
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productDetailsViewController = segue.destination as? ProductDetailsViewController {
            productDetailsViewController.productVariant = selectedProductVariant
        }
    }
    
    // MARK: - setup
    private func setupViews() {
        title = "ControllerTitle.OrderDetails".localizable
    }
    
    private func setupTableView() {
        let orderItemNib = UINib(nibName: String(describing: OrderItemTableViewCell.self), bundle: nil)
        tableView.register(orderItemNib, forCellReuseIdentifier: String(describing: OrderItemTableViewCell.self))
        
        let shippingAddressEditNib = UINib(nibName: String(describing: CheckoutShippingAddressEditTableCell.self), bundle: nil)
        tableView.register(shippingAddressEditNib, forCellReuseIdentifier: String(describing: CheckoutShippingAddressEditTableCell.self))
        
        tableDataSource = OrdersDetailsTableDataSource()
        tableDataSource.delegate = self
        tableView.dataSource = tableDataSource
        
        tableDelegate = OrdersDetailsTableDelegate()
        tableDelegate.delegate = self
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
    
    // MARK: - OrdersDetailsTableDelegateProtocol
    func didSelectItem(at index: Int) {
        selectedProductVariant = viewModel.productVariant(at: index)
        performSegue(withIdentifier: SegueIdentifiers.toProductDetails, sender: self)
    }
}
