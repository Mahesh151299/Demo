//
//  ImageExtensions.swift
//  InstaDate
//
//  Created by apple on 13/03/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

extension String{
    
    func convertISTToLocalDate(inputFormat: String, outputFormat: String)-> String{
        let formatter = DateFormatter()
        formatter.dateFormat = inputFormat
        formatter.timeZone = TimeZone(abbreviation: "IST")
        
        let oldDate = formatter.date(from: self)
        
        let formatter2 = DateFormatter()
        formatter2.timeZone = TimeZone.current
        
        formatter2.dateFormat = outputFormat
        formatter2.locale = Locale.current
        formatter2.amSymbol = "AM"
        formatter2.pmSymbol = "PM"
        
        if oldDate != nil{
            return formatter2.string(from: oldDate!)
        }
        return self
    }
    
    func convertToLocalDate(inputFormat: String, outputFormat: String)-> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = inputFormat
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        let oldDate = formatter.date(from: self)
        
        formatter.dateFormat = outputFormat
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        if oldDate != nil{
            return formatter.string(from: oldDate!)
        }
        return self
    }
    
    func convertToDate()-> Date?{
        if let stampDouble = Double(self){
            let date = Date(timeIntervalSince1970: stampDouble)
            return date
        } else{
            return nil
        }
    }
    
    func convertStampToDate(_ timeZone : TimeZone)-> Date?{
        if let stampDouble = Double(self){
            let date = Date(timeIntervalSince1970: stampDouble)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy hh:mm:ss a"
            formatter.timeZone = timeZone
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            let dateStr = formatter.string(from: date)
            return formatter.date(from: dateStr)
        } else{
            return nil
        }
    }
    
    func convertToDate(format: String, timeZone: TimeZone)-> Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.date(from: self)
    }
    
    
    func convertStamp(format: String, timeZone : TimeZone)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        if let stampDouble = Double(self){
            let date = Date(timeIntervalSince1970: stampDouble)
            return formatter.string(from: date)
        } else{
            return self
        }
    }
    
    
    func convertToLocalTime(inputFormat: String, inputTimeZone: TimeZone , outputFormat: String, outputTimeZone: TimeZone)-> String{
        let formatter = DateFormatter()
        formatter.dateFormat = inputFormat
        formatter.timeZone = inputTimeZone
        let oldDate = formatter.date(from: self)
        
        formatter.dateFormat = outputFormat
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.timeZone = outputTimeZone
        if oldDate != nil{
            return formatter.string(from: oldDate!)
        }
        return self
    }
    
    func localize()-> String{
        return NSLocalizedString(self, comment: self)
    }
    
    func isValidPasswordLimit() -> Bool {
        let emailFormat = ".{8,15}$"
        return NSPredicate(format:"SELF MATCHES %@", emailFormat).evaluate(with: self)
    }
    
    func validate() -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    func checkCapital() -> Bool{
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: self)
        return capitalresult
    }
    
    func isValidateCard() -> Bool {
        let MobileRegex = "/((3(4[0-9]{2}|7[0-9]{2})( |-|)[0-9]{6}( |-|)[0-9]{5}))|((3(7[0-9]{2}|7[0-9]{2})( |-|)[0-9]{4}( |-|)[0-9]{4}( |-|)[0-9]{4}))|((4[0-9]{3}( |-|)([0-9]{4})( |-|)([0-9]{4})( |-|)([0-9]{4})))|((5[0-9]{3}( |-|)([0-9]{4})( |-|)([0-9]{4})( |-|)([0-9]{4})))/g|(\\d{4} *\\d{4} *\\d{4} *\\d{4})"
        return NSPredicate(format: "SELF MATCHES %@", MobileRegex).evaluate(with: self)
    }
    
    func isValidateCVV() -> Bool {
        let MobileRegex = "^\\d{3,4}$"
        return NSPredicate(format: "SELF MATCHES %@", MobileRegex).evaluate(with: self)
    }
    
    func isValidateExpireDate() -> Bool {
        let MobileRegex = "(0[1-9]|1[0-2])\\/?(([0-9]{4})|[0-9]{2}$)"
        return NSPredicate(format: "SELF MATCHES %@", MobileRegex).evaluate(with: self)
    }
    
    
    func passwordValidation() -> Bool {
        let password = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{4,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", password)
        let result =  passwordTest.evaluate(with: self)
        return result
        
    }
    
    func removeCommas() -> String {
        return self.replacingOccurrences(of: ",", with: "")
    }
    
    var isBackspace: Bool {
        let char = self.cString(using: String.Encoding.utf8)!
        return strcmp(char, "\\b") == -92
    }
    
    func chopPrefix(_ count: Int = 1) -> String {
        return substring(from: self.index(startIndex, offsetBy: count))
    }
    
    func chopSuffix(_ count: Int = 1) -> String {
        
        return substring(to: self.index(endIndex, offsetBy: -count))
    }
    
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    func base64Conv() -> String{
        
        let longstring = self
        let data = (longstring).data(using: String.Encoding.utf8)
        let base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64
        
    }
    
    func base64Decoded() -> String? {
        var base64Encoded = self
        
        if base64Encoded.last == "\n" || base64Encoded.last == " " {
            base64Encoded.removeLast()
        }
        
        if Data(base64Encoded: base64Encoded) == nil{
            
            return self
            
        } else{
            
            let decodedData = Data(base64Encoded: base64Encoded)!
            
            if String(data: decodedData, encoding: .utf8) == nil{
                return self
            }
            
            let decodedString = String(data: decodedData, encoding: .utf8)!
            
            return decodedString
        }
    }
    
    func isValidateEmail() -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    func isValidatePassword() -> Bool {
        
        //        let passwordRegex = "(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,15}"
        let passwordRegex = "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\\W]).{8,64})"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func formattedNumber() -> String {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX) XXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func formattedCard() -> String {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "XXXX XXXX XXXX XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func formattedAmexCard() -> String {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "XXXX XXXXXX XXXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    
    
    func floorValidation() -> String {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "XXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func isValidateMobile() -> Bool {
        let mobile = self.replacingOccurrences(of: "[- ()]", with: "", options: .regularExpression, range: nil)
        let MobileRegex = "^\\d{10,10}$"
        return NSPredicate(format: "SELF MATCHES %@", MobileRegex).evaluate(with: mobile)
    }
    
    
    func isValidNumeric() -> Bool{
        let numericRegex = "^(\\d{0,8})((((\\.){0,1})(\\d{0,8})))"
        return NSPredicate(format: "SELF MATCHES %@", numericRegex).evaluate(with: self)
    }
    
    
    func isMedPassword1() -> Bool {
        let passwordRegex = "(?=.*[A-Z])(?=.*\\d).{8,15}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    
    func isMedPassword2() -> Bool {
        let passwordRegex = "(?=.*[a-z])(?=.*\\d).{8,15}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    
    func isStrongPassword() -> Bool {
        let passwordRegex = "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\\W]).{8,64})"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    
    func isValidName() -> Bool {
        let passwordRegex = "[a-zA-Z][a-zA-Z0-9]{1,26}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    
}

