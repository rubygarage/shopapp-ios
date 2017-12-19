//
//  PolicyViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import WebKit

private let kTextViewContentInsets = UIEdgeInsetsMake(28, 16, 28, 16)

class PolicyViewController: UIViewController {
    @IBOutlet weak var policyTextView: UITextView!
    
    var policy: Policy?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        populateViews()
    }
    
    private func setupViews() {
        addBackButtonIfNeeded()
        policyTextView.contentInset = kTextViewContentInsets
    }
    
    private func populateViews() {
        title = policy?.title
        policyTextView.text = policy?.body
    }
}
