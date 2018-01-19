//
//  HomeTableHeaderView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol SeeAllHeaderViewProtocol: class {
    func didTapSeeAll(type: SeeAllViewType)
}

enum SeeAllViewType {
    case latestArrivals
    case popular
    case blogPosts
    case myCart
    case relatedItems
}

class SeeAllTableHeaderView: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var sectionTitleLabel: UILabel!
    @IBOutlet private weak var separatprHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var seeAllButton: UIButton!
    
    private var headerViewType = SeeAllViewType.relatedItems
    
    weak var delegate: SeeAllHeaderViewProtocol?
    
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
        Bundle.main.loadNibNamed(String(describing: SeeAllTableHeaderView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        populateViews()
    }
    
    private func setupConstraints(separatorVisible: Bool) {
        separatprHeightConstraint.constant = separatorVisible ? 1 : 0
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
    
    @IBAction func seeAllTapped(_ sender: UIButton) {
        delegate?.didTapSeeAll(type: headerViewType)
    }
}
