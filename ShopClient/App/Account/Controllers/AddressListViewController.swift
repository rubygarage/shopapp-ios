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

protocol AddressListControllerDelegate: class {
    func viewController(_ controller: AddressListViewController, didSelect address: Address)
}

class AddressListViewController: BaseViewController<AddressListViewModel> {
    @IBOutlet private weak var tableView: UITableView!
    
    private var tableProvider: AddressListTableProvider!
    
    fileprivate var destinationAddress: Address?
    fileprivate var destinationAddressAction: AddressAction = .add
    fileprivate var needToUpdate = false
    
    var selectedAddress: Address?
    var addressListType: AddressListType = .shipping
    
    weak var delegate: AddressListControllerDelegate?
    
    // MARK: - View conttroller lifecycle
    
    override func viewDidLoad() {
        viewModel = AddressListViewModel()
        super.viewDidLoad()

        setupViews()
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let customerAddressFormController = segue.destination as? CustomerAddressFormViewController {
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
                if strongSelf.addressListType == .billing {
                    strongSelf.destinationAddress = address
                }
                strongSelf.delegate?.viewController(strongSelf, didSelect: address)
            })
            .disposed(by: disposeBag)
    }
        
    private func loadData() {
        viewModel.loadCustomerAddresses()
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
        viewModel.updateCheckoutShippingAddress(with: address)
    }
    
    func tableViewCell(_ cell: AddressListTableViewCell, didTapEdit address: Address) {
        destinationAddress = address
        destinationAddressAction = .edit
        needToUpdate = selectedAddress?.isEqual(to: address) ?? false
        performSegue(withIdentifier: SegueIdentifiers.toCustomerAddressForm, sender: self)
    }
    
    func tableViewCell(_ cell: AddressListTableViewCell, didTapDelete address: Address) {
        let isSelected = viewModel.selectedAddress?.isEqual(to: address) ?? false
        viewModel.deleteCustomerAddress(with: address, isSelected: isSelected)
    }
    
    func tableViewCell(_ cell: AddressListTableViewCell, didTapDefault address: Address) {
        viewModel.updateCustomerDefaultAddress(with: address)
    }
}

// MARK: - CustomerAddressFormControllerDelegate

extension AddressListViewController: CustomerAddressFormControllerDelegate {
    func viewController(_ controller: CustomerAddressFormViewController, didUpdate address: Address) {
        if needToUpdate {
            viewModel.updateCheckoutShippingAddress(with: address)
        } else {
            viewModel.loadCustomerAddresses()
        }
        navigationController?.popToViewController(self, animated: true)
    }
}
