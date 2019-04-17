//
//  CoreStore+Transaction.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import CoreStore

extension AsynchronousDataTransaction {
    func fetchOrCreate<T: DynamicObject>(predicate: NSPredicate) -> T? {
        var item: T?
        do {
            item = try fetchOne(From<T>(), Where<T>(predicate))
        } catch {}
        if item == nil {
            item = create(Into<T>())
        }
        return item as T?
    }
}
