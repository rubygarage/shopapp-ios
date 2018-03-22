//
//  HomeTableHeaderView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol SeeAllHeaderViewDelegate: class {
    func headerView(_ headerView: SeeAllTableHeaderView, didTapSeeAll type: SeeAllViewType)
}

enum SeeAllViewType {
    case latestArrivals
    case popular
    case blogPosts
    case myCart
    case relatedItems
}

let kSeeAllTableHeaderViewHeight: CGFloat = 75

class SeeAllTableHeaderView: UIView {
    @IBOutlet private weak var sectionTitleLabel: UILabel!
    @IBOutlet private weak var separatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var seeAllButton: UIButton!
    
    private var headerViewType = SeeAllViewType.relatedItems
    
    weak var delegate: SeeAllHeaderViewDelegate?
    
    // MARK: - View lifecycle
    
    init(type: SeeAllViewType, separatorVisible: Bool = false) {
        super.init(frame: CGRect.zero)
        
        headerViewType = type
        commonInit()
        setupConstraints(separatorVisible: separatorVisible)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    // MARK: - Setup
    
    private func commonInit() {
        loadFromNib()
        populateViews()
    }
    
    private func setupConstraints(separatorVisible: Bool) {
        separatorHeightConstraint.constant = separatorVisible ? 1 : 0
    }
    
    private func populateViews() {
        switch headerViewType {
        case .latestArrivals:
            sectionTitleLabel.text = "Label.LatestArrivals".localizable
        case .popular:
            sectionTitleLabel.text = "Label.Popular".localizable
        case .blogPosts:
            sectionTitleLabel.text = "Label.BlogPosts".localizable
        case .myCart:
            sectionTitleLabel.text = "Label.MyCart".localizable
        case .relatedItems:
            sectionTitleLabel.text = "Label.RelatedItems".localizable
        }
        seeAllButton.setTitle("Button.SeeAll".localizable, for: .normal)
    }
    
    func hideSeeAllButton() {
        seeAllButton.isHidden = true
    }
    
    func hideSeparator() {
        setupConstraints(separatorVisible: false)
    }
    
    // MARK: - Actions
    
    @IBAction func seeAllButtonDidPress(_ sender: UIButton) {
        delegate?.headerView(self, didTapSeeAll: headerViewType)
    }
}
