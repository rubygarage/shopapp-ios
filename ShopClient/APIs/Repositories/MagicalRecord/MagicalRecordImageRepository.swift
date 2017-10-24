//
//  MagicalRecordImageRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MagicalRecord

extension MagicalRecordRepository {
    func loadImage(with item: ImageEntityInterface?, in context: NSManagedObjectContext) -> ImageEntity? {
        let imageIdValue = item?.entityId ?? String()
        let image = ImageEntity.mr_findFirstOrCreate(byAttribute: "id", withValue: imageIdValue, in: context)
        update(image: image, with: item)
        return image
    }
    
    func loadImages(with items: [ImageEntityInterface], in context: NSManagedObjectContext) -> [ImageEntity] {
        for imageInterface in items {
            let image = ImageEntity.mr_findFirstOrCreate(byAttribute: "id", withValue: imageInterface.entityId, in: context)
            update(image: image, with: imageInterface)
        }
        let imagesIds = items.map({ $0.entityId })
        let predicate = NSPredicate(format: "id IN %@", imagesIds)
        return ImageEntity.mr_findAll(with: predicate, in: context) as? [ImageEntity] ?? [ImageEntity]()
    }
    
    // MARK: - private
    private func update(image: ImageEntity, with remoteItem: ImageEntityInterface?) {
        image.id = remoteItem?.entityId
        image.src = remoteItem?.entitySrc
        image.imageDescription = remoteItem?.entityImageDescription
    }
}
