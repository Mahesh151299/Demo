//
//  EditProfileVC.swift
//  Courail
//
//  Created by mac on 17/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var txtFieldLastName: UITextField!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var txtFieldPhoneNumber: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var lblPhoneVerified: UILabel!
    @IBOutlet weak var lblEmailVerified: UILabel!
    @IBOutlet weak var profileImg: UIImageViewCustomClass!
    @IBOutlet weak var headerTittle: UILabel!
    @IBOutlet weak var eyeBtnOut: UIButton!
    @IBOutlet weak var saveBGOut: UIView!
    @IBOutlet weak var txtFieldInsta: UITextField!
    @IBOutlet weak var txtFieldFacebook: UITextField!
    @IBOutlet weak var txtFieldTwitter: UITextField!
    
    @IBOutlet weak var tapToConnectLbl: UILabel!
    //MARK: VARIABLES
    var openPopUp = ""
    var colorGray = UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0)
    
    var editingnField: UITextField?
    
    var isSecuredPass = true{
        didSet{
            if self.isSecuredPass{
                self.txtFieldPassword.isSecureTextEntry = true
                self.eyeBtnOut.setImage(UIImage(named: "eyen"), for: .normal)
                
                
            } else{
                self.txtFieldPassword.isSecureTextEntry = false
                self.eyeBtnOut.setImage(UIImage(named: "view1"), for: .normal)
                
                let pass = userInfo.new_password ?? ""
                let key = "hello"

                let cryptLib = CryptLib()
                let decryptedString = cryptLib.decryptCipherTextRandomIV(withCipherText: pass, key: key)
                self.txtFieldPassword.text = decryptedString
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getProfileApi()
        self.txtFieldFirstName.delegate = self
        self.txtFieldLastName.delegate = self
        self.txtFieldPhoneNumber.delegate = self
        self.txtFieldEmail.delegate = self
        self.txtFieldInsta.delegate = self
        self.txtFieldFacebook.delegate = self
        self.txtFieldTwitter.delegate = self
        
        self.txtFieldEmail.addTarget(self, action: #selector(self.emailChanged(_:)), for: .editingChanged)
        
        profileImg.layer.cornerRadius = profileImg.frame.height/2
        profileImg.clipsToBounds = true
        
        if openPopUp == "open" {
            self.EditProfilePic("")
        }
        
        self.tapToConnectLbl.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)

        
        self.setupFields()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func EditProfilePic(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OpenCameraAlertVC") as! OpenCameraAlertVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.view.addSubview(vc.view)
        self.addChild(vc)
    }
    
    @IBAction func menuBtn(_ sender: UIButton) {
        toggleMenu(self)
    }
    
    @IBAction func eyeBtn(_ sender: UIButton) {
        self.isSecuredPass = !self.isSecuredPass
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        guard self.saveBGOut.backgroundColor == appColorBlue else{
            return
        }
        
        if self.editingnField == self.txtFieldFirstName || self.editingnField == self.txtFieldLastName || self.editingnField == self.txtFieldInsta || self.editingnField == self.txtFieldFacebook || self.editingnField == self.txtFieldTwitter{
            guard self.txtFieldFirstName.text?.isEmpty == false else{
                showSwiftyAlert("", "Please enter First name", false)
                return
            }
            guard self.txtFieldLastName.text?.isEmpty == false else{
                showSwiftyAlert("", "Please enter Last name", false)
                return
            }
            
            self.view.endEditing(true)
            self.saveBGOut.backgroundColor = self.colorGray
            self.setupFields()
            self.editProfileApi()
        } else if self.editingnField == self.txtFieldPhoneNumber{
            guard (self.txtFieldPhoneNumber.text!.isValidateMobile()) else{
                showSwiftyAlert("", "Invalid mobile number", false)
                return
            }
            
            guard (self.lblPhoneVerified.isHidden) == true else{
                self.view.endEditing(true)
                self.saveBGOut.backgroundColor = self.colorGray
                self.setupFields()
                return
            }
            
            self.view.endEditing(true)
            self.saveBGOut.backgroundColor = self.colorGray
            self.setupFields()
           
            self.checkPhoneApi()
            
        } else if self.editingnField == self.txtFieldEmail{
            if self.txtFieldEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty == true{
                showSwiftyAlert("", "Please enter email", false)
            }else if self.txtFieldEmail.text?.isValidateEmail() == false{
                showSwiftyAlert("", "Invalid email address", false)
            } else{
                guard (self.lblEmailVerified.isHidden) == true else{
                    self.view.endEditing(true)
                    self.saveBGOut.backgroundColor = self.colorGray
                    self.setupFields()
                    return
                }
                self.view.endEditing(true)
                self.saveBGOut.backgroundColor = self.colorGray
                self.setupFields()
                
                self.checkEmailApi()
            }
        } else{
           self.view.endEditing(true)
           self.saveBGOut.backgroundColor = self.colorGray
           self.setupFields()
        }
    }
    
    @IBAction func changePasswordBtn(_ sender: UIButton) {
        let changeView = ChangePasswordView.init(frame: screenFrame()) { (result) in
            self.isSecuredPass = false
            self.getProfileApi()
        }
        rootVC?.view.addSubview(changeView)
    }
    
    func loadData(){
        DispatchQueue.main.async {
            self.txtFieldFirstName.text = userInfo.firstName ?? ""
            self.txtFieldLastName.text = userInfo.lastName ?? ""
            self.txtFieldEmail.text = userInfo.email ?? ""
            self.txtFieldPhoneNumber.text = (userInfo.phone ?? "")
            self.txtFieldInsta.text = userInfo.instagram ?? ""
            self.txtFieldFacebook.text = userInfo.facebook ?? ""
            self.txtFieldTwitter.text = userInfo.twitter ?? ""
            self.lblPhoneVerified.isHidden = ((userInfo.isVerified ?? 0) == 1) ? false : true
            self.lblEmailVerified.isHidden = ((userInfo.emailVerify ?? 0) == 1) ? false : true
            
            self.profileImg.sd_setImage(with: URL(string: (userInfo.image ?? "")), placeholderImage: UIImage(named: "imgPlaceholder"), options: [] , completed: nil)
        }
    }
}

extension EditProfileVC : CameraAlertDelegate, UITextFieldDelegate {
    
    func imageSelected(_ img: UIImage) {
        self.editImageApi(img)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.editingnField = textField
        self.saveBGOut.backgroundColor = appColorBlue
        self.setupFields()
    }
    
  
    func setupFields(){
        guard self.saveBGOut.backgroundColor == appColorBlue else {
            self.txtFieldFirstName.isUserInteractionEnabled = true
            self.txtFieldLastName.isUserInteractionEnabled = true
            self.txtFieldPhoneNumber.isUserInteractionEnabled = true
            self.txtFieldEmail.isUserInteractionEnabled = true
            return
        }
        
        if self.editingnField == self.txtFieldFirstName || self.editingnField == self.txtFieldLastName{
            self.txtFieldPhoneNumber.isUserInteractionEnabled = false
            self.txtFieldEmail.isUserInteractionEnabled = false
        } else if self.editingnField == self.txtFieldPhoneNumber{
            self.txtFieldFirstName.isUserInteractionEnabled = false
            self.txtFieldLastName.isUserInteractionEnabled = false
            self.txtFieldEmail.isUserInteractionEnabled = false
        } else if self.editingnField == self.txtFieldEmail{
            self.txtFieldFirstName.isUserInteractionEnabled = false
            self.txtFieldLastName.isUserInteractionEnabled = false
            self.txtFieldPhoneNumber.isUserInteractionEnabled = false
        } else{
            self.txtFieldFirstName.isUserInteractionEnabled = false
            self.txtFieldLastName.isUserInteractionEnabled = false
            self.txtFieldPhoneNumber.isUserInteractionEnabled = false
            self.txtFieldEmail.isUserInteractionEnabled = false
        }
    }
    
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         guard textField == self.txtFieldPhoneNumber else {return true}
         
         guard let text = textField.text else { return false }
         
         let newString = (text as NSString).replacingCharacters(in: range, with: string)
         textField.text = newString.formattedNumber()
         self.phoneChanged(textField)
         return false
     }
    
    @objc func phoneChanged(_ sender: UITextField){
          if self.txtFieldPhoneNumber.text == userInfo.phone{
              self.lblPhoneVerified.isHidden = false
          } else{
              self.lblPhoneVerified.isHidden = true
          }
      }
      
      
      @objc func emailChanged(_ sender: UITextField){
          if self.txtFieldEmail.text == userInfo.email && userInfo.emailVerify == 1{
              self.lblEmailVerified.isHidden = false
          } else{
              self.lblEmailVerified.isHidden = true
          }
      }
    
    @IBAction func igBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        self.openUrl("https://instagram.com/gocourial")
    }
    
    @IBAction func fbBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        self.openUrl("https://www.facebook.com/courial/")
    }
    
    @IBAction func twitterBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        self.openUrl("https://twitter.com/gocourial")
    }
        
    //MARK:- OpenUrl
    func openUrl(_ urlStr: String = "https://www.courial.com"){
        if let url = URL(string: "\(urlStr)"), !url.absoluteString.isEmpty, (UIApplication.shared.canOpenURL(url)) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            showSwiftyAlert("", "Sorry! We are not able to open this page.", false)
        }
    }
}


