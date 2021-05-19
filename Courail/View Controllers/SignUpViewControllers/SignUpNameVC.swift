//
//  SignUpNameVC.swift
//  Courail
//
//  Created by mac on 29/01/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SignUpNameVC: UIViewController,UITextFieldDelegate {
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var txtFieldFirstName: UITextField!

    @IBOutlet weak var txtFieldLastName: UITextField!
    
    //MARK:- VARIABLES
    
    var countryCode = ""
    var phone = ""
    var email = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        if self.txtFieldFirstName.text?.trimmingCharacters(in: .whitespaces).isEmpty == true{
            showSwiftyAlert("", "Please enter first name", false)
        }else if self.txtFieldLastName.text?.trimmingCharacters(in: .whitespaces).isEmpty == true{
            showSwiftyAlert("", "Please enter last name", false)
        } else{
            self.signUpApi()
        }
    }
    
    
}

extension SignUpNameVC {
    
    //MARK:- API
    
    func signUpApi(){
        let params: Parameters = [
            "first_name": self.txtFieldFirstName.text!,
            "last_name": self.txtFieldLastName.text!,
            "email": self.email,
            "password": self.password,
            "country_code": self.countryCode,
            "phone": self.phone,
            "latitude": "\(LocationInterface.shared.lats)",
            "longitude": "\(LocationInterface.shared.longs)",
            "phoneversion": UIDevice().type.rawValue,
            "device_type":iOSplatform,
            "device_token": notificationToken,
            "appversion": Bundle.main.releaseVersionNumber ?? "0.0",
            "apprelease": "\(buildDate.timeIntervalSince1970)",
            "os":UIDevice.current.systemVersion
        ]
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.signup , success: { (json) in
            hideLoader()
            userInfo = UserInfoModel.init(json: json["data"])
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpReferVC") as! SignUpReferVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
}
