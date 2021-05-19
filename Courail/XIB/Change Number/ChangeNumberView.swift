//
//  ChangeNumberView.swift
//  Courail
//
//  Created by Omeesh Sharma on 25/06/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SVPinView

class ChangeNumberView: UIView {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var pinView: SVPinView!
    
    @IBOutlet weak var field: UITextField!
    
    @IBOutlet weak var resendLbl: UILabel!
    @IBOutlet weak var resendBtnOut: UIButtonCustomClass!
    
    //MARK: VARIABLES
    
    var completion : ((Bool)-> ())?
    
    var isNumber = true
    var emailNum = ""
    var countryCode = ""
    
    var OTP = ""
    
    var timer = Timer()
    var endDate = Date()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, emailNum: String, isNumber: Bool,CC : String,otp: String, completion: @escaping ((Bool)-> ())) {
        super.init(frame: frame)
        self.completion = completion
        self.setup(emailNum: emailNum, CC : CC,isNumber: isNumber,otp: otp)
    }
    
    
    func setup(emailNum: String,CC  : String, isNumber: Bool,otp: String){
        self.bgView = Bundle.main.loadNibNamed("ChangeNumberView", owner: self, options: nil)?.first as? UIView
        self.bgView.frame = self.bounds
        self.addSubview(self.bgView)
        self.emailNum = emailNum
        self.countryCode = CC
        self.isNumber = isNumber
        self.field.text = self.emailNum
        self.OTP = otp
        self.pinView.font = .boldSystemFont(ofSize: 20)
        
        if self.isNumber{
            self.field.placeholder = "(000) 000-0000"
            self.field.keyboardType = .phonePad
            self.message.text = "A 4-digit code was sent to you at \(self.emailNum). Enter it below."
            self.setupTimer()
        } else{
            self.field.placeholder = "Email Address"
            self.message.text = "A confirmation code was emailed to you at \(self.emailNum)"
            self.field.keyboardType = .emailAddress
        }
    }
    
    
    
    //MARK: BUTTONS ACTIONS
    @IBAction func crossBtn(_ sender: UIButton) {
        self.timer.invalidate()
        self.removeFromSuperview()
    }
    
    @IBAction func resendBtn(_ sender: UIButton) {
        guard self.isNumber == false else {return}
        self.checkEmailApi()
    }
    
    @IBAction func updateBtn(_ sender: UIButton) {
        guard self.pinView.getPin().isEmpty == false else{
            showSwiftyAlert("", "Please enter CODE", false)
            return
        }
        
        guard self.pinView.getPin() == self.OTP else{
            showSwiftyAlert("", "Invalid CODE", false)
            return
        }
        
        self.resendLbl.text = " "
        self.timer.invalidate()
        
        if self.isNumber{
            self.updatePhoneApi()
        }else{
            self.updateEmailApi()
        }
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
            self.resendLbl.text = " "
            self.checkPhoneApi()
        } else{
            let diff = String(format: "%.02d:%.02d", minutes, seconds).replacingOccurrences(of: "-", with: "")
            self.resendLbl.text = "we'll resend code in \(diff)"
        }
    }
}

extension ChangeNumberView {
    
    //MARK: API
    func checkPhoneApi(){
        let params: Parameters = [
            "phone": self.emailNum,
            "country_code" : self.countryCode
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.check_phone , success: { (json) in
            hideLoader()
            self.OTP = json["data"]["otp"].stringValue
            showSwiftyAlert("", json["msg"].stringValue, true)
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    func updatePhoneApi(){
        let params: Parameters = [
            "phone": self.emailNum,
            "countryCode" : self.countryCode
        ]
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.update_phone, method: .put , success: { (json) in
            userInfo.isVerified = 1
            userInfo.countryCode = self.countryCode
            userInfo.phone = self.emailNum
            hideLoader()
            guard let completion = self.completion else{
                self.removeFromSuperview()
                return
            }
            completion(true)
            self.removeFromSuperview()
            showSwiftyAlert("", json["msg"].stringValue, true)
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    func checkEmailApi(){
        let params: Parameters = [
            "email": self.emailNum
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.send_otp , success: { (json) in
            hideLoader()
            self.OTP = json["data"]["otp"].stringValue
            showSwiftyAlert("", json["msg"].stringValue, true)
            
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    func updateEmailApi(){
        let params: Parameters = [
            "email": self.emailNum
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.update_email, method: .put , success: { (json) in
            userInfo.emailVerify = 1
            userInfo.email = self.emailNum
            hideLoader()
            guard let completion = self.completion else{
                self.removeFromSuperview()
                return
            }
            completion(true)
            self.removeFromSuperview()
            showSwiftyAlert("", json["msg"].stringValue, true)
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
}
