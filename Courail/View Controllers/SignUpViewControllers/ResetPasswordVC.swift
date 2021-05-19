//
//  ResetPasswordVC.swift
//  Courail
//
//  Created by Omeesh Sharma on 13/05/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import MBProgressHUD
import LGSideMenuController

class ResetPasswordVC: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var newPassTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    @IBOutlet weak var newPassEyeBtn: UIButton!
    @IBOutlet weak var confirmPassEyeBtn: UIButton!
    //MARK:- VARIABLES
    
    var isSecuredNew = true{
        didSet{
            if self.isSecuredNew{
                self.newPassTF.isSecureTextEntry = true
                self.newPassEyeBtn.setImage(UIImage(named: "eyen"), for: .normal)
            } else{
                self.newPassTF.isSecureTextEntry = false
                self.newPassEyeBtn.setImage(UIImage(named: "view1"), for: .normal)
            }
        }
    }
    
    var isSecuredConfirm = true{
        didSet{
            if self.isSecuredConfirm{
                self.confirmPassTF.isSecureTextEntry = true
                self.confirmPassEyeBtn.setImage(UIImage(named: "eyen"), for: .normal)
            } else{
                self.confirmPassTF.isSecureTextEntry = false
                self.confirmPassEyeBtn.setImage(UIImage(named: "view1"), for: .normal)
            }
        }
    }
    
    var userID = ""
    var showTabBar = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorLbl.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func backAction(_ sender: UIButton) {
        rootVC?.tabBarController?.tabBar.isHidden = !self.showTabBar
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newPassEyeAction(_ sender: UIButton) {
        self.isSecuredNew = !self.isSecuredNew
    }
    
    @IBAction func confirmPassEyeAction(_ sender: UIButton) {
        self.isSecuredConfirm = !self.isSecuredConfirm
    }
    
    @IBAction func signInBtn(_ sender: UIButton) {
        if self.newPassTF.text?.trimmingCharacters(in: .whitespaces).isEmpty == true{
            self.errorLbl.isHidden = true
            showSwiftyAlert("", "Please enter New password", false)
        }else if self.confirmPassTF.text?.trimmingCharacters(in: .whitespaces).isEmpty == true{
            self.errorLbl.isHidden = true
            showSwiftyAlert("", "Please re-enter New password", false)
        }else if (self.newPassTF.text?.count ?? 0) < 8{
            self.errorLbl.isHidden = true
            showSwiftyAlert("", "New Password should be atleast 8 characters long", false)
        }else if self.newPassTF.text != self.confirmPassTF.text{
            self.errorLbl.isHidden = false
            showSwiftyAlert("", "Password do not match", false)
        }else{
            self.errorLbl.isHidden = true
            self.resetPasswordApi()
        }
    }
    
    
}


extension ResetPasswordVC {
    
    //MARK:- API
    
    func resetPasswordApi(){
        let params: Parameters = [
            "userid": self.userID,
            "password" : self.newPassTF.text!
        ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ApiInterface.requestApi(params: params, api_url: API.reset_userpassword , success: { (json) in
            logout()
            showSwiftyAlert("", json["msg"].stringValue, true)
        }) { (error, json) in
            MBProgressHUD.hide(for: self.view, animated: true)
            showSwiftyAlert("", error, false)
        }
    }

    

}
