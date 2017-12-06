//
//  HomeTableHeaderView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol HomeHeaderViewProtocol {
    func didTapSeeAll(type: HomeTableViewType)
}

enum HomeTableViewType {
    case latestArrivals
    case blogPosts
}

class HomeTableHeaderView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    
    private var delegate: HomeHeaderViewProtocol?
    private var headerViewType = HomeTableViewType.latestArrivals
    
    init(delegate: HomeHeaderViewProtocol?, type: HomeTableViewType) {
        super.init(frame: CGRect.zero)
        
        self.delegate = delegate
        headerViewType = type
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: HomeTableHeaderView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        populateViews()
    }
    
    private func populateViews() {
        switch headerViewType {
        case .latestArrivals:
            sectionTitleLabel.text = NSLocalizedString("Label.LatestArrivals", comment: String())
        case .blogPosts:
            sectionTitleLabel.text = NSLocalizedString("Label.BlogPosts", comment: String())
        }
        seeAllButton.setTitle(NSLocalizedString("Button.SeeAll", comment: String()), for: .normal)
    }
    
    // MARK: - actions
    @IBAction func seeAllTapped(_ sender: UIButton) {
        delegate?.didTapSeeAll(type: headerViewType)
    }
}
