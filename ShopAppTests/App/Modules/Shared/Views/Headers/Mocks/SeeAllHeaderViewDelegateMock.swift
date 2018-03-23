//
//  SeeAllHeaderViewDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class SeeAllHeaderViewDelegateMock: SeeAllHeaderViewDelegate {
    var headerView: SeeAllTableHeaderView?
    var type: SeeAllViewType?
    
    // MARK: - SeeAllHeaderViewDelegate
    
    func headerView(_ headerView: SeeAllTableHeaderView, didTapSeeAll type: SeeAllViewType) {
        self.headerView = headerView
        self.type = type
    }
}
