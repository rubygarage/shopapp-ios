//
//  ArticleDetailsViewModelSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class ArticleDetailsViewModelSpec: QuickSpec {
    override func spec() {
        let repositoryMock = ArticleRepositoryMock()
        let articleUseCaseMock = ArticleUseCaseMock(repository: repositoryMock)
        
        var viewModel: ArticleDetailsViewModel!
        
        beforeEach {
            viewModel = ArticleDetailsViewModel(articleUseCase: articleUseCaseMock)
        }
        
        describe("when view model initialized") {
            it("should have a correct superclass") {
                expect(viewModel).to(beAKindOf(BaseViewModel.self))
            }
            
            it("should have correct initial values") {
                expect(viewModel.articleId).to(beNil())
            }
        }
        
        describe("when data loaded") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            var article: Article?
            
            beforeEach {
                disposeBag = DisposeBag()
                states = []
                article = nil
                viewModel.articleId = "id"
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
                
                viewModel.data
                    .subscribe(onNext: { data in
                        article = data.article
                    })
                    .disposed(by: disposeBag)
            }

            context("if data loaded") {
                it("should present data") {
                    articleUseCaseMock.isNeedToReturnError = false
                    viewModel.loadData()
                    
                    expect(article).toNot(beNil())
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.content
                }
            }
            
            context("if error did occured") {
                it("should not present data") {
                    articleUseCaseMock.isNeedToReturnError = true
                    viewModel.loadData()
                    
                    expect(article).to(beNil())
                    expect(states.count) == 2
                    expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                    expect(states.last) == ViewState.error(error: nil)
                }
            }
        }
        
        describe("when try again") {
            var disposeBag: DisposeBag!
            var states: [ViewState]!
            var article: Article?
            
            beforeEach {
                disposeBag = DisposeBag()
                states = []
                article = nil
                viewModel.articleId = "id"
                
                viewModel.state
                    .subscribe(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
                
                viewModel.data
                    .subscribe(onNext: { data in
                        article = data.article
                    })
                    .disposed(by: disposeBag)
            }
            
            it("should present data") {
                articleUseCaseMock.isNeedToReturnError = false
                viewModel.tryAgain()
                
                expect(article).toNot(beNil())
                expect(states.count) == 2
                expect(states.first) == ViewState.loading(showHud: true, isTranslucent: false)
                expect(states.last) == ViewState.content
            }
        }
    }
}
