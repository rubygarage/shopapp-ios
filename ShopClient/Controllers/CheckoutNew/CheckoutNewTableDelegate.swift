//
//  CheckoutNewTableDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class CheckoutNewTableDelegate: NSObject, UITableViewDelegate {
    var delegate: SeeAllHeaderViewProtocol!
    
    init(delegate: SeeAllHeaderViewProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return SeeAllTableHeaderView(delegate: delegate, type: .myCart, separatorVisible: true)
    }
}
