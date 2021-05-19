//
//  UISwitchUICustom.swift
//  Daleoak
//
//  Created by apple on 25/09/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

@IBDesignable class UISwitchUICustom: UISwitch {

    @IBInspectable var scale : CGFloat = 1{
        didSet{
            setup()
        }
    }
    
    //from storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    //from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup(){
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
        super.prepareForInterfaceBuilder()
    }

}
