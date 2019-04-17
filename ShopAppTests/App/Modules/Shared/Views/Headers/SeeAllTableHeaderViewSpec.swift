//
//  SeeAllTableHeaderViewSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class SeeAllTableHeaderViewSpec: QuickSpec {
    override func spec() {
        var view: SeeAllTableHeaderView!
        var sectionTitleLabel: UILabel!
        var seeAllButton: UIButton!
        var separatorView: UIView!
        var separatorHeightConstraint: NSLayoutConstraint!
        
        func setupViews() {
            sectionTitleLabel = self.findView(withAccessibilityLabel: "title", in: view) as? UILabel
            seeAllButton = self.findView(withAccessibilityLabel: "seeAllButton", in: view) as? UIButton
            separatorView = self.findView(withAccessibilityLabel: "separator", in: view)
            separatorHeightConstraint = separatorView.constraints.filter({ $0.accessibilityLabel == "separatorHeight" }).first
        }
        
        describe("when view initialized") {
            it("should have correct title of see all button") {
                view = SeeAllTableHeaderView(type: .latestArrivals)
                setupViews()
                
                expect(seeAllButton.title(for: .normal)) == "Button.SeeAll".localizable
            }
            
            context("if type is latest arrivals") {
                it("needs to setup title with correct text") {
                    view = SeeAllTableHeaderView(type: .latestArrivals)
                    setupViews()
                    
                    expect(sectionTitleLabel.text) == "Label.LatestArrivals".localizable
                }
            }
            
            context("if type is latest arrivals") {
                it("needs to setup title with correct text") {
                    view = SeeAllTableHeaderView(type: .popular)
                    setupViews()
                    
                    expect(sectionTitleLabel.text) == "Label.Popular".localizable
                }
            }
            
            context("if type is latest arrivals") {
                it("needs to setup title with correct text") {
                    view = SeeAllTableHeaderView(type: .blogPosts)
                    setupViews()
                    
                    expect(sectionTitleLabel.text) == "Label.BlogPosts".localizable
                }
            }
            
            context("if type is latest arrivals") {
                it("needs to setup title with correct text") {
                    view = SeeAllTableHeaderView(type: .myCart)
                    setupViews()
                    
                    expect(sectionTitleLabel.text) == "Label.MyCart".localizable
                }
            }
            
            context("if type is latest arrivals") {
                it("needs to setup title with correct text") {
                    view = SeeAllTableHeaderView(type: .relatedItems)
                    setupViews()
                    
                    expect(sectionTitleLabel.text) == "Label.RelatedItems".localizable
                }
            }
            
            context("if separator visibility is false") {
                it("needs to hide separator") {
                    view = SeeAllTableHeaderView(type: .latestArrivals)
                    setupViews()
                    
                    expect(separatorHeightConstraint.constant) == 0
                }
            }
            
            context("if separator visibility is true") {
                it("needs to show separator") {
                    view = SeeAllTableHeaderView(type: .latestArrivals, separatorVisible: true)
                    setupViews()
                    
                    expect(separatorHeightConstraint.constant) == 1
                }
            }
        }
        
        describe("when user needs to hide see all button") {
            it("needs to do it") {
                view = SeeAllTableHeaderView(type: .latestArrivals)
                setupViews()
                view.hideSeeAllButton()
                
                expect(seeAllButton.isHidden) == true
            }
        }
        
        describe("when user needs to hide separator") {
            it("needs to do it") {
                view = SeeAllTableHeaderView(type: .latestArrivals, separatorVisible: true)
                setupViews()
                view.hideSeparator()
                
                expect(separatorHeightConstraint.constant) == 0
            }
        }
        
        describe("when see all button pressed") {
            it("needs to notify delegate") {
                view = SeeAllTableHeaderView(type: .latestArrivals, separatorVisible: true)
                setupViews()
                
                let delegateMock = SeeAllHeaderViewDelegateMock()
                view.delegate = delegateMock
                
                seeAllButton.sendActions(for: .touchUpInside)
                
                expect(delegateMock.headerView) === view
                expect(delegateMock.type).toNot(beNil())
            }
        }
    }
}
