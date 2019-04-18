//
//  CoreDataDAO.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 11/8/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import CoreStore
import ShopApp_Gateway

class CoreDataDAO: DAO {
    func getCartProductList(callback: @escaping RepoCallback<[CartProduct]>) {
        var cartProducts: [CartProduct] = []
        
        CoreStore.perform(asynchronous: { transaction in
            let items = try transaction.fetchAll(From<CartProductEntity>())
            cartProducts = items.map({ CoreDataCartProductAdapter.adapt(item: $0)! })
        }, completion: { result in
            switch result {
            case .success:
                callback(cartProducts, nil)
            case .failure(let error):
                callback(nil, RepoError(with: error))
            }
        })
    }
    
    func addCartProduct(cartProduct: CartProduct, callback: @escaping RepoCallback<Bool>) {
        let predicate = getPredicate(with: cartProduct.productVariant?.id)
        
        CoreStore.perform(asynchronous: { transaction in
            var item = try transaction.fetchOne(From<CartProductEntity>(), Where<CartProductEntity>(predicate))
            
            if item != nil {
                let newQuantity = Int(item?.quantity ?? 0) + cartProduct.quantity
                item?.quantity = Int64(newQuantity < kCartProductQuantityMax ? newQuantity : kCartProductQuantityMax)
            } else {
                item = transaction.create(Into<CartProductEntity>())
                CartProductEntityUpdateService.update(item, with: cartProduct, transaction: transaction)
            }
        }, completion: { result in
            switch result {
            case .success:
                callback(true, nil)
            case .failure(let error):
                callback(false, RepoError(with: error))
            }
        })
    }
    
    func deleteProductFromCart(with productVariantId: String?, callback: @escaping RepoCallback<Bool>) {
        let predicate = getPredicate(with: productVariantId)
        
        CoreStore.perform(asynchronous: { transaction in
            let item = try transaction.fetchOne(From<CartProductEntity>(), Where<CartProductEntity>(predicate))
            transaction.delete(item)
        }, completion: { result in
            switch result {
            case .success:
                callback(true, nil)
            case .failure(let error):
                callback(false, RepoError(with: error))
            }
        })
    }
    
    func deleteProductsFromCart(with productVariantIds: [String?], callback: @escaping RepoCallback<Bool>) {
        let ids: [String] = productVariantIds.filter({ $0 != nil }).map({ $0! })
        let predicate = getPredicate(with: ids)
        
        CoreStore.perform(asynchronous: { transaction in
            let items = try transaction.fetchAll(From<CartProductEntity>(), Where<CartProductEntity>(predicate))
            transaction.delete(items)
        }, completion: { result in
            switch result {
            case .success:
                callback(true, nil)
            case .failure(let error):
                callback(false, RepoError(with: error))
            }
        })
    }
    
    func deleteAllProductsFromCart(with callback: @escaping RepoCallback<Bool>) {
        CoreStore.perform(asynchronous: { transaction in
            try transaction.deleteAll(From<CartProductEntity>())
        }, completion: { result in
            switch result {
            case .success:
                callback(true, nil)
            case .failure(let error):
                callback(false, RepoError(with: error))
            }
        })
    }
    
    func changeCartProductQuantity(with productVariantId: String?, quantity: Int, callback: @escaping RepoCallback<Bool>) {
        let predicate = getPredicate(with: productVariantId)
        
        CoreStore.perform(asynchronous: { transaction in
            let item: CartProductEntity? = transaction.fetchOrCreate(predicate: predicate)
            item?.quantity = Int64(quantity)
        }, completion: { result in
            switch result {
            case .success:
                callback(true, nil)
            case .failure(let error):
                callback(false, RepoError(with: error))
            }
        })
    }
    
    private func getPredicate(with productVariantId: String?) -> NSPredicate {
        let variantId = productVariantId ?? ""
        return NSPredicate(format: "productVariant.id == %@", variantId)
    }
    
    private func getPredicate(with productVariantsIds: [String]) -> NSPredicate {
        return NSPredicate(format: "productVariant.id IN %@", productVariantsIds)
    }
}
