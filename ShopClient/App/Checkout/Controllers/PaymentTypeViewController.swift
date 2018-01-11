//
//  PaymentTypeViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class PaymentTypeViewController: BaseViewController<PaymentTypeViewModel>, PaymentCreditCardTableCellProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    private var tableDataSource: PaymentTypeDataSource!
    private var destinationTitle: String!
    var completion: CreditCardPaymentCompletion?
    
    override func viewDidLoad() {
        viewModel = PaymentTypeViewModel()
        super.viewDidLoad()

        setupViews()
        setupTableView()
    }
    
    private func setupViews() {
        title = "ControllerTitle.PaymentType".localizable
    }
    
    private func setupTableView() {
        let paymentCreditCardNib = UINib(nibName: String(describing: PaymentCreditCardTableCell.self), bundle: nil)
        tableView.register(paymentCreditCardNib, forCellReuseIdentifier: String(describing: PaymentCreditCardTableCell.self))
        
        let paymentApplePayNib = UINib(nibName: String(describing: PaymentApplePayTableCell.self), bundle: nil)
        tableView.register(paymentApplePayNib, forCellReuseIdentifier: String(describing: PaymentApplePayTableCell.self))
        
        tableDataSource = PaymentTypeDataSource()
        tableDataSource.delegate = self
        tableView.dataSource = tableDataSource
        
        tableView.contentInset = TableView.paymentTypeContentInsets
    }
    
    // MARK: - PaymentTypeTableCellProtocol
    func didSelectCreditCartPayment() {
        performSegue(withIdentifier: SegueIdentifiers.toAddressList, sender: self)
    }
    
    // MARK: - segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addressListViewController = segue.destination as? AddressListViewController {
            addressListViewController.title = "ControllerTitle.BillingAddress".localizable
            addressListViewController.addressListType = .billing
            addressListViewController.destinationCreditCardCompletion = completion
        }
    }
}
