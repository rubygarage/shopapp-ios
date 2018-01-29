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
    
    private var tableProvider: SettingsTableProvider!
    
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
        
        tableProvider = SettingsTableProvider()
        tableView.dataSource = tableProvider
        
        tableView.contentInset = TableView.defaultContentInsets
    }
    
    private func setupViewModel() {
        viewModel.customer.asObservable()
            .subscribe(onNext: { [weak self] customer in
                guard let strongSelf = self else {
                    return
                }
                if let customer = customer {
                    strongSelf.tableProvider.promo = ("Label.Promo".localizable, customer.promo)
                } else {
                    strongSelf.tableProvider.promo = nil
                }
                strongSelf.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadCustomer()
    }
}

// MARK: - SwitchTableViewCellDelegate

extension SettingsViewController: SwitchTableViewCellDelegate {
    func tableViewCell(_ tableViewCell: SwitchTableViewCell, didChangeSwitchStateAt indexPath: IndexPath, with value: Bool) {
        switch indexPath.section {
        case SettingsSection.promo.rawValue:
            viewModel.setPromo(value)
        default:
            break
        }
    }
}
