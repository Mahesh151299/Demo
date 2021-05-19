//
//  ResendEmailVC.swift
//  Courail
//
//  Created by Omeesh Sharma on 13/05/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ResendEmailVC: UIViewController {
    
    //MARK:- OUTLETS
      
      @IBOutlet weak var emailTF: UITextField!
      
      //MARK:- VARIABLES

    var email = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTF.text = self.email
        // Do any additional setup after loading the view.
    }
 
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func backBtn(_ sender: UIButton){
        self.pop()
    }
    
    @IBAction func resendBtn(_ sender: UIButton){
        self.forgotPasswordApi()
    }

}


extension ResendEmailVC {
    
    //MARK:- API
    
    func forgotPasswordApi(){
        let params : Parameters = [
            "email": self.email
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params , api_url: API.forgot_password, success: { (json) in
            hideLoader()
            showSwiftyAlert("", json["msg"].stringValue, true)
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    
}
