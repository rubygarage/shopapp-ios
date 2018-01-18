//
//  PaymentTypeViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class PaymentTypeViewController: BaseViewController<PaymentTypeViewModel> {
    @IBOutlet weak var tableView: UITableView!
    
    private var tableDataSource: PaymentTypeDataSource!
    // swiftlint:disable weak_delegate
    private var tableDelegate: PaymentTypeDelegate!
    // swiftlint:enable weak_delegate
    private var destinationTitle: String!
    
    var creditCardCompletion: CreditCardPaymentCompletion?
    var checkout: Checkout!
    
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
        tableView.dataSource = tableDataSource
        
        tableDelegate = PaymentTypeDelegate()
        tableDelegate.delegate = self
        tableView.delegate = tableDelegate
        
        tableView.contentInset = TableView.paymentTypeContentInsets
    }
    
    fileprivate func setupApplePay() {
        viewModel.setupApplePay()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addressListViewController = segue.destination as? AddressListViewController {
            addressListViewController.title = "ControllerTitle.BillingAddress".localizable
            addressListViewController.addressListType = .billing
            addressListViewController.destinationCreditCardCompletion = creditCardCompletion
        }
    }
}

// MARK: - PaymentTypeDelegateProtocol

extension PaymentTypeViewController: PaymentTypeDelegateProtocol {
    func didSelectPayment(type: PaymentTypeSection) {
        viewModel.selectedType = type
        tableView.reloadData()
        switch type {
        case .applePay:
            setupApplePay()
        default:
            performSegue(withIdentifier: SegueIdentifiers.toAddressList, sender: self)
        }
    }
}
