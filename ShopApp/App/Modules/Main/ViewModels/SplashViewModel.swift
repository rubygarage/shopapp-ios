//
//  SplashViewModel.swift
//  ShopApp
//
//  Created by Evgeniy Antonov on 4/24/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import RxSwift
import ShopApp_Gateway

class SplashViewModel: BaseViewModel {
    private let cartProductListUseCase: CartProductListUseCase
    private let cartValidationUseCase: CartValidationUseCase
    private let deleteCartProductUseCase: DeleteCartProductUseCase
    
    var dataLoaded = PublishSubject<Void>()
    
    init(cartProductListUseCase: CartProductListUseCase, cartValidationUseCase: CartValidationUseCase, deleteCartProductUseCase: DeleteCartProductUseCase) {
        self.cartProductListUseCase = cartProductListUseCase
        self.cartValidationUseCase = cartValidationUseCase
        self.deleteCartProductUseCase = deleteCartProductUseCase
    }
    
    func loadData() {
        cartProductListUseCase.getCartProductList { [weak self] (products, error) in
            guard let strongSelf = self else {
                return
            }
            
            let filteredProducts = products?.filter({ $0.productVariant?.id != nil })
            if let ids = filteredProducts?.map({ $0.productVariant!.id}), !ids.isEmpty, error == nil {
                strongSelf.loadProductVariants(ids: ids)
            } else {
                strongSelf.dataLoaded.onNext(())
            }
        }
    }
    
    private func loadProductVariants(ids: [String]) {
        cartValidationUseCase.getProductVariantList(ids: ids) { [weak self] (productVariants, error) in
            guard let strongSelf = self else {
                return
            }
            
            if let remoteIds = productVariants?.map({ $0.id }), error == nil {
                strongSelf.filterProductVariants(localIds: ids, remoteIds: remoteIds)
            } else {
                strongSelf.dataLoaded.onNext(())
            }
        }
    }
    
    private func filterProductVariants(localIds: [String], remoteIds: [String]) {
        let excludedIds = localIds.filter({ !remoteIds.contains($0) })
        deleteCartProductUseCase.deleteProductsFromCart(with: excludedIds) { [weak self] (_, _) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.dataLoaded.onNext(())
        }
    }
    
    // MARK: - BaseViewModel
    
    override func tryAgain() {
        loadData()
    }
}
