//
//  LastArrivalsTableHeaderView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/4/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol LastArrivalsSeeAllProtocol {
    func didTapSeeAllLastArrivals()
}

class LastArrivalsTableHeaderView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var seeAllLabel: UILabel!
    
    var delegate: LastArrivalsSeeAllProtocol?
    
    init(delegate: LastArrivalsSeeAllProtocol?) {
        super.init(frame: CGRect.zero)
        
        commonInit()
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: LastArrivalsTableHeaderView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        populateViews()
    }
    
    private func populateViews() {
//        seeAllLabel.text = N
    }
}
