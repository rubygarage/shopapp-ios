//
//  ArticlesListTableDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol ArticlesListTableDelegateProtocol {
    func didSelectItem(at index: Int)
}

class ArticlesListTableDelegate: NSObject, UITableViewDelegate {
    var delegate: ArticlesListTableDelegateProtocol?
    
    init(delegate: ArticlesListTableDelegateProtocol?) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDelegate    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TableView.headerFooterDefaultHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return TableView.headerFooterDefaultHeight
    }
}
