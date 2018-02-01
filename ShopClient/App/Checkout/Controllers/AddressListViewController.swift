//
//  AddressListViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

enum AddressListType {
    case shipping
    case billing
}

class AddressListViewController: BaseViewController<AddressListViewModel>, AddressListDataSourceProtocol, AddressListTableViewCellProtocol {
    @IBOutlet private weak var tableView: UITableView!
    
    private var tableDataSource: AddressListDataSource!
    // swiftlint:disable weak_delegate
    private var tableDelegate: AddressListDelegate!
    // swiftlint:enable weak_delegate
    
    fileprivate var destinationAddress: Address?
    fileprivate var destinationAddressAction: AddressAction = .add
    fileprivate var needToUpdate = false
    
    var selectedAddress: Address?
    var completion: AddressListCompletion?
    var addressListType: AddressListType = .shipping
    
    override func viewDidLoad() {
        viewModel = AddressListViewModel()
        super.viewDidLoad()

        setupViews()
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    private func setupViews() {
        title = addressListType == .shipping ? "ControllerTitle.ShippingAddress".localizable : "ControllerTitle.BillingAddress".localizable
    }
    
    private func setupTableView() {
        let addressCellNib = UINib(nibName: String(describing: AddressListTableViewCell.self), bundle: nil)
        tableView.register(addressCellNib, forCellReuseIdentifier: String(describing: AddressListTableViewCell.self))
        
        tableDataSource = AddressListDataSource()
        tableDataSource.delegate = self
        tableView.dataSource = tableDataSource
        
        tableDelegate = AddressListDelegate()
        tableDelegate.delegate = self
        tableView.delegate = tableDelegate
    }
    
    private func setupViewModel() {
        viewModel.selectedAddress = selectedAddress
        viewModel.completion = completion
        
        viewModel.customerAddresses.asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.didSelectAddress
            .subscribe(onNext: { [weak self] (address) in
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.addressListType == .billing {
                    strongSelf.destinationAddress = address
                }
            })
            .disposed(by: disposeBag)
    }
        
    private func loadData() {
        viewModel.loadCustomerAddresses()
    }
    
    // MARK: - AddressListDataSourceProtocol
    
    func itemsCount() -> Int {
        return viewModel.customerAddresses.value.count
    }
    
    func item(at index: Int) -> AddressTuple {
        return viewModel.item(at: index)
    }
    
    // MARK: - AddressListTableViewCellProtocol
    
    func didTapSelect(with address: Address) {
        viewModel.updateCheckoutShippingAddress(with: address)
    }
    
    func didTapEdit(with address: Address) {
        destinationAddress = address
        destinationAddressAction = .edit
        needToUpdate = selectedAddress?.isEqual(to: address) ?? false
        performSegue(withIdentifier: SegueIdentifiers.toCustomerAddressForm, sender: self)
    }
    
    func didTapDelete(with address: Address) {
        let isSelected = viewModel.selectedAddress?.isEqual(to: address) ?? false
        viewModel.deleteCustomerAddress(with: address, isSelected: isSelected)
    }
    
    func didTapDefault(with address: Address) {
        viewModel.updateCustomerDefaultAddress(with: address)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let customerAddressFormController = segue.destination as? CustomerAddressFormViewController {
            customerAddressFormController.selectedAddress = destinationAddress
            customerAddressFormController.delegate = self
            customerAddressFormController.addressAction = destinationAddressAction
        }
    }
}

// MARK: - AddressListHeaderViewProtocol

extension AddressListViewController: AddressListHeaderViewProtocol {
    func didTapAddNewAddress() {
        destinationAddress = nil
        destinationAddressAction = .add
        performSegue(withIdentifier: SegueIdentifiers.toCustomerAddressForm, sender: self)
    }
}

// MARK: - CustomerAddressFormDelegate

extension AddressListViewController: CustomerAddressFormDelegate {
    func viewModel(_ model: CustomerAddressFormViewModel, didUpdate address: Address) {
        if needToUpdate {
            viewModel.updateCheckoutShippingAddress(with: address)
        } else {
            viewModel.loadCustomerAddresses()
        }
        navigationController?.popToViewController(self, animated: true)
    }
}
