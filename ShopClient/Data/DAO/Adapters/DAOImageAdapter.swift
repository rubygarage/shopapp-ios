//
//  DAOImageAdapter.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/9/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

extension Image {
    convenience init?(with image: ImageEntity?) {
        if image == nil {
            return nil
        }
        self.init()
        
        id = image?.id ?? String()
        src = image?.src
        imageDescription = image?.imageDescription
    }
}
