//
//  UIStoryboard+Additions.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class var account: UIStoryboard {
        return UIStoryboard(name: "Account", bundle: nil)
    }
    
    class func cart() -> UIStoryboard {
        return UIStoryboard(name: "Cart", bundle: nil)
    }
    
    class func main() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}
