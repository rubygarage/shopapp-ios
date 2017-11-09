//
//  DAOCoreStoreCartProduct.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import CoreStore

extension DAO {
    func getCartProductList() -> [CartProduct] {        
        let items: [CartProductEntity]? = CoreStore.fetchAll(From<CartProductEntity>())
        return items?.map({ CartProduct(with: $0)! }) ?? [CartProduct]()
    }
    
    func addCartProduct(cartProduct: CartProduct, callback: @escaping RepoCallback<CartProduct>) {
        let variantId = cartProduct.productVariant?.id ?? String()
        let predicate = NSPredicate(format: "productVariant.id == %@", variantId)
        
        CoreStore.perform(asynchronous: { (transaction) in
            let item: CartProductEntity? = transaction.fetchOrCreate(predicate: predicate)
            item?.update(with: cartProduct, transaction: transaction)
        }) { (result) in
            switch result {
            case .success:
                let item = CoreStore.fetchOne(From<CartProductEntity>(), Where(predicate))
                callback(CartProduct(with: item), nil)
            case .failure(let error):
                callback(nil, error)
            }
        }
    }
    
    func deleteProductFromCart(with productVariantId: String?, callback: @escaping RepoCallback<Bool>) {
        let variantId = productVariantId ?? String()
        let predicate = NSPredicate(format: "productVariant.id == %@", variantId)
        CoreStore.perform(asynchronous: { (transaction) in
            let item: CartProductEntity? = transaction.fetchOne(From<CartProductEntity>(), Where(predicate))
            transaction.delete(item)
        }) { (result) in
            switch result {
            case .success:
                callback(true, nil)
            case .failure(let error):
                callback(false, error)
            }
        }
    }
    
    func changeCartProductQuantity(with productVariantId: String?, quantity: Int, callback: @escaping RepoCallback<CartProduct>) {
        // TODO:
    }
}
