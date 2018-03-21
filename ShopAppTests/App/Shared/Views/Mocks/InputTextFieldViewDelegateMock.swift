//
//  InputTextFieldViewDelegateMock.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 3/20/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class InputTextFieldViewDelegateMock: InputTextFieldViewDelegate {
    var isViewDidEndUpdate = false
    var isViewDidUpdate = false
    var view: InputTextFieldView?
    var text: String?
    
    // MARK: - InputTextFieldViewDelegate
    
    func textFieldView(_ view: InputTextFieldView, didEndUpdate text: String) {
        isViewDidEndUpdate = true
        
        self.view = view
        self.text = text
    }
    
    func textFieldView(_ view: InputTextFieldView, didUpdate text: String) {
        isViewDidUpdate = true
        
        self.view = view
        self.text = text
    }
}
