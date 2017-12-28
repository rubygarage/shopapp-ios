//
//  AddressListViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class AddressListViewController: BaseViewController<AddressListViewModel>, AddressListDataSourceProtocol, AddressListTableViewCellProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    var tableDataSource: AddressListDataSource!
    var checkoutId: String!
    var selectedAddress: Address!
    var delegate: AddressListViewModelProtocol!
    
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
    }
    
    private func setupViewModel() {
        viewModel.checkoutId = checkoutId
        viewModel.selectedAddress = selectedAddress
        viewModel.delegate = delegate
        
        viewModel.customerAddresses.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.remoteOperationsCompleted
            .subscribe(onNext: { [weak self] _ in
                self?.closeAddressFormController()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - private
    private func loadData() {
        viewModel.loadCustomerAddresses()
    }
    
    private func closeAddressFormController() {
        navigationController?.popToViewController(self, animated: true)
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
        pushAddressFormController(with: address) { [weak self] (filledAddress, isDefaultAddress) in
            self?.viewModel.updateAddress(with: filledAddress)
        }
    }
    
    func didTapDelete(with address: Address) {
        viewModel.deleteCustomerAddress(with: address)
    }
}