extension EditProfileVC {
    
    //MARK:- API
    
    func getProfileApi(){
        showLoader()
        ApiInterface.requestApi(params: [:], api_url: API.get_profile, method: .get, encoding: URLEncoding.httpBody , success: { (json) in
            hideLoader()
            var data = json["data"].dictionaryObject ?? [:]
            data.updateValue((userInfo.token ?? ""), forKey: "token")
            userInfo = UserInfoModel.init(json: JSON(data))
            self.loadData()
        }) { (error, json) in
            hideLoader()
        }
    }
    
    
    func editProfileApi(){
        let params : Parameters = [
            "instagram": self.txtFieldInsta.text!,
            "facebook": self.txtFieldFacebook.text!,
            "twitter": self.txtFieldTwitter.text!,
            "first_name": self.txtFieldFirstName.text!,
            "last_name": self.txtFieldLastName.text!
        ]
        showLoader()
        ApiInterface.requestApi(params: params , api_url: API.edit_profile, method: .put , success: { (json) in
            DispatchQueue.main.async {
                hideLoader()
                userInfo.instagram = self.txtFieldInsta.text!
                userInfo.twitter = self.txtFieldTwitter.text!
                userInfo.facebook = self.txtFieldFacebook.text!
                userInfo.firstName = self.txtFieldFirstName.text!
                userInfo.lastName = self.txtFieldLastName.text!
                saveUserInfo()
                showSwiftyAlert("", json["msg"].stringValue, true)
            }
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    
    func editImageApi(_ img: UIImage?){
        showLoader()
        ApiInterface.formDataApi(params: [:], api_url: API.edit_profile, image: img, imageName: "image", headers: createHeaders(), method: .put, success: { (json) in
            hideLoader()
            userInfo.image = json["data"]["image"].stringValue
            self.loadData()
            saveUserInfo()
            showSwiftyAlert("", json["msg"].stringValue, true)
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    func checkPhoneApi(){
        let params: Parameters = [
            "phone": self.txtFieldPhoneNumber.text!,
            "country_code" : userInfo.countryCode ?? "+1"
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.check_phone , success: { (json) in
            hideLoader()
            let OTP = json["data"]["otp"].stringValue
            let changeView = ChangeNumberView.init(frame: screenFrame(), emailNum: self.txtFieldPhoneNumber.text!, isNumber: true, CC: userInfo.countryCode ?? "+1",otp: OTP) { (result) in
                self.loadData()
            }
            rootVC?.view.addSubview(changeView)
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    func checkEmailApi(){
        let params: Parameters = [
            "email": self.txtFieldEmail.text!
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.send_otp , success: { (json) in
            hideLoader()
            let OTP = json["data"]["otp"].stringValue
            let changeView = ChangeNumberView.init(frame: screenFrame(), emailNum: self.txtFieldEmail.text!, isNumber: false, CC: "", otp: OTP) { (result) in
                self.loadData()
            }
            rootVC?.view.addSubview(changeView)
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
}
