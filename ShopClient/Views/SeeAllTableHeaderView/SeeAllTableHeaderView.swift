//
//  HomeTableHeaderView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol SeeAllHeaderViewProtocol {
    func didTapSeeAll(type: SeeAllViewType)
}

enum SeeAllViewType {
    case latestArrivals
    case popular
    case blogPosts
    case myCart
}

class SeeAllTableHeaderView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var separatprHeightConstraint: NSLayoutConstraint!
    
    private var delegate: SeeAllHeaderViewProtocol?
    private var headerViewType = SeeAllViewType.latestArrivals
    
    init(delegate: SeeAllHeaderViewProtocol?, type: SeeAllViewType, separatorVisible: Bool = false) {
        super.init(frame: CGRect.zero)
        
        self.delegate = delegate
        headerViewType = type
        commonInit()
        setupConstraints(separatorVisible: separatorVisible)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
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
            sectionTitleLabel.text = NSLocalizedString("Label.LatestArrivals", comment: String())
        case .popular:
            sectionTitleLabel.text = NSLocalizedString("Label.Popular", comment: String())
        case .blogPosts:
            sectionTitleLabel.text = NSLocalizedString("Label.BlogPosts", comment: String())
        case .myCart:
            sectionTitleLabel.text = NSLocalizedString("Label.MyCart", comment: String())
        }
        seeAllButton.setTitle(NSLocalizedString("Button.SeeAll", comment: String()), for: .normal)
    }
    
    // MARK: - actions
    @IBAction func seeAllTapped(_ sender: UIButton) {
        delegate?.didTapSeeAll(type: headerViewType)
    }
}
