//
//  TTTAttributedLabelLinks.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/26/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import TTTAttributedLabel

private let kFontDefault = UIFont.systemFont(ofSize: 11)

extension TTTAttributedLabel {
    public func setup(with text: String, links: [String], delegate: TTTAttributedLabelDelegate) {
        setupDefaultAttributes(with: text)
        setupLinkAttributes(with: links)
        self.delegate = delegate
    }
    
    private func setupDefaultAttributes(with text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        let attributedString = NSAttributedString(string: text, attributes: [NSFontAttributeName: kFontDefault,
                                                                             NSParagraphStyleAttributeName: paragraphStyle,
                                                                             NSForegroundColorAttributeName: textColor.cgColor])
        attributedText = attributedString
    }
    
    private func setupLinkAttributes(with links: [String]) {
        let linkAttributes: [String: Any] = [NSForegroundColorAttributeName: UIColor.black,
                              NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        self.linkAttributes = linkAttributes
        self.activeLinkAttributes = linkAttributes
        
        for link in links {
            if let encodedString = link.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
                let range = (attributedText.string as NSString).range(of: link)
                let url = URL(string: encodedString)
                addLink(to: url, with: range)
            }
        }
    }
}
