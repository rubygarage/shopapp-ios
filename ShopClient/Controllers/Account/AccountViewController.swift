//
//  AccountViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/10/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class AccountViewController: BaseViewController<AccountViewModel>, AccountTableDataSourceProtocol, AccountTableDelegateProtocol, AccountNotLoggedHeaderProtocol, AccountLoggedHeaderProtocol, SignInViewModelProtocol, SignUpViewModelProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    var tableDataSource: AccountTableDataSource!
    var tableDelegate: AccountTableDelegate!
    
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
    
    private func updateNavigationBar() {
        tabBarController?.navigationItem.titleView = nil
        tabBarController?.title = NSLocalizedString("ControllerTitle.Account", comment: String())
    }
    
    private func setupTableView() {
        let cellNib = UINib(nibName: String(describing: AccountTableViewCell.self), bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: String(describing: AccountTableViewCell.self))
        
        tableDataSource = AccountTableDataSource(delegate: self)
        tableView.dataSource = tableDataSource
        
        tableDelegate = AccountTableDelegate(delegate: self)
        tableView.delegate = tableDelegate
    }
    
    private func setupViewModel() {
        viewModel.policies.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.customer.asObservable()
            .subscribe(onNext: { (customer) in
                print()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        viewModel.loadData(with: disposeBag)
    }
    
    // MARK: - AccountTableDataSourceProtocol
    func policies() -> [Policy] {
        return viewModel.policies.value
    }
    
    // MARK: - AccountTableDelegateProtocol
    func didSelectItem(at index: Int) {
        if index < viewModel.policies.value.count {
            let policy = viewModel.policies.value[index]
            pushPolicyController(with: policy)
        }
    }
    
    func customer() -> Customer? {
        return viewModel.customer.value
    }
    
    // MARK: - AccountNotLoggedHeaderProtocol
    func didTapSignIn() {
        showSignInController(delegate: self)
    }
    
    func didTapCreateNewAccount() {
        showSignUpController(delegate: self)
    }
    
    // MARK: - AccountLoggedHeaderProtocol
    func didTapMyOrders() {
        // TODO:
    }
    
    // MARK: - SignInViewModelProtocol
    func didSignedIn() {
        loadData()
    }
    
    // MARK: - SignUpViewModelProtocol
    func didSignedUp() {
        loadData()
    }
}
