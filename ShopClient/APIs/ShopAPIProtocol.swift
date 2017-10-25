//
//  ShopAPIProtocol.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 8/30/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

typealias ApiCallback<T> = (_ result: T?, _ error: Error?) -> ()

protocol ShopAPIProtocol {
    // MARK: - articles
    func getArticleList(perPage: Int, paginationValue: Any?, sortBy: SortingValue?, reverse: Bool, callback: @escaping ApiCallback<[Article]>)
}
