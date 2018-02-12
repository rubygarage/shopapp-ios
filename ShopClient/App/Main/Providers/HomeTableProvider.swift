//
//  HomeTableProvider.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/31/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

private enum HomeSection: Int {
    case lastArrivals
    case popular
    case newInBlog
}

protocol HomeTableProviderDelegate: class {
    func provider(_ provider: HomeTableProvider, didSelect article: Article)
}

class HomeTableProvider: NSObject {
    var lastArrivalsProducts: [Product] = []
    var popularProducts: [Product] = []
    var articles: [Article] = []
    
    weak var delegate: (HomeTableProviderDelegate & LastArrivalsTableCellDelegate & PopularTableCellDelegate & SeeAllHeaderViewProtocol)?
}

// MARK: - UITableViewDataSource

extension HomeTableProvider: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let lastArrivalsSectionCount = lastArrivalsProducts.isEmpty ? 0 : 1
        let popularSectionCount = popularProducts.isEmpty ? 0 : 1
        let articlesSectionCount = articles.isEmpty ? 0 : 1
        return lastArrivalsSectionCount + popularSectionCount + articlesSectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case HomeSection.lastArrivals.rawValue, HomeSection.popular.rawValue:
            return 1
        case HomeSection.newInBlog.rawValue:
            return articles.count
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
    
    private func lastArrivalsCell(with tableView: UITableView, indexPath: IndexPath) -> LastArrivalsTableViewCell {
        let cell: LastArrivalsTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        cell.delegate = delegate
        cell.configure(with: lastArrivalsProducts)
        return cell
    }
    
    private func popularCell(with tableView: UITableView, indexPath: IndexPath) -> PopularTableViewCell {
        let cell: PopularTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        cell.delegate = delegate
        cell.configure(with: popularProducts)
        return cell
    }
    
    private func newInBlogCell(with tableView: UITableView, indexPath: IndexPath) -> ArticleTableViewCell {
        let cell: ArticleTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
        let article = articles[indexPath.row]
        let separatorHidden = indexPath.row == articles.count - 1
        cell.configure(with: article, separatorHidden: separatorHidden)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeTableProvider: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate, indexPath.section == HomeSection.newInBlog.rawValue else {
            return
        }
        let article = articles[indexPath.row]
        delegate.provider(self, didSelect: article)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kBoldTitleTableHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var type: SeeAllViewType
        var isNeedToHideSeeAllButton = false
        
        switch section {
        case HomeSection.lastArrivals.rawValue:
            type = .latestArrivals
            isNeedToHideSeeAllButton = lastArrivalsProducts.count < kItemsPerPage
        case HomeSection.popular.rawValue:
            type = .popular
            isNeedToHideSeeAllButton = true
        default:
            type = .blogPosts
            isNeedToHideSeeAllButton = articles.count < kItemsPerPage
        }
        
        let view = SeeAllTableHeaderView(type: type)
        view.delegate = delegate
        
        if isNeedToHideSeeAllButton {
            view.hideSeeAllButton()
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
