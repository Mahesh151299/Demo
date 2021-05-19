//
//  ChangePasswordView.swift
//  Courail
//
//  Created by Omeesh Sharma on 26/06/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SVPinView

class ChangePasswordView: UIView {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var instuctionLbl: UILabel!
    
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var pinView: SVPinView!
    
    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var oldPasswordEye: UIButton!
    @IBOutlet weak var newPasswordEye: UIButton!
    @IBOutlet weak var confirmPasswordEye: UIButton!
    
    
    @IBOutlet weak var resendLbl: UILabel!
    @IBOutlet weak var resendBtnOut: UIButtonCustomClass!
    @IBOutlet weak var resendView: UIView!
    
    //MARK: VARIABLES
    
    var completion : ((Bool)-> ())?
    var OTP = ""
    
    var isSecuredOld = true{
        didSet{
            if self.isSecuredOld{
                self.oldPasswordTF.isSecureTextEntry = true
                self.oldPasswordEye.setImage(UIImage(named: "eyen"), for: .normal)
            } else{
                self.oldPasswordTF.isSecureTextEntry = false
                self.oldPasswordEye.setImage(UIImage(named: "view1"), for: .normal)
            }
        }
    }
    
    var isSecuredNew = true{
        didSet{
            if self.isSecuredNew{
                self.newPasswordTF.isSecureTextEntry = true
                self.newPasswordEye.setImage(UIImage(named: "eyen"), for: .normal)
            } else{
                self.newPasswordTF.isSecureTextEntry = false
                self.newPasswordEye.setImage(UIImage(named: "view1"), for: .normal)
            }
        }
    }
    
    
    var isSecuredConfirm = true{
         didSet{
             if self.isSecuredConfirm{
                 self.confirmPasswordTF.isSecureTextEntry = true
                 self.confirmPasswordEye.setImage(UIImage(named: "eyen"), for: .normal)
             } else{
                 self.confirmPasswordTF.isSecureTextEntry = false
                 self.confirmPasswordEye.setImage(UIImage(named: "view1"), for: .normal)
             }
         }
     }
     

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, completion: @escaping ((Bool)-> ())) {
        super.init(frame: frame)
        self.completion = completion
        self.setup()
    }
    
    
    func setup(){
        self.bgView = Bundle.main.loadNibNamed("ChangePasswordView", owner: self, options: nil)?.first as? UIView
        self.bgView.frame = self.bounds
        self.addSubview(self.bgView)
        self.pinView.font = .boldSystemFont(ofSize: 20)
        
        self.message.text = "A 4-digit code was sent to you at \(userInfo.phone ?? ""). Enter it below."
        
        self.message.isHidden = true
        self.pinView.isHidden = true
        self.resendView.isHidden = true
        
    }
    
    //MARK: BUTTONS ACTIONS
    @IBAction func crossBtn(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func oldEye(_ sender: UIButton) {
        self.isSecuredOld = !self.isSecuredOld
    }
    
    @IBAction func newEye(_ sender: UIButton) {
        self.isSecuredNew = !self.isSecuredNew
    }
    
    @IBAction func confirmEye(_ sender: UIButton) {
        self.isSecuredConfirm = !self.isSecuredConfirm
    }
    
    @IBAction func resendBtn(_ sender: UIButton) {
        self.checkPhoneApi()
    }
    
    @IBAction func updateBtn(_ sender: UIButton) {
        if self.message.isHidden{
            if self.oldPasswordTF.text?.trimmingCharacters(in: .whitespaces).isEmpty == true{
                showSwiftyAlert("", "Please enter Old password", false)
            }else if self.newPasswordTF.text?.trimmingCharacters(in: .whitespaces).isEmpty == true{
                showSwiftyAlert("", "Please enter New password", false)
            }else if (self.newPasswordTF.text?.count ?? 0) < 8{
                showSwiftyAlert("", "New Password should be atleast 8 characters long", false)
            }else if (self.newPasswordTF.text) != (self.confirmPasswordTF.text){
                showSwiftyAlert("", "Confirm Password does not match", false)
            } else{
                self.instuctionLbl.isHidden = true
                self.oldPasswordTF.isUserInteractionEnabled = false
                self.newPasswordTF.isUserInteractionEnabled = false
                self.confirmPasswordTF.isUserInteractionEnabled = false
                
                self.message.isHidden = false
                self.pinView.isHidden = false
                self.resendView.isHidden = false
                self.checkPhoneApi()
            }
        } else{
            guard self.pinView.getPin().isEmpty == false else{
                showSwiftyAlert("", "Please enter CODE", false)
                return
            }
            
            guard self.pinView.getPin() == self.OTP else{
                showSwiftyAlert("", "Invalid CODE", false)
                return
            }
            
            self.changePasswordApi()
        }
      
    }
   
}

extension ChangePasswordView {
    
    //MARK: API
    func checkPhoneApi(){
        let params: Parameters = [
            "phone": userInfo.phone ?? "",
            "country_code" : userInfo.countryCode ?? ""
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.mobile_send_otp , success: { (json) in
            hideLoader()
            self.OTP = json["data"]["otp"].stringValue
            showSwiftyAlert("", json["msg"].stringValue, true)
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    func changePasswordApi(){
        let params: Parameters = [
            "old_password": self.oldPasswordTF.text!,
            "new_password": self.newPasswordTF.text!
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.change_password, method: .put , success: { (json) in
            hideLoader()
            guard let completion = self.completion else{
                self.removeFromSuperview()
                return
            }
            completion(true)
            self.removeFromSuperview()
            showSwiftyAlert("", json["msg"].stringValue, true)
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
}
