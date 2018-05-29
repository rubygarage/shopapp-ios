//
//  String+HtmlSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 5/17/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick

@testable import ShopApp

class String_HtmlSpec: QuickSpec {
    override func spec() {
        describe("when extension used") {
            it("needs to convert html string to string without tags") {
                let htmlString = "<p>Perfect for class, work or the gym, the Wayfarer Messenger Bag is packed with pockets. The dual-buckle flap closure reveals an organizational panel, and the roomy main compartment has spaces for your laptop and a change of clothes. An adjustable shoulder strap and easy-grip handle promise easy carrying.</p>\n<ul>\n<li>Multiple internal zip pockets.</li>\n<li>Made of durable nylon.</li>\n</ul>"
                let string = htmlString.htmlToString
                
                expect(string) == "Perfect for class, work or the gym, the Wayfarer Messenger Bag is packed with pockets. The dual-buckle flap closure reveals an organizational panel, and the roomy main compartment has spaces for your laptop and a change of clothes. An adjustable shoulder strap and easy-grip handle promise easy carrying.\n\t•\tMultiple internal zip pockets.\n\t•\tMade of durable nylon.\n"
            }
        }
    }
}
