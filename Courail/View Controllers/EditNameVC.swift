//
//  EditNameVC.swift
//  CourailtxtFieldPhone
//
//  Created by mac on 18/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SKCountryPicker

class EditNameVC: UIViewController, UITextFieldDelegate {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var headerTittle: UILabel!
    
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var FirstNameView: UIView!
    @IBOutlet weak var txtFieldFirstName: UITextField!
    
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var LastNameView: UIView!
    @IBOutlet weak var txtFieldLastName: UITextField!
    
    @IBOutlet weak var PhoneNumberView: UIView!
    @IBOutlet weak var txtFieldPhone: UITextField!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var EmailView: UIView!
    @IBOutlet weak var txtFieldEmail: UITextField!
    
    @IBOutlet weak var PasswordView: UIView!
    @IBOutlet weak var lblVerifyPassword: UILabel!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var lblNewPassword: UILabel!
    @IBOutlet weak var txtFieldNewPassword: UITextField!
    @IBOutlet weak var eyeBtnOld: UIButton!
    @IBOutlet weak var eyeBtnNew: UIButton!
    
    @IBOutlet weak var countryCode: UILabel!
    @IBOutlet weak var flag: UIImageView!
    
    @IBOutlet weak var verifiedView: UIView!
    @IBOutlet weak var emailVerifyView: UIView!
    
    //MARK:- VARIABLES
    
    var NameView = ""
    
    var isSecuredOld = true{
        didSet{
            if self.isSecuredOld{
                self.txtFieldPassword.isSecureTextEntry = true
                self.eyeBtnOld.setImage(UIImage(named: "eyen"), for: .normal)
            } else{
                self.txtFieldPassword.isSecureTextEntry = false
                self.eyeBtnOld.setImage(UIImage(named: "view1"), for: .normal)
            }
        }
    }
    
