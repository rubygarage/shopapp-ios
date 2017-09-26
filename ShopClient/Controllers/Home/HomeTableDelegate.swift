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

let kRowHeightHomeSectionNewInBlog: CGFloat = 150
let kRowHeightHomeSectionLoadMore: CGFloat = 50
let kLastArrivalsNumberOfColumnPortrait: CGFloat = 2
let kLastArrivalsNumberOfColumnLandscape: CGFloat = 4

class HomeTableDelegate: NSObject, UITableViewDelegate {
    var delegate: HomeTableDelegateProtocol?
    
    init(delegate: HomeTableDelegateProtocol) {
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
            let screenWidth = UIScreen.main.bounds.size.width
            let numberOfColumn: CGFloat = UIDevice.current.orientation.isPortrait ? kLastArrivalsNumberOfColumnPortrait : kLastArrivalsNumberOfColumnLandscape
            return screenWidth / numberOfColumn
        case HomeSection.newInBlog.rawValue:
            return kRowHeightHomeSectionNewInBlog
        case HomeSection.loadMore.rawValue:
            return kRowHeightHomeSectionLoadMore
        default:
            return 0
        }
    }
}
