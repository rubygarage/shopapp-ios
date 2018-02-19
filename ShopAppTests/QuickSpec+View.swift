//
//  QuickSpecView.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Quick

extension QuickSpec {
    func findView(withAccessibilityLabel label: String, in view: UIView) -> UIView? {
        var findedView: UIView?
        
        func processSubview(of view: UIView) {
            if view.accessibilityLabel == label {
                findedView = view
            }
            if findedView == nil && !view.subviews.isEmpty {
                view.subviews.forEach { processSubview(of: $0) }
            }
        }
        
        processSubview(of: view)
        return findedView
    }
}
