//
//  SortModalDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol SortModalDelegateProtocol {
    func heightForRow() -> CGFloat
    func didSelectItem(at index: Int)
}

class SortModalDelegate: NSObject, UITableViewDelegate {
    var delegate: SortModalDelegateProtocol?
    
    init(delegate: SortModalDelegateProtocol?) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return delegate?.heightForRow() ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath.row)
    }
}
