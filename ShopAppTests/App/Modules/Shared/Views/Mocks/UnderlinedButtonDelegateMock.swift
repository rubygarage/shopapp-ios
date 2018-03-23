//
//  UnderlinedButtonDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class UnderlinedButtonDelegateMock: UnderlinedButtonDelegate {
    var button: UnderlinedButton?
    var isHighlighted: Bool?
    
    // MARK: - UnderlinedButtonDelegate
    
    func underlinedButton(_ button: UnderlinedButton, didChangeState isHighlighted: Bool) {
        self.button = button
        self.isHighlighted = isHighlighted
    }
}
