//
//  OrderFooterDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

@testable import ShopApp

class OrderFooterDelegateMock: OrderFooterDelegate {
    var footerView: OrderFooterView?
    var section: Int?
    
    // MARK: - OrderFooterDelegate
    
    func footerView(_ footerView: OrderFooterView, didTapWith section: Int) {
        self.footerView = footerView
        self.section = section
    }
}
