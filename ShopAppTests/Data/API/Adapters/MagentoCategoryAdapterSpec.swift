//
//  MagentoCategoryAdapterSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class MagentoCategoryAdapterSpec: QuickSpec {
    override func spec() {
        describe("when adapter used") {
            it("needs to adapt magento list response to shopapp model") {
                let childrenResponse = GetCategoryListResponse(id: 1, name: "children name", childrenData: [])
                let response = GetCategoryListResponse(id: 0, name: "name", childrenData: [childrenResponse])
                let object = MagentoCategoryAdapter.adapt(response)
                
                expect(object.id) == String(response.id)
                expect(object.title) == response.name
                expect(object.categoryDescription) == ""
                expect(object.updatedAt).toNot(beNil())
                expect(object.childrenCategories?.first?.id) == String(childrenResponse.id)
                expect(object.products?.isEmpty) == true
                expect(object.additionalDescription) == ""
                expect(object.image).to(beNil())
            }
            
            it("needs to adapt magento details response to shopapp model") {
                BaseRouter.hostUrl = MagentoAdaptersTestHepler.host
                
                let product = Product()
                product.id = "id"
                
                let descriptionCustomAttributeResponse = MagentoAdaptersTestHepler.descriptionCustomAttributeResponse
                let imageCustomAttributeResponse = MagentoAdaptersTestHepler.imageCustomAttributeResponse
                let response = GetCategoryDetailsResponse.init(id: 0, name: "name", customAttributes: [descriptionCustomAttributeResponse, imageCustomAttributeResponse], updatedAt: Date())
                let object = MagentoCategoryAdapter.adapt(response, products: [product])
                
                expect(object.id) == String(response.id)
                expect(object.title) == response.name
                expect(object.categoryDescription) == response.customAttributes.first?.value.data?.htmlToString
                expect(object.updatedAt) == response.updatedAt
                expect(object.childrenCategories?.isEmpty) == true
                expect(object.products?.first?.id) == product.id
                expect(object.additionalDescription) == response.customAttributes.first?.value.data
                expect(object.image?.id) == BaseRouter.hostUrl! + "pub/media/catalog/category" + response.customAttributes.last!.value.data!
            }
        }
    }
}
