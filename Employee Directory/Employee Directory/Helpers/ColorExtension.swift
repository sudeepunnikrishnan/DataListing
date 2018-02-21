//
//  ColorExtension.swift
//  Employee Directory
//
//  Created by Sudeep.Unnikrishnan on 24/12/17.
//  Copyright © 2017 Sudeep Unnikrishnan. All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    class func color(red: CGFloat, green : CGFloat, blue: CGFloat ) -> UIColor
    {
        return UIColor(red: red / 255.0 , green: green / 255.0 , blue: blue / 255.0, alpha: 1.0)
    }
}
