//
//  BaseClass.swift
//  Daleoak
//
//  Created by Abhishek Sharma on 24/09/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit


import LGSideMenuController

class BaseClass: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    
    func pushTap(_ VC: String, _ storyBoard: UIStoryboard) {
        let vc = storyBoard.instantiateViewController(withIdentifier: "\(VC)")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func applyGradientWhite(colours: [UIColor], btn: UIButton) {
        let gradLa = btn.layer.sublayers?.filter({$0.accessibilityHint == "gradientLayer"}).first
        gradLa?.removeFromSuperlayer()
        
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let alert = UIAlertController()
            alert.title = "You don't have camera"
            
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery(){
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            let cameraImagePicker = UIImagePickerController()
            cameraImagePicker.delegate = self
            cameraImagePicker.sourceType = .photoLibrary
            cameraImagePicker.allowsEditing = false
            self.present(cameraImagePicker, animated: true, completion: nil)
            
        }else{
            let alert = UIAlertController()
            alert.title = "You don't have gallary"
            
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func showImagePicker(){
        
        imagePicker.sourceType = .photoLibrary
        
        let alert = UIAlertController(title: "Select Source", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let openCamera = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { (data) in
            self.openCamera()
        }
        let openGalary = UIAlertAction(title: "Gallery", style: .default) { (data) in
            self.openGallery()
        }
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(openCamera)
        alert.addAction(openGalary)
        alert.addAction(cancelBtn)
        alert.view.tintColor = .black
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToHomeVC(){
        
    }
    
   
    
    func time24hrs12hrs(_ time: String?) -> String{
        if time == ""{
            return ""
        }else{
            let dateString = time
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let timeStr = dateFormatter.date(from: dateString ?? "")
            dateFormatter.dateFormat = "h:mm a"
            
            return dateFormatter.string(from: timeStr!)
        }
        
    }
    
    func time12hrs24hrs(_ time: String?) -> String{
        
        if time == ""{
            return ""
        }else{
            let dateString = time
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let timeStr = dateFormatter.date(from: dateString ?? "")
            dateFormatter.dateFormat = "HH:mm"
            
            return dateFormatter.string(from: timeStr!)
        }
        
    }
    
//    func goToInitialVc(){
//        loginStatus = false
//        let vc = userStoryBoard.instantiateViewController(withIdentifier:"LoginVc") as! LoginVc
//        let destinationController = UINavigationController.init(rootViewController: vc)
//        destinationController.isNavigationBarHidden = true
//        applicationDelegate.window?.rootViewController = destinationController
//    }

}

extension UITextField{
    

    
    func validateEmail() -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        if !emailPredicate.evaluate(with: self.text){
            
            return false
        }else{
            return true
        }
        
    }
    
}

extension UIViewController{
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dismissTap(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
   
    
    
}
