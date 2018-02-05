//
//  PaymentTypeViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol PaymentTypeViewControllerDelegate: class {
    func viewController(_ viewController: PaymentTypeViewController, didSelect paymentType: PaymentType)
}

class PaymentTypeViewController: BaseViewController<PaymentTypeViewModel> {
    @IBOutlet private weak var tableView: UITableView!
    
    private var tableProvider: PaymentTypeProvider!
    private var destinationTitle: String!
    
    var checkout: Checkout!
    var selectedType: PaymentType?
    
    weak var delegate: PaymentTypeViewControllerDelegate?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = PaymentTypeViewModel()
        super.viewDidLoad()

        setupViews()
        setupTableView()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        title = "ControllerTitle.PaymentType".localizable
    }
    
    private func setupTableView() {
        let paymentTypeNib = UINib(nibName: String(describing: PaymentTypeTableViewCell.self), bundle: nil)
        tableView.register(paymentTypeNib, forCellReuseIdentifier: String(describing: PaymentTypeTableViewCell.self))
        
        tableProvider = PaymentTypeProvider()
        tableProvider.selectedPaymentType = selectedType
        tableProvider.delegate = self
        tableView.dataSource = tableProvider
        tableView.delegate = tableProvider
        
        tableView.contentInset = TableView.paymentTypeContentInsets
    }

    fileprivate func reloadTable() {
        tableView.reloadData()
    }
}

// MARK: - PaymentTypeProviderDelegate

extension PaymentTypeViewController: PaymentTypeProviderDelegate {
    func provider(_ provider: PaymentTypeProvider, didSelect type: PaymentType) {
        delegate?.viewController(self, didSelect: type)
        selectedType = type
        reloadTable()
        navigationController?.popViewController(animated: true)
    }
}
