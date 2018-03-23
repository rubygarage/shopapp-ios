//
//  BaseAddressListViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

enum AddressListType {
    case shipping
    case billing
}

protocol BaseAddressListControllerDelegate: class {
    func viewController(didSelectBillingAddress address: Address)
}

class BaseAddressListViewController<T: BaseAddressListViewModel>: BaseViewController<T>, AddressListHeaderViewDelegate, AddressListTableCellDelegate, AccountAddressFormControllerDelegate {
    // swiftlint:disable private_outlet
    @IBOutlet private(set) weak var tableView: UITableView!
    // swiftlint:enable private_outlet
    
    private var destinationAddress: Address?
    private var destinationAddressAction: AddressAction = .add
    
    var tableProvider: BaseAddressListTableProvider!
    var selectedAddress: Address?
    var addressListType: AddressListType = .shipping
    var showSelectionButton = false
    
    weak var delegate: BaseAddressListControllerDelegate?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let customerAddressFormController = segue.destination as? AccountAddressFormViewController {
            customerAddressFormController.isSelectedAddress = destinationAddress?.isEqual(to: selectedAddress) ?? false
            customerAddressFormController.selectedAddress = destinationAddress
            customerAddressFormController.delegate = self
            customerAddressFormController.addressAction = destinationAddressAction
        }
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        title = addressListType == .shipping ? "ControllerTitle.ShippingAddress".localizable : "ControllerTitle.BillingAddress".localizable
    }
    
    private func setupTableView() {
        guard let tableView = tableView else {
            return
        }
        tableView.registerNibForCell(AddressListTableViewCell.self)
        
        tableProvider.showSelectionButton = showSelectionButton
        tableProvider.delegate = self
        tableView.dataSource = tableProvider
        tableView.delegate = tableProvider        
    }
    
    private func setupViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.selectedAddress = selectedAddress
        
        viewModel.customerAddresses.asObservable()
            .subscribe(onNext: { [weak self] addresses in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tableProvider.addresses = addresses.map({ strongSelf.viewModel.addressTuple(with: $0) })
                strongSelf.tableView?.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.didSelectAddress
            .subscribe(onNext: { [weak self] (address) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.selectedAddress = address
                strongSelf.viewModel.selectedAddress = address
                strongSelf.viewModel.loadCustomerAddresses(isTranslucentHud: true)
                if strongSelf.addressListType == .billing {
                    strongSelf.delegate?.viewController(didSelectBillingAddress: address)
                }
            })
            .disposed(by: disposeBag)
    }
        
    private func loadData() {
        viewModel?.loadCustomerAddresses()
    }
    
    func update(shippingAddress: Address, isSelectedAddress: Bool) {
        viewModel.loadCustomerAddresses(isTranslucentHud: true)
    }
    
    func update(billingAddress: Address, isSelectedAddress: Bool) {
        if isSelectedAddress {
            selectedAddress = billingAddress
            viewModel.selectedAddress = billingAddress
            delegate?.viewController(didSelectBillingAddress: billingAddress)
        }
        viewModel.loadCustomerAddresses(isTranslucentHud: true)
    }
    
    // MARK: - AddressListHeaderViewDelegate
    
    func tableViewHeaderDidTapAddAddress(_ header: AddressListTableHeaderView) {
        destinationAddress = nil
        destinationAddressAction = .add
        performSegue(withIdentifier: SegueIdentifiers.toCustomerAddressForm, sender: self)
    }
    
    // MARK: - AddressListTableCellDelegate
    
    func tableViewCell(_ cell: AddressListTableViewCell, didSelect address: Address) {
        // Method to override
    }
    
    func tableViewCell(_ cell: AddressListTableViewCell, didTapEdit address: Address) {
        destinationAddress = address
        destinationAddressAction = .edit
        performSegue(withIdentifier: SegueIdentifiers.toCustomerAddressForm, sender: self)
    }
    
    func tableViewCell(_ cell: AddressListTableViewCell, didTapDelete address: Address) {
        viewModel.deleteCustomerAddress(with: address, type: addressListType)
    }
    
    func tableViewCell(_ cell: AddressListTableViewCell, didTapDefault address: Address) {
        viewModel.updateCustomerDefaultAddress(with: address)
    }
    
    // MARK: - AccountAddressFormControllerDelegate
    
    func viewController(_ controller: AccountAddressFormViewController, didUpdate address: Address, isSelectedAddress: Bool) {
        if addressListType == .shipping {
            update(shippingAddress: address, isSelectedAddress: isSelectedAddress)
        } else {
            update(billingAddress: address, isSelectedAddress: isSelectedAddress)
        }
        navigationController?.popToViewController(self, animated: true)
    }
    
    func viewController(_ controller: AccountAddressFormViewController, didAdd address: Address) {
        viewModel.loadCustomerAddresses(isTranslucentHud: true)
        navigationController?.popToViewController(self, animated: true)
    }
}
