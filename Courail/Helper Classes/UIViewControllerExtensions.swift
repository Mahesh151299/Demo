//
//  UIViewControllerExtensions.swift
//  InstaDate
//
//  Created by apple on 13/03/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit


extension UIViewController{
    
    func showWhiteStatusBar(_ show: Bool){
        UIApplication.shared.statusBarStyle = (show == true) ? UIStatusBarStyle.lightContent : UIStatusBarStyle.default
    }
    
    
    func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func showalertview(messagestring:String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: messagestring, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func showalertview(messagestring:String, Buttonmessage: String ,handler:@escaping () -> Void ){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: messagestring, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Buttonmessage, style: .default, handler: { action  in
                DispatchQueue.main.async {
                    handler()
                }
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func showAlert(msg:String, doneBtnTitle: String, cancelBtnTitle: String, handler:@escaping () -> Void ){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: msg, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: doneBtnTitle, style: .default, handler: { action  in
                DispatchQueue.main.async {
                    handler()
                }
            }))
            alert.addAction(UIAlertAction(title: cancelBtnTitle, style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
           }
       }
    
    func showAlertTwoActions(msg:String, doneBtnTitle: String, cancelBtnTitle: String, doneActions:@escaping () -> Void, cancelActions:@escaping () -> Void ){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: msg, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: doneBtnTitle, style: .default, handler: { action  in
                DispatchQueue.main.async {
                    doneActions()
                }
            }))
            alert.addAction(UIAlertAction(title: cancelBtnTitle, style: .destructive, handler: { action  in
                DispatchQueue.main.async {
                    cancelActions()
                }
            }))
            self.present(alert, animated: true, completion: nil)
           }
       }
    
    
    func attributedText(name: String, body: String)-> NSAttributedString{
        let fontName = UIFont.init(name: "Calibri-Bold", size: 12) ?? UIFont.systemFont(ofSize: 12)
        let fontBody = UIFont.init(name: "Calibri", size: 12) ?? UIFont.systemFont(ofSize: 12)
        let AttributesName : [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font : fontName]
        let AttributesBody : [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font : fontBody]
        
        let customName = NSAttributedString.init(string: name, attributes: AttributesName)
        let space = NSAttributedString.init(string: " ")
        let customBody = NSAttributedString.init(string: body, attributes: AttributesBody)
        let combinedStr = NSMutableAttributedString()
        combinedStr.append(customName)
        combinedStr.append(space)
        combinedStr.append(customBody)
        
        return combinedStr
    }
    
    
    
    func showalertViewcontroller(message:String,handler:@escaping () -> Void){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            action in
            DispatchQueue.main.async {
                handler()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func shareAction(content: [Any] , sender: UIView){
        let activityViewController = UIActivityViewController(
            activityItems: content,
            applicationActivities: nil)
        //        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        //        self.present(activityViewController, animated: true, completion: nil)
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = sender as UIView
            popoverController.sourceRect = sender.bounds
        }
        self.present(activityViewController, animated: true, completion: nil)
    }

}

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
