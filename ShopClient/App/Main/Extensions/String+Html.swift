//
//  String+Html.swift
//  ShopClient
//
//  Created by Radyslav Krechet on 1/30/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

private let kHtmlImageTag = "<img "
private let kHtmlStyleWithMaxWidthFormat = "style='max-width:%.0f' "
private let kHtmlIframeOpenTag = "<iframe "
private let kHtmlIframeCloseTag = "</iframe>"
private let kHtmlWidthPrefix = "width="
private let kHtmlHeightPrefix = "height="
private let kHtmlWidthFormat = "width='%.0f'"
private let kHtmlHeightFormat = "height='%.0f'"
private let kHtmlMarging = CGFloat(12)
private let kHtmlIframeAspectRation = CGFloat(1.5)

extension String {
    func adaptiveWithMultimediaWidth(_ width: CGFloat) -> String {
        guard self.range(of: kHtmlImageTag) != nil || self.range(of: kHtmlIframeOpenTag) != nil else {
            return self
        }
        return self.adaptiveWithImageWidth(width).adaptiveWithVideoWidth(width)
    }
    
    private func adaptiveWithImageWidth(_ width: CGFloat) -> String {
        guard self.range(of: kHtmlImageTag) != nil else {
            return self
        }
        var result = ""
        let style = String(format: kHtmlStyleWithMaxWidthFormat, width - kHtmlMarging)
        var temp = self
        while let range = temp.range(of: kHtmlImageTag) {
            if result.isEmpty {
                result = temp.substring(to: range.upperBound)
            }
            let tail = temp.substring(from: range.upperBound)
            if let subrange = tail.range(of: kHtmlImageTag) {
                result += style + tail.substring(to: subrange.upperBound)
                temp = tail.substring(from: subrange.lowerBound)
            } else {
                result += style + tail
                break
            }
        }
        return result.isEmpty ? self : result
    }
    
    private func adaptiveWithVideoWidth(_ width: CGFloat) -> String {
        guard self.range(of: kHtmlIframeOpenTag) != nil else {
            return self
        }
        var result = ""
        var temp = self
        while let startRange = temp.range(of: kHtmlIframeOpenTag) {
            if result.isEmpty {
                result = temp.substring(to: startRange.upperBound)
            }
            let tail = temp.substring(from: startRange.upperBound)
            let endRange = tail.range(of: kHtmlIframeCloseTag)!
            let iframe = tail.substring(to: endRange.lowerBound)
            var iframeParts = iframe.split(separator: " ")
            if let width = iframeParts.first(where: { $0.hasPrefix(kHtmlWidthPrefix) }), let index = iframeParts.index(of: width) {
                iframeParts.remove(at: index)
            }
            iframeParts.insert(Substring(String(format: kHtmlWidthFormat, width - kHtmlMarging)), at: 0)
            if let height = iframeParts.first(where: { $0.hasPrefix(kHtmlHeightPrefix) }), let index = iframeParts.index(of: height) {
                iframeParts.remove(at: index)
            }
            iframeParts.insert(Substring(String(format: kHtmlHeightFormat, width / kHtmlIframeAspectRation)), at: 0)
            if let subrange = tail.range(of: kHtmlIframeOpenTag) {
                result += iframeParts.joined(separator: " ") + tail.substring(to: subrange.upperBound).substring(from: endRange.lowerBound)
                temp = tail.substring(from: subrange.lowerBound)
            } else {
                result += iframeParts.joined(separator: " ") + tail.substring(from: endRange.lowerBound)
                break
            }
        }
        return result.isEmpty ? self : result
    }
}
