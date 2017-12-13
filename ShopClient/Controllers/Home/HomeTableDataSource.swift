//
//  HomeTableDataSource.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

enum HomeSection: Int {
    case lastArrivals
    case popular
    case newInBlog
}

protocol HomeTableDataSourceProtocol {
    func lastArrivalsObjects() -> [Product]
    func popularObjects() -> [Product]
    func articlesCount() -> Int
    func article(at index: Int) -> Article?
}

class HomeTableDataSource: NSObject, UITableViewDataSource {
    var delegate: (HomeTableDataSourceProtocol & LastArrivalsCellDelegate)?
    
    init(delegate: (HomeTableDataSourceProtocol & LastArrivalsCellDelegate)?) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        let lastArrivalsSectionCount = delegate?.lastArrivalsObjects().count ?? 0 > 0 ? 1 : 0
        let popularSectionCount = delegate?.popularObjects().count ?? 0 > 0 ? 1 : 0
        let articlesSectionCount = delegate?.articlesCount() ?? 0 > 0 ? 1 : 0
        return lastArrivalsSectionCount + popularSectionCount + articlesSectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case HomeSection.lastArrivals.rawValue:
            return 1
        case HomeSection.popular.rawValue:
            return 1
        case HomeSection.newInBlog.rawValue:
            return delegate?.articlesCount() ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case HomeSection.newInBlog.rawValue:
            return newInBlogCell(with: tableView, indexPath: indexPath)
        case HomeSection.popular.rawValue:
            return popularCell(with: tableView, indexPath: indexPath)
        default:
            return lastArrivalsCell(with: tableView, indexPath: indexPath)
        }
    }
    
    // MARK: - private
    private func lastArrivalsCell(with tableView: UITableView, indexPath: IndexPath) -> LastArrivalsTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LastArrivalsTableViewCell.self), for: indexPath) as! LastArrivalsTableViewCell
        cell.configure(with: delegate?.lastArrivalsObjects(), cellDelegate: self.delegate)
        
        return cell
    }
    
    private func popularCell(with tableView: UITableView, indexPath: IndexPath) -> PopularTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PopularTableViewCell.self), for: indexPath) as! PopularTableViewCell
        
        return cell
    }
    
    private func newInBlogCell(with tableView: UITableView, indexPath: IndexPath) -> ArticleTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleTableViewCell.self), for: indexPath) as! ArticleTableViewCell
        let article = delegate?.article(at: indexPath.row)
        let separatorHidden = indexPath.row == ((delegate?.articlesCount() ?? 0) - 1)
        cell.configure(with: article, separatorHidden: separatorHidden)
        
        return cell
    }
}
