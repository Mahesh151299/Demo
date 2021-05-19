//
//  ForgotPasswordVC.swift
//  Courail
//
//  Created by Omeesh Sharma on 05/05/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController , UITextFieldDelegate {
    
    //MARK:- OUTLETS
    @IBOutlet weak var EmailView: UIView!
    @IBOutlet weak var txtFieldEmail: UITextField!
    
    
    //MARK:- VARIABLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtFieldEmail.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.txtFieldEmail.becomeFirstResponder()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func backBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SubmitBtn(_ sender: Any) {
        if self.txtFieldEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty == true{
            showSwiftyAlert("", "Please enter email", false)
        }else if self.txtFieldEmail.text?.isValidateEmail() == false{
            showSwiftyAlert("", "Invalid email address", false)
        } else{
            self.forgotPasswordApi()
        }
    }
    
    @IBAction func BtnClearTextField(_ sender: UIButton) {
        self.txtFieldEmail.text = nil
    }
    
}


extension ForgotPasswordVC {
    
    //MARK:- API
    
    func forgotPasswordApi(){
        let params : Parameters = [
            "email": self.txtFieldEmail.text!,
            "secondsFromGMT": "\(TimeZone.current.secondsFromGMT())",
            "timezoneID": TimeZone.current.identifier,
            "timezoneDate": "\(Date().timeIntervalSince1970)"
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params , api_url: API.forgot_password, success: { (json) in
            hideLoader()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResendEmailVC")as! ResendEmailVC
            vc.email = self.txtFieldEmail.text!
            self.navigationController?.pushViewController(vc, animated: true)
            
            showSwiftyAlert("", json["msg"].stringValue, true)
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    
}


