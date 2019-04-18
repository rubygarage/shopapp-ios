//
//  ArticleDetailsViewController.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 9/26/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import SafariServices
import UIKit

import ShopApp_Gateway

class ArticleDetailsViewController: BaseViewController<ArticleDetailsViewModel>, UIWebViewDelegate {
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var articleTitleLabel: UILabel!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var articleContentHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var articleContentWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var articleTitleLabelTopLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var articleContentWebView: UIWebView! {
        didSet {
            articleContentWebView.scrollView.isScrollEnabled = false
        }
    }
    
    private let articleTitleLabelTopDefault: CGFloat = 20
    
    var articleId: String!
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupViewModel()
        loadData()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        articleContentWebView.delegate = self
        errorView.delegate = self
    }
    
    private func setupViewModel() {
        viewModel.articleId = articleId

        viewModel.data
            .subscribe(onNext: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.populateViews(with: result.article, baseUrl: result.baseUrl)
            })
            .disposed(by: disposeBag)
    }
    
    private func populateViews(with article: Article, baseUrl: URL) {
        articleTitleLabelTopLayoutConstraint.constant = articleTitleLabelTopDefault
        if let image = article.image {
            articleImageView.set(image: image)
            articleTitleLabelTopLayoutConstraint.constant += articleImageView.frame.size.height
        }
        articleImageView.isHidden = article.image == nil
        articleTitleLabel.text = article.title
        authorNameLabel.text = article.author?.fullName
        guard let htmlString = article.contentHtml else {
            return
        }
        let html = HtmlStringMultimediaCompressor.compress(htmlString, withMultimediaWidth: articleTitleLabel.frame.size.width)
        articleContentWebView.loadHTMLString(html, baseURL: baseUrl)
    }

    private func loadData() {
        viewModel.loadData()
    }
    
    // MARK: - UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        guard navigationType.rawValue == UIWebView.NavigationType.linkClicked.rawValue else {
            return true
        }
        if let url = request.url {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true)
        }
        return false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        articleContentHeightLayoutConstraint.constant = webView.scrollView.contentSize.height
        articleContentWidthLayoutConstraint.constant = webView.scrollView.contentSize.width
    }
}
