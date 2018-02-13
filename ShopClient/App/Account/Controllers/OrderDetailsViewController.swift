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
    
    private var tableProvider: OrdersDetailsTableProvider!
    
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow_left"), style: .plain, target: self, action: #selector(self.backButtonDidPress))
    }
    
    private func setupTableView() {
        tableView.registerNibForCell(OrderItemTableViewCell.self)
        tableView.registerNibForCell(CheckoutShippingAddressEditTableCell.self)
        
        tableProvider = OrdersDetailsTableProvider()
        tableProvider.delegate = self
        tableView.dataSource = tableProvider
        tableView.delegate = tableProvider
        
        tableView.contentInset = TableView.defaultContentInsets
    }
    
    private func setupViewModel() {
        viewModel.orderId = orderId

        viewModel.data.asObservable()
            .subscribe(onNext: { [weak self] order in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tableProvider.order = order
                strongSelf.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadOrder()
    }
    
    // MARK: - Actions
    @objc private func backButtonDidPress() {
        setHomeController()
        dismissModalStack()
    }
}

// MARK: - OrdersDetailsTableProviderDelegate

extension OrderDetailsViewController: OrdersDetailsTableProviderDelegate {
    func provider(_ provider: OrdersDetailsTableProvider, didSelect productVariant: ProductVariant) {
        selectedProductVariant = productVariant
        performSegue(withIdentifier: SegueIdentifiers.toProductDetails, sender: self)
    }
}
