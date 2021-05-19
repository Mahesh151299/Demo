//
//  UpdateNotesView.swift
//  Courail
//
//  Created by apple on 07/04/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class UpdateNotesView: UIView {

    //MARK: OUTLETS
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var textView: IQTextView!
    @IBOutlet weak var itemNameTF: UITextField!
    @IBOutlet weak var itemNameView: UIViewCustomClass!
    
    //MARK: VARIABLES
    
    var previousName = ""
    var previousNotes = ""
    var isSkill = false
    var completion : ((_ item:String,_ notes: String)->Void)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect,isSkill: Bool, notes: String, name: String , completion: @escaping ((_ item:String,_ notes: String)-> ())) {
        super.init(frame: frame)
        self.completion = completion
        self.setup(isSkill: isSkill, notes: notes, name: name)
    }
    
    
    func setup(isSkill: Bool, notes: String, name: String){
        self.bgView = Bundle.main.loadNibNamed("UpdateNotesView", owner: self, options: nil)?.first as? UIView
        self.bgView.frame = self.bounds
        self.addSubview(self.bgView)
        self.previousName = name
        self.previousNotes = notes
        
        self.isSkill = isSkill
        
        self.itemNameTF.text = name
        self.textView.text = notes
        
        if isSkill{
            self.itemNameView.isHidden = true
            self.textView.placeholder = "Update additional notes"
        }else{
            self.textView.placeholder = "Update pickup notes"
        }
    }
    
    //MARK: BUTTONS ACTIONS
    
    @IBAction func applyBtn(_ sender: UIButton) {
        if self.isSkill == false && self.itemNameTF.text?.isEmpty == true{
            showSwiftyAlert("", "Please enter what's being picked up?", false)
        }else{
            guard let completion = self.completion else{
                self.removeFromSuperview()
                return
            }
            completion(self.itemNameTF.text ?? "", self.textView.text ?? "")
            self.removeFromSuperview()
        }
    }
    
    @IBAction func closeBtn(_ sender: UIButton){
        self.removeFromSuperview()
    }
    
     
}
