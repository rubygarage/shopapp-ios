//
//  ArticleListTableProviderSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ArticleListTableProviderSpec: QuickSpec {
    override func spec() {
        var tableProvider: ArticleListTableProvider!
        var tableView: UITableView!
        
        beforeEach {
            tableProvider = ArticleListTableProvider()
            tableView = UITableView()
            tableView.registerNibForCell(ArticleTableViewCell.self)
            tableView.dataSource = tableProvider
            tableView.delegate = tableProvider
        }
        
        describe("when provider created") {
            it("should return correct rows count") {
                let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                
                expect(rowsCount) == 0
            }
            
            it("should return correct header height") {
                let headerHeight = tableProvider.tableView(tableView, heightForHeaderInSection: 0)
                
                expect(headerHeight) == TableView.headerFooterDefaultHeight
            }
            
            it("should return correct footer height") {
                let footerHeight = tableProvider.tableView(tableView, heightForFooterInSection: 0)
                
                expect(footerHeight) == TableView.headerFooterDefaultHeight
            }
        }
        
        describe("when articles did set") {
            beforeEach {
                let article = Article()
                tableProvider.articles = [article]
            }
            
            it("should return correct rows count") {
                let rowsCount = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                
                expect(rowsCount) == tableProvider.articles.count
            }
            
            it("should return correct cell class") {
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = tableProvider.tableView(tableView, cellForRowAt: indexPath)
                
                expect(cell).to(beAnInstanceOf(ArticleTableViewCell.self))
            }
        }
        
        describe("when article selected") {
            var article: Article!
            
            beforeEach {
                article = Article()
                tableProvider.articles = [article]
            }
            
            it("should select order") {
                let providerDelegateMock = ArticleListTableProviderDelegateMock()
                tableProvider.delegate = providerDelegateMock
                
                let indexPath = IndexPath(row: 0, section: 0)
                tableProvider.tableView(tableView, didSelectRowAt: indexPath)
                
                expect(providerDelegateMock.provider) === tableProvider
                expect(providerDelegateMock.article) === article
            }
        }
    }
}
