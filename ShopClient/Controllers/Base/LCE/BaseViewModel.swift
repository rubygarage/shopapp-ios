//
//  BaseViewModel.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 11/2/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import RxSwift

typealias ViewStateResult = (state: ViewState, error: Error?)

class BaseViewModel {
    var state = PublishSubject<ViewStateResult>()
}
