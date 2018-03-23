//
//  ArticleDetailsViewControllerSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class ArticleDetailsViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: ArticleDetailsViewController!
        var viewModelMock: ArticleDetailsViewModelMock!
        var articleImageView: UIImageView!
        var articleTitleLabel: UILabel!
        var authorNameLabel: UILabel!
        var articleContentWebView: UIWebView!
        
        beforeEach {
            viewController = UIStoryboard(name: StoryboardNames.main, bundle: nil).instantiateViewController(withIdentifier: ControllerIdentifiers.articleDetails) as! ArticleDetailsViewController
            viewController.articleId = "id"
            
            let repository = ArticleRepositoryMock()
            let articleUseCaseMock = ArticleUseCaseMock(repository: repository)
            
            viewModelMock = ArticleDetailsViewModelMock(articleUseCase: articleUseCaseMock)
            viewController.viewModel = viewModelMock
            
            articleImageView = self.findView(withAccessibilityLabel: "image", in: viewController.view) as! UIImageView
            articleTitleLabel = self.findView(withAccessibilityLabel: "title", in: viewController.view) as! UILabel
            authorNameLabel = self.findView(withAccessibilityLabel: "author", in: viewController.view) as! UILabel
            articleContentWebView = self.findView(withAccessibilityLabel: "webView", in: viewController.view) as! UIWebView
        }
        
        describe("when view loaded") {
            it("should have a correct superclass") {
                expect(viewController.isKind(of: BaseViewController<ArticleDetailsViewModel>.self)) == true
            }
            
            it("should have a correct view model type") {
                expect(viewController.viewModel).to(beAKindOf(ArticleDetailsViewModel.self))
            }

            it("should have correct delegate of web view") {
                expect(articleContentWebView.delegate) === viewController
            }
            
            it("should have correct delegate of error view") {
                expect(viewController.errorView.delegate) === viewController
            }
            
            it("should have unscrollable web view") {
                expect(articleContentWebView.scrollView.isScrollEnabled) == false
            }
            
            it("should have correct article id of view model") {
                expect(viewModelMock.articleId) == viewController.articleId
            }
            
            it("should start reload data") {
                expect(viewModelMock.isLoadDataStarted) == true
            }
        }
        
        describe("when data loaded") {
            it("needs to setup text of labels") {
                viewModelMock.loadData()
                
                expect(articleTitleLabel.text) == "Title"
                expect(authorNameLabel.text) == "First Last"
            }
            
            it("needs to setup web view size after content loading") {
                expect(articleContentWebView.bounds.size.height) == articleContentWebView.scrollView.contentSize.height
                expect(articleContentWebView.bounds.size.width) == articleContentWebView.scrollView.contentSize.width
            }
            
            context("if article hasn't image") {
                it("needs to hide image view") {
                    viewModelMock.isNeedToReturnImageOfArticle = false
                    viewModelMock.loadData()
                    
                    expect(articleImageView.image).to(beNil())
                    expect(articleImageView.isHidden) == true
                }
            }
            
            context("if article has image") {
                it("needs to show image view") {
                    viewModelMock.isNeedToReturnImageOfArticle = true
                    viewModelMock.loadData()
                    
                    expect(articleImageView.image).toNot(beNil())
                    expect(articleImageView.isHidden) == false
                }
            }
        }
    }
}
