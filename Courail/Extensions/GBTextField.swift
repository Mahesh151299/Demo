//
//  GBTextField.swift
//  iFixit4U
//
//  Created by Vivekcql on 15/06/18.
//  Copyright © 2018 Gurindercql. All rights reserved.
//

import UIKit

@IBDesignable
class GBTextField: UITextField {

    @IBInspectable var cornerRadius : CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var leftViewImage: UIImage?{
        didSet{
            let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height))
            let imageView = UIImageView(image: leftViewImage)
            view.addSubview(imageView)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: [:], views: ["v0":imageView]))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0]-10-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: [:], views: ["v0":imageView]))
            self.leftView = view
            self.leftViewMode = .always
        }
    }
    
    @IBInspectable var rightViewImage: UIImage?{
        didSet{
            let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height))
            let imageView = UIImageView(image: rightViewImage)
            view.addSubview(imageView)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: [:], views: ["v0":imageView]))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0]-10-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: [:], views: ["v0":imageView]))
            self.rightView = view
            self.rightViewMode = .always
        }
    }
    
    
   
    
//MARK:-  Add Space in front of Text Field View
    
    var textPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);
    
    @IBInspectable var padding: CGFloat = 0{
        didSet{
            if rightViewImage != nil && leftViewImage != nil{
                textPadding = UIEdgeInsets(top: 0, left: self.frame.size.height, bottom: 0, right: self.frame.size.height)
            }else if rightViewImage != nil{
                textPadding = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: self.frame.size.height)
            }else if leftViewImage != nil{
                textPadding = UIEdgeInsets(top: 0, left: self.frame.size.height, bottom: 0, right: padding)
            }else{
                textPadding = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
            }
        }
    }
    /*
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, textPadding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, textPadding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, textPadding)
    }
    */
    
}
