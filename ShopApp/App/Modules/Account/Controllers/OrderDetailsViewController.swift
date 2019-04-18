//
//  OrderDetailsViewController.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

class OrderDetailsViewController: BaseViewController<OrderDetailsViewModel>, OrderDetailsTableProviderDelegate {
    @IBOutlet private weak var tableView: UITableView!
    
    private var selectedProductVariant: ProductVariant!
    
    var orderId: String!
    var tableProvider: OrderDetailsTableProvider!
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
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
        tableView.registerNibForCell(OrderItemTableViewCell.self)
        tableView.registerNibForCell(CheckoutShippingAddressEditTableCell.self)
        
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
    
    @objc override func backButtonDidPress() {
        guard let index = navigationController?.viewControllers.firstIndex(of: self), navigationController?.viewControllers[index - 1] is CheckoutSuccessViewController else {
            navigationController?.popViewController(animated: true)
            return
        }
        setHomeController()
        dismissModalStack()
    }
    
    // MARK: - OrderDetailsTableProviderDelegate
    
    func provider(_ provider: OrderDetailsTableProvider, didSelect productVariant: ProductVariant) {
        selectedProductVariant = productVariant
        performSegue(withIdentifier: SegueIdentifiers.toProductDetails, sender: self)
    }
}
