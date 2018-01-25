//
//  PaymentTypeViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol PaymentTypeViewControllerProtocol: class {
    func didSelect(paymentType: PaymentType)
}

class PaymentTypeViewController: BaseViewController<PaymentTypeViewModel> {
    @IBOutlet private weak var tableView: UITableView!
    
    private var tableDataSource: PaymentTypeDataSource!
    // swiftlint:disable weak_delegate
    private var tableDelegate: PaymentTypeDelegate!
    // swiftlint:enable weak_delegate
    private var destinationTitle: String!
    
    var checkout: Checkout!
    var selectedType: PaymentType?
    weak var delegate: PaymentTypeViewControllerProtocol?
    
    override func viewDidLoad() {
        viewModel = PaymentTypeViewModel()
        super.viewDidLoad()

        setupViews()
        setupViewModel()
        setupTableView()
    }
    
    private func setupViews() {
        title = "ControllerTitle.PaymentType".localizable
    }
    
    private func setupViewModel() {
        viewModel.checkout = checkout
    }
    
    private func setupTableView() {
        let paymentTypeNib = UINib(nibName: String(describing: PaymentTypeTableViewCell.self), bundle: nil)
        tableView.register(paymentTypeNib, forCellReuseIdentifier: String(describing: PaymentTypeTableViewCell.self))
        
        tableDataSource = PaymentTypeDataSource()
        tableDataSource.delegate = self
        tableView.dataSource = tableDataSource
        
        tableDelegate = PaymentTypeDelegate()
        tableDelegate.delegate = self
        tableView.delegate = tableDelegate
        
        tableView.contentInset = TableView.paymentTypeContentInsets
    }

    fileprivate func reloadTable() {
        tableView.reloadData()
    }
}

// MARK: - PaymentTypeDelegateProtocol

extension PaymentTypeViewController: PaymentTypeDelegateProtocol {
    func didSelectPayment(type: PaymentType) {
        delegate?.didSelect(paymentType: type)
        selectedType = type
        reloadTable()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - PaymentTypeDataSourceProtocol

extension PaymentTypeViewController: PaymentTypeDataSourceProtocol {
    func selectedPaymentType() -> PaymentType? {
        return selectedType
    }
}
