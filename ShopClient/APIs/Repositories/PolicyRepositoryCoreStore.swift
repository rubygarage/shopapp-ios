//
//  PolicyRepositoryCoreStore.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/11/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import CoreStore

class PolicyRepositoryCoreStore {
    class func loadPolicy<T: Policy>(with item: PolicyEntityInterface?, transaction: AsynchronousDataTransaction) -> T? {
        var policy = transaction.fetchOne(From<T>())
        if policy == nil {
            policy = transaction.create(Into<T>())
        }
        policy?.update(with: item)
        
        return policy
    }
}

internal extension Policy {
    func update(with remoteItem: PolicyEntityInterface?) {
        title = remoteItem?.entityTitle
        body = remoteItem?.entityBody
        url = remoteItem?.entityUrl
    }
}
