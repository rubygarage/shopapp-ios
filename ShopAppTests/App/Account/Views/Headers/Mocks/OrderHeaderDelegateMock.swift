//
//  OrderHeaderDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/2/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

@testable import ShopApp

class OrderHeaderDelegateMock: OrderHeaderDelegate {
    var headerView: OrderHeaderView?
    var section: Int?
    
    // MARK: - OrderHeaderDelegate
    
    func headerView(_ headerView: OrderHeaderView, didTapWith section: Int) {
        self.headerView = headerView
        self.section = section
    }
}
