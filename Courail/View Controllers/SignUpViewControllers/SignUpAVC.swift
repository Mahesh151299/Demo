//
//  ViewController.swift
//  Courail
//
//  Created by apple on 23/01/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import LGSideMenuController
import SKCountryPicker


class SignUpAVC: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var countryCode: UILabel!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet var txtfldMobileNumber: UITextField!
    @IBOutlet var btnCreateAccount: UIButtonCustomClass!
    @IBOutlet var btnCancelView: UIView!
    
    
    //MARK:- VARIABLES
    
    var isClicked = true
    
    var ongoingProcess = false
    
    var closed : (()->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.txtfldMobileNumber.delegate = self
        self.countryCode.text = CountryManager.shared.currentCountry?.dialingCode ?? "+1"
        self.flag.image = CountryManager.shared.currentCountry?.flag
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UpdateAvailable.isUpdateAvailable()
    }
    
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func countryCodeBtn(_ sender: UIButton) {
        DispatchQueue.main.async {
            UINavigationBar.appearance().isTranslucent = true
            
            let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
                UINavigationBar.appearance().isTranslucent = false
                guard let self = self else { return }
                self.countryCode.text = (country.dialingCode ?? "")
                self.flag.image = country.flag
            }
            // can customize the countryPicker here e.g font and color
            countryController.modalPresentationStyle = .fullScreen
        }
    }
    
    
    @IBAction func startTypeNumTap(_ sender: Any) {
        self.btnCreateAccount.setTitle("Send Code", for: .normal)
    }
    
    @IBAction func cancelTap(_ sender: UIButton){
        if !ongoingProcess{
            guard self.btnCreateAccount.title(for: .normal) == "Send Code" else{
                self.pop()
                return
            }
            
            self.btnCreateAccount.setTitle("Just Browsing", for: .normal)
        } else{
            if let close = self.closed{
                close()
                self.pop()
            }
        }
    }
    
    @IBAction func getOTPTap(_ sender: Any) {
        guard self.btnCreateAccount.title(for: .normal) == "Send Code" else{
            if ongoingProcess{
                self.pop()
            } else{
                GoToHome()
            }
            return
        }
        
        guard (self.txtfldMobileNumber.text!.isValidateMobile()) else{
            showSwiftyAlert("", "Invalid mobile number", false)
            return
        }
        self.checkPhoneApi()
    }
    
    @IBAction func signInTap(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        navigationController?.pushViewController(vc, animated: true)
    }
   
}


extension SignUpAVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = newString.formattedNumber()
        return false
    }
    
}


extension SignUpAVC {
    
    //MARK:- API
    
    func checkPhoneApi(){
        let params: Parameters = [
            "phone": self.txtfldMobileNumber.text!,
            "country_code" : self.countryCode.text!
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.check_phone , success: { (json) in
            hideLoader()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
            vc.OTP = json["data"]["otp"].stringValue
            vc.countryCode = self.countryCode.text!
            vc.phone = self.txtfldMobileNumber.text!
            self.navigationController?.pushViewController(vc, animated: true)
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
}