    var isSecuredNew = true{
        didSet{
            if self.isSecuredNew{
                self.txtFieldNewPassword.isSecureTextEntry = true
                self.eyeBtnNew.setImage(UIImage(named: "eyen"), for: .normal)
            } else{
                self.txtFieldNewPassword.isSecureTextEntry = false
                self.eyeBtnNew.setImage(UIImage(named: "view1"), for: .normal)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch NameView{
        case "1":
            self.LastNameView.isHidden = true
            self.PhoneNumberView.isHidden = true
            self.EmailView.isHidden = true
            self.PasswordView.isHidden = true
            self.verifiedView.isHidden = true
            self.txtFieldFirstName.text = userInfo.firstName ?? ""
            self.txtFieldFirstName.becomeFirstResponder()
        case "2":
            self.headerTittle.text = "Edit Last Name"
            self.FirstNameView.isHidden = true
            self.PhoneNumberView.isHidden = true
            self.EmailView.isHidden = true
            self.PasswordView.isHidden = true
            self.verifiedView.isHidden = true
            
            self.txtFieldLastName.text = userInfo.lastName ?? ""
            self.txtFieldLastName.becomeFirstResponder()
        case "3":
            self.headerTittle.text = "Edit Phone"
            self.FirstNameView.isHidden = true
            self.LastNameView.isHidden = true
            self.EmailView.isHidden = true
            self.PasswordView.isHidden = true
            
            self.txtFieldPhone.delegate = self
            let countryCode = (userInfo.countryCode ?? "")
            var country = CountryManager.shared.currentCountry
            if countryCode != "" && countryCode != CountryManager.shared.currentCountry?.dialingCode{
                country = CountryManager.shared.country(withDigitCode: countryCode)
            }
            
            self.flag.image = country?.flag
            self.countryCode.text = country?.dialingCode ?? "+1"
            self.txtFieldPhone.text = userInfo.phone ?? ""
            _ = self.textField(self.txtFieldPhone, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "")
            self.phoneChanged(self.txtFieldPhone)
            self.txtFieldPhone.becomeFirstResponder()
        case "4":
            self.headerTittle.text = "Edit Email"
            self.FirstNameView.isHidden = true
            self.LastNameView.isHidden = true
            self.PhoneNumberView.isHidden = true
            self.PasswordView.isHidden = true
            self.verifiedView.isHidden = true
            
            self.txtFieldEmail.text = userInfo.email ?? ""
            self.verifiedView.isHidden = (userInfo.emailVerify ?? 0) == 1 ? false : true
            self.txtFieldEmail.addTarget(self, action: #selector(self.emailChanged(_:)), for: .editingChanged)
            self.txtFieldEmail.becomeFirstResponder()
            
        default:
            self.headerTittle.text = "Edit Password"
            self.FirstNameView.isHidden = true
            self.LastNameView.isHidden = true
            self.PhoneNumberView.isHidden = true
            self.EmailView.isHidden = true
            self.verifiedView.isHidden = true
            self.txtFieldPassword.becomeFirstResponder()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        switch self.NameView{
        case "1":
            guard self.txtFieldFirstName.text?.isEmpty == false else{
                showSwiftyAlert("", "Please enter First name", false)
                return
            }
            if self.txtFieldFirstName.text == userInfo.firstName{
                self.pop()
            } else{
                self.editProfileApi()
            }
        case "2":
            guard self.txtFieldLastName.text?.isEmpty == false else{
                showSwiftyAlert("", "Please enter First name", false)
                return
            }
            
            if self.txtFieldLastName.text == userInfo.lastName{
                self.pop()
            } else{
                self.editProfileApi()
            }
        case "3":
            if self.txtFieldPhone.text == userInfo.phone && self.countryCode.text == userInfo.countryCode{
                self.pop()
            } else{
                guard (self.txtFieldPhone.text!.isValidateMobile()) else{
                    showSwiftyAlert("", "Invalid mobile number", false)
                    return
                }
                self.checkPhoneApi()
            }
        case "4":
            if self.txtFieldEmail.text == userInfo.email && userInfo.emailVerify == 1{
                self.pop()
            } else{
                if self.txtFieldEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty == true{
                    showSwiftyAlert("", "Please enter email", false)
                }else if self.txtFieldEmail.text?.isValidateEmail() == false{
                    showSwiftyAlert("", "Invalid email address", false)
                } else{
                    self.updateEmailApi()
                }
            }
        default:
            if self.txtFieldPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty == true{
                showSwiftyAlert("", "Please enter Old password", false)
            }else if self.txtFieldNewPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty == true{
                    showSwiftyAlert("", "Please enter New password", false)
            }else if (self.txtFieldNewPassword.text?.count ?? 0) < 8{
                showSwiftyAlert("", "New Password should be atleast 8 characters long", false)
            } else{
                self.changePasswordApi()
            }
        }
        
    }
    
    @IBAction func BtnClearTextField(_ sender: UIButton) {
        if sender.tag == 0 {
            self.txtFieldFirstName.text = nil
        } else if sender.tag == 1 {
            self.txtFieldLastName.text = nil
        } else {
            self.txtFieldEmail.text = nil
        }
    }
    
    @IBAction func countryCodeBtn(_ sender: UIButton) {
        DispatchQueue.main.async {
            UINavigationBar.appearance().isTranslucent = true
            
            let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
                UINavigationBar.appearance().isTranslucent = false
                guard let self = self else { return }
                self.countryCode.text = (country.dialingCode ?? "")
                self.flag.image = country.flag
                self.phoneChanged(self.txtFieldPhone)
            }
            // can customize the countryPicker here e.g font and color
            countryController.modalPresentationStyle = .fullScreen
        }
    }
    
    @IBAction func secureTextBtnOld(_ sender: UIButton) {
        self.isSecuredOld = !self.isSecuredOld
    }
    
    @IBAction func secureTextBtnNew(_ sender: UIButton) {
        self.isSecuredNew = !self.isSecuredNew
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFieldFirstName {
            self.hideshowtxtfield(textfield: self.lblFirstName, ishidden: false)
        }
        if textField == txtFieldLastName {
            self.hideshowtxtfield(textfield: self.lblLastName, ishidden: false)
            
        }
        if textField == txtFieldEmail {
            self.hideshowtxtfield(textfield: self.lblEmail, ishidden: false)
            
        }
        if textField == txtFieldPassword {
            self.hideshowtxtfield(textfield: self.lblVerifyPassword, ishidden: false)
            if self.txtFieldNewPassword.text == "" {
                self.hideshowtxtfield(textfield: self.lblNewPassword, ishidden: true)
            }
        }
        
        if textField == txtFieldNewPassword {
            self.hideshowtxtfield(textfield: self.lblNewPassword, ishidden: false)
            if self.txtFieldPassword.text == "" {
                self.hideshowtxtfield(textfield: self.lblVerifyPassword, ishidden: true)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtFieldFirstName {
            if self.txtFieldFirstName.text == "" {
                self.hideshowtxtfield(textfield: self.lblFirstName, ishidden: true)
            }
        }
        if textField == txtFieldLastName {
            if self.txtFieldLastName.text == "" {
                self.hideshowtxtfield(textfield: self.lblLastName, ishidden: true)
            }
            
        }
        if textField == txtFieldEmail {
            if self.txtFieldEmail.text == "" {
                self.hideshowtxtfield(textfield: self.lblEmail, ishidden: true)
            }
            
        }
        if textField == txtFieldPassword {
            if self.txtFieldPassword.text == "" {
                self.hideshowtxtfield(textfield: self.lblVerifyPassword, ishidden: true)
            }
            
        }
        if textField == txtFieldNewPassword {
            if self.txtFieldNewPassword.text == "" {
                self.hideshowtxtfield(textfield: self.lblNewPassword, ishidden: true)
            }
        }
    }
    
    func hideshowtxtfield(textfield:UIView,ishidden: Bool) {
        textfield.isHidden = ishidden
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func phoneChanged(_ sender: UITextField){
        if self.txtFieldPhone.text == userInfo.phone && self.countryCode.text == userInfo.countryCode{
            self.verifiedView.isHidden = false
        } else{
            self.verifiedView.isHidden = true
        }
    }
    
    
    @objc func emailChanged(_ sender: UITextField){
        if self.txtFieldEmail.text == userInfo.email && userInfo.emailVerify == 1{
            self.verifiedView.isHidden = false
        } else{
            self.verifiedView.isHidden = true
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == self.txtFieldPhone else {return true}
        
        guard let text = textField.text else { return false }
        
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = newString.formattedNumber()
        self.phoneChanged(textField)
        return false
    }
    
}


extension EditNameVC {
    
    //MARK:- API
    
    func editProfileApi(){
        var params : Parameters = [
            "first_name": self.txtFieldFirstName.text!
        ]
        
        switch NameView{
        case "1":
            params = [ "first_name": self.txtFieldFirstName.text! ]
        case "2":
            params = [ "last_name": self.txtFieldLastName.text! ]
        default:
            break;
        }
        
        showLoader()
        ApiInterface.requestApi(params: params , api_url: API.edit_profile, method: .put , success: { (json) in
            hideLoader()
            if self.NameView == "1"{
                userInfo.firstName = self.txtFieldFirstName.text!
            } else{
                userInfo.lastName = self.txtFieldLastName.text!
            }
            saveUserInfo()
            
            self.pop()
            showSwiftyAlert("", json["msg"].stringValue, true)
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    func checkPhoneApi(){
        let params: Parameters = [
            "phone": self.txtFieldPhone.text!,
            "country_code" : self.countryCode.text!
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.check_phone , success: { (json) in
            hideLoader()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
            vc.OTP = json["data"]["otp"].stringValue
            vc.countryCode = self.countryCode.text!
            vc.phone = self.txtFieldPhone.text!
            
            self.navigationController?.pushViewController(vc, animated: true)
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    func updateEmailApi(){
        let params: Parameters = [
            "email": self.txtFieldEmail.text!
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.update_email, method: .put , success: { (json) in
            hideLoader()
            self.emailVerifyView.isHidden = false
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    func changePasswordApi(){
           let params: Parameters = [
               "old_password": self.txtFieldPassword.text!,
               "new_password": self.txtFieldNewPassword.text!
           ]
           
           showLoader()
           ApiInterface.requestApi(params: params, api_url: API.change_password, method: .put , success: { (json) in
               hideLoader()
                self.pop()
            
                showSwiftyAlert("", json["msg"].stringValue, true)
           }) { (error, json) in
               hideLoader()
               showSwiftyAlert("", error, false)
           }
       }
    
    
}


