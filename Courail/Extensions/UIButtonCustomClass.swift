//
//  UIButtonCustomClass.swift
//  LevelUp
//
//  Created by Rishabh Arora on 2/13/18.
//  Copyright © 2018 Rishabh Arora. All rights reserved.
//

import UIKit

class UIButtonCustomClass:UIButton{
    
    override func awakeFromNib() {
    }
    
    @IBInspectable var borderWidth:CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor:UIColor {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }
    
    @IBInspectable var cornerRadius:CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
}
