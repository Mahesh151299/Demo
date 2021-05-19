//
//  SharedTextField.swift
//  Browser App
//
//  Created by Gaurav Gupta
//  .
//

import UIKit

@IBDesignable
class SharedTextField: UITextField {
    
    @IBInspectable var inset: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        //return bounds.insetBy(dx: inset, dy: inset / 3)
        var newBounds = bounds
        newBounds.origin.x += 5
        newBounds.size.width -= 25
               return newBounds
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.editingRect(forBounds: bounds)
        rect.size.width = rect.size.width
        return textRect(forBounds: rect)
    }
	
	override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
		var rect = super.rightViewRect(forBounds: bounds)
		rect.origin.x -= 7
       // rect.size.width = rect.size.width - 20.0
		return rect
	}
	
}
