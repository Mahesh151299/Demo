
//
//  TermsPrivacyVC.swift
//  Courail
//
//  Created by apple on 24/01/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class TermsPrivacyVC: UIViewController {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var textView: UITextView!
    
    //MARK: VARIABLES
    
    let termsURL = "http://www.example.com/terms"
    let privacyURL = "http://www.example.com/privacy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTextView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LocationInterface.shared.setupCoreLocation()
    }
    
    
    @IBAction func crossBtn(_ sender: UIButton) {
        GoToHome()
    }
    
    @IBAction func showDeliveryAddressTap(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SetAddressVC") as! SetAddressVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TermsPrivacyVC : UITextViewDelegate {
    
    func setupTextView(){
        let myParagraphStyle = NSMutableParagraphStyle()
        myParagraphStyle.alignment = .center // center the text
        myParagraphStyle.lineSpacing = 2 //Change spacing between lines
        myParagraphStyle.paragraphSpacing = 2 //Change space between paragraphs
        
        let originalText = "By continuing, you agree to our\nTerms of Service and Privacy Policy"
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        
        let linkRange = attributedOriginalText.mutableString.range(of: originalText)
        let myAttribute = [ NSAttributedString.Key.font: UIFont.init(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.paragraphStyle: myParagraphStyle]
        attributedOriginalText.addAttributes(myAttribute, range: linkRange)
        
        let linkTermsRange = attributedOriginalText.mutableString.range(of: "Terms of Service")
        attributedOriginalText.addAttribute(.link, value: termsURL, range: linkTermsRange)
        attributedOriginalText.addAttributes([NSAttributedString.Key.font : UIFont.init(name: "Roboto-Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 16)], range: linkTermsRange)
        
        
        let linkPrivacyRange = attributedOriginalText.mutableString.range(of: "Privacy Policy")
        attributedOriginalText.addAttribute(.link, value: privacyURL, range: linkPrivacyRange)
        attributedOriginalText.addAttributes([NSAttributedString.Key.font : UIFont.init(name: "Roboto-Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 16)], range: linkPrivacyRange)
        
        self.textView.linkTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.white]
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
