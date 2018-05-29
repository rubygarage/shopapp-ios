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
        let product = Product()
        product.id = response.sku
        product.title = response.name
        product.price = Decimal(response.price)
        product.currency = currency
        product.discount = ""
        product.images = []
        product.type = String(response.attributeSetId)
        product.vendor = ""
        product.createdAt = response.createdAt
        product.updatedAt = response.updatedAt
        product.tags = []
        product.variants = []
        product.options = []
        
        if let paginationValue = paginationValue {
            product.paginationValue = String(paginationValue)
        }
        
        if let descriptionValue = response.customAttributes.filter({ $0.attributeCode == customAttributeDescriptionCode }).first?.value.data {
            product.productDescription = descriptionValue.htmlToString
            product.additionalDescription = descriptionValue
        }
        
        var customAttributeImages: [Image] = []
        
        if let thumbnailValue = response.customAttributes.filter({ $0.attributeCode == customAttributeThumbnailCode }).first?.value.data, let thumbnail = MagentoImageAdapter.adapt(thumbnailValue, catalogPath: imageCatalogPath) {
            customAttributeImages.append(thumbnail)
        }
        
        if let imageValue = response.customAttributes.filter({ $0.attributeCode == customAttributeImageCode }).first?.value.data, let image = MagentoImageAdapter.adapt(imageValue, catalogPath: imageCatalogPath) {
            customAttributeImages.append(image)
        }
        
        guard let mediaGalleryEntries = response.mediaGalleryEntries else {
            product.images = customAttributeImages
            
            return product
        }
        
        let mediaGalleryImages = mediaGalleryEntries.flatMap { MagentoImageAdapter.adapt($0, catalogPath: imageCatalogPath) }
        let productVariant = ProductVariant()
        productVariant.id = response.sku
        productVariant.title = response.name
        productVariant.price = Decimal(response.price)
        productVariant.available = true
        productVariant.image = customAttributeImages.first ?? mediaGalleryImages.first
        productVariant.selectedOptions = []
        productVariant.productId = response.sku
        
        product.images = mediaGalleryImages
        product.variants?.append(productVariant)
        
        return product
    }
}
