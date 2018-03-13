//
//  ArticleListTableProvider.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/31/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

protocol ArticleListTableProviderDelegate: class {
    func provider(_ provider: ArticleListTableProvider, didSelect article: Article)
}

class ArticleListTableProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    var articles: [Article] = []
    
    weak var delegate: ArticleListTableProviderDelegate?

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArticleTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        let article = articles[indexPath.row]
        let separatorHidden = indexPath.row == articles.count - 1
        cell.configure(with: article, separatorHidden: separatorHidden)
        return cell
    }

    // MARK: - UITableViewDelegate

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
