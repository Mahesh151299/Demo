//
//  OpenCameraAlertVC.swift
//  Courail
//
//  Created by mac on 04/03/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Photos
import TOCropViewController

protocol CameraAlertDelegate: class {
    func imageSelected(_ img: UIImage)
}

class OpenCameraAlertVC: UIViewController {
    
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIViewCustomClass!
    //MARK:- VRIABLES
    private let pickerController = UIImagePickerController()
    
    weak var delegate : CameraAlertDelegate?
    
    var isClearBG = false
    
    var spaceBottom : CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerController.delegate = self
        self.pickerController.mediaTypes = ["public.image"]
        
        self.bgView.backgroundColor = isClearBG ? .clear :  .white
        self.bottom.constant = self.spaceBottom
        // Do any additional setup after loading the view.
    }
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func cancelBtnAct(_ sender: Any) {
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
    @IBAction func openCameraAct(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            self.pickerController.sourceType = UIImagePickerController.SourceType.camera
            self.pickerController.allowsEditing = false
            self.present(self.pickerController, animated: true, completion: nil)
        }else{
            showSwiftyAlert("", "Unable to access Camera", false)
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
        
    }
    
    @IBAction func galleryBtn(_ sender: UIButton) {
        self.checkPermission(completion: { (result) in
            if result == true{
                DispatchQueue.main.async {
                    self.pickerController.sourceType = .photoLibrary
                    self.present(self.pickerController, animated: true)
                }
            }
        })
    }
    
    public func checkPermission(completion: @escaping(Bool)-> Void){
        if PHPhotoLibrary.authorizationStatus() == .denied{
            showSwiftyAlert("", "Please enable photos permission to access photo library", false)
        } else{
            PHPhotoLibrary.requestAuthorization { (result) in
                if result == .authorized{
                    completion(true)
                } else{
                    completion(false)
                }
            }
        }
    }
    
}


extension OpenCameraAlertVC: UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            self.pickerController(picker, didSelect: image)
        }else{
            return self.pickerController(picker, didSelect: nil)
        }
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        guard let compressdImage = image?.compressImage() else{
            controller.dismiss(animated: true, completion: nil)
            self.removeFromParent()
            self.view.removeFromSuperview()
            return
        }
        
        controller.dismiss(animated: false, completion: {
            let cropViewController = TOCropViewController(image: compressdImage)
            cropViewController.delegate = self
            self.present(cropViewController, animated: false, completion: nil)
        })
    }
    
}

extension OpenCameraAlertVC : TOCropViewControllerDelegate{
    
    public func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        
        cropViewController.dismiss(animated: false, completion: nil)
        let img = image
        img.accessibilityHint = "1"
        
        self.delegate?.imageSelected(img)
        
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
}

