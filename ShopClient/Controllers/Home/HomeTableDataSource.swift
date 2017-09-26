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
    case newInBlog
    case loadMore
}

protocol HomeTableDataSourceProtocol {
    func lastArrivalsObjects() -> [Product]
    func didSelectProduct(at index: Int)
    func articlesCount() -> Int
    func article(at index: Int) -> Article?
}

let kNumberOfSectionsDefault = 2
let kNumberOfSectionsWithLoadMoreSection = 3

class HomeTableDataSource: NSObject, UITableViewDataSource {
    var delegate: (HomeTableDataSourceProtocol & LastArrivalsCellDelegate)?
    
    init(delegate: (HomeTableDataSourceProtocol & LastArrivalsCellDelegate)?) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return delegate?.articlesCount() ?? 0 == kItemsPerPage ? kNumberOfSectionsWithLoadMoreSection : kNumberOfSectionsDefault
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case HomeSection.lastArrivals.rawValue:
            return 1
        case HomeSection.newInBlog.rawValue:
            return delegate?.articlesCount() ?? 0
        case HomeSection.loadMore.rawValue:
            return delegate?.articlesCount() ?? 0 == kItemsPerPage ? 1 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case HomeSection.newInBlog.rawValue:
            return newInBlogCell(with: tableView, indexPath: indexPath)
        case HomeSection.loadMore.rawValue:
            return loadMoreCell(with: tableView, indexPath: indexPath)
        default:
            return lastArrivalsCell(with: tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case HomeSection.lastArrivals.rawValue:
            return NSLocalizedString("ControllerTitle.LastArrivals", comment: String())
        case HomeSection.newInBlog.rawValue:
            return delegate?.articlesCount() ?? 0 > 0 ? NSLocalizedString("ControllerTitle.NewInBlog", comment: String()) : nil
        default:
            return nil
        }
    }
    
    // MARK: - private
    private func lastArrivalsCell(with tableView: UITableView, indexPath: IndexPath) -> LastArrivalsTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LastArrivalsTableViewCell.self), for: indexPath) as! LastArrivalsTableViewCell
        cell.configure(with: delegate?.lastArrivalsObjects(), cellDelegate: self.delegate)
        
        return cell
    }
    
    private func newInBlogCell(with tableView: UITableView, indexPath: IndexPath) -> ArticleTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleTableViewCell.self), for: indexPath) as! ArticleTableViewCell
        cell.configure(with: delegate?.article(at: indexPath.row))
        
        return cell
    }
    
    private func loadMoreCell(with tableView: UITableView, indexPath: IndexPath) -> ArticleLoadMoreCell {
        return tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleLoadMoreCell.self), for: indexPath) as! ArticleLoadMoreCell
    }
}
