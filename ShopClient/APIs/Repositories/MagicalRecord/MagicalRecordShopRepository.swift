//
//  MagicalRecordShopDAO.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MagicalRecord

extension MagicalRecordRepository {
    func loadShopInfo(with item: ShopEntityInterface?, callback: @escaping ((_ shop: ShopEntity?, _ error: Error?) -> ())) {
        MagicalRecord.save({ [weak self] (context) in
            if let shop = self?.getShop(in: context) {
                self?.update(shop: shop, with: item, in: context)
            }
        }) { (contextDidSave, error) in
            let shop = ShopEntity.mr_findFirst()
            callback(shop, error)
        }
    }
    
    func getShop() -> ShopEntity? {
        return ShopEntity.mr_findFirst()
    }
    
    // MARK: - private
    private func getShop(in context: NSManagedObjectContext) -> ShopEntity? {
        var shop = ShopEntity.mr_findFirst(in: context)
        if shop == nil {
            shop = ShopEntity.mr_createEntity(in: context)
        }
        return shop
    }
    
    private func update(shop: ShopEntity, with remoteItem: ShopEntityInterface?, in context: NSManagedObjectContext) {
        shop.name = remoteItem?.entityName
        shop.shopDescription = remoteItem?.entityDesription
        shop.currency = remoteItem?.entityCurrency
        if let policy = remoteItem?.entityPrivacyPolicy {
            shop.privacyPolicy = loadPolicy(with: policy, in: context)
        }
        if let policy = remoteItem?.entityRefundPolicy {
            shop.refundPolicy = loadPolicy(with: policy, in: context)
        }
        if let terms = remoteItem?.entityTermsOfService {
            shop.termsOfService = loadPolicy(with: terms, in: context)
        }
    }
}
