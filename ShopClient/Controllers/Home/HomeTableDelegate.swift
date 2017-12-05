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
    func didTapLoadMore()
}

let kRowHeightHomeSectionLastArrivals: CGFloat = 200
let kRowHeightHomeSectionNewInBlog: CGFloat = 150
let kRowHeightHomeSectionLoadMore: CGFloat = 50
let kHeaderHeightHomeSectionLastArrivals: CGFloat = 80

class HomeTableDelegate: NSObject, UITableViewDelegate {
    var delegate: (HomeTableDelegateProtocol & LastArrivalsSeeAllProtocol)?
    
    init(delegate: (HomeTableDelegateProtocol & LastArrivalsSeeAllProtocol)?) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == HomeSection.newInBlog.rawValue {
            delegate?.didSelectArticle(at: indexPath.row)
        } else if indexPath.section == HomeSection.loadMore.rawValue {
            delegate?.didTapLoadMore()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case HomeSection.lastArrivals.rawValue:
            return kRowHeightHomeSectionLastArrivals
        case HomeSection.newInBlog.rawValue:
            return kRowHeightHomeSectionNewInBlog
        case HomeSection.loadMore.rawValue:
            return kRowHeightHomeSectionLoadMore
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case HomeSection.lastArrivals.rawValue:
            return kHeaderHeightHomeSectionLastArrivals
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case HomeSection.lastArrivals.rawValue:
            return LastArrivalsTableHeaderView(delegate: delegate)
        default:
            return nil
        }
    }
}
