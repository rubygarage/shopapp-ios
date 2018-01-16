//
//  PaymentTypeViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class PaymentTypeViewController: BaseViewController<PaymentTypeViewModel>, PaymentTypeTableCellProtocol, PaymentTypeDataSourceProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    private var tableDataSource: PaymentTypeDataSource!
    private var destinationTitle: String!
    var creditCardCompletion: CreditCardPaymentCompletion?
    var applePayCompletion: ApplePayPaymentCompletion?
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
        tableDataSource.delegate = self
        tableView.dataSource = tableDataSource
        
        tableView.contentInset = TableView.paymentTypeContentInsets
    }
    
    private func setupApplePay() {
        viewModel.setupApplePay()
    }
    
    // MARK: - PaymentTypeTableCellProtocol
    func didPayment(with type: PaymentTypeSection) {
        viewModel.selectedType = type
        tableView.reloadData()
        switch type {
        case .applePay:
            setupApplePay()
        default:
            performSegue(withIdentifier: SegueIdentifiers.toAddressList, sender: self)
        }
    }
    
    // MARK: - PaymentTypeDataSourceProtocol
    func isSelected(type: PaymentTypeSection) -> Bool {
        return type == viewModel.selectedType
    }
    
    // MARK: - segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addressListViewController = segue.destination as? AddressListViewController {
            addressListViewController.title = "ControllerTitle.BillingAddress".localizable
            addressListViewController.addressListType = .billing
            addressListViewController.destinationCreditCardCompletion = creditCardCompletion
        }
    }
}
