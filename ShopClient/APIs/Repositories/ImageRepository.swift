//
//  ImageRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/12/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MagicalRecord

class ImageRepository {
    class func loadImage(with item: ImageEntityInterface?, in context: NSManagedObjectContext) -> Image? {
        let imageIdValue = item?.entityId ?? String()
        let image = Image.mr_findFirstOrCreate(byAttribute: "id", withValue: imageIdValue, in: context)
        image.update(with: item)
        
        return image
    }
    
    class func loadImages(with items: [ImageEntityInterface], in context: NSManagedObjectContext) -> [Image] {
        for imageInterface in items {
            let image = Image.mr_findFirstOrCreate(byAttribute: "id", withValue: imageInterface.entityId, in: context)
            image.update(with: imageInterface)
        }
        let imagesIds = items.map({ $0.entityId })
        let predicate = NSPredicate(format: "id IN %@", imagesIds)
        return Image.mr_findAll(with: predicate, in: context) as? [Image] ?? [Image]()
    }
}

internal extension Image {
    func update(with remoteItem: ImageEntityInterface?) {
        id = remoteItem?.entityId
        src = remoteItem?.entitySrc
        imageDescription = remoteItem?.entityImageDescription
    }
}
