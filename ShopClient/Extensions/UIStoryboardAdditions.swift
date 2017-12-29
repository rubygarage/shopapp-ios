//
//  StoryboardAdditions.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/5/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    class func search() -> UIStoryboard {
        return UIStoryboard(name: "Search", bundle: nil)
    }
    
    class func category() -> UIStoryboard {
        return UIStoryboard(name: "Category", bundle: nil)
    }
    
    class func imagesCarousel() -> UIStoryboard {
        return UIStoryboard(name: "ImagesCarousel", bundle: nil)
    }
    
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
    
    class func addressForm() -> UIStoryboard {
        return UIStoryboard(name: "AddressForm", bundle: nil)
    }
    
    class func billingAddress() -> UIStoryboard {
        return UIStoryboard(name: "BillingAddress", bundle: nil)
    }
    
    class func addressList() -> UIStoryboard {
        return UIStoryboard(name: "AddressList", bundle: nil)
    }
}
