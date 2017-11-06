//
//  GridCollectionViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/3/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class GridCollectionViewModel: BaseCollectionViewModel {
    var products = Variable<[Product]>([Product]())
}
