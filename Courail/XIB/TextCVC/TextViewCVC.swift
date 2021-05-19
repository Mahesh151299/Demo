//
//  TextViewCVC.swift
//  Courail
//
//  Created by Omeesh Sharma on 29/10/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class TextViewCVC: UICollectionReusableView {
    
    @IBOutlet weak var textView: UITextView!
    
    override init(frame: CGRect) {
       super.init(frame: frame)
       // Customize here

    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)

    }
        
}
