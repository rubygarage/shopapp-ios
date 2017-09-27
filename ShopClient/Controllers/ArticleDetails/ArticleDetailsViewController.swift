//
//  ArticleDetailsViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/26/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleDetailsViewController: UIViewController {
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var articleContentLabel: UILabel!
    
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        populateViews()
    }
    
    func populateViews() {
        let imageUrl = URL(string: article?.image?.src ?? String())
        articleImageView.sd_setImage(with: imageUrl)
        articleTitleLabel.text = article?.title
        authorNameLabel.text = article?.author?.fullName
        articleContentLabel.text = article?.content
    }
}
