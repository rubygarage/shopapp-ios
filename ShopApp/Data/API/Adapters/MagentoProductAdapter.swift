//
//  MagentoProductAdapter.swift
//  ShopApp
//
//  Created by Radyslav Krechet on 4/30/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import ShopApp_Gateway

struct MagentoProductAdapter {
    private static let customAttributeDescriptionCode = "description"
    private static let customAttributeThumbnailCode = "thumbnail"
    private static let customAttributeImageCode = "image"
    private static let imageCatalogPath = "pub/media/catalog/product"
    
    static func adapt(_ response: GetProductResponse, currency: String, paginationValue: Int? = nil) -> Product {
        let price = Decimal(response.price)
        let type = String(response.attributeSetId)
        
        var pagination: String?
        if let paginationValue = paginationValue {
            pagination = String(paginationValue)
        }
        
        var productDescription: String = ""
        if let descriptionValue = response.customAttributes.filter({ $0.attributeCode == customAttributeDescriptionCode }).first?.value.data {
            productDescription = descriptionValue.htmlToString
        }
        
        var customAttributeImages: [Image] = []
        if let thumbnailValue = response.customAttributes.filter({ $0.attributeCode == customAttributeThumbnailCode }).first?.value.data, let thumbnail = MagentoImageAdapter.adapt(thumbnailValue, catalogPath: imageCatalogPath) {
            customAttributeImages.append(thumbnail)
        }
        if let imageValue = response.customAttributes.filter({ $0.attributeCode == customAttributeImageCode }).first?.value.data, let image = MagentoImageAdapter.adapt(imageValue, catalogPath: imageCatalogPath) {
            customAttributeImages.append(image)
        }
        
        guard let mediaGalleryEntries = response.mediaGalleryEntries else {
            return Product(id: response.sku, title: response.name, productDescription: productDescription, price: price, hasAlternativePrice: false, currency: currency, images: customAttributeImages, type: type, paginationValue: pagination, variants: [], options: [])
        }
        
        let mediaGalleryImages = mediaGalleryEntries.flatMap { MagentoImageAdapter.adapt($0, catalogPath: imageCatalogPath) }

        let variantPrice = Decimal(response.price)
        let variantImage = customAttributeImages.first ?? mediaGalleryImages.first
        let variant = ProductVariant(id: response.sku, title: response.name, price: variantPrice, isAvailable: true, image: variantImage, selectedOptions: [], productId: response.sku)
        
        return Product(id: response.sku, title: response.name, productDescription: productDescription, price: price, hasAlternativePrice: false, currency: currency, images: mediaGalleryImages, type: type, paginationValue: pagination, variants: [variant], options: [])
    }
}
