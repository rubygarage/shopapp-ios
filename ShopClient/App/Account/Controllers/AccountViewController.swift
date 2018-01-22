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
        let cellNib = UINib(nibName: String(describing: AccountTableViewCell.self), bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: String(describing: AccountTableViewCell.self))
        
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
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.customer.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.updateNavigationBar()
                self?.tableView.reloadData()
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
        performSegue(withIdentifier: SegueIdentifiers.toPersonalInfo, sender: self) // toAccountSettings
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
        if index < viewModel.policies.value.count {
            selectedPolicy = viewModel.policies.value[index]
            performSegue(withIdentifier: SegueIdentifiers.toPolicy, sender: self)
        }
    }
    
    func customer() -> Customer? {
        return viewModel.customer.value
    }
}

// MARK: - AccountNotLoggedHeaderProtocol

extension AccountViewController: AccountNotLoggedHeaderProtocol {
    func didTapSignIn() {
        performSegue(withIdentifier: SegueIdentifiers.toSignIn, sender: self)
    }
    
    func didTapCreateNewAccount() {
        performSegue(withIdentifier: SegueIdentifiers.toSignUp, sender: self)
    }
}

// MARK: - AccountLoggedHeaderProtocol

extension AccountViewController: AccountLoggedHeaderProtocol {
    func didTapMyOrders() {
        performSegue(withIdentifier: SegueIdentifiers.toOrdersList, sender: self)
    }
}

// MARK: - AccountFooterViewProtocol

extension AccountViewController: AccountFooterViewProtocol {
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
