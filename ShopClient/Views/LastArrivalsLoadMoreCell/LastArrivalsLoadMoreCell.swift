//
//  LastArrivalsLoadMoreCell.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/21/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

class LastArrivalsLoadMoreCell: UICollectionViewCell {
    @IBOutlet weak var loadMoreTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadMoreTitle.text = NSLocalizedString("Cell.LoadMore", comment: String())
    }
}
