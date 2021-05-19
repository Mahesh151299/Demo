//
//  SocialMediaVC.swift
//  Courail
//
//  Created by apple on 11/12/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SocialMediaVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var textFieldIGLink: UITextField!
    @IBOutlet weak var textFieldFBLink: UITextField!
    @IBOutlet weak var textFieldTwitterLink: UITextField!
    
    //MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- OpenUrl
    func openUrl(_ urlStr: String = "https://www.courial.com"){
        if let url = URL(string: "\(urlStr)"), !url.absoluteString.isEmpty, (UIApplication.shared.canOpenURL(NSURL(string:urlStr)! as URL)) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            showSwiftyAlert("", "Sorry! We are not able to open this page.", false)
        }
    }
  
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.pop()
    }
    
    //MARK:- Button Action
    @IBAction func nextClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.updateSocialLinks()
    }
    
    
    @IBAction func openMediaLink(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.tag == 1{
            self.openUrl("https://instagram.com/gocourial")
        }else if sender.tag == 2{
            self.openUrl("https://www.facebook.com/courial/")
        }else {
            self.openUrl("https://twitter.com/gocourial")
        }
    }

}


extension SocialMediaVC {
    
    //MARK:- API
    
    func updateSocialLinks(){
        let params: Parameters = ["instagram": self.textFieldIGLink.text!, "facebook": self.textFieldFBLink.text!, "twitter": self.textFieldTwitterLink.text!]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.updateSocialMedia , success: { (json) in
            hideLoader()
            userInfo.instagram = self.textFieldIGLink.text!
            userInfo.twitter = self.textFieldTwitterLink.text!
            userInfo.facebook = self.textFieldFBLink.text!
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpInfoViewController") as! SignUpInfoViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
}
