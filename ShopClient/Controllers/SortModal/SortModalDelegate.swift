//
//  SortModalDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol SortModalDelegateProtocol: class {
    func heightForRow() -> CGFloat
    func didSelectItem(at index: Int)
}

class SortModalDelegate: NSObject, UITableViewDelegate {
    
    weak var delegate: SortModalDelegateProtocol?
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return delegate?.heightForRow() ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath.row)
    }
}
