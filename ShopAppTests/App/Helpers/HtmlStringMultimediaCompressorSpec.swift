//
//  HtmlStringMultimediaCompressorSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class HtmlStringMultimediaCompressorSpec: QuickSpec {
    override func spec() {
        describe("when HtmlStringMultimediaCompressor used") {
            context("if html string hasn't images and iframes") {
                it("needs to return html string without changes") {
                    let htmlString = "<p>Some text.</p><p><span>Some text. Again.</span></p><p><span>Some text. One more time.</span></p><p><span>Some text. Last.</span></p><p><span>The end.</span></p>"
                    let compressedHtmlString = HtmlStringMultimediaCompressor.compress(htmlString, withMultimediaWidth: 320)
                    
                    expect(compressedHtmlString) == htmlString
                }
            }
            
            context("if html string has images") {
                it("needs to return compressed html string") {
                    let htmlString = "<p>Some text.</p><p><img src=\"//cdn.shopify.com/s/files/1/0011/5068/1149/files/placeholder_large.png?v=1521814984\" alt=\"\" /></p><p><span>Some text. Again.</span></p><p><img src=\"//cdn.shopify.com/s/files/1/0011/5068/1149/products/57455_profile_medium.jpg?v=1521534386\" alt=\"\" /></p><p><span>Some text. One more time.</span></p>"
                    let expectCompressedHtmlString = "<p>Some text.</p><p><img style='max-width:308' src=\"//cdn.shopify.com/s/files/1/0011/5068/1149/files/placeholder_large.png?v=1521814984\" alt=\"\" /></p><p><span>Some text. Again.</span></p><p><img style='max-width:308' src=\"//cdn.shopify.com/s/files/1/0011/5068/1149/products/57455_profile_medium.jpg?v=1521534386\" alt=\"\" /></p><p><span>Some text. One more time.</span></p>"
                    let compressedHtmlString = HtmlStringMultimediaCompressor.compress(htmlString, withMultimediaWidth: 320)
                    
                    expect(compressedHtmlString) == expectCompressedHtmlString
                }
            }
            
            context("if html string has iframes") {
                it("needs to return compressed html string") {
                    let htmlString = "<p><span>Some text. Last.</span></p><p><span><iframe width=\"420\" height=\"315\" src=\"https://www.youtube.com/embed/tgbNymZ7vqY\"></iframe></span></p><p><span>The end.</span></p><p><span>Some text. Last.</span></p><p><span><iframe width=\"420\" height=\"315\" src=\"https://www.youtube.com/embed/tgbNymZ7vqY\"></iframe></span></p><p><span>The end.</span></p>"
                    let expectCompressedHtmlString = "<p><span>Some text. Last.</span></p><p><span><iframe height='213' width='308' src=\"https://www.youtube.com/embed/tgbNymZ7vqY\"></iframe></span></p><p><span>The end.</span></p><p><span>Some text. Last.</span></p><p><span><iframe height='213' width='308' src=\"https://www.youtube.com/embed/tgbNymZ7vqY\"></iframe></span></p><p><span>The end.</span></p>"
                    let compressedHtmlString = HtmlStringMultimediaCompressor.compress(htmlString, withMultimediaWidth: 320)
                    
                    expect(compressedHtmlString) == expectCompressedHtmlString
                }
            }

            context("if html string has images and iframes") {
                it("needs to return compressed html string") {
                    let htmlString = "<p>Some text.</p><p><img src=\"//cdn.shopify.com/s/files/1/0011/5068/1149/files/placeholder_large.png?v=1521814984\" alt=\"\" /></p><p><span>Some text. Last.</span></p><p><span><iframe width=\"420\" height=\"315\" src=\"https://www.youtube.com/embed/tgbNymZ7vqY\"></iframe></span></p><p><span>The end.</span></p>"
                    let expectCompressedHtmlString = "<p>Some text.</p><p><img style='max-width:308' src=\"//cdn.shopify.com/s/files/1/0011/5068/1149/files/placeholder_large.png?v=1521814984\" alt=\"\" /></p><p><span>Some text. Last.</span></p><p><span><iframe height='213' width='308' src=\"https://www.youtube.com/embed/tgbNymZ7vqY\"></iframe></span></p><p><span>The end.</span></p>"
                    let compressedHtmlString = HtmlStringMultimediaCompressor.compress(htmlString, withMultimediaWidth: 320)
                    
                    expect(compressedHtmlString) == expectCompressedHtmlString
                }
            }
        }
    }
}
