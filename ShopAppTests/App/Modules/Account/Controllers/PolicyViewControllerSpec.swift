//
//  PolicyViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/27/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class PolicyViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: PolicyViewController!
        var policyTextView: UITextView!
        
        beforeEach {
            let policy = Policy()
            policy.title = "Title"
            policy.body = "Body"
            
            viewController = UIStoryboard(name: StoryboardNames.account, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.policy) as! PolicyViewController
            viewController.policy = policy
            
            let navigationController = NavigationController(rootViewController: UIViewController())
            navigationController.pushViewController(viewController, animated: false)
            
            policyTextView = self.findView(withAccessibilityLabel: "policy", in: viewController.view) as! UITextView
        }
        
        describe("when view loaded") {
            it("should have correct back button image") {
                expect(viewController.navigationItem.leftBarButtonItem?.image) == #imageLiteral(resourceName: "arrow_left")
            }
            
            it("should have correct content inset of policy text view") {
                expect(policyTextView.contentInset) == UIEdgeInsets(top: 28, left: 16, bottom: 28, right: 16)
            }
            
            it("needs to set title and present body in text view") {
                expect(viewController.title) == "Title"
                expect(policyTextView.text) == "Body"
            }
        }
        
        describe("when view layouted subviews") {
            it("should have correct content offset of policy text view") {
                viewController.viewDidLayoutSubviews()
                
                expect(policyTextView.contentOffset) == CGPoint(x: -16, y: -28)
            }
        }
    }
}
