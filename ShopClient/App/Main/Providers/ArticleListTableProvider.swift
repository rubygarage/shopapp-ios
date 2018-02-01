//
//  ArticleListTableProvider.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/31/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

protocol ArticlesListTableProviderDelegate: class {
    func provider(_ provider: ArticlesListTableProvider, didSelect article: Article)
}

class ArticlesListTableProvider: NSObject {
    var articles: [Article] = []
    
    weak var delegate: ArticlesListTableProviderDelegate?
}

// MARK: - UITableViewDataSource

extension ArticlesListTableProvider: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellName = String(describing: ArticleTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! ArticleTableViewCell
        let article = articles[indexPath.row]
        let separatorHidden = indexPath.row == articles.count - 1
        cell.configure(with: article, separatorHidden: separatorHidden)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ArticlesListTableProvider: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        let article = articles[indexPath.row]
        delegate.provider(self, didSelect: article)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TableView.headerFooterDefaultHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return TableView.headerFooterDefaultHeight
    }
}
