//
//  MediaShareInterface.swift
//  Courail
//
//  Created by Omeesh Sharma on 12/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices
import Speech
import AVFoundation

class MediaShareInterface: NSObject {
    
    static let shared = MediaShareInterface()
    
    weak var currentVC : UIViewController?
    
    var voipView : VoiceCallViewController?
    
    var endCallView : UIView?
    
    var tabBarShowAtEnd = false
    
    var player: AVAudioPlayer?
    
    deinit {
        self.player?.delegate = nil
    }
    
    func shareActivity(text: String, _ vc: UIViewController){
        self.currentVC = vc
        let firstActivityItem = text
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        
        vc.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func makeCall(_ recipientNumber: String){
        let url = "tel://\(recipientNumber)"
        let urlString = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        guard let callURL = URL(string: urlString!)else{
            showSwiftyAlert("", "Sorry! You can't make a call.", false)
            return
        }
        if UIApplication.shared.canOpenURL(callURL){
            UIApplication.shared.open(callURL, options: [:], completionHandler: nil)
        }else{
            showSwiftyAlert("", "Sorry! You can't make a call.", false)
        }
    }

    func sendSms(_ recipientNumber: String,_ vc: UIViewController){
        self.currentVC = vc
        
        let messageBody = ""
        let sms: String = "sms://open?addresses=\(recipientNumber)&body=\(messageBody)"
        let smsEncoded = sms.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        guard let url = URL(string: smsEncoded) else{
            showSwiftyAlert("", "Unable to send message to this number", false)
            return
        }
        
        if UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: { (result) in
                if !result {
                    showSwiftyAlert("", "Messaging feature not available", false)
                }
            })
        }else{
            showSwiftyAlert("", "Messaging feature not available", false)
        }
        
//        let controller = MFMessageComposeViewController()
//        if (MFMessageComposeViewController.canSendText())
//        {
//            controller.body = ""
//            controller.recipients = [recipientNumber]
//            controller.messageComposeDelegate = self
//            vc.present(controller, animated: true, completion: nil)
//        }else{
//            showSwiftyAlert("", "Messaging feature not available", false)
//        }
    }
    
    func supportEmail(_ vc: UIViewController){
        self.currentVC = vc
        let supportEmail = "support@courial.com"
        if ( MFMailComposeViewController.canSendMail())
        {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.navigationBar.barTintColor = appColorBlue
            mailComposer.navigationBar.tintColor = UIColor.black
            
            mailComposer.setToRecipients([supportEmail])
            mailComposer.setSubject("Courial")
            vc.present(mailComposer, animated: true, completion: nil)
        }
        else
        {
            let coded = "mailto:\(supportEmail)?subject=Courial".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let emailURL = URL(string: coded!)
            {
                if UIApplication.shared.canOpenURL(emailURL)
                {
                    UIApplication.shared.open(emailURL, options: [:], completionHandler: { (result) in
                        if !result {
                            showSwiftyAlert("", "Your device is not currently configured to send mail.", false)
                        }
                    })
                }else{
                    showSwiftyAlert("", "Mailing App not available", false)
                }
            }
        }
    }
    
    func ratingEmail(_ vc: UIViewController){
        self.currentVC = vc
        let supportEmail = "support@courial.com"
        let body = "Thanks for your rating.\n\nYour feedback is very important to us. In one or two sentences, please tell us what we can do better and offer any suggestions if possible.\n\nWe are looking forward to making Courial the best tool for all your delivery needs.\n\n===================\n\nWRITE YOUR COMMENTS BELOW:\n"
        if ( MFMailComposeViewController.canSendMail()) {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.navigationBar.barTintColor = appColorBlue
            mailComposer.navigationBar.tintColor = UIColor.black
            
            mailComposer.setToRecipients([supportEmail])
            mailComposer.setSubject("Rating from User")
            mailComposer.setMessageBody(body, isHTML: false)
            vc.present(mailComposer, animated: true, completion: nil)
        }else {
            let coded = "mailto:\(supportEmail)?subject=Rating from User&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let emailURL = URL(string: coded!)
            {
                if UIApplication.shared.canOpenURL(emailURL)
                {
                    UIApplication.shared.open(emailURL, options: [:], completionHandler: { (result) in
                        if !result {
                            showSwiftyAlert("", "Your device is not currently configured to send mail.", false)
                        }
                    })
                }else{
                    showSwiftyAlert("", "Mailing App not available", false)
                }
            }
        }
    }
    
    
    
    func twilioCall(vc: UIViewController, no: String, name: String, hideDetails: Bool? = false){
        self.currentVC = vc
        if tabBarShowAtEnd{
            vc.tabBarController?.tabBar.isHidden = true
            vc.navigationController?.view.setNeedsLayout()
        }
        let popup = vc.storyboard?.instantiateViewController(withIdentifier: "CallPopupVC") as! CallPopupVC
        popup.phoneNo = no
        popup.storeName = name
        popup.hideDetails = hideDetails ?? false
        popup.modalPresentationStyle = .overCurrentContext
        vc.view.addSubview(popup.view)
        vc.addChild(popup)
        popup.completion = { (phone, result) in
            switch result {
            case "1":
                self.sfPermission()
                self.showCallPopup(phone, vc)
            case "2":
                if self.tabBarShowAtEnd{
                    vc.tabBarController?.tabBar.isHidden = false
                    vc.navigationController?.view.setNeedsLayout()
                }
                let mobileNum = phone
                if let phoneCallURL = URL(string: "tel://\(mobileNum)"), UIApplication.shared.canOpenURL(phoneCallURL){
                    UIApplication.shared.open(phoneCallURL, options: [:]
                        , completionHandler: nil)
                }
            default:
                if self.tabBarShowAtEnd{
                    vc.tabBarController?.tabBar.isHidden = false
                    vc.navigationController?.view.setNeedsLayout()
                }
            }
        }
    }
    
    func sfPermission(){
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    break;
                case .denied:
                    //User denied access to speech recognition
                    break;
                case .restricted:
                    //"Speech recognition       restricted on this device"
                    break;
                case .notDetermined:
                    //                    "Speech recognition not yet authorized"
                    break;
                }
            }
        }
    }
    
    func showCallPopup(_ phone: String,_ vc: UIViewController){
        let popup = vc.storyboard?.instantiateViewController(withIdentifier: "VoiceCallViewController") as! VoiceCallViewController
        popup.modalPresentationStyle = .overCurrentContext
        popup.storePhone = "+1" + phone
//        popup.storePhone = "+14163429562"
        popup.fromSite = false
        popup.completion = { transcription in
            if transcription == "-Hide"{
                self.voipView?.view.isHidden = true
                self.endCallView?.isHidden = false
            } else if transcription == "-"{
                self.endCallView?.isHidden = true
                if self.tabBarShowAtEnd{
                    vc.tabBarController?.tabBar.isHidden = false
                    vc.navigationController?.view.setNeedsLayout()
                }
            } else if transcription == "--Unable to connect--"{
                self.endCallView?.isHidden = true
                showSwiftyAlert("", "Unable to connect with the Store", false)
                if self.tabBarShowAtEnd{
                    vc.tabBarController?.tabBar.isHidden = false
                    vc.navigationController?.view.setNeedsLayout()
                }
            }else{
                self.endCallView?.isHidden = true
                if self.tabBarShowAtEnd{
                    vc.tabBarController?.tabBar.isHidden = false
                    vc.navigationController?.view.setNeedsLayout()
                }
            }
        }
        vc.view.addSubview(popup.view)
        vc.addChild(popup)
        self.voipView = popup
    }
    
    
    func playSound(_ type: appSounds){
        guard let path = Bundle.main.path(forResource: type.rawValue, ofType : "caf") else {return}
        let url = URL(fileURLWithPath : path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            DispatchQueue.main.async {
                self.player?.play()
            }
        } catch {
            print ("There is an issue with this code!")
        }
    }
    
}


