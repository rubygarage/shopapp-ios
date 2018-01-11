//
//  StoryboardAdditions.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class func sortModal() -> UIStoryboard {
        return UIStoryboard(name: "SortModal", bundle: nil)
    }
    
    class func cart() -> UIStoryboard {
        return UIStoryboard(name: "Cart", bundle: nil)
    }
    
    class func checkout() -> UIStoryboard {
        return UIStoryboard(name: "Checkout", bundle: nil)
    }
}
