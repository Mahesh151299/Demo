//
//  UIViewExtensions.swift
//  InstaDate
//
//  Created by apple on 13/03/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

extension UIView {
    
    @available(iOS 10.0, *)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }
    
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = .init(x: 0.0, y: 0.5)
        gradient.endPoint = .init(x: 1.0, y: 0.5)
        gradient.accessibilityHint = "gradientLayer"
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    
    func circularShadow(rad: CGFloat , color: UIColor){
        // add the shadow to the base view
        self.clipsToBounds = true
        self.layer.cornerRadius = rad
        self.layer.masksToBounds = false
        
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 2.0
        self.layoutIfNeeded()
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: rad).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func circularShadowCustom(rad: CGFloat , color: UIColor, bgColor: UIColor){
        // add the shadow to the base view
        self.clipsToBounds = true
        self.layer.cornerRadius = rad
        self.layer.masksToBounds = false
        
        self.backgroundColor = bgColor
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 2.0
        self.layoutIfNeeded()
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: rad).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func roundedShadow(cornerRad: CGFloat){
        // border radius
        layer.cornerRadius = cornerRad
        // border
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        
        // drop shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3.0
        layer.shadowOffset = CGSize(width: 20.0, height: 10.0)
    }
    
    func addShadowsToImage(){
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        self.layer.shadowOpacity = 1
    }
    
    func addShadows(){
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 1
    }
    
    func addShadowsRadius(){
        self.layoutIfNeeded()
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.layer.cornerRadius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 3
        
//        self.layer.borderColor = UIColor.lightGray.cgColor
//        self.layer.borderWidth = 0.5
    }
    
    func addShadowsRadius(shadowRadius: CGFloat){
            self.layoutIfNeeded()
            self.layer.masksToBounds = false
            self.layer.cornerRadius = self.layer.cornerRadius
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
//            self.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        self.layer.shadowOffset = CGSize.zero
            self.layer.shadowOpacity = 0.3
            self.layer.shadowRadius = shadowRadius
        }
   
    
    func startProgresshud(){
        DispatchQueue.main.async {
            if let _ = self.viewWithTag(40) {
                //View is already locked
            }
            else {
                self.isUserInteractionEnabled = false
                let lockView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width / 4, height: self.frame.size.width / 4))
                lockView.layer.cornerRadius = 10
                lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
                lockView.tag = 40
                lockView.alpha = 0.0
                
                let activity = UIActivityIndicatorView()
                activity.color = .white
                activity.center = lockView.center
                activity.startAnimating()
                lockView.addSubview(activity)
                
                self.addSubview(lockView)
                
                UIView.animate(withDuration: 0.2) {
                    lockView.alpha = 1.0
                }
                lockView.center = self.center
            }
        }
    }
    
    func stopProgressHud() {
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = true
            if let lockView = self.viewWithTag(40) {
                UIView.animate(withDuration: 0.2, animations: {
                    lockView.alpha = 0.0
                }) { finished in
                    lockView.removeFromSuperview()
                }
            }
        }
    }

    
    func setTop(topAnchor: NSLayoutConstraint){
        topAnchor.constant = 30
    }
    
    
    func dashedBorderLayerWithColor(color:CGColor , view: UIView) -> CAShapeLayer {
        
        let  borderLayer = CAShapeLayer()
        borderLayer.name  = "borderLayer"
        let frameSize = view.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        borderLayer.bounds=shapeRect
        borderLayer.position = CGPoint(x: frameSize.width / 2 , y: frameSize.height / 2)
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color
        borderLayer.lineWidth = 0.5
        borderLayer.lineJoin=CAShapeLayerLineJoin.round
        borderLayer.lineDashPattern = [2 , 2]
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint.init(x: view.frame.width / 2, y: 0))
        path.addLine(to: CGPoint.init(x: view.frame.width / 2, y: view.frame.height))
        
        borderLayer.path = path.cgPath
        
        return borderLayer
        
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor?, borderWidth : CGFloat?) {
        self.layoutIfNeeded()
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
