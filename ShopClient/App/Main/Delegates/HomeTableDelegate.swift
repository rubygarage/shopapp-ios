//
//  HomeTableDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol HomeTableDelegateProtocol: class {
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

        switch section {
        case HomeSection.lastArrivals.rawValue:
            type = .latestArrivals
        case HomeSection.popular.rawValue:
            type = .popular
        default:
            type = .blogPosts
        }
        
        let view = SeeAllTableHeaderView(type: type)
        view.delegate = delegate
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
