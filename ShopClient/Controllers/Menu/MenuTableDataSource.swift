//
//  MenuTableDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/18/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

enum MenuSection: Int {
    case home
    case category
    case policy
    case account
}

protocol MenuTableDataSourceProtocol {
    func numberOfCategories() -> Int
    func category(for index: Int) -> Category?
    func numberOfPolicies() -> Int
    func policyTitle(for index: Int) -> String?
}

let kMenuNumberOfSections = 4

class MenuTableDataSource: NSObject, UITableViewDataSource {
    var delegate: MenuTableDataSourceProtocol?
    
    init(delegate: MenuTableDataSourceProtocol?) {
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return kMenuNumberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case MenuSection.home.rawValue:
            return 1
        case MenuSection.category.rawValue:
            return delegate?.numberOfCategories() ?? 0
        case MenuSection.policy.rawValue:
            return delegate?.numberOfPolicies() ?? 0
        case MenuSection.account.rawValue:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case MenuSection.home.rawValue:
            return menuImageCell(with: tableView, indexPath: indexPath)
        case MenuSection.category.rawValue:
            return menuCategoryCell(with: tableView, indexPath: indexPath)
        case MenuSection.account.rawValue:
            return menuAccountCell(with: tableView, indexPath: indexPath)
        default:
            return menuDefaultCell(with: tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == MenuSection.category.rawValue ? NSLocalizedString("Menu.Categories", comment: String()) : nil
    }
    
    private func menuCategoryCell(with tableView: UITableView, indexPath: IndexPath) -> MenuCategoryTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MenuCategoryTableViewCell.self), for: indexPath) as! MenuCategoryTableViewCell
        let category = delegate?.category(for: indexPath.row)
        cell.configure(with: category)
        
        return cell
    }
    
    private func menuDefaultCell(with tableView: UITableView, indexPath: IndexPath) -> MenuDefaultTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MenuDefaultTableViewCell.self), for: indexPath) as! MenuDefaultTableViewCell
        let title = delegate?.policyTitle(for: indexPath.row)
        cell.configure(with: title)
        
        return cell
    }
    
    private func menuImageCell(with tableView: UITableView, indexPath: IndexPath) -> MenuImageTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MenuImageTableViewCell.self), for: indexPath) as! MenuImageTableViewCell
        cell.configure(with: NSLocalizedString("Menu.Home", comment: String()), imageName: ImageName.home)
        
        return cell
    }
    
    private func menuAccountCell(with tableView: UITableView, indexPath: IndexPath) -> MenuAccountTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MenuAccountTableViewCell.self), for: indexPath) as! MenuAccountTableViewCell
        cell.configure()
        
        return cell
    }
}
