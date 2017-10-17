//
//  ShopAPIModelInterface.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 10/11/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import Foundation

protocol ShopEntityInterface {
    var entityName: String? { get }
    var entityDesription: String? { get }
    var entityCurrency: String? { get }
    var entityPrivacyPolicy: PolicyEntityInterface? { get }
    var entityRefundPolicy: PolicyEntityInterface? { get }
    var entityTermsOfService: PolicyEntityInterface? { get }
}

protocol PolicyEntityInterface {
    var entityBody: String? { get }
    var entityTitle: String? { get }
    var entityUrl: String? { get }
}

protocol CategoryEntityInterface {
    var entityId: String { get }
    var entityTitle: String? { get }
    var entityCategoryDescription: String? { get }
    var entityAdditionalDescription: String? { get }
    var entityUpdatedAt: Date? { get }
    var entityImage: ImageEntityInterface? { get }
    var entityPaginationValue: Any? { get }
    var entityProducts: [ProductEntityInterface]? { get }
}

protocol ImageEntityInterface {
    var entityId: String { get }
    var entitySrc: String? { get }
    var entityImageDescription: String? { get }
}

protocol ProductEntityInterface {
    var entityId: String { get }
    var entityTitle: String? { get }
    var entityProductDescription: String? { get }
    var entityCurrency: String? { get }
    var entityDiscount: String? { get }
    var entityImages: [ImageEntityInterface]? { get }
    var entityType: String? { get }
    var entityVendor: String? { get }
    var entityCreatedAt: Date? { get }
    var entityUpdatedAt: Date? { get }
    var entityTags: [String]? { get }
    var entityPaginationValue: String? { get }
    var entityAdditionalDescription: String? { get }
    var entityVariants: [ProductVariantEntityEnterface]? { get }
}

protocol ProductOptionEntityInterface {
    var entityId: String { get }
    var entityName: String { get }
    var entityValues: [String] { get }
}

protocol ProductVariantEntityEnterface {
    var entityId: String { get }
    var entityTitle: String? { get }
    var entityPrice: String? { get }
    var entityAvailable: Bool { get }
    var entityImage: ImageEntityInterface? { get }
}
