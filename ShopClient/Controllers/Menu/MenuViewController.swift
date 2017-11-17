//
//  MenuViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/18/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MenuViewController: BaseViewController<MenuViewModel>, MenuTableDataSourceProtocol, MenuTableDelegateProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    var tableDataSource: MenuTableDataSource?
    var tableDelegate: MenuTableDelegate?

    override func viewDidLoad() {
        viewModel = MenuViewModel()
        super.viewDidLoad()
        
        setupTableView()
        loadData()
    }
    
    private func setupTableView() {
        let menuCategoryNib = UINib(nibName: String(describing: MenuCategoryTableViewCell.self), bundle: nil)
        tableView.register(menuCategoryNib, forCellReuseIdentifier: String(describing: MenuCategoryTableViewCell.self))
        
        let menuDefaultNib = UINib(nibName: String(describing: MenuDefaultTableViewCell.self), bundle: nil)
        tableView.register(menuDefaultNib, forCellReuseIdentifier: String(describing: MenuDefaultTableViewCell.self))
        
        let menuImageNib = UINib(nibName: String(describing: MenuImageTableViewCell.self), bundle: nil)
        tableView.register(menuImageNib, forCellReuseIdentifier: String(describing: MenuImageTableViewCell.self))
        
        let menuAccountNib = UINib(nibName: String(describing: MenuAccountTableViewCell.self), bundle: nil)
        tableView.register(menuAccountNib, forCellReuseIdentifier: String(describing: MenuAccountTableViewCell.self))
        
        tableDataSource = MenuTableDataSource(delegate: self)
        tableView.dataSource = tableDataSource
        
        tableDelegate = MenuTableDelegate(delegate: self)
        tableView.delegate = tableDelegate
    }
    
    private func loadData() {
        viewModel.data.subscribe(onSuccess: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func openCategoryController(with index: Int) {
        if index < viewModel.categories.value.count {
            let category = viewModel.categories.value[index]
            setCategoryController(with: category.id, title: category.title ?? String())
        }
    }
    
    private func openPolicyController(with index: Int) {
        if index < viewModel.policies.value.count {
            let policy = viewModel.policies.value[index]
            pushPolicyController(with: policy)
        }
    }
    
    // MARK: - MenuTableDataSourceProtocol
    func numberOfCategories() -> Int {
        return viewModel.categories.value.count
    }
    
    func category(for index: Int) -> Category? {
        if index < viewModel.categories.value.count {
            return viewModel.categories.value[index]
        }
        return nil
    }
    
    func numberOfPolicies() -> Int {
        return viewModel.policies.value.count
    }
    
    func policyTitle(for index: Int) -> String? {
        if index < viewModel.policies.value.count {
            return viewModel.policies.value[index].title
        }
        return nil
    }
    
    // MARK: - MenuTableDelegateProtocol
    func didSelectMenuItem(at indexPath: IndexPath) {
        if indexPath.section == MenuSection.home.rawValue {
            setHomeController()
        } else if indexPath.section == MenuSection.category.rawValue {
            openCategoryController(with: indexPath.row)
        } else if indexPath.section == MenuSection.policy.rawValue {
            openPolicyController(with: indexPath.row)
        } else if indexPath.section == MenuSection.account.rawValue {
//            Repository.shared.isLoggedIn() ? setAccountController() : setAuthController()
            setAuthController()
        }
    }
}
