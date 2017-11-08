//
//  CartProductDAO.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import MagicalRecord

extension DAOMagicalRecord {
    func getCartProductList() -> [CartProduct] {
        let e: [CartProductEntity]? = CartProductEntity.mr_findAll() as? [CartProductEntity]
//        let r = e?.map({ CartProduct(with: $0 })
        print("w")
        return [CartProduct]()
    }
    
    func addCartProduct(cartProduct: CartProduct, callback: @escaping RepoCallback<CartProduct>) {
        let variantId = cartProduct.productVariant?.id ?? String()
        let predicate = NSPredicate(format: "productVariant.id = %@", variantId)
        MagicalRecord.save({ (context) in
            var cartProductEntity = CartProductEntity.mr_findFirst(with: predicate, in: context)
            if cartProductEntity == nil {
                cartProductEntity = CartProductEntity.mr_createEntity(in: context)
            }
            cartProductEntity?.update(with: cartProduct, context: context)
        }) { (contextDidSave, error) in
            let item = CartProductEntity.mr_findFirst(with: predicate)
            let r = CartProductEntity.mr_findAll()
            let result = CartProduct(with: item)
            callback(result, error)
        }
    }
}
