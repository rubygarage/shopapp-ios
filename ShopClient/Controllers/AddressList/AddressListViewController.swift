//
//  AddressListViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class AddressListViewController: BaseViewController<AddressListViewModel>, AddressListDataSourceProtocol, AddressListTableViewCellProtocol, AddressListHeaderViewProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    private var tableDataSource: AddressListDataSource!
    private var tableDelegate: AddressListDelegate!
    var selectedAddress: Address?
    var completion: AddressListCompletion?
    
    override func viewDidLoad() {
        viewModel = AddressListViewModel()
        super.viewDidLoad()

        setupTableView()
        setupViewModel()
        loadData()
    }
    
    private func setupTableView() {
        let addressCellNib = UINib(nibName: String(describing: AddressListTableViewCell.self), bundle: nil)
        tableView.register(addressCellNib, forCellReuseIdentifier: String(describing: AddressListTableViewCell.self))
        
        tableDataSource = AddressListDataSource(delegate: self)
        tableView.dataSource = tableDataSource
        
        tableDelegate = AddressListDelegate(delegate: self)
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
    }
    
    // MARK: - private
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
//        navigationController?.popViewController(animated: true)
    }
    
    func didTapEdit(with address: Address) {
        let selected = selectedAddress?.isEqual(to: address) ?? false
        pushAddressFormController(with: address) { [weak self] (filledAddress, isDefaultAddress) in
            self?.viewModel.updateAddress(with: filledAddress, isSelected: selected)
        }
    }
    
    func didTapDelete(with address: Address) {
        viewModel.deleteCustomerAddress(with: address)
    }
    
    // MARK: - AddressListHeaderViewProtocol
    func didTapAddNewAddress() {
        pushAddressFormController(with: nil) { [weak self] (address, isDefaultAddress) in
            self?.viewModel.addCustomerAddress(with: address, isDefaultAddress: isDefaultAddress)
        }
    }
}
