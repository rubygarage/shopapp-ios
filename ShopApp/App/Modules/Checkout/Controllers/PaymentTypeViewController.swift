//
//  PaymentTypeViewController.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

protocol PaymentTypeViewControllerDelegate: class {
    func viewController(_ viewController: PaymentTypeViewController, didSelect paymentType: PaymentType)
}

class PaymentTypeViewController: BaseViewController<BaseViewModel>, PaymentTypeProviderDelegate {
    // swiftlint:disable private_outlet
    @IBOutlet private(set) weak var tableView: UITableView!
    // swiftlint:enable private_outlet
    
    private var destinationTitle: String!
    
    var tableProvider: PaymentTypeProvider!
    var checkout: Checkout!
    var selectedType: PaymentType?
    
    weak var delegate: PaymentTypeViewControllerDelegate?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTableView()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        title = "ControllerTitle.PaymentType".localizable
    }
    
    private func setupTableView() {
        tableView.registerNibForCell(PaymentTypeTableViewCell.self)
        
        tableProvider.selectedPaymentType = selectedType
        tableProvider.delegate = self
        tableView.dataSource = tableProvider
        tableView.delegate = tableProvider
        
        tableView.contentInset = TableView.defaultContentInsets
    }
    
    // MARK: - PaymentTypeProviderDelegate
    
    func provider(_ provider: PaymentTypeProvider, didSelect type: PaymentType) {
        delegate?.viewController(self, didSelect: type)
        selectedType = type
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}
