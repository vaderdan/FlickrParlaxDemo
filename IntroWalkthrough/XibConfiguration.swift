//
//  XibConfiguration.swift
//  IntroWalkthrough
//
//  Created by Danny on 9/22/15.
//  Copyright © 2015 Danny. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    var borderUIColor: UIColor {
        get {
            return UIColor.init(CGColor: self.borderColor!)
        }
        set(color) {
            self.borderColor = color.CGColor
        }
    }
}