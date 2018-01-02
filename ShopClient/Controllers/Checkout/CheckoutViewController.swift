//
//  CheckoutViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CheckoutViewController: BaseViewController<CheckoutViewModel>, SeeAllHeaderViewProtocol, CheckoutCombinedProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    private var tableDataSource: CheckoutTableDataSource!
    private var tableDelegate: CheckoutTableDelegate!
    
    override func viewDidLoad() {
        viewModel = CheckoutViewModel()
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
        
        let shippingAddressAddNib = UINib(nibName: String(describing: CheckoutShippingAddressAddTableCell.self), bundle: nil)
        tableView.register(shippingAddressAddNib, forCellReuseIdentifier: String(describing: CheckoutShippingAddressAddTableCell.self))
        
        let shippingAddressEditNib = UINib(nibName: String(describing: CheckoutShippingAddressEditTableCell.self), bundle: nil)
        tableView.register(shippingAddressEditNib, forCellReuseIdentifier: String(describing: CheckoutShippingAddressEditTableCell.self))
        
        let paymentAddNib = UINib(nibName: String(describing: CheckoutPaymentAddTableCell.self), bundle: nil)
        tableView.register(paymentAddNib, forCellReuseIdentifier: String(describing: CheckoutPaymentAddTableCell.self))
        
        tableDataSource = CheckoutTableDataSource(delegate: self)
        tableView?.dataSource = tableDataSource
        
        tableDelegate = CheckoutTableDelegate(delegate: self)
        tableView?.delegate = tableDelegate
        
        tableView?.contentInset = TableView.defaultContentInsets
    }
    
    private func setupViewModel() {
        viewModel.checkout.asObservable()
            .subscribe(onNext: { [weak self] (checkout) in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadData(with: disposeBag)
    }
    
    private func closeAddressFormController() {
        navigationController?.popToViewController(self, animated: true)
    }
    
    // MARK: - CheckoutTableDataSourceProtocol
    func cartProducts() -> [CartProduct] {
        return viewModel.cartItems
    }
    
    func shippingAddress() -> Address? {
        return viewModel.checkout.value?.shippingAddress
    }
    
    // MARK: - CheckoutShippingAddressAddCellProtocol
    func didTapAddNewAddress() {
        pushAddressFormController(with: nil) { [weak self] (address, isDefaultAddress) in
            self?.viewModel.updateCheckoutShippingAddress(with: address, isDefaultAddress: isDefaultAddress)
        }
    }
    
    // MARK: - CheckoutShippingAddressEditCellProtocol
    func didTapEdit() {
        if let checkoutId = viewModel.checkout.value?.id, let address = viewModel.checkout.value?.shippingAddress {
            processUpdateAddress(with: checkoutId, address: address)
        }
    }
    
    // MARK: - private
    private func processUpdateAddress(with checkoutId: String, address: Address) {
        if Repository.shared.isLoggedIn() {
            openAddressList(with: checkoutId, address: address)
        } else {
            openAddressForm(with: address)
        }
    }
    
    private func openAddressList(with checkoutId: String, address: Address) {
        pushAddressListController(with: address, completion: { [weak self] (address) in
            self?.viewModel.updateCheckoutShippingAddress(with: address, isDefaultAddress: false)
        })
    }
    
    private func openAddressForm(with address: Address) {
        pushAddressFormController(with: address, completion: { [weak self] (address, isDefaultAddress) in
            self?.viewModel.updateCheckoutShippingAddress(with: address, isDefaultAddress: isDefaultAddress)
        })
    }
    
    // MARK: - SeeAllHeaderViewProtocol
    func didTapSeeAll(type: SeeAllViewType) {
        if type == .myCart {
            // TODO:
        }
    }
    
    // MARK: - CheckoutPaymentAddCellProtocol
    func didTapAddPayment() {
        if let checkoutId = viewModel.checkout.value?.id, let address = viewModel.checkout.value?.shippingAddress {
            pushPaymentTypeController()
        }
    }
}
