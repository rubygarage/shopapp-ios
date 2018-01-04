//
//  OrderDetailsViewController.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/3/18.
//  Copyright © 2018 Evgeniy Antonov. All rights reserved.
//

import UIKit

class OrderDetailsViewController: BaseViewController<OrderDetailsViewModel> {
    @IBOutlet weak var tableView: UITableView!
    
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
        
        tableDataSource = CartTableDataSource(delegate: self)
        tableView.dataSource = tableDataSource
        
        tableDelegate = CartTableDelegate(delegate: self)
        tableView.delegate = tableDelegate
 */
    }
    
    private func setupViewModel() {
        viewModel.orderId = orderId
        
        errorView.tryAgainButton.rx.tap
            .bind(to: viewModel.loadData)
            .disposed(by: disposeBag)
        
        viewModel.data.asObservable()
            .subscribe(onNext: { [weak self] products in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadOrder()
    }
}
