//
//  SignInVC.swift
//  Courail
//
//  Created by apple on 24/01/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SignInVC: UIViewController,UITextFieldDelegate {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var txtfieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var eyeBtn: UIButton!
    
    //MARK:- VARIABLES
    
    var isSecured = true{
        didSet{
            if self.isSecured{
                self.txtFieldPassword.isSecureTextEntry = true
                self.eyeBtn.setImage(UIImage(named: "eyen"), for: .normal)
            } else{
                self.txtFieldPassword.isSecureTextEntry = false
                self.eyeBtn.setImage(UIImage(named: "view1"), for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UpdateAvailable.isUpdateAvailable()
    }
    
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func nextTap(_ sender: Any) {
        self.view.endEditing(true)
        if txtfieldEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty == true{
            showSwiftyAlert("", "Please enter email", false)
        }else if self.txtfieldEmail.text?.isValidateEmail() == false{
            showSwiftyAlert("", "Invalid email address", false)
        } else if txtFieldPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty == true{
            showSwiftyAlert("", "Please enter password", false)
        } else{
            self.signInApi()
        }
    }
    @IBAction func signUpBtn(_ sender: UIButton) {
        if let vc = self.navigationController?.viewControllers.last(where: {($0 as? SignUpAVC) != nil}){
            self.pop()
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpAVC")as! SignUpAVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func backTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func secureTextBtn(_ sender: UIButton) {
        self.isSecured = !self.isSecured
    }
    
    @IBAction func forgotPasswordBtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC")as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
      
}

extension SignInVC {
    
    //MARK:- API
    
    func signInApi(){
        let params: Parameters = [
            "email": self.txtfieldEmail.text!,
            "password" : self.txtFieldPassword.text!,
            "device_type":iOSplatform,
            "device_token": notificationToken,
            "phoneversion": UIDevice().type.rawValue,
            "appversion": Bundle.main.releaseVersionNumber ?? "0.0",
            "apprelease": "\(buildDate.timeIntervalSince1970)",
            "os":UIDevice.current.systemVersion
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.login , success: { (json) in
            hideLoader()
            userInfo = UserInfoModel.init(json: json["data"])
         
            ApiInterface.getCatCount()
            
            LocationInterface.shared.setupCoreLocation()
            
            if orderInProgress{
                if let vc = self.navigationController?.viewControllers.last(where: {$0 as? TabBarVC != nil}){
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            } else{
                if let addModel = userInfo.selectedAddress{
                    if addModel.deliveryPickup == 3{
                        DeliveryAddressInterface.shared.courialHub.internalIdentifier = addModel.internalIdentifier
                    }
                    DeliveryAddressInterface.shared.selectedAddress = addModel
                    GoToHome()
                } else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetAddressVC") as! SetAddressVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
}
