//
//  UIColorCustom.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 12/14/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    class var backgroundDefault: UIColor {
        return UIColor.init(red: 245, green: 245, blue: 245)
    }
    
    class var underlineDefault: UIColor {
        return UIColor.init(red: 230, green: 230, blue: 230)
    }
}
