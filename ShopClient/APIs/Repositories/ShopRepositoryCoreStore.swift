//
//  ShopRepositoryCoreStore.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/11/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import CoreStore

class ShopRepositoryCoreStore {
    // MARK: - public
    class func loadShopInfo(with item: ShopEntityInterface?, callback: @escaping ((_ shop: Shop?, _ error: Error?) -> ())) {
        CoreStore.perform(asynchronous: { (transaction) in
            let shop = getShop(with: transaction)
            shop?.update(with: item, transaction: transaction)
        }) { (result) in
            switch result {
            case .success:
                let shop = CoreStore.fetchOne(From<Shop>())
                callback(shop, nil)
            case .failure(let error):
                callback(nil, error)
            }
        }
    }
    
    class func getShop() -> Shop? {
        return CoreStore.fetchOne(From<Shop>())
    }
    
    // MARK: - private
    private class func getShop(with transaction: AsynchronousDataTransaction) -> Shop? {
        var shop = transaction.fetchOne(From<Shop>())
        if shop == nil {
            shop = transaction.create(Into<Shop>())
        }
        return shop
    }
}

internal extension Shop {
    func update(with remoteItem: ShopEntityInterface?, transaction: AsynchronousDataTransaction) {
        name = remoteItem?.entityName
        shopDescription = remoteItem?.entityDesription
        
        if let policy = remoteItem?.entityPrivacyPolicy {
            privacyPolicy = PolicyRepositoryCoreStore.loadPolicy(with: policy, transaction: transaction)
        }
        
        if let policy = remoteItem?.entityRefundPolicy {
            refundPolicy = PolicyRepositoryCoreStore.loadPolicy(with: policy, transaction: transaction)
        }
        
        if let terms = remoteItem?.entityTermsOfService {
            termsOfService = PolicyRepositoryCoreStore.loadPolicy(with: terms, transaction: transaction)
        }
    }
}
