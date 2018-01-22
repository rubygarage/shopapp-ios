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
        
        setupViews()
        setupTableView()
        setupViewModel()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        title = "ControllerTitle.Settings".localizable
    }
    
    private func setupTableView() {
        let cellNib = UINib(nibName: String(describing: SwitchTableViewCell.self), bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: String(describing: SwitchTableViewCell.self))
        
        tableDataSource = SettingsTableDataSource()
        tableDataSource.delegate = self
        tableView.dataSource = tableDataSource
        
        tableView.contentInset = TableView.defaultContentInsets
    }
    
    private func setupViewModel() {
//        viewModel.policies.asObservable()
//            .subscribe(onNext: { [weak self] _ in
//                self?.tableView.reloadData()
//            })
//            .disposed(by: disposeBag)
//        
//        viewModel.customer.asObservable()
//            .subscribe(onNext: { [weak self] _ in
//                self?.updateNavigationBar()
//                self?.tableView.reloadData()
//            })
//            .disposed(by: disposeBag)
    }
}

// MARK: - SettingsTableDataSourceProtocol

extension SettingsViewController: SettingsTableDataSourceProtocol {
    func promo() -> (description: String, state: Bool)? {
        return ("Label.Promo".localizable, true)
    }
}

// MARK: - SwitchTableViewCellProtocol

extension SettingsViewController: SwitchTableViewCellProtocol {
    func stateDidChange(at indexPath: IndexPath, value: Bool) {
        switch indexPath.section {
        case SettingsSection.promo.rawValue:
            break
        default:
            break
        }
    }
}
