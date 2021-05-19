//
//  HelpView.swift
//  Courail
//
//  Created by Omeesh Sharma on 13/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class HelpView: UIView {
    
    //MARK: OUTLETS
    
    @IBOutlet var bgView: UIView!
    
    @IBOutlet weak var bottom: NSLayoutConstraint!
    //MARK: VARIABLES
    
    var completion : ((Int)-> ())?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect,bottomCons: CGFloat?, completion: @escaping ((Int)-> ())) {
        super.init(frame: frame)
        self.completion = completion
        self.setup(bottomCons: bottomCons)
    }
    
    
    func setup(bottomCons: CGFloat?){
        self.bgView = Bundle.main.loadNibNamed("HelpView", owner: self, options: nil)?.first as? UIView
        self.bgView.frame = self.bounds
        self.addSubview(self.bgView)
        
        self.bottom.constant = bottomCons ?? 230
    }
   
    
    
    //MARK: BUTTONS ACTIONS
    
    func dismissView(value: Int){
        guard let completion = self.completion else{
            self.removeFromSuperview()
            return
        }
        completion(value)
        self.removeFromSuperview()
    }
    
    @IBAction func rescheduleBtn(_ sender: UIButton) {
        self.dismissView(value: 1)
    }
    
    @IBAction func modifyBtn(_ sender: UIButton){
     self.dismissView(value: 2)
    }
    
    @IBAction func cancelBtn(_ sender: UIButton){
        self.dismissView(value: 3)
    }
    
    @IBAction func doNotCancelBtn(_ sender: UIButton){
        self.dismissView(value: 4)
    }
    
}
