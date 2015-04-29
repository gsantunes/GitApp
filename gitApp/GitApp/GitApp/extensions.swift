//
//  extensions.swift
//  GitApp
//
//  Created by Fernando on 4/28/15.
//  Copyright (c) 2015 Fernando. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable
    var borderColor: UIColor {
        get {
            return UIColor(CGColor: layer.borderColor)!
        }
        set {
            layer.borderColor = newValue.CGColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var BorderRadius: CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
        }
    }
}


@IBDesignable
class FHButton : UIButton {

}