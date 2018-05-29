//
//  MagentoImageAdapterSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/16/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class MagentoImageAdapterSpec: QuickSpec {
    override func spec() {
        describe("when adapter used") {
            var catalog: String!
            var image: String!
            
            beforeEach {
                catalog = "catalog/"
                image = "image/"
                
                BaseRouter.hostUrl = MagentoAdaptersTestHepler.host
            }
            
            it("needs to adapt string parameters to shopapp model") {
                let object = MagentoImageAdapter.adapt(image, catalogPath: catalog)
                let scr = BaseRouter.hostUrl! + catalog + image
                
                expect(object?.id) == scr
                expect(object?.src) == scr
                expect(object?.imageDescription).to(beNil())
            }
            
            it("needs to adapt magento response to shopapp model") {
                let response = GalleryEntryResponse(id: 0, mediaType: "image", label: "label", file: "file")
                let object = MagentoImageAdapter.adapt(response, catalogPath: catalog)
                let scr = BaseRouter.hostUrl! + catalog + response.file
                
                expect(object?.id) == String(response.id)
                expect(object?.src) == scr
                expect(object?.imageDescription) == response.label
            }
        }
    }
}
