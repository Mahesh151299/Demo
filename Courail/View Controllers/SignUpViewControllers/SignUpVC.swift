//
//  SignUpVC.swift
//  Courail
//
//  Created by apple on 23/01/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController,UITextFieldDelegate {
    
    //MARK:- OUTLETS
    
    @IBOutlet var lblPasswordMEssage: UILabel!
    @IBOutlet weak var txtfieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var eyeBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    //MARK: VARIABLES
    
    let termsURL = "http://www.example.com/terms"
    let privacyURL = "http://www.example.com/privacy"
    
    var countryCode = ""
    var phone = ""
    
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
        self.setupTextView()
    }
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func nextTap(_ sender: Any) {
        if txtfieldEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty == true{
            showSwiftyAlert("", "Please enter email", false)
        }else if self.txtfieldEmail.text?.isValidateEmail() == false{
            showSwiftyAlert("", "Invalid email address", false)
        } else if txtFieldPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty == true{
            showSwiftyAlert("", "Please enter password", false)
        }else if (txtFieldPassword.text?.count ?? 0) < 8{
            showSwiftyAlert("", "Password should be atleast 8 characters long", false)
        } else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpNameVC") as! SignUpNameVC
            vc.countryCode = self.countryCode
            vc.phone = self.phone
            vc.email = self.txtfieldEmail.text!
            vc.password = self.txtFieldPassword.text!
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func backTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func secureTextBtn(_ sender: UIButton) {
        self.isSecured = !self.isSecured
    }
    
}



extension SignUpVC : UITextViewDelegate {
    
    func setupTextView(){
        let myParagraphStyle = NSMutableParagraphStyle()
        myParagraphStyle.alignment = .center // center the text
        myParagraphStyle.lineSpacing = 2 //Change spacing between lines
        myParagraphStyle.paragraphSpacing = 2 //Change space between paragraphs
        
        let originalText = "By continuing, I agree to the Courial\nTerms of Service and Privacy Policy"
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        
        let linkRange = attributedOriginalText.mutableString.range(of: originalText)
        let myAttribute = [ NSAttributedString.Key.font: UIFont.init(name: "Roboto-Regular", size: 12) ?? UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : appColorBlue, NSAttributedString.Key.paragraphStyle: myParagraphStyle]
        attributedOriginalText.addAttributes(myAttribute, range: linkRange)
        
        let linkTermsRange = attributedOriginalText.mutableString.range(of: "Terms of Service")
        attributedOriginalText.addAttribute(.link, value: termsURL, range: linkTermsRange)
        attributedOriginalText.addAttributes([NSAttributedString.Key.font : UIFont.init(name: "Roboto-Medium", size: 12) ?? UIFont.boldSystemFont(ofSize: 13)], range: linkTermsRange)
        
        
        let linkPrivacyRange = attributedOriginalText.mutableString.range(of: "Privacy Policy")
        attributedOriginalText.addAttribute(.link, value: privacyURL, range: linkPrivacyRange)
        attributedOriginalText.addAttributes([NSAttributedString.Key.font : UIFont.init(name: "Roboto-Medium", size: 12) ?? UIFont.boldSystemFont(ofSize: 13)], range: linkPrivacyRange)
        
        self.textView.linkTextAttributes = [ NSAttributedString.Key.foregroundColor : appColor]
        self.textView.delegate = self
        self.textView.attributedText = attributedOriginalText
    }
    
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyViewController") as! PrivacyViewController
        if (URL.absoluteString == termsURL) {
            vc.screen = "Terms of Service"
        }else{
            vc.screen = "Privacy Policy"
        }
        self.navigationController?.pushViewController(vc, animated: true)
        return false
    }
    
}
