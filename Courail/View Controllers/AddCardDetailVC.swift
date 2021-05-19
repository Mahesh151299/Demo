//
//  AddCardDetailVC.swift
//  Courail
//
//  Created by mac on 27/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import CreditCardValidator

class AddCardDetailVC: UIViewController {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var cardImage: UIImageView!
    
    @IBOutlet weak var cardNo: UITextField!
    
    @IBOutlet weak var cardExpiry: UITextField!
    
    @IBOutlet weak var cardCVV: UITextField!
    
    @IBOutlet weak var cardZip: UITextField!
    
    @IBOutlet weak var saveBtnOut: UIButton!
    
    //MARK: VARIABLES
    
    let cardValidator = CreditCardValidator()
    var cardType = ""
    var isAmex = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cardImage.image = UIImage(named: "cardGray")
        
        self.cardNo.delegate = self
        self.cardExpiry.delegate = self
        self.cardCVV.delegate = self
        self.cardZip.delegate = self
        
        self.cardNo.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .editingChanged)
        self.cardExpiry.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .editingChanged)
        self.cardCVV.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .editingChanged)
        self.cardZip.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK: BUTTONS ACTIONS
    @IBAction func backBtnAct(_ sender: Any) {
        self.view.endEditing(true)
        self.pop()
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        guard self.checkValidations(true) == true else {return}
        self.addCardApi()
    }
    
    func checkValidations(_ showAlert: Bool)-> Bool{
        self.checkCardType(self.cardNo)
        
        if (self.cardNo.text ?? "").isEmpty == true{
            showAlert ? showSwiftyAlert("", "Please enter Card number", false) : ()
            self.saveBtnOut.setTitleColor(.lightGray, for: .normal)
            return false
        }else if (self.cardNo.text ?? "").count != 19 && self.isAmex == false{
            showAlert ? showSwiftyAlert("", "Please enter a Valid Card number", false) : ()
            self.saveBtnOut.setTitleColor(.lightGray, for: .normal)
            return false
        }else if (self.cardNo.text ?? "").count != 17 && self.isAmex == true{
            showAlert ? showSwiftyAlert("", "Please enter a Valid Card number", false) : ()
            self.saveBtnOut.setTitleColor(.lightGray, for: .normal)
            return false
        }else if self.checkCard() == false{
            showAlert ? showSwiftyAlert("", "Please enter a Valid Card number", false) : ()
            self.saveBtnOut.setTitleColor(.lightGray, for: .normal)
            return false
        }else if (self.cardExpiry.text ?? "").isEmpty == true{
            showAlert ? showSwiftyAlert("", "Please enter Expiry (MM/YY)", false) : ()
            self.saveBtnOut.setTitleColor(.lightGray, for: .normal)
            return false
        }else if (self.cardExpiry.text ?? "").count != 5{
            showAlert ? showSwiftyAlert("", "Please enter a Valid Expiry (MM/YY)", false) : ()
            self.saveBtnOut.setTitleColor(.lightGray, for: .normal)
            return false
        } else if (self.cardCVV.text ?? "").isEmpty == true{
            showAlert ? showSwiftyAlert("", "Please enter CVV", false) : ()
            self.saveBtnOut.setTitleColor(.lightGray, for: .normal)
            return false
        } else if (self.cardCVV.text ?? "").count != 3 && self.isAmex == false{
            showAlert ? showSwiftyAlert("", "Please enter a Valid CVV", false) : ()
            self.saveBtnOut.setTitleColor(.lightGray, for: .normal)
            return false
        }else if (self.cardCVV.text ?? "").count != 4 && self.isAmex == true{
            showAlert ? showSwiftyAlert("", "Please enter a Valid CVV", false) : ()
            self.saveBtnOut.setTitleColor(.lightGray, for: .normal)
            return false
        } else if (self.cardZip.text ?? "").isEmpty == true{
            showAlert ? showSwiftyAlert("", "Please enter ZipCode", false) : ()
            self.saveBtnOut.setTitleColor(.lightGray, for: .normal)
            return false
        }else if (self.cardZip.text ?? "").count != 5{
            showAlert ? showSwiftyAlert("", "Please enter a Valid ZipCode", false) : ()
            self.saveBtnOut.setTitleColor(.lightGray, for: .normal)
            return false
        } else{
            self.saveBtnOut.setTitleColor(appColorBlue, for: .normal)
            return true
        }
    }
    
    func checkCard()-> Bool{
        let cardNo = self.cardNo.text?.replacingOccurrences(of: " ", with: "") ?? ""
        return self.cardValidator.validate(string: cardNo)
    }
}


