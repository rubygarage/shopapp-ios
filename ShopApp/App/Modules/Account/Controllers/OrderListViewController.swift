//
//  OrderListViewController.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

class OrderListViewController: BaseTableViewController<OrderListViewModel>, OrderListEmptyDataViewDelegate, OrderListTableProviderDelegate, CheckoutCartTableViewCellDelegate {
    var tableProvider: OrderListTableProvider!
    
    private var selectedOrder: Order?
    private var selectedProductVariant: ProductVariant!
    
    override var customEmptyDataView: UIView {
        let emptyView = OrderListEmptyDataView(frame: view.frame)
        emptyView.delegate = self
        return emptyView
    }

    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
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
    
    private func loadData() {
        viewModel.reloadData()
    }
    
    private func setupViews() {
        title = "ControllerTitle.MyOrders".localizable
    }
    
    private func setupViewModel() {
        viewModel?.items.asObservable()
            .subscribe(onNext: { [weak self] orders in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.stopLoadAnimating()
                strongSelf.tableProvider.orders = orders
                strongSelf.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.registerNibForCell(CheckoutCartTableViewCell.self)
        
        tableProvider.delegate = self
        tableView.dataSource = tableProvider
        tableView.delegate = tableProvider
        
        tableView.contentInset = TableView.defaultContentInsets
    }
    
    // MARK: - BasePaginationViewController
    
    override func pullToRefreshHandler() {
        viewModel.reloadData()
    }
    
    override func infinityScrollHandler() {
        viewModel.loadNextPage()
    }
    
    // MARK: - OrderListEmptyDataViewDelegate
    
    func viewDidTapStartShopping(_ view: OrderListEmptyDataView) {
        setHomeController()
        navigationController?.popViewController(animated: false)
    }
    
    // MARK: - OrderListTableProviderDelegate
    
    func provider(_ provider: OrderListTableProvider, didSelect order: Order) {
        selectedOrder = order
        performSegue(withIdentifier: SegueIdentifiers.toOrderDetails, sender: self)
    }
    
    // MARK: - CheckoutCartTableViewCellDelegate
    
    func tableViewCell(_ cell: CheckoutCartTableViewCell, didSelect productVariantId: String, at index: Int) {
        selectedProductVariant = viewModel.productVariant(with: productVariantId, at: index)
        if selectedProductVariant != nil {
            performSegue(withIdentifier: SegueIdentifiers.toProductDetails, sender: self)
        }
    }
}
