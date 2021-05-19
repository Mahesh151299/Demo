//
//  CaptureView.swift
//  Courail
//
//  Created by Omeesh Sharma on 09/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class CaptureView: UIView {
    
    //MARK:- OUTLETS
    
    @IBOutlet var bgView: UIView!
    
    
    //MARK:- ACTIVITY CYCLE
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup(){
        self.bgView = Bundle.main.loadNibNamed("CaptureView", owner: self, options: nil)?.first as? UIView
        self.bgView.frame = self.bounds
        self.addSubview(bgView)
    }
        
}
