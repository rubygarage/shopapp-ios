//
//  ProductOptionsCollectionCellDelegateMock.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/21/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import UIKit

import ShopApp_Gateway

@testable import ShopApp

class ProductOptionsCollectionCellDelegateMock: ProductOptionsCollectionCellDelegate {
    var collectionViewCell: ProductOptionsCollectionViewCell?
    var values: [String]?
    var selectedValue: String?
    
    func collectionViewCell(_ collectionViewCell: ProductOptionsCollectionViewCell, didSelectItemWith values: [String], selectedValue: String) {
        self.collectionViewCell = collectionViewCell
        self.values = values
        self.selectedValue = selectedValue
    }
}
