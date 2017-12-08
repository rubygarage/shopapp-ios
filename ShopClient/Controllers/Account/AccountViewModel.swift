//
//  AccountViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/6/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

class AccountViewModel: BaseViewModel {
    var policies = Variable<[Policy]>([Policy]())
    var customer = Variable<Customer?>(nil)
    
    public func loadData(with disposeBag: DisposeBag) {
        state.onNext(.loading(showHud: true))
        Single.zip(shopSingle, customerSingle).do()
            .subscribe(onSuccess: { [weak self] (shop, customer) in
                self?.processResponse(with: shop, customerItem: customer)
                self?.state.onNext(.content)
            }, onError: { [weak self] (error) in
                let castedError = error as? RepoError
                self?.state.onNext(.error(error: castedError))
            })
        .disposed(by: disposeBag)
    }

    private var shopSingle: Single<Shop?> {
        return Single.create(subscribe: { (single) in
            Repository.shared.getShop(callback: { (shop, error) in
                if let error = error {
                    single(.error(error))
                }
                if let shop = shop {
                    single(.success(shop))
                }
            })
            return Disposables.create()
        })
    }
    
    private var customerSingle: Single<Customer?> {
        return Single.create(subscribe: { single in
            if Repository.shared.isLoggedIn() {
                // TODO: get customer
                single(.success(nil)) // remove
            } else {
                single(.success(nil))
            }
            return Disposables.create()
        })
    }
    
    private func processResponse(with shopItem: Shop?, customerItem: Customer?) {
        var policiesItems = [Policy]()
        if let privacyPolicy = shopItem?.privacyPolicy {
            policiesItems.append(privacyPolicy)
        }
        if let refundPolicy = shopItem?.refundPolicy {
            policiesItems.append(refundPolicy)
        }
        if let termsOfService = shopItem?.termsOfService {
            policiesItems.append(termsOfService)
        }
        policies.value = policiesItems
        
        if let customer = customerItem {
            self.customer.value = customer
        }
    }
}
