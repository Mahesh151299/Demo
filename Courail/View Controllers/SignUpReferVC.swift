//
//  SignUpReferVC.swift
//  Courail
//
//  Created by Omeesh Sharma on 04/01/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class SignUpReferVC: UIViewController {

    
    //MARK:- OUTLETS
    
    @IBOutlet weak var txtReferCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backction(_ sender: Any) {
        self.pop()
    }
    
    
    @IBAction func nextBtnAction(_ sender: Any) {
        if self.txtReferCode.text?.isEmpty == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SocialMediaVC") as! SocialMediaVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else{
            self.referApi()
        }
    }
    
}



extension SignUpReferVC {
    
    //MARK:- API
    
    func referApi(){
        let params: Parameters = [
            "referralcode": self.txtReferCode.text!,
            "appversion": Bundle.main.releaseVersionNumber ?? "0.0",
            "apprelease": "\(buildDate.timeIntervalSince1970)",
            "os":UIDevice.current.systemVersion
        ]
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.applyrefrelcode , success: { (json) in
            hideLoader()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SocialMediaVC") as! SocialMediaVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
}
