//
//  ArticlesListTableDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol ArticlesListTableDataSourceProtocol: class {
    func articlesCount() -> Int
    func article(at index: Int) -> Article?
}

class ArticlesListTableDataSource: NSObject, UITableViewDataSource {
    weak var delegate: ArticlesListTableDataSourceProtocol?
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.articlesCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleTableViewCell.self), for: indexPath) as! ArticleTableViewCell
        let article = delegate?.article(at: indexPath.row)
        let separatorHidden = indexPath.row == ((delegate?.articlesCount() ?? 0) - 1)
        cell.configure(with: article, separatorHidden: separatorHidden)
        
        return cell
    }
}
