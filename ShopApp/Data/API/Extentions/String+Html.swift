//
//  String+Html.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 5/10/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

extension String {
    var htmlToAttributedString: NSAttributedString? {
        return try? NSAttributedString(data: Data(utf8), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
