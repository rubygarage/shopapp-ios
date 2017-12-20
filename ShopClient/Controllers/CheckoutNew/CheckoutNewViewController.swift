//
//  CheckoutNewViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CheckoutNewViewController: BaseViewController<CheckoutNewViewModel>, CheckoutNewTableDataSourceProtocol {
    @IBOutlet weak var tableVew: UITableView!
    
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
        tableVew.register(cartNib, forCellReuseIdentifier: String(describing: CheckoutCartTableViewCell.self))
        
        tableDataSource = CheckoutNewTableDataSource(delegate: self)
        tableVew.dataSource = tableDataSource
        
        tableDelegate = CheckoutNewTableDelegate()
        tableVew.delegate = tableDelegate
    }
    
    private func setupViewModel() {
        viewModel.cartItems.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.tableVew.reloadData()
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
}
