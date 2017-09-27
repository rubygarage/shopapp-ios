//
//  SortModalDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol SortModalDataSourceProtocol {
    func itemsCount() -> Int
    func item(at index: Int) -> String?
    func selectedItem() -> String?
}

class SortModalDataSource: NSObject, UITableViewDataSource {
    var delegate: SortModalDataSourceProtocol?
    
    init(delegate: SortModalDataSourceProtocol?) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.itemsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SortModalTableViewCell.self), for: indexPath) as! SortModalTableViewCell
        let item = delegate?.item(at: indexPath.row)
        let selected = item == delegate?.selectedItem()
        cell.configure(with: item, selected: selected)
        
        return cell
    }
}
