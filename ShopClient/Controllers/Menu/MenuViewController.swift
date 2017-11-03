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

class MenuViewController: BaseViewController<BaseViewModel>, MenuTableDataSourceProtocol, MenuTableDelegateProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    private var menuViewModel = MenuViewModel()
    
    var categories = [Category]()
    var policies = [Policy]()
    
    var tableDataSource: MenuTableDataSource?
    var tableDelegate: MenuTableDelegate?

    override func viewDidLoad() {
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
        
        tableDataSource = MenuTableDataSource(delegate: self)
        tableView.dataSource = tableDataSource
        
        tableDelegate = MenuTableDelegate(delegate: self)
        tableView.delegate = tableDelegate
    }
    
    private func loadData() {
        menuViewModel.data.subscribe(onSuccess: { [weak self] (shop, categories) in
            self?.processResponse(with: shop, categoriesItems: categories)
            self?.tableView.reloadData()
        }, onError: { [weak self] (error) in
            self?.showErrorAlert(with: error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    private func processResponse(with shopItem: Shop?, categoriesItems: [Category]?) {
        if let privacyPolicy = shopItem?.privacyPolicy {
            policies.append(privacyPolicy)
        }
        if let refundPolicy = shopItem?.refundPolicy {
            policies.append(refundPolicy)
        }
        if let termsOfService = shopItem?.termsOfService {
            policies.append(termsOfService)
        }
        if let categoriesItems = categoriesItems {
            categories = categoriesItems
        }
    }
    
    private func openCategoryController(with index: Int) {
        if index < categories.count {
            let category = categories[index]
            setCategoryController(with: category.id, title: category.title ?? String())
        }
    }
    
    private func openPolicyController(with index: Int) {
        if index < policies.count {
            let policy = policies[index]
            pushPolicyController(with: policy)
        }
    }
    
    // MARK: - MenuTableDataSourceProtocol
    func numberOfCategories() -> Int {
        return categories.count
    }
    
    func category(for index: Int) -> Category? {
        if index < categories.count {
            return categories[index]
        }
        return nil
    }
    
    func numberOfPolicies() -> Int {
        return policies.count
    }
    
    func policyTitle(for index: Int) -> String? {
        if index < policies.count {
            return policies[index].title
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
        }
    }
    
    // MARK: - view model
//    override func viewModel() -> BaseViewModel {
//        return menuViewModel
//    }
}
