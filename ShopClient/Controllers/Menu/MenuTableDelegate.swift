//
//  MenuTableDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol MenuTableDelegateProtocol {
    func didSelectMenuItem(at indexPath: IndexPath)
}

class MenuTableDelegate: NSObject, UITableViewDelegate {
    var delegate: MenuTableDelegateProtocol?
    
    init(delegate: MenuTableDelegateProtocol?) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectMenuItem(at: indexPath)
    }
}
