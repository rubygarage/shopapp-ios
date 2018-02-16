//
//  AccountViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/10/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

import ShopApp_Gateway

class AccountViewController: BaseViewController<AccountViewModel> {
    @IBOutlet private weak var tableView: UITableView!
    
    private var tableProvider: AccountTableProvider!
    
    fileprivate var selectedPolicy: Policy?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        viewModel = AccountViewModel()
        super.viewDidLoad()
        
        setupTableView()
        setupViewModel()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavigationBar()
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let policyViewController = segue.destination as? PolicyViewController {
            policyViewController.policy = selectedPolicy
        }
    }
    
    // MARK: - Setup
    
    fileprivate func updateNavigationBar() {
        navigationItem.title = "ControllerTitle.Account".localizable
        
        if viewModel.customer.value != nil && navigationItem.rightBarButtonItem == nil {
            let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(settingsButtonDidPress))
            navigationItem.rightBarButtonItem = settingsButton
        } else if viewModel.customer.value == nil {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    fileprivate func loadData() {
        viewModel.loadCustomer()
        viewModel.loadPolicies()
    }
    
    private func setupTableView() {
        tableView.registerNibForCell(AccountTableViewCell.self)
        
        tableProvider = AccountTableProvider()
        tableProvider.delegate = self
        tableView.dataSource = tableProvider
        tableView.delegate = tableProvider
    }
    
    private func setupViewModel() {
        viewModel.policies.asObservable()
            .subscribe(onNext: { [weak self] policies in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tableProvider.policies = policies
                strongSelf.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.customer.asObservable()
            .subscribe(onNext: { [weak self] customer in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.updateNavigationBar()
                strongSelf.tableProvider.customer = customer
                strongSelf.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    
    @objc private func settingsButtonDidPress() {
        performSegue(withIdentifier: SegueIdentifiers.toAccountSettings, sender: self)
    }
}

// MARK: - AccountTableProviderDelegate

extension AccountViewController: AccountTableProviderDelegate {
    func provider(_ provider: AccountTableProvider, didSelect policy: Policy) {
        selectedPolicy = policy
        performSegue(withIdentifier: SegueIdentifiers.toPolicy, sender: self)
    }
}

// MARK: - AccountNotLoggedHeaderDelegate

extension AccountViewController: AccountNotLoggedHeaderDelegate {
    func headerViewDidTapSignIn(_ headerView: AccountNotLoggedHeaderView) {
        performSegue(withIdentifier: SegueIdentifiers.toSignIn, sender: self)
    }
    
    func headerViewDidTapCreateNewAccount(_ headerView: AccountNotLoggedHeaderView) {
        performSegue(withIdentifier: SegueIdentifiers.toSignUp, sender: self)
    }
}

// MARK: - AccountLoggedHeaderDelegate

extension AccountViewController: AccountLoggedHeaderDelegate {
    func headerViewDidTapMyOrders(_ headerView: AccountLoggedHeaderView) {
        performSegue(withIdentifier: SegueIdentifiers.toOrdersList, sender: self)
    }
    
    func headerViewDidTapPersonalInfo(_ headerView: AccountLoggedHeaderView) {
        performSegue(withIdentifier: SegueIdentifiers.toPersonalInfo, sender: self)
    }
    
    func headerViewDidTapShippingAddress(_ headerView: AccountLoggedHeaderView) {
        performSegue(withIdentifier: SegueIdentifiers.toAddressList, sender: self)
    }
}

// MARK: - AccountFooterViewDelegate

extension AccountViewController: AccountFooterDelegate {
    func footerViewDidTapLogout(_ footerView: AccountFooterView) {
        viewModel.logout()
        updateNavigationBar()
        showToast(with: "Alert.LoggedOut".localizable)
    }
}
