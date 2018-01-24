//
//  HomeTableDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol HomeTableDelegateProtocol: class {
    func lastArrivalsObjectsCount() -> Int
    func articlesCount() -> Int
    func didSelectArticle(at index: Int)
}

class HomeTableDelegate: NSObject, UITableViewDelegate {
    weak var delegate: (HomeTableDelegateProtocol & SeeAllHeaderViewProtocol)?
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == HomeSection.newInBlog.rawValue {
            delegate?.didSelectArticle(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var type: SeeAllViewType
        var isNeedToHideSeeAllButton = false
        
        switch section {
        case HomeSection.lastArrivals.rawValue:
            type = .latestArrivals
            isNeedToHideSeeAllButton = delegate?.lastArrivalsObjectsCount() ?? 0 < kItemsPerPage ? true : false
        case HomeSection.popular.rawValue:
            type = .popular
            isNeedToHideSeeAllButton = true
        default:
            type = .blogPosts
            isNeedToHideSeeAllButton = delegate?.articlesCount() ?? 0 < kItemsPerPage ? true : false
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
