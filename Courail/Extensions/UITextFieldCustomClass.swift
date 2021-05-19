//
//  UITextFieldCustomClass.swift
//  LevelUp
//
//  Created by Rishabh Arora on 2/13/18.
//  Copyright © 2018 Rishabh Arora. All rights reserved.
//

import Foundation
import UIKit

class UITextFieldCustomClass:UITextField {
    
    @IBInspectable var placeholderColor: UIColor = UIColor.black {
        didSet {
            if let placeholder = self.placeholder {
                let attributes = [NSAttributedString.Key.foregroundColor: placeholderColor]
                attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
            }
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderWidth:CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor:UIColor {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }   
    
    @IBInspectable var paddingLeftCustom: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var paddingRightCustom: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable var leftViewImage: UIImage?{
        didSet{
            if leftViewImage != nil {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height))
                view.clipsToBounds = true
                let imgView = UIImageView()
                imgView.contentMode = .scaleAspectFit
                imgView.clipsToBounds = true
                imgView.image = leftViewImage
                view.addSubview(imgView)
                imgView.translatesAutoresizingMaskIntoConstraints = false
                imgView.tintColor = .lightGray
                imgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
                imgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
                imgView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
                imgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
                self.leftView = view
                self.leftViewMode = .always
            }
        }
    }
    
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.insetBy(dx: 10, dy: 0)
//    }
//    
//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.insetBy(dx: 10, dy: 0)
//    }
    
}

extension UITextField {
    
    var isEmpty: Bool {
        if self.text == nil || self.text == "" || self.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return true
        }
        return false
    }
    
    func setPlaceholder(color: UIColor, size: CGFloat, style: UIFont) {
        let attributedString = NSAttributedString(string: self.placeholder!, attributes:[NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: style.withSize(size)])
        self.attributedPlaceholder = attributedString
    }
    
    var isEmailValid: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text!)
    }
    
    var isPasswordValid:Bool{
        let stricterFilterString = "^(?=.*\\d)[A-Za-z\\d$@$!%*?&]{8,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", stricterFilterString)
        return emailTest.evaluate(with: self.text!)
    }
    
    var isValidPhoneNo: Bool{
        let phoneRegex = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneNoTest = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return phoneNoTest.evaluate(with: self.text!)
    }
    
    
}

extension UITextView {
    
    var isEmpty: Bool {
        if self.text == nil || self.text == "" || self.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return true
        }
        return false
    }
    
}


