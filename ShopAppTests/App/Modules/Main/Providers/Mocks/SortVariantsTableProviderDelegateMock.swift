//
//  SortVariantsTableProviderDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/14/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

@testable import ShopApp

class SortVariantsTableProviderDelegateMock: NSObject, SortVariantsTableProviderDelegate {
    var provider: SortVariantsTableProvider?
    var variant: String?
    
    // MARK: - SortVariantsTableProviderDelegate
    
    func provider(_ provider: SortVariantsTableProvider, didSelect variant: String?) {
        self.provider = provider
        self.variant = variant
    }
}
