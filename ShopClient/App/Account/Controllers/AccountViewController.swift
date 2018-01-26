//
//  AccountViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/10/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class AccountViewController: BaseViewController<AccountViewModel> {
    @IBOutlet private weak var tableView: UITableView!
    
    private var tableDataSource: AccountTableDataSource!
    // swiftlint:disable weak_delegate
    private var tableDelegate: AccountTableDelegate!
    // swiftlint:enable weak_delegate
    
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
        } else if let navigationController = segue.destination as? UINavigationController {
            if let signInViewController = navigationController.viewControllers.first as? SignInViewController {
                signInViewController.delegate = self
            } else if let signUpViewController = navigationController.viewControllers.first as? SignUpViewController {
                signUpViewController.delegate = self
            }
        }
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        let cellName = String(describing: AccountTableViewCell.self)
        let cellNib = UINib(nibName: cellName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellName)
        
        tableDataSource = AccountTableDataSource()
        tableDataSource.delegate = self
        tableView.dataSource = tableDataSource
        
        tableDelegate = AccountTableDelegate()
        tableDelegate.delegate = self
        tableView.delegate = tableDelegate
    }
    
    private func setupViewModel() {
        viewModel.policies.asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.customer.asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.updateNavigationBar()
                strongSelf.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    fileprivate func updateNavigationBar() {
        navigationItem.title = "ControllerTitle.Account".localizable
        
        if viewModel.customer.value != nil && navigationItem.rightBarButtonItem == nil {
            let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(self.settingsButtonHandler))
            navigationItem.rightBarButtonItem = settingsButton
        } else if viewModel.customer.value == nil {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    fileprivate func loadData() {
        viewModel.loadCustomer()
        viewModel.loadPolicies()
    }
    
    // MARK: - Actions
    
    @objc private func settingsButtonHandler() {
        performSegue(withIdentifier: SegueIdentifiers.toAccountSettings, sender: self)
    }
}

// MARK: - AccountTableDataSourceProtocol

extension AccountViewController: AccountTableDataSourceProtocol {
    func policies() -> [Policy] {
        return viewModel.policies.value
    }
}

// MARK: - AccountTableDelegateProtocol

extension AccountViewController: AccountTableDelegateProtocol {
    func didSelectItem(at index: Int) {
        guard index < viewModel.policies.value.count else {
            return
        }
        selectedPolicy = viewModel.policies.value[index]
        performSegue(withIdentifier: SegueIdentifiers.toPolicy, sender: self)
    }
    
    func customer() -> Customer? {
        return viewModel.customer.value
    }
}

// MARK: - AccountNotLoggedHeaderDelegate

extension AccountViewController: AccountNotLoggedHeaderDelegate {
    func didTapSignIn() {
        performSegue(withIdentifier: SegueIdentifiers.toSignIn, sender: self)
    }
    
    func didTapCreateNewAccount() {
        performSegue(withIdentifier: SegueIdentifiers.toSignUp, sender: self)
    }
}

// MARK: - AccountLoggedHeaderDelegate

extension AccountViewController: AccountLoggedHeaderDelegate {
    func didTapMyOrders() {
        performSegue(withIdentifier: SegueIdentifiers.toOrdersList, sender: self)
    }
    
    func didTapPersonalInfo() {
        performSegue(withIdentifier: SegueIdentifiers.toPersonalInfo, sender: self)
    }
}

// MARK: - AccountFooterViewDelegate

extension AccountViewController: AccountFooterViewDelegate {
    func didTapLogout() {
        viewModel.logout()
        updateNavigationBar()
    }
}

// MARK: - AuthenticationProtocol

extension AccountViewController: AuthenticationProtocol {
    func didAuthorize() {
        loadData()
    }
}
