//
//  AddressListViewController.swift
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

protocol AddressListControllerDelegate: class {
    func viewController(didSelectBillingAddress address: Address)
}

class AddressListViewController<T: AddressListViewModel>: BaseViewController<T> {
    @IBOutlet private weak var tableView: UITableView!
    
    private var tableProvider: AddressListTableProvider!
    
    fileprivate var destinationAddress: Address?
    fileprivate var destinationAddressAction: AddressAction = .add
    fileprivate var needToUpdate = false
    
    var selectedAddress: Address?
    var addressListType: AddressListType = .shipping
    var showSelectionButton = false
    
    weak var delegate: AddressListControllerDelegate?
    
    // MARK: - View conttroller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let customerAddressFormController = segue.destination as? AccountAddressFormViewController {
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
        tableView.registerNibForCell(AddressListTableViewCell.self)
        
        tableProvider = AddressListTableProvider()
        tableProvider.showSelectionButton = showSelectionButton
        tableProvider.delegate = self
        tableView.dataSource = tableProvider
        tableView.delegate = tableProvider
    }
    
    private func setupViewModel() {
        viewModel.selectedAddress = selectedAddress
        
        viewModel.customerAddresses.asObservable()
            .subscribe(onNext: { [weak self] addresses in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tableProvider.addresses = addresses.map({ strongSelf.viewModel.addressTuple(with: $0) })
                strongSelf.tableView.reloadData()
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
        viewModel.loadCustomerAddresses()
    }
    
    func update(shippingAddress: Address) {
        if needToUpdate, let model = viewModel as? CheckoutAddressListViewModel {
            model.updateCheckoutShippingAddress(with: shippingAddress)
        } else {
            viewModel.loadCustomerAddresses(isTranslucentHud: true)
        }
    }
    
    func update(billingAddress: Address) {
        if needToUpdate {
            selectedAddress = billingAddress
            viewModel.selectedAddress = billingAddress
            delegate?.viewController(didSelectBillingAddress: billingAddress)
        }
        viewModel.loadCustomerAddresses(isTranslucentHud: true)
    }
}

// MARK: - AddressListHeaderViewDelegate

extension AddressListViewController: AddressListHeaderViewDelegate {
    func tableViewHeaderDidTapAddAddress(_ header: AddressListTableHeaderView) {
        destinationAddress = nil
        destinationAddressAction = .add
        performSegue(withIdentifier: SegueIdentifiers.toCustomerAddressForm, sender: self)
    }
}

// MARK: - AddressListTableViewCellDelegate

extension AddressListViewController: AddressListTableCellDelegate {
    func tableViewCell(_ cell: AddressListTableViewCell, didSelect address: Address) {
        if let model = viewModel as? CheckoutAddressListViewModel, addressListType == .shipping {
            model.updateCheckoutShippingAddress(with: address)
        } else if addressListType == .billing {
            selectedAddress = address
            viewModel.selectedAddress = address
            viewModel.loadCustomerAddresses(isTranslucentHud: true)
            delegate?.viewController(didSelectBillingAddress: address)
        }
    }
    
    func tableViewCell(_ cell: AddressListTableViewCell, didTapEdit address: Address) {
        destinationAddress = address
        destinationAddressAction = .edit
        needToUpdate = selectedAddress?.isEqual(to: address) ?? false
        performSegue(withIdentifier: SegueIdentifiers.toCustomerAddressForm, sender: self)
    }
    
    func tableViewCell(_ cell: AddressListTableViewCell, didTapDelete address: Address) {
        viewModel.deleteCustomerAddress(with: address, type: addressListType)
    }
    
    func tableViewCell(_ cell: AddressListTableViewCell, didTapDefault address: Address) {
        viewModel.updateCustomerDefaultAddress(with: address)
    }
}

// MARK: - AccountAddressFormControllerDelegate

extension AddressListViewController: AccountAddressFormControllerDelegate {
    func viewController(_ controller: AccountAddressFormViewController, didUpdate address: Address) {
        if addressListType == .shipping {
            update(shippingAddress: address)
        } else {
            update(billingAddress: address)
        }
        navigationController?.popToViewController(self, animated: true)
    }
    
    func viewController(_ controller: AccountAddressFormViewController, didAdd address: Address) {
        viewModel.loadCustomerAddresses(isTranslucentHud: true)
        navigationController?.popToViewController(self, animated: true)
    }
}
