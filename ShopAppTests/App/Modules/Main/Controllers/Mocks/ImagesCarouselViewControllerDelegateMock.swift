//
//  ImagesCarouselViewControllerDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Foundation

@testable import ShopApp

class ImagesCarouselViewControllerDelegateMock: NSObject, ImagesCarouselViewControllerDelegate {
    var viewController: ImagesCarouselViewController?
    var index: Int?
    
    // MARK: - ImagesCarouselViewControllerDelegate
    
    func viewController(_ viewController: ImagesCarouselViewController, didTapImageAt index: Int) {
        self.viewController = viewController
        self.index = index
    }
}
