//
//  UIImageView+NetworkSpec.swift
//  ShopAppTests
//
//  Created by Evgeniy Antonov on 3/23/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import ShopApp_Gateway

@testable import ShopApp

class UIImageView_NetworkSpec: QuickSpec {
    override func spec() {
        var imageView: UIImageView!
        
        beforeEach {
            imageView = UIImageView()
        }
        
        describe("when image did set") {
            var image: Image!
            
            it("should have correct placeholder") {
                imageView.set(image: nil)
                
                expect(imageView.image) == #imageLiteral(resourceName: "placeholder")
            }
 
            context("if image exist and content mode did set") {
                beforeEach {
                    image = Image()
                    image.src = "https://via.placeholder.com/1000x1000"
                    
                    imageView.set(image: image, initialContentMode: .left)
                }
                
                it("should have correct content mode") {
                    expect(imageView.contentMode.rawValue) == UIViewContentMode.left.rawValue
                }
                
                it("should load image and change content mode") {
                    waitUntil(timeout: 2) { done in
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            done()
                        })
                    }
                    
                    expect(imageView.image) != #imageLiteral(resourceName: "placeholder")
                    expect(imageView.image).toNot(beNil())
                    expect(imageView.contentMode.rawValue) == UIViewContentMode.scaleAspectFit.rawValue
                }
            }
            
            context("and if image nil and content mode didn't set") {
                beforeEach {
                    imageView.set(image: nil)
                }
                
                it("should have correct content mode") {
                    expect(imageView.contentMode.rawValue) == UIViewContentMode.center.rawValue
                }
                
                it("should load image and change content mode") {
                    waitUntil(timeout: 2) { done in
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            done()
                        })
                    }
                    
                    expect(imageView.image) == #imageLiteral(resourceName: "placeholder")
                    expect(imageView.contentMode.rawValue) == UIViewContentMode.center.rawValue
                }
            }
            
            context("if error did occured") {
                it("should keep placeholder image") {
                    let image = Image()
                    image.src = "wrong source"
                    imageView.set(image: image)
                    
                    waitUntil(timeout: 2) { done in
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            done()
                        })
                    }
                    
                    expect(imageView.image) == #imageLiteral(resourceName: "placeholder")
                    expect(imageView.contentMode.rawValue) == UIViewContentMode.center.rawValue
                }
            }
        }
    }
}
