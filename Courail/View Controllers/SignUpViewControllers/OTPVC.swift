//
//  OTPVC.swift
//  Courail
//
//  Created by apple on 23/01/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SVPinView

class OTPVC: UIViewController {
    
    //MARK:- OUTETS
    
    @IBOutlet weak var pinView: SVPinView!
    
    @IBOutlet weak var numberLbl: UILabel!
    
    @IBOutlet weak var resendLbl: UILabel!
    
    //MARK:- VARIABLES
    
    var OTP = ""
    var countryCode = ""
    var phone = ""
    
    var timer = Timer()
    var endDate = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let originalText = (self.phone) + ". Enter it below."
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let noRange = attributedOriginalText.mutableString.range(of: (self.phone))
        
        let myAttribute = [ NSAttributedString.Key.font: UIFont.init(name: "Roboto-Medium", size: 17) ?? UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : appColor]
        attributedOriginalText.addAttributes(myAttribute, range: noRange)
        
        self.numberLbl.attributedText = attributedOriginalText
        
        
        self.pinView.font = .boldSystemFont(ofSize: 20)
        self.pinView.didFinishCallback = { otp in
            if otp == self.OTP{
                self.view.endEditing(true)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                vc.countryCode = self.countryCode
                vc.phone = self.phone
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.setupTimer()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }
    
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func nextTap(_ sender: Any) {
        self.view.endEditing(true)
        guard self.pinView.getPin().isEmpty == false else{
            showSwiftyAlert("", "Please enter CODE", false)
            return
        }
        
        guard self.pinView.getPin() == self.OTP else{
            showSwiftyAlert("", "Invalid CODE", false)
            return
        }
        
        
        self.OTP = ""
        self.resendLbl.text = ""
        self.timer.invalidate()
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        vc.countryCode = self.countryCode
        vc.phone = self.phone
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func setupTimer(){
        self.timer.invalidate()
        self.endDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (sender) in
            self.updateCount(self.endDate)
        })
    }
    
    
    func updateCount(_ todate: Date){
        let timeinterval = todate.timeIntervalSinceNow
        let interval = Int(timeinterval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        
        if seconds < 0 || minutes < 0{
            self.timer.invalidate()
            self.resendLbl.text = ""
            self.checkPhoneApi()
        } else{
            let diff = String(format: "%.02d:%.02d", minutes, seconds).replacingOccurrences(of: "-", with: "")
            self.resendLbl.text = "we'll resend code in \(diff)"
        }
    }
    
    
}


extension OTPVC {
    
    //MARK:- API
    
    func checkPhoneApi(){
        let params: Parameters = [
            "phone": self.phone,
            "country_code" : self.countryCode
        ]
        
        ApiInterface.requestApi(params: params, api_url: API.check_phone , success: { (json) in
            self.OTP = json["data"]["otp"].stringValue
        }) { (error, json) in
            showSwiftyAlert("", error, false)
        }
    }
    
}
