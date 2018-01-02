//
//  PaymentTypeViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/29/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

typealias PaymentCompletion = () -> ()

class PaymentTypeViewController: BaseViewController<PaymentTypeViewModel>, PaymentTypeTableCellProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    private var tableDataSource: PaymentTypeDataSource!
    var completion: PaymentCompletion?
    
    override func viewDidLoad() {
        viewModel = PaymentTypeViewModel()
        super.viewDidLoad()

        setupViews()
        setupTableView()
    }
    
    private func setupViews() {
        title = NSLocalizedString("ControllerTitle.PaymentType", comment: String())
    }
    
    private func setupTableView() {
        let cellNib = UINib(nibName: String(describing: PaymentTypeTableCell.self), bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: String(describing: PaymentTypeTableCell.self))
        
        tableDataSource = PaymentTypeDataSource(with: self)
        tableView.dataSource = tableDataSource
    }
    
    // MARK: - PaymentTypeTableCellProtocol
    func didSelectCreditCartPayment() {
        let addressListTitle = NSLocalizedString("ControllerTitle.BillingAddress", comment: String())
        pushAddressListController(title: addressListTitle) { [weak self] (address) in
            self?.pushCreditCardController()
        }
    }
}
