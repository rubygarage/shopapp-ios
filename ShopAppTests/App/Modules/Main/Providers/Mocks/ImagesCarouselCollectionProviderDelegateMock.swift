//
//  ImagesCarouselCollectionProviderDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/19/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

@testable import ShopApp

class ImagesCarouselCollectionProviderDelegateMock: ImagesCarouselCollectionProviderDelegate {
    var provider: ImagesCarouselCollectionProvider?
    var index: Int?
    
    func provider(_ provider: ImagesCarouselCollectionProvider, didScrollToImageAt index: Int) {
        self.provider = provider
        self.index = index
    }
}
