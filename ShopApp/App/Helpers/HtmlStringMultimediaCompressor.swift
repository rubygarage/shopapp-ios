//
//  HtmlStringMultimediaCompressor.swift
//  ShopApp
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

struct HtmlStringMultimediaCompressor {
    static func compress(_ string: String, withMultimediaWidth width: CGFloat) -> String {
        let isHaveImage = string.range(of: kHtmlImageTag) != nil
        let isHaveIframe = string.range(of: kHtmlIframeOpenTag) != nil
        guard isHaveImage || isHaveIframe else {
            return string
        }
        let intermediateResultString = isHaveImage ? compress(string, withImageWidth: width) : string
        return isHaveIframe ? compress(intermediateResultString, withVideoWidth: width) : intermediateResultString
    }
    
    private static func compress(_ string: String, withImageWidth width: CGFloat) -> String {
        var result = ""
        let style = String(format: kHtmlStyleWithMaxWidthFormat, width - kHtmlMarging)
        var temp = string
        while let range = temp.range(of: kHtmlImageTag) {
            if result.isEmpty {
                result = String(temp[..<range.upperBound])
            }
            let tail = String(temp[range.upperBound...])
            if let subrange = tail.range(of: kHtmlImageTag) {
                result += style + String(tail[..<subrange.upperBound])
                temp = String(tail[subrange.lowerBound...])
            } else {
                result += style + tail
                break
            }
        }
        return result
    }
    
    private static func compress(_ string: String, withVideoWidth width: CGFloat) -> String {
        var result = ""
        var temp = string
        while let startRange = temp.range(of: kHtmlIframeOpenTag) {
            if result.isEmpty {
                result = String(temp[..<startRange.upperBound])
            }
            let tail = String(temp[startRange.upperBound...])
            let endRange = tail.range(of: kHtmlIframeCloseTag)!
            let iframe = String(tail[..<endRange.lowerBound])
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
                result += iframeParts.joined(separator: " ") + String(String(tail[..<subrange.upperBound])[endRange.lowerBound...])
                temp = String(tail[subrange.lowerBound...])
            } else {
                result += iframeParts.joined(separator: " ") + String(tail[endRange.lowerBound...])
                break
            }
        }
        return result
    }
}
