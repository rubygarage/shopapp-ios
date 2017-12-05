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

let kRowHeightHomeSectionLastArrivals: CGFloat = 200
let kRowHeightHomeSectionNewInBlog: CGFloat = 150
let kHeaderHeightHome: CGFloat = 75

class HomeTableDelegate: NSObject, UITableViewDelegate {
    var delegate: (HomeTableDelegateProtocol & LastArrivalsHeaderViewProtocol & ArticlesHeaderViewProtocol)?
    
    init(delegate: (HomeTableDelegateProtocol & LastArrivalsHeaderViewProtocol & ArticlesHeaderViewProtocol)?) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == HomeSection.newInBlog.rawValue {
            delegate?.didSelectArticle(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case HomeSection.lastArrivals.rawValue:
            return kRowHeightHomeSectionLastArrivals
        case HomeSection.newInBlog.rawValue:
            return kRowHeightHomeSectionNewInBlog
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeaderHeightHome
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return TableView.headerFooterMinHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case HomeSection.lastArrivals.rawValue:
            return LastArrivalsTableHeaderView(delegate: delegate)
        default:
            return ArticlesTableHeaderView(delegate: delegate)
        }
    }
}
