//
//  DeleteView.swift
//  Omni Serve
//
//  Created by apple on 21/01/20.
//  Copyright © 2020 Vivek thakur. All rights reserved.
//

import UIKit

class DeleteView: UIView {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var message: UILabel!
    
    //MARK: VARIABLES
    
    var completion : ((Bool)-> ())?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, msg: String, completion: @escaping ((Bool)-> ())) {
        super.init(frame: frame)
        self.completion = completion
        self.setup(msg : msg)
    }
    
    
    func setup(msg: String){
        self.bgView = Bundle.main.loadNibNamed("DeleteView", owner: self, options: nil)?.first as? UIView
        self.bgView.frame = self.bounds
        self.addSubview(self.bgView)
        self.message.text = msg
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.innerView.addShadowsRadius()
    }
    
    
    //MARK: BUTTONS ACTIONS
    
    @IBAction func yesBtn(_ sender: UIButton) {
        guard let completion = self.completion else{
            self.removeFromSuperview()
            return
        }
        completion(true)
        self.removeFromSuperview()
    }
    
    @IBAction func noBtn(_ sender: UIButton){
        guard let completion = self.completion else{
            self.removeFromSuperview()
            return
        }
        completion(false)
        self.removeFromSuperview()
    }
    
}
