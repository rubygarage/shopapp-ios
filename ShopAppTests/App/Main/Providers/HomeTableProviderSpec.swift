//
//  HomeTableProviderSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/13/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import ShopApp_Gateway

@testable import ShopApp

class HomeTableProviderSpec: QuickSpec {
    override func spec() {
        var tableProvider: HomeTableProvider!
        var tableView: UITableView!
        
        beforeEach {
            tableProvider = HomeTableProvider()
            tableView = UITableView()
            tableView.registerNibForCell(LastArrivalsTableViewCell.self)
            tableView.registerNibForCell(PopularTableViewCell.self)
            tableView.registerNibForCell(ArticleTableViewCell.self)
            tableView.dataSource = tableProvider
            tableView.delegate = tableProvider
        }
        
        describe("when provider initialized") {
            it("should have correct properties") {
                expect(tableProvider.lastArrivalsProducts.count) == 0
                expect(tableProvider.popularProducts.count) == 0
                expect(tableProvider.articles.count) == 0
            }
            
            it("should return correct sections count") {
                let sectionsCount = tableProvider.numberOfSections(in: tableView)
                
                expect(sectionsCount) == 0
            }
            
            it("should return correct rows count") {
                let rowsCountSectionZero = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                let rowsCountSectionOne = tableProvider.tableView(tableView, numberOfRowsInSection: 1)
                let rowsCountSectionTwo = tableProvider.tableView(tableView, numberOfRowsInSection: 2)
                let rowsCountSectionThree = tableProvider.tableView(tableView, numberOfRowsInSection: 4)
                
                expect(rowsCountSectionZero) == 1
                expect(rowsCountSectionOne) == 1
                expect(rowsCountSectionTwo) == 0
                expect(rowsCountSectionThree) == 0
            }
            
            it("should return correct header height") {
                let headerHeight = tableProvider.tableView(tableView, heightForHeaderInSection: 0)
                
                expect(headerHeight) == kBoldTitleTableHeaderViewHeight
            }
            
            it("should return correct header class type") {
                for index in 0...2 {
                    let headerView = tableProvider.tableView(tableView, viewForHeaderInSection: index)
                    expect(headerView).to(beAnInstanceOf(SeeAllTableHeaderView.self))
                }
            }
            
            it("shouldn't return footer view") {
                let footerView = tableProvider.tableView(tableView, viewForFooterInSection: 0)
                
                expect(footerView).to(beNil())
            }
        }
        
        describe("when data did set") {
            var lastArrivalsProducts: [Product]!
            var popularProducts: [Product]!
            var articles: [Article]!
            
            beforeEach {
                lastArrivalsProducts = [Product()]
                popularProducts = [Product()]
                articles = [Article()]
                
                tableProvider.lastArrivalsProducts = lastArrivalsProducts
                tableProvider.popularProducts = popularProducts
                tableProvider.articles = articles
                
                tableView.reloadData()
            }
            
            it("should have correct properties") {
                expect(tableProvider.lastArrivalsProducts.count) == 1
                expect(tableProvider.popularProducts.count) == 1
                expect(tableProvider.articles.count) == 1
            }
            
            it("should return correct sections count") {
                let sectionsCount = tableProvider.numberOfSections(in: tableView)
                
                expect(sectionsCount) == 3
            }
            
            it("should return correct rows count") {
                let rowsCountSectionFirst = tableProvider.tableView(tableView, numberOfRowsInSection: 0)
                let rowsCountSectionSecond = tableProvider.tableView(tableView, numberOfRowsInSection: 1)
                let rowsCountSectionThird = tableProvider.tableView(tableView, numberOfRowsInSection: 2)
                
                expect(rowsCountSectionFirst) == lastArrivalsProducts.count
                expect(rowsCountSectionSecond) == popularProducts.count
                expect(rowsCountSectionThird) == articles.count
            }
            
            it("should return correct cell class") {
                let indexPathSectionZero = IndexPath(row: 0, section: 0)
                let cellSectionZero = tableProvider.tableView(tableView, cellForRowAt: indexPathSectionZero)
                let indexPathSectionOne = IndexPath(row: 0, section: 1)
                let cellSectionOne = tableProvider.tableView(tableView, cellForRowAt: indexPathSectionOne)
                let indexPathSectionTwo = IndexPath(row: 0, section: 2)
                let cellSectionTwo = tableProvider.tableView(tableView, cellForRowAt: indexPathSectionTwo)
                
                expect(cellSectionZero).to(beAnInstanceOf(LastArrivalsTableViewCell.self))
                expect(cellSectionOne).to(beAnInstanceOf(PopularTableViewCell.self))
                expect(cellSectionTwo).to(beAnInstanceOf(ArticleTableViewCell.self))
            }
        }
        
        describe("if cell did select") {
            var article: Article!
            
            beforeEach {
                article = Article()
                tableProvider.articles = [article]
                tableView.reloadData()
            }
            
            it("should select article") {
                let delegateMock = HomeTableProviderDelegateMock()
                tableProvider.delegate = delegateMock
                let indexPath = IndexPath(row: 0, section: 2)
                tableProvider.tableView(tableView, didSelectRowAt: indexPath)
                
                expect(delegateMock.provider) === tableProvider
                expect(delegateMock.article) === article
            }
            
            it("shouldn't select article") {
                let delegateMock = HomeTableProviderDelegateMock()
                tableProvider.delegate = delegateMock
                let indexPath = IndexPath(row: 0, section: 0)
                tableProvider.tableView(tableView, didSelectRowAt: indexPath)
                
                expect(delegateMock.provider).to(beNil())
                expect(delegateMock.article).to(beNil())
            }
        }
    }
}
