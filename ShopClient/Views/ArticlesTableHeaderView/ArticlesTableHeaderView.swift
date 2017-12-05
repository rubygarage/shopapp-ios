//
//  ArticlesTableHeaderView.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol ArticlesHeaderViewProtocol {
    func didTapSeeAllblogPosts()
}

class ArticlesTableHeaderView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var blogPostsLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    
    var delegate: ArticlesHeaderViewProtocol?
    
    init(delegate: ArticlesHeaderViewProtocol?) {
        super.init(frame: CGRect.zero)
        
        commonInit()
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: ArticlesTableHeaderView.self), owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        populateViews()
    }
    
    private func populateViews() {
        blogPostsLabel.text = NSLocalizedString("Label.BlogPosts", comment: String())
        seeAllButton.setTitle(NSLocalizedString("Button.SeeAll", comment: String()), for: .normal)
    }
    
    // MARK: - actions
    @IBAction func seeAllTapped(_ sender: UIButton) {
        delegate?.didTapSeeAllblogPosts()
    }
}
