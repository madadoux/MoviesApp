//
//  UIView+rounding.swift
//  swvl
//
//  Created by mohamed saeed on 5/25/19.
//  Copyright © 2019 mohamed saeed. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    
    func makeRoundedWith ( _ r: CGFloat) {
        self.layer.cornerRadius = r
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
}
