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

class AddressListViewController: BaseViewController<AddressListViewModel>, AddressListDataSourceProtocol, AddressListTableViewCellProtocol, AddressListHeaderViewProtocol {
    @IBOutlet private weak var tableView: UITableView!
    
    private var tableDataSource: AddressListDataSource!
    // swiftlint:disable weak_delegate
    private var tableDelegate: AddressListDelegate!
    // swiftlint:enable weak_delegate
    private var destinationAddress: Address?
    private var destinationAddressFormCompletion: AddressFormCompletion!
    
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
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.didSelectAddress
            .subscribe(onNext: { [weak self] (address) in
                if self?.addressListType == .billing {
                    self?.destinationAddress = address
                }
        })
        .disposed(by: disposeBag)
    }
    
    // MARK: - Private
    
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
        let selected = selectedAddress?.isEqual(to: address) ?? false
        destinationAddress = address
        destinationAddressFormCompletion = { [weak self] (filledAddress, isDefaultAddress) in
            self?.viewModel.updateAddress(with: filledAddress, isSelected: selected)
        }
        performSegue(withIdentifier: SegueIdentifiers.toAddressForm, sender: self)
    }
    
    func didTapDelete(with address: Address) {
        viewModel.deleteCustomerAddress(with: address)
    }
    
    // MARK: - AddressListHeaderViewProtocol
    
    func didTapAddNewAddress() {
        destinationAddress = nil
        destinationAddressFormCompletion = { [weak self] (address, isDefaultAddress) in
            self?.viewModel.addCustomerAddress(with: address, isDefaultAddress: isDefaultAddress)
        }
        performSegue(withIdentifier: SegueIdentifiers.toAddressForm, sender: self)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addressFormViewController = segue.destination as? AddressFormViewController {
            addressFormViewController.address = destinationAddress
            addressFormViewController.completion = destinationAddressFormCompletion
        }
    }
}
