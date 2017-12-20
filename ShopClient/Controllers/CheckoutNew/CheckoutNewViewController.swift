//
//  CheckoutNewViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CheckoutNewViewController: BaseViewController<CheckoutNewViewModel>, CheckoutNewTableDataSourceProtocol, SeeAllHeaderViewProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    var tableDataSource: CheckoutNewTableDataSource!
    var tableDelegate: CheckoutNewTableDelegate!
    
    override func viewDidLoad() {
        viewModel = CheckoutNewViewModel()
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
        
        tableDataSource = CheckoutNewTableDataSource(delegate: self)
        tableView?.dataSource = tableDataSource
        
        tableDelegate = CheckoutNewTableDelegate(delegate: self)
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
    
    // MARK: - CheckoutNewTableDataSource
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
