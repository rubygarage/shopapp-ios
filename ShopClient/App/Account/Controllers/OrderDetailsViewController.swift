//
//  OrderDetailsViewController.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class OrderDetailsViewController: BaseViewController<OrderDetailsViewModel> {
    @IBOutlet private weak var tableView: UITableView!
    
    private var tableDataSource: OrdersDetailsTableDataSource!
    // swiftlint:disable weak_delegate
    private var tableDelegate: OrdersDetailsTableDelegate!
    // swiftlint:enable weak_delegate
    
    fileprivate var selectedProductVariant: ProductVariant!
    
    var orderId: String!
    
    // MARK: - View controller lifecycle
    
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
    
    // MARK: - Setup
    
    private func setupViews() {
        title = "ControllerTitle.OrderDetails".localizable
    }
    
    private func setupTableView() {
        let orderItemCellName = String(describing: OrderItemTableViewCell.self)
        let orderItemNib = UINib(nibName: orderItemCellName, bundle: nil)
        tableView.register(orderItemNib, forCellReuseIdentifier: orderItemCellName)
        
        let checkoutShippingAddressEditCellname = String(describing: CheckoutShippingAddressEditTableCell.self)
        let shippingAddressEditNib = UINib(nibName: checkoutShippingAddressEditCellname, bundle: nil)
        tableView.register(shippingAddressEditNib, forCellReuseIdentifier: checkoutShippingAddressEditCellname)
        
        tableDataSource = OrdersDetailsTableDataSource()
        tableDataSource.delegate = self
        tableView.dataSource = tableDataSource
        
        tableDelegate = OrdersDetailsTableDelegate()
        tableDelegate.delegate = self
        tableView.delegate = tableDelegate
        
        tableView.contentInset = TableView.defaultContentInsets
    }
    
    private func setupViewModel() {
        viewModel.orderId = orderId

        viewModel.data.asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadOrder()
    }
}

// MARK: - OrdersDetailsTableDataSourceProtocol

extension OrderDetailsViewController: OrdersDetailsTableDataSourceProtocol {
    func order() -> Order? {
        return viewModel.data.value
    }
}

// MARK: - OrdersDetailsTableDelegateProtocol

extension OrderDetailsViewController: OrdersDetailsTableDelegateProtocol {
    func didSelectItem(at index: Int) {
        guard let productVariant = viewModel.productVariant(at: index) else {
            return
        }
        selectedProductVariant = productVariant
        performSegue(withIdentifier: SegueIdentifiers.toProductDetails, sender: self)
    }
}
