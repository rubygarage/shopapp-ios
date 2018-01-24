//
//  PaymentTypeViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol PaymentTypeViewControllerProtocol: class {
    func didSelect(paymentType: PaymentTypeSection)
}

class PaymentTypeViewController: BaseViewController<PaymentTypeViewModel> {
    @IBOutlet private weak var tableView: UITableView!
    
    private var tableDataSource: PaymentTypeDataSource!
    // swiftlint:disable weak_delegate
    private var tableDelegate: PaymentTypeDelegate!
    // swiftlint:enable weak_delegate
    private var destinationTitle: String!
    
    var checkout: Checkout!
    var selectedType: PaymentTypeSection?
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
    
    fileprivate func setupApplePay() {
        viewModel.setupApplePay()
    }

    fileprivate func reloadTable() {
        tableView.reloadData()
    }
    
    // MARK: - Segues
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let addressListViewController = segue.destination as? AddressListViewController {
//            addressListViewController.title = "ControllerTitle.BillingAddress".localizable
//            addressListViewController.addressListType = .billing
//        }
//    }
}

// MARK: - PaymentTypeDelegateProtocol

extension PaymentTypeViewController: PaymentTypeDelegateProtocol {
    func didSelectPayment(type: PaymentTypeSection) {
        delegate?.didSelect(paymentType: type)
        selectedType = type
        reloadTable()
        navigationController?.popViewController(animated: true)
//        viewModel.selectedType = type
//        reloadData()
//        switch type {
//        case .applePay:
//            setupApplePay()
//        default:
//            performSegue(withIdentifier: SegueIdentifiers.toAddressList, sender: self)
//        }
    }
}

extension PaymentTypeViewController: PaymentTypeDataSourceProtocol {
    func selectedPaymentType() -> PaymentTypeSection? {
        return selectedType
    }
}
