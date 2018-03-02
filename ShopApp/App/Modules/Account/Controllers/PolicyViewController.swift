//
//  PolicyViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/20/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit
import WebKit

import ShopApp_Gateway

class PolicyViewController: UIViewController {
    @IBOutlet private weak var policyTextView: UITextView!
    
    private let textViewContentInsets = UIEdgeInsets(top: 28, left: 16, bottom: 28, right: 16)
    private let textViewContentOffset = CGPoint(x: -16, y: -28)
    
    var policy: Policy?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        populateViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        policyTextView.contentOffset = textViewContentOffset
    }

    // MARK: - Setup
    
    private func setupViews() {
        addBackButtonIfNeeded()
        policyTextView.contentInset = textViewContentInsets
    }
    
    private func populateViews() {
        guard let policy = policy else {
            return
        }
        title = policy.title
        policyTextView.text = policy.body
    }
}
