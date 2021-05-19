//
//  CallPopupVC.swift
//  Courail
//
//  Created by Omeesh Sharma on 03/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class CallPopupVC: UIViewController {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var callBtnOut: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    //MARK: VARIABLES
    
    var completion: ((String, String)->())?
    
    var phoneNo = ""
    var storeName = "Store"
    var hideDetails = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneTF.delegate = self
        self.phoneTF.text = phoneNo
        
        if self.hideDetails{
            self.stackView.isHidden = true
            self.stackHeight.constant = 0
        }
        
        self.callBtnOut.setTitle("CALL " + storeName, for: .normal)
        
        _ = self.textField(self.phoneTF, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "")
        // Do any additional setup after loading the view.
    }
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func crossBtn(_ sender: UIButton) {
        guard let result = self.completion else {
            self.removeView()
            return
        }
        result("","")
        self.removeView()
    }
    
    @IBAction func withTrasnBtn(_ sender: UIButton) {
        
        guard (self.phoneTF.text!.isValidateMobile()) else{
            showSwiftyAlert("", "Invalid mobile number", false)
            return
        }
        guard let result = self.completion else {
            self.removeView()
            return
        }
        let no = self.phoneTF.text!.replacingOccurrences(of: "[- ()]", with: "", options: .regularExpression, range: nil)
        //With Twilio
//        result(no,"1")
        
        //Without Twilio
        result(no,"2")
        
        
        self.removeView()
    }
    
    @IBAction func withoutTransBtn(_ sender: UIButton) {
        guard (self.phoneTF.text!.isValidateMobile()) else{
            showSwiftyAlert("", "Invalid mobile number", false)
            return
        }

        guard let result = self.completion else {
            self.removeView()
            return
        }
        let no = self.phoneTF.text!.replacingOccurrences(of: "[- ()]", with: "", options: .regularExpression, range: nil)
        result(no,"2")
        self.removeView()
        
//        guard (self.phoneTF.text!.isValidateMobile()) else{
//            showSwiftyAlert("", "Invalid mobile number", false)
//            return
//        }
//        guard let result = self.completion else {
//            self.removeView()
//            return
//        }
//        let no = self.phoneTF.text!.replacingOccurrences(of: "[- ()]", with: "", options: .regularExpression, range: nil)
//        result(no,"1")
//        self.removeView()
    }
    
    func removeView(){
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
}

extension CallPopupVC : UITextFieldDelegate{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = newString.formattedNumber()
        
        return false
    }
    
    
}
