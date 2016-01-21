//
//  UIColor+Hex.swift
//  RocketBuy
//
//  Created by Rajan Khattri on 2/3/15.
//  Copyright (c) 2015 Braindigit. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    class func loaderBackgroundColor() ->UIColor {
        return UIColor(netHex: 0xb8222e)
    }
    
    class func viewBackgroundColor() ->UIColor {
        return UIColor(red: 236.0/255, green: 236.0/255, blue: 236.0/255, alpha: 1.0)
    }
    
    class func instagramButtonColor() ->UIColor {
        return UIColor(red: 65.0/255, green: 106.0/255, blue: 147.0/255, alpha: 1.0)
    }
    
    class func twitterButtonColor() ->UIColor {
        return UIColor(red: 34.0/255, green: 154.0/255, blue: 232.0/255, alpha: 1.0)
    }
    
    class func facebookButtonColor() ->UIColor {
        return UIColor(red: 46.0/255, green: 68.0/255, blue: 132.0/255, alpha: 1.0)
    }
    
    class func feedButtonColor() ->UIColor {
        return UIColor.grayColor()
    }
    
    class func feedLikedColor() ->UIColor {
        return UIColor(red: 222.0/255, green: 0.0/255, blue: 25.0/255, alpha: 1.0)
    }
    
    class func imageBackGroundColor() ->UIColor {
        return UIColor.whiteColor()
    }
    
    class func profileViewBackgroundColor() ->UIColor {
        return UIColor(red: 236.0/255, green: 236.0/255, blue: 236.0/255, alpha: 1.0)
    }
    
    class func cellBackgroundColor() ->UIColor {
        return UIColor(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0)
    }
    
    class func borderColor() ->UIColor {
        return UIColor.lightGrayColor()
    }
    
    class func tabBarTintColor() ->UIColor {
        return UIColor(red: 136.0/255, green: 194.0/255, blue: 47.0/255, alpha: 1.0)
    }
    
    class func tabBarSelectedColor() ->UIColor {
        return UIColor(red: 136.0/255, green: 194.0/255, blue: 47.0/255, alpha: 1.0)
    }
    
    class func primaryTextColor() ->UIColor {
        return UIColor.whiteColor()
    }
    
    class func usernameTextColor() ->UIColor {
        return UIColor.darkTextColor()
    }
    
    class func secondaryTextColor() ->UIColor {
        return UIColor.darkTextColor()
    }
    
    class func buttonBackgroundColor() ->UIColor {
        return UIColor(red: 26.0/255, green: 23.0/255, blue: 24.0/255, alpha: 1.0)
    }
    
    class func cameraButtonColor() ->UIColor {
        return UIColor.whiteColor()
    }
    
    class func buttonSelectedColor() ->UIColor {
        return UIColor.grayColor()
    }
    
    class func fedButtonBackgroundColor()-> UIColor {
        return UIColor(red: 136.0/255, green: 194.0/255, blue: 47.0/255, alpha: 1.0)
    }
    
}