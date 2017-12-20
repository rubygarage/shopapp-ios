//
//  CheckoutViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CheckoutViewController: BaseViewController<CheckoutViewModel>, CheckoutTableDataSourceProtocol, SeeAllHeaderViewProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    var tableDataSource: CheckoutTableDataSource!
    var tableDelegate: CheckoutTableDelegate!
    
    override func viewDidLoad() {
        viewModel = CheckoutViewModel()
        super.viewDidLoad()

        setupViews()
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    private func setupViews() {
        addCloseButton()
        title = NSLocalizedString("ControllerTitle.Checkout", comment: String())
    }
    
    private func setupTableView() {
        let cartNib = UINib(nibName: String(describing: CheckoutCartTableViewCell.self), bundle: nil)
        tableView?.register(cartNib, forCellReuseIdentifier: String(describing: CheckoutCartTableViewCell.self))
        
        let shippingAddressNib = UINib(nibName: String(describing: CheckoutShippingAddressAddTableCell.self), bundle: nil)
        tableView.register(shippingAddressNib, forCellReuseIdentifier: String(describing: CheckoutShippingAddressAddTableCell.self))
        
        tableDataSource = CheckoutTableDataSource(delegate: self)
        tableView?.dataSource = tableDataSource
        
        tableDelegate = CheckoutTableDelegate(delegate: self)
        tableView?.delegate = tableDelegate
        
        tableView?.contentInset = TableView.defaultContentInsets
    }
    
    private func setupViewModel() {
        viewModel.cartItems.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadData()
    }
    
    // MARK: - CheckoutTableDataSourceProtocol
    func cartProducts() -> [CartProduct] {
        return viewModel.cartItems.value
    }
    
    // MARK: - SeeAllHeaderViewProtocol
    func didTapSeeAll(type: ViewType) {
        if type == .myCart {
            // TODO:
        }
    }
}
