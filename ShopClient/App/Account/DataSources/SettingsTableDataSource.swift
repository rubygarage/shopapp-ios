//
//  SettingsTableDataSource.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

enum SettingsSection: Int {
    case promo
    
    static let allValues = [promo]
}

protocol SettingsTableDataSourceProtocol: class {
    func promo() -> (description: String, state: Bool)?
}

class SettingsTableDataSource: NSObject {
    weak var delegate: (SettingsTableDataSourceProtocol & SwitchTableViewCellProtocol)?
}

// MARK: - UITableViewDataSource

extension SettingsTableDataSource: UITableViewDataSource {
    
    // MARK: - Private
    
    private func switchCell(with tableView: UITableView, indexPath: IndexPath) -> SwitchTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SwitchTableViewCell.self), for: indexPath) as! SwitchTableViewCell
        cell.delegate = delegate
        if let promo = delegate?.promo() {
            cell.configure(with: indexPath, description: promo.description, state: promo.state)
        }
        return cell
    }
    
    // MARK: - Internal
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let delegate = delegate else { return 0 }
        let promoSectionCount = delegate.promo() == nil ? 0 : 1
        return promoSectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SettingsSection.promo.rawValue:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SettingsSection.promo.rawValue:
            return switchCell(with: tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
}
