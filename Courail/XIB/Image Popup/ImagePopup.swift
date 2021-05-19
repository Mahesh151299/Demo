//
//  DeleteView.swift
//  Omni Serve
//
//  Created by apple on 21/01/20.
//  Copyright © 2020 Vivek thakur. All rights reserved.
//

import UIKit

class ImagePopup: UIView {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var innerView: UIView!
    
    
    //MARK: VARIABLES
    
    var completion : ((String)-> ())?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, completion: @escaping ((String)-> ())) {
        super.init(frame: frame)
        self.completion = completion
        self.setup()
    }
    
    
    func setup(){
        self.bgView = Bundle.main.loadNibNamed("ImagePopup", owner: self, options: nil)?.first as? UIView
        self.bgView.frame = self.bounds
        self.addSubview(self.bgView)
    }
    
    
    
    //MARK: BUTTONS ACTIONS
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        guard let completion = self.completion else{
            self.removeFromSuperview()
            return
        }
        completion("1")
        self.removeFromSuperview()
    }
    
    @IBAction func viewBtn(_ sender: UIButton) {
        guard let completion = self.completion else{
            self.removeFromSuperview()
            return
        }
        completion("2")
        self.removeFromSuperview()
    }
    
    @IBAction func closeBtn(_ sender: UIButton){
        self.removeFromSuperview()
    }
}
