//
//  ActiveOrderView.swift
//  Courail
//
//  Created by Omeesh Sharma on 10/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ActiveOrderView: UIView {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var yesBtnOut: UIButton!
    @IBOutlet weak var cancelBtnOut: UIButton!
    
    //MARK: VARIABLES
    
    var completion : ((Bool)-> ())?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, type: Int, completion: @escaping ((Bool)-> ())) {
        super.init(frame: frame)
        self.completion = completion
        self.setup(type : type)
    }
    
    
    func setup(type: Int){
        self.bgView = Bundle.main.loadNibNamed("ActiveOrderView", owner: self, options: nil)?.first as? UIView
        self.bgView.frame = self.bounds
        self.addSubview(self.bgView)
        
        
        var msgText = ""
        
        if type == 0{
            self.yesBtnOut.isHidden = false
            self.cancelBtnOut.isHidden = true
            
            self.title.text = "Start Another Order?"
            msgText = "There is currently another delivery request pending. Do you want to cancel your pending order and start a new order with this one?"
        }else{
            self.yesBtnOut.isHidden = true
            self.cancelBtnOut.isHidden = false
            
            self.title.text = "Active Order."
            msgText = "You currently have an order in progress. At this time we are unable to start a new order until the current order has been cancelled or completed. Shall we cancel this order?"
        }
        
        let attributedString = NSMutableAttributedString(string: msgText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.message.attributedText = attributedString
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.innerView.addShadowsRadius()
    }
    
    
    //MARK: BUTTONS ACTIONS
    
    @IBAction func closeBtn(_ sender: UIButton){
        self.removeFromSuperview()
    }
    
    @IBAction func noBtn(_ sender: UIButton){
        self.removeFromSuperview()
    }
    
    
    @IBAction func cancelBtn(_ sender: UIButton){
        guard let completion = self.completion else{
            self.removeFromSuperview()
            return
        }
        completion(true)
        self.removeFromSuperview()
    }
    
    @IBAction func yesBtn(_ sender: UIButton) {
        guard let completion = self.completion else{
            self.removeFromSuperview()
            return
        }
        completion(true)
        self.removeFromSuperview()
    }
    

}
