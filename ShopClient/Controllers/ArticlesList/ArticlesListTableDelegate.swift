//
//  ArticlesListTableDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol ArticlesListTableDelegateProtocol {
    // TODO:
}

class ArticlesListTableDelegate: NSObject, UITableViewDelegate {
    var delegate: ArticlesListTableDelegateProtocol?
    
    init(delegate: ArticlesListTableDelegateProtocol?) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kRowHeightHomeSectionNewInBlog
    }
}
