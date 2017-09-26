//
//  ArticleLoadMoreCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/22/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class ArticleLoadMoreCell: UITableViewCell {
    @IBOutlet weak var loadMoreTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        loadMoreTitle.text = NSLocalizedString("Cell.LoadMore", comment: String())
    }
}
