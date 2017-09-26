//
//  SearchViewControllerDelegate.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/25/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegateProtocol {
    func didTapSearch(with text: String)
}

class SearchViewControllerDelegate: NSObject, UISearchBarDelegate {
    var delegate: SearchViewControllerDelegateProtocol?
    
    init(delegate: SearchViewControllerDelegateProtocol) {
        super.init()
        
        self.delegate = delegate
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            delegate?.didTapSearch(with: searchText)
        }
    }
}
