//
//  TTTAttributedLabelLinks.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 12/26/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import TTTAttributedLabel

private let kFontDefault = UIFont.systemFont(ofSize: 11)

extension TTTAttributedLabel {
    func setup(with text: String, links: [String], delegate: TTTAttributedLabelDelegate) {
        setupDefaultAttributes(with: text)
        setupLinkAttributes(with: links)
        self.delegate = delegate
    }
    
    private func setupDefaultAttributes(with text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: kFontDefault,
                                                                             NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                                                             NSAttributedString.Key.foregroundColor: textColor.cgColor])
        attributedText = attributedString
    }
    
    private func setupLinkAttributes(with links: [String]) {
        let linkAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                             NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
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
