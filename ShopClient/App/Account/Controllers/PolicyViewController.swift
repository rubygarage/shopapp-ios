//
//  PolicyViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import WebKit

private let kTextViewContentInsets = UIEdgeInsets(top: 28, left: 16, bottom: 28, right: 16)
private let kTextViewContentOffset = CGPoint(x: -16, y: -28)

class PolicyViewController: UIViewController {
    @IBOutlet private weak var policyTextView: UITextView!
    
    var policy: Policy?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        populateViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        policyTextView.contentOffset = kTextViewContentOffset
    }

    // MARK: - Setup
    
    private func setupViews() {
        addBackButtonIfNeeded()
        policyTextView.contentInset = kTextViewContentInsets
    }
    
    private func populateViews() {
        title = policy?.title
        policyTextView.text = policy?.body
    }
}
