//
//  InstructionsView.swift
//  Courail
//
//  Created by Omeesh Sharma on 06/04/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class InstructionsView: UIView {

    //MARK: OUTLETS
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var instructionsTF: UITextField!
    
    //MARK: VARIABLES
    
    var previousLink = ""
    
    var completion : ((String)->Void)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, link: String, completion: @escaping ((String)-> ())) {
        super.init(frame: frame)
        self.completion = completion
        self.setup(link: link)
    }
    
    
    func setup(link: String){
        self.bgView = Bundle.main.loadNibNamed("InstructionsView", owner: self, options: nil)?.first as? UIView
        self.bgView.frame = self.bounds
        self.addSubview(self.bgView)
        self.previousLink = link
        self.instructionsTF.text = link
    }
    
    //MARK: BUTTONS ACTIONS
    
    @IBAction func applyBtn(_ sender: UIButton) {
        guard self.instructionsTF.text?.isEmpty == false else{
            showSwiftyAlert("", "Please enter a special instructions link", false)
            return
        }
        
        guard self.instructionsTF.text != self.previousLink else{
            self.removeFromSuperview()
            return
        }
        
        let specialURL = URL(string: self.instructionsTF.text ?? "")
        if specialURL != nil
                && UIApplication.shared.canOpenURL(specialURL!) == false{
            showSwiftyAlert("", "Please enter a valid special instructions link", false)
        }else{
            guard let completion = self.completion else{
                self.removeFromSuperview()
                return
            }
            completion(self.instructionsTF.text ?? "")
            self.removeFromSuperview()
        }
    }
    
    @IBAction func closeBtn(_ sender: UIButton){
        self.removeFromSuperview()
    }
    
     
}
