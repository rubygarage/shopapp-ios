//
//  DAOImageHelper.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/9/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import CoreStore

extension ImageEntity {
    func update(with item: Image?) {
        id = item?.id
        src = item?.src
        imageDescription = item?.imageDescription
    }
}
