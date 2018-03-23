//
//  TTTAttributedLabel+LinksSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/22/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import Nimble
import Quick
import TTTAttributedLabel

@testable import ShopApp

class TTTAttributedLabel_LinksSpec: QuickSpec {
    override func spec() {
        describe("when label did set up") {
            let text = "Text with link"
            let link = "link"
            var label: TTTAttributedLabel!
            let delegate = TTTAttributedLabelDelegateMock()
            
            beforeEach {
                label = TTTAttributedLabel(frame: CGRect.zero)
                label.setup(with: text, links: [link], delegate: delegate)
            }
            
            it("should have delegate") {
                expect(label.delegate) === delegate
            }
            
            it("should have same link and active link attributes") {
                expect(NSDictionary(dictionary: label!.linkAttributes).isEqual(label!.activeLinkAttributes)) == true
            }
            
            describe("when text attributes did set") {
                var attributedString: NSAttributedString!
                var attributes: [String: Any]!
                
                beforeEach {
                    attributedString = label.attributedText
                    attributes = attributedString?.attributes(at: 0, effectiveRange: nil)
                }
                
                it("should set text to label") {
                    expect(attributedString.string) == text
                }
                
                it("should have correct text color") {
                    let colorAttribute = attributes?.filter({ $0.key == "NSColor" }).first
                    
                    expect(colorAttribute?.value) === label.textColor.cgColor
                }
                
                it("should have correct paragraph attribute class type") {
                    let paragraphAttribute = attributes?.filter({ $0.key == "NSParagraphStyle" }).first
                    
                    expect(paragraphAttribute?.value).to(beAnInstanceOf(NSMutableParagraphStyle.self))
                }
                
                it("should have correct font") {
                    let fontAttribute = attributes?.filter({ $0.key == "NSFont" }).first
                    
                    expect(fontAttribute?.value) === UIFont.systemFont(ofSize: 11)
                }
            }
            
            describe("when link attributes did set") {
                it("should have correct color attribute") {
                    let colorAttribute = label.linkAttributes.filter({ $0.key == AnyHashable("CTForegroundColor") }).first
                    
                    expect(colorAttribute?.value) === UIColor.black
                }
                
                it("should have correct underline style attribute") {
                    let underlineAttribute = label.linkAttributes.filter({ $0.key == AnyHashable("NSUnderline") }).first
                    
                    expect(underlineAttribute?.value) === NSUnderlineStyle.styleSingle.rawValue
                }
            }
            
            describe("when links added") {
                var textResult: NSTextCheckingResult!
                var urlString: String!
                
                beforeEach {
                    textResult = label.links.first as! NSTextCheckingResult
                    urlString = textResult.url!.absoluteString
                }
                
                it("should have correct link url text") {
                    expect(urlString) == link
                }
                
                it("should have correct link range") {
                    let expectedRange = (text as NSString).range(of: urlString)
                    
                    expect(textResult.range) == expectedRange
                }
            }
        }
    }
}
