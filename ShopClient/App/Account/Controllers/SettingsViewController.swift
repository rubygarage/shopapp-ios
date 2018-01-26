//
//  SettingsViewController.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController<SettingsViewModel> {
    @IBOutlet private weak var tableView: UITableView!
    
    private var tableDataSource: SettingsTableDataSource!
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = SettingsViewModel()
        super.viewDidLoad()
        
        updateNavigationBar()
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    // MARK: - Setup
    
    private func updateNavigationBar() {
        title = "ControllerTitle.Settings".localizable
    }
    
    private func setupTableView() {
        let cellName = String(describing: SwitchTableViewCell.self)
        let cellNib = UINib(nibName: cellName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellName)
        
        tableDataSource = SettingsTableDataSource()
        tableDataSource.delegate = self
        tableView.dataSource = tableDataSource
        
        tableView.contentInset = TableView.defaultContentInsets
    }
    
    private func setupViewModel() {
        viewModel.customer.asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadCustomer()
    }
}

// MARK: - SettingsTableDataSourceProtocol

extension SettingsViewController: SettingsTableDataSourceProtocol {
    func promo() -> (description: String, state: Bool)? {
        guard let customer = viewModel.customer.value else {
            return nil
        }
        return ("Label.Promo".localizable, customer.promo)
    }
}

// MARK: - SwitchTableViewCellDelegate

extension SettingsViewController: SwitchTableViewCellDelegate {
    func stateDidChange(at indexPath: IndexPath, value: Bool) {
        switch indexPath.section {
        case SettingsSection.promo.rawValue:
            viewModel.setPromo(value)
        default:
            break
        }
    }
}
