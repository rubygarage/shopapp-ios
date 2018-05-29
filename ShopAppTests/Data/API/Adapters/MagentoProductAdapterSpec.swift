//
//  MagentoProductAdapterSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class MagentoProductAdapterSpec: QuickSpec {
    override func spec() {
        describe("when adapter used") {
            var curency: String!
            var paginationValue: Int!
            
            beforeEach {
                curency = "UAH"
                paginationValue = 2
                
                BaseRouter.hostUrl = MagentoAdaptersTestHepler.host
            }
            
            context("if response hasn't media gallery images") {
                it("needs to adapt magento response to shopapp model") {
                    let descriptionCustomAttributeResponse = MagentoAdaptersTestHepler.descriptionCustomAttributeResponse
                    let thumbnailCustomAttributeResponse = MagentoAdaptersTestHepler.thumbnailCustomAttributeResponse
                    let imageCustomAttributeResponse = MagentoAdaptersTestHepler.imageCustomAttributeResponse
                    let customAttributes = [descriptionCustomAttributeResponse, thumbnailCustomAttributeResponse, imageCustomAttributeResponse]
                    let response = GetProductResponse.init(id: 0, sku: "sku", name: "name", attributeSetId: 1, price: 15.5, createdAt: Date(), updatedAt: Date(), customAttributes: customAttributes, mediaGalleryEntries: nil)
                    let object = MagentoProductAdapter.adapt(response, currency: curency, paginationValue: paginationValue)
                    
                    self.compare(object, with: response, curency: curency, paginationValue: paginationValue)
                }
            }
            
            context("if response has media gallery images") {
                it("needs to adapt magento response to shopapp model") {
                    let descriptionCustomAttributeResponse = MagentoAdaptersTestHepler.descriptionCustomAttributeResponse
                    let galleryEntryResponse = GalleryEntryResponse(id: 3, mediaType: "image", label: "label", file: "file")
                    let response = GetProductResponse.init(id: 0, sku: "sku", name: "name", attributeSetId: 1, price: 15.5, createdAt: Date(), updatedAt: Date(), customAttributes: [descriptionCustomAttributeResponse], mediaGalleryEntries: [galleryEntryResponse])
                    let object = MagentoProductAdapter.adapt(response, currency: curency, paginationValue: paginationValue)
                    
                    self.compare(object, with: response, curency: curency, paginationValue: paginationValue, galleryEntryResponse: galleryEntryResponse)
                }
            }
        }
    }
    
    private func compare(_ object: Product, with response: GetProductResponse, curency: String, paginationValue: Int, galleryEntryResponse: GalleryEntryResponse! = nil) {
        expect(object.id) == response.sku
        expect(object.title) == response.name
        expect(object.price) == Decimal(response.price)
        expect(object.currency) == curency
        expect(object.discount) == ""
        expect(object.type) == String(response.attributeSetId)
        expect(object.vendor) == ""
        expect(object.createdAt) == response.createdAt
        expect(object.updatedAt) == response.updatedAt
        expect(object.tags?.isEmpty) == true
        expect(object.options?.isEmpty) == true
        expect(object.paginationValue) == String(paginationValue)
        expect(object.productDescription) == response.customAttributes.first?.value.data?.htmlToString
        expect(object.additionalDescription) == response.customAttributes.first?.value.data
        
        if let mediaGalleryEntries = response.mediaGalleryEntries, !mediaGalleryEntries.isEmpty {
            expect(object.images?.first?.id) == String(galleryEntryResponse.id)
            expect(object.variants?.first?.id) == response.sku
            expect(object.variants?.first?.title) == response.name
            expect(object.variants?.first?.price) == Decimal(response.price)
            expect(object.variants?.first?.available) == true
            expect(object.variants?.first?.image?.id) == String(galleryEntryResponse.id)
            expect(object.variants?.first?.selectedOptions?.isEmpty) == true
            expect(object.variants?.first?.productId) == response.sku
        } else {
            expect(object.images?.first?.id) == BaseRouter.hostUrl! + "pub/media/catalog/product" + response.customAttributes[1].value.data!
            expect(object.images?.last?.id) == BaseRouter.hostUrl! + "pub/media/catalog/product" + response.customAttributes.last!.value.data!
            expect(object.variants?.isEmpty) == true
        }
    }
}
