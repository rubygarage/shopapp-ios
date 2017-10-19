//
//  MagicalRecordPolicyRepository.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/19/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MagicalRecord

extension MagicalRecordRepository {
    func loadPolicy<T: Policy>(with item: PolicyEntityInterface?, in context: NSManagedObjectContext) -> T? {
        var policy = T.mr_findFirst(in: context)
        if policy == nil {
            policy = T.mr_createEntity(in: context)
        }
        update(policy: policy!, with: item)
        return policy
    }
    
    private func update(policy: Policy, with remoteItem: PolicyEntityInterface?) {
        policy.title = remoteItem?.entityTitle
        policy.body = remoteItem?.entityBody
        policy.url = remoteItem?.entityUrl
    }
}
