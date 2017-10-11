//
//  PolicyRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/11/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MagicalRecord

class PolicyRepository {
    class func loadPolicy<T: Policy>(with item: PolicyEntityInterface?, in context: NSManagedObjectContext) -> T? {
        var policy = T.mr_findFirst(in: context)
        if policy == nil {
            policy = T.mr_createEntity(in: context)
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
