//
//  PolicyViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import WebKit

class PolicyViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    var policy: PolicyEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        populateViews()
    }
    
    private func populateViews() {
        title = policy?.title
        if let url = policy?.url {
            populateWebView(urlString: url)
        }
    }
    
    private func populateWebView(urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }
}
