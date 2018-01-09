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
    
    class func productOptions() -> UIStoryboard {
        return UIStoryboard(name: "ProductOptions", bundle: nil)
    }
    
    class func cart() -> UIStoryboard {
        return UIStoryboard(name: "Cart", bundle: nil)
    }
    
    class func checkout() -> UIStoryboard {
        return UIStoryboard(name: "Checkout", bundle: nil)
    }
    
    class func creditCard() -> UIStoryboard {
        return UIStoryboard(name: "CreditCard", bundle: nil)
    }
}
