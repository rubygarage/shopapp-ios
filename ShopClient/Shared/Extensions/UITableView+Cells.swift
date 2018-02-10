//
//  TableView+Dequeue.swift
//  ShopClient
//
//  Created by Mykola Voronin on 2/9/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

extension UITableView {
    func registerNibForCell<T: UITableViewCell>(_ cell: T.Type) {
        let cellNib = UINib(nibName: T.nameOfClass, bundle: nil)
        register(cellNib, forCellReuseIdentifier: T.nameOfClass)
    }

    func dequeueReusableCellForIndexPath<T: UITableViewCell>(_ indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.nameOfClass, for: indexPath) as! T
    }
}
