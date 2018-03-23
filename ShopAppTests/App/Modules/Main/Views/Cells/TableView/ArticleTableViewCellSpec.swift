//
//  ArticleTableViewCellSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/12/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class ArticleTableViewCellSpec: QuickSpec {
    override func spec() {
        var cell: ArticleTableViewCell!
        var articleImageView: UIImageView!
        var titleLabel: UILabel!
        var descriptionLabel: UILabel!
        var authorLabel: UILabel!
        var separatorView: UIView!
        
        beforeEach {
            let provider = ArticleListTableProvider()
            let tableView = UITableView()
            tableView.dataSource = provider
            tableView.delegate = provider
            tableView.registerNibForCell(ArticleTableViewCell.self)
            
            let indexPath = IndexPath(row: 0, section: 0)
            let dequeuedCell: ArticleTableViewCell = tableView.dequeueReusableCellForIndexPath(indexPath)
            cell = dequeuedCell
            
            articleImageView = self.findView(withAccessibilityLabel: "image", in: cell) as! UIImageView
            titleLabel = self.findView(withAccessibilityLabel: "title", in: cell) as! UILabel
            descriptionLabel = self.findView(withAccessibilityLabel: "description", in: cell) as! UILabel
            authorLabel = self.findView(withAccessibilityLabel: "author", in: cell) as! UILabel
            separatorView = self.findView(withAccessibilityLabel: "separator", in: cell)
        }
        
        describe("when cell initialized") {
            it("should have correct selection style") {
                expect(cell.selectionStyle.rawValue) == UITableViewCellSelectionStyle.none.rawValue
            }
        }
        
        describe("when cell configured") {
            var article: Article!
            
            beforeEach {
                let author = Author()
                author.fullName = "First Last"
                
                article = Article()
                article.title = "Title"
                article.content = "Description"
                article.author = author
            }
            
            it("needs to setup labels with article") {
                cell.configure(with: article, separatorHidden: false)
                
                expect(titleLabel.text) == article.title
                expect(descriptionLabel.text) == article.content
                expect(authorLabel.text) == article.author!.fullName
            }
            
            context("when article has image") {
                it("needs to show image view") {
                    article.image = Image()
                    cell.configure(with: article, separatorHidden: false)
                        
                    expect(articleImageView.isHidden) == false
                }
            }
                
            context("when article hasn't image") {
                it("needs to hide image view") {
                    article.image = nil
                    cell.configure(with: article, separatorHidden: false)
                        
                    expect(articleImageView.isHidden) == true
                }
            }

            context("when separator should be unhidden") {
                it("needs to show separator") {
                    cell.configure(with: article, separatorHidden: false)
                        
                    expect(separatorView.isHidden) == false
                }
            }
                
            context("when separator should be hidden") {
                it("needs to hide separator") {
                    cell.configure(with: article, separatorHidden: true)
                        
                    expect(separatorView.isHidden) == true
                }
            }
        }
    }
}
