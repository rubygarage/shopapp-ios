//
//  AddressListHeaderViewDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 5/4/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

@testable import ShopApp

class AddressListHeaderViewDelegateMock: AddressListHeaderViewDelegate {
    var header: AddressListTableHeaderView?
    
    // MARK: - AddressListHeaderViewDelegate
    
    func tableViewHeaderDidTapAddAddress(_ header: AddressListTableHeaderView) {
        self.header = header
    }
}