extension MediaShareInterface: MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, SFSafariViewControllerDelegate{
    
    func shareImageOnSocalSites(index:Int,text: String, _ vc: UIViewController){
        self.currentVC = vc
        
        let fileURL = text.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        var socialURL = ""
        
        if index == 0
        {
            let urlWhats = "twitter://post?message=\(fileURL)"
            let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let whatsappURL = URL(string: urlString!)
            if UIApplication.shared.canOpenURL(whatsappURL!)
            {
                UIApplication.shared.open(whatsappURL!, options: [:], completionHandler: nil)
            }
            else
            {
                socialURL = "https://twitter.com/intent/tweet?url="
                shareImageBySafari(socialURL: socialURL, url: fileURL)
                // AFWrapper.showError("Error!", msg: "Twitter is not Installed")
            }
        }
        else if index == 1 {
            socialURL = "https://www.facebook.com/sharer/sharer.php?u=www.courial.com&quote="
            shareImageBySafari(socialURL: socialURL, url: fileURL)
        } else if index == 2{
            let myURLString = text
            if ( MFMailComposeViewController.canSendMail())
            {
                let mailComposer = MFMailComposeViewController()
                mailComposer.mailComposeDelegate = self
                mailComposer.navigationBar.barTintColor = appColorBlue
                mailComposer.navigationBar.tintColor = UIColor.black
                
                mailComposer.setSubject("Courial")
                mailComposer.setMessageBody(myURLString, isHTML: false)
                
                vc.present(mailComposer, animated: true, completion: nil)
            }
            else
            {
                let coded = "mailto:?subject=Courial&body=\(myURLString)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                if let emailURL = URL(string: coded!)
                {
                    if UIApplication.shared.canOpenURL(emailURL)
                    {
                        UIApplication.shared.open(emailURL, options: [:], completionHandler: { (result) in
                            if !result {
                                showSwiftyAlert("", "Your device is not currently configured to send mail.", false)
                            }
                        })
                    }else{
                        showSwiftyAlert("", "Mailing App not available", false)
                    }
                }
            }
        }
        else if index == 3
        {
            let controller = MFMessageComposeViewController()
            if (MFMessageComposeViewController.canSendText())
            {
                controller.body = text
                controller.messageComposeDelegate = self
                vc.present(controller, animated: true, completion: nil)
            }else{
                showSwiftyAlert("", "Messaging feature not available", false)
            }
            
        }else if index == 4{
            let urlStr = String(format: "fb-messenger://")
            let url  = NSURL(string: urlStr)
            if let Url = url{
                UIApplication.shared.open(Url as URL, options: [:]) { (success) in
                    if success {
                        print("Messenger accessed successfully")
                    } else {
                        showSwiftyAlert("", "Messenger not installed", false)
                    }
                }
            }
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult){
        controller.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?)
    {
        switch result
        {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
        case MFMailComposeResult.saved:
            print("Mail saved")
        case MFMailComposeResult.sent:
            print("Mail sent")
        case MFMailComposeResult.failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
        default:
            print("Default case")
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func shareImageBySafari(socialURL:String,url:String)
    {
        let shareURL = socialURL + url
        
        if let url = URL(string:shareURL)
        {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
            self.currentVC?.present(vc, animated: true)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
    {
        self.currentVC?.navigationController?.navigationBar.isHidden = true
        controller.dismiss(animated: true, completion: nil)
    }
}