extension AddCardDetailVC : UITextFieldDelegate{
    
    @objc func textFieldChanged(_ sender: UITextField){
        _ = self.checkValidations(false)
    }
    
    func checkCardType(_ textfield : UITextField){
        if let type = self.cardValidator.type(from: textfield.text!){
            print(type.name) // Visa, Mastercard, Amex etc.
            self.cardType = type.name
            let img = UIImage(named: type.name.lowercased())
            self.cardImage.image = img
            
            if type.name.lowercased() == "amex"{
                self.isAmex = true
                self.cardCVV.placeholder = "1234"
            } else{
                self.isAmex = false
                self.cardCVV.placeholder = "123"
            }
        } else {
            //Can't detect type of credit card
            self.cardType = ""
            self.cardImage.image = UIImage(named: "cardGray")
            self.isAmex = false
            self.cardCVV.placeholder = "123"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.cardNo{
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = isAmex ? newString.formattedAmexCard() : newString.formattedCard()
            
            _ = self.checkValidations(false)
            return false
        }else if textField == self.cardExpiry{
            let currentText = textField.text! as NSString
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            if string == "" {
                if textField.text?.count == 3{
                    textField.text = "\(updatedText.prefix(1))"
                    return false
                }
                return true
            }
            if updatedText.count == 5{
                expDateValidation(dateStr:updatedText)
                return updatedText.count <= 5
            } else if updatedText.count > 5{
                return updatedText.count <= 5
            } else if updatedText.count == 1{
                if updatedText > "1"{
                    return updatedText.count < 1
                }
            }  else if updatedText.count == 2{   //Prevent user to not enter month more than 12
                if updatedText > "12"{
                    return updatedText.count < 2
                }
            }
            textField.text = updatedText
            if updatedText.count == 2 {
                textField.text = "\(updatedText)/"   //This will add "/" when user enters 2nd digit of month
            }
            return false
        }
        else if textField == self.cardCVV{
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let numberOfChars = newText.count
            if self.isAmex{
                return numberOfChars < 5
            } else{
                return numberOfChars < 4
            }
        }
        else if textField == self.cardZip{
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let numberOfChars = newText.count
            return numberOfChars < 6
        } else{
            return true
        }
    }
     
    
    func expDateValidation(dateStr:String) {
        let currentYear = Calendar.current.component(.year, from: Date()) % 100   // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)
        
        let enterdYr = Int(dateStr.suffix(2)) ?? 0   // get last two digit from entered string as year
        let enterdMonth = Int(dateStr.prefix(2)) ?? 0  // get first two digit from entered string as month
        print(dateStr) // This is MM/YY Entered by user
        if enterdYr > currentYear
        {
            if (1 ... 12).contains(enterdMonth){
                print("Entered Date Is Right")
            } else
            {
                print("Entered Date Is Wrong")
            }
        } else  if currentYear == enterdYr {
            if enterdMonth >= currentMonth
            {
                if (1 ... 12).contains(enterdMonth) {
                    print("Entered Date Is Right")
                }  else
                {
                    print("Entered Date Is Wrong")
                }
            } else {
                print("Entered Date Is Wrong")
            }
        } else
        {
            print("Entered Date Is Wrong")
        }
    }
    
}


extension AddCardDetailVC {
    
    //MARK:- API
    
    func addCardApi(){
        let params: Parameters = [
            "accountnumber": self.cardNo.text!.replacingOccurrences(of: " ", with: ""),
            "expmonth" : self.cardExpiry.text!.components(separatedBy: "/").first ?? "",
            "expyear": self.cardExpiry.text!.components(separatedBy: "/").last ?? "",
            "cvc" : self.cardCVV.text!,
            "zip" : self.cardZip.text!,
            "card_type" : self.cardType
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.createCard , success: { (json) in
            let cardInfo = CardModel.init(json: json["data"])
            self.defaultCardApi(cardInfo: cardInfo,msg: json["msg"].stringValue)
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    func defaultCardApi(cardInfo: CardModel, msg: String){
        let params: Parameters = [
            "card_id": "\(cardInfo.internalIdentifier ?? 0)"
        ]
        
        ApiInterface.requestApi(params: params, api_url: API.select_default_card, method: .put, success: { (json) in
            hideLoader()
            userInfo.card_default = cardInfo
            if let vc = self.navigationController?.viewControllers.last(where: {($0 as? QueueDeliveryDetailVC) != nil}){
                self.navigationController?.popToViewController(vc, animated: true)
            } else{
                self.pop()
            }
        }) { (error, json) in
            hideLoader()
            userInfo.card_default = cardInfo
            showSwiftyAlert("", error, false)
        }
    }
}
