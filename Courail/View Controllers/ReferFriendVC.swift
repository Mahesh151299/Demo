//
//  ReferFriendVC.swift
//  CourialPartner
//
//  Created by apple on 05/05/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ReferFriendVC: UIViewController {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var referCodeView: UIViewCustomClass!
    @IBOutlet weak var referCode: UILabel!
    
    let promoText = "Hi! Relax and let Courial's super heroes deliver anything to you in 30 minutes or less! What's more, we both receive $55 in credits ($5 off your first 11 deliveries).\n\nUSE MY CODE: \((userInfo.refrel ?? "").uppercased())\nUSE THIS LINK: \(appStoreLinkUser)"
    
    
    //MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.referCode.text = (userInfo.refrel ?? "").uppercased()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.referCodeView.addGestureRecognizer(tapGestureRecognizer)
            
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.referCodeView.addGestureRecognizer(longPressRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Button Action
    @IBAction func backAct(_ sender: Any) {
        toggleMenu(self)
    }
    
    @objc func tapped(sender: UITapGestureRecognizer){
        print("tapped")
        MediaShareInterface.shared.shareActivity(text: self.promoText, self)
    }

    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        print("longpressed")
        if sender.state != .ended {
                    //When lognpress is start or running
            UIPasteboard.general.string = (userInfo.refrel ?? "").uppercased()
            showSwiftyAlert("", "Referral Code Copied", true)
        }
    }
  
    
    @IBAction func shareOnSMS(_ sender: UIButton) {
        MediaShareInterface.shared.shareImageOnSocalSites(index: 3,text: self.promoText, self)
    }
    
    @IBAction func shareOnMail(_ sender: UIButton) {
        MediaShareInterface.shared.shareImageOnSocalSites(index: 2,text: self.promoText, self)
    }
    
//    @IBAction func shareOnFacebook(_ sender: UIButton) {
//        MediaShareInterface.shared.shareImageOnSocalSites(index: 1,text: self.promoText, self)
//    }
//
//    @IBAction func shareOnTwitter(_ sender: UIButton) {
//        MediaShareInterface.shared.shareImageOnSocalSites(index: 0,text: self.promoText, self)
//    }
//
//    @IBAction func shareOnMessenger(_ sender: UIButton) {
//        UIPasteboard.general.string = self.promoText
//        MediaShareInterface.shared.shareImageOnSocalSites(index: 4,text: self.promoText, self)
//    }
}
