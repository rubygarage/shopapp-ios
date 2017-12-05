//
//  HomeTableDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol HomeTableDelegateProtocol {
    func didSelectArticle(at index: Int)
}

private let kHeaderHeightDefault: CGFloat = 75
private let kHeaderHeightFirstSection: CGFloat = 80

class HomeTableDelegate: NSObject, UITableViewDelegate {
    var delegate: (HomeTableDelegateProtocol & HomeHeaderViewProtocol)?
    
    init(delegate: (HomeTableDelegateProtocol & HomeHeaderViewProtocol)?) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == HomeSection.newInBlog.rawValue {
            delegate?.didSelectArticle(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == HomeSection.lastArrivals.rawValue ? kHeaderHeightFirstSection : kHeaderHeightDefault
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return TableView.headerFooterMinHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case HomeSection.lastArrivals.rawValue:
            return HomeTableHeaderView(delegate: delegate, type: .latestArrivals)
        default:
            return HomeTableHeaderView(delegate: delegate, type: .blogPosts)
        }
    }
}
