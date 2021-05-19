//
//  ImagePicker.swift
//  FindThat
//
//  Created by apple on 04/09/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import Photos
import TOCropViewController

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?, video: URL?)
}

open class ImagePicker: NSObject{
    
    private let pickerController = UIImagePickerController()
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    
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
    
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate , isVideo: Bool? = false) {
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        if isVideo == true{
            self.pickerController.mediaTypes = ["public.movie"]
            self.pickerController.allowsEditing = true
            self.pickerController.videoMaximumDuration = 60
        } else{
            self.pickerController.mediaTypes = ["public.image"]
        }
        
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            
            if title == "Photo Library"{
                self.checkPermission(completion: { (result) in
                    if result == true{
                        DispatchQueue.main.async {
                            self.presentationController?.present(self.pickerController, animated: true)
                        }
                    }
                })
            }else if title == "Take photo"{
                //Camera
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                    if response {
                        //access granted
                        DispatchQueue.main.async {
                            self.presentationController?.present(self.pickerController, animated: true)
                        }
                    } else{
                        showSwiftyAlert("", "Please enable camera permission to access device camera", false)
                    }
                }
            } else{
                DispatchQueue.main.async {
                    self.presentationController?.present(self.pickerController, animated: true)
                }
            }
        }
    }
    
    public func present(from sourceView: UIView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = UIColor.darkGray
        
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        //        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
        //            alertController.addAction(action)
        //        }
        if let action = self.action(for: .photoLibrary, title: "Photo Library") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        guard let compressdImage = image?.compressImage() else{
            controller.dismiss(animated: true, completion: nil)
            return
        }
        
        controller.dismiss(animated: false, completion: {
            let cropViewController = TOCropViewController(image: compressdImage)
            cropViewController.delegate = self
            self.presentationController?.present(cropViewController, animated: false, completion: nil)
        })
        
    }
}


extension ImagePicker: UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image = info[.originalImage] as? UIImage{
            self.pickerController(picker, didSelect: image)
        }else if let video = info[.mediaURL] as? URL{
            picker.dismiss(animated: false, completion: {
                self.delegate?.didSelect(image: nil, video: video)
            })
        }else{
            return self.pickerController(picker, didSelect: nil)
        }
        
    }
}

extension ImagePicker : TOCropViewControllerDelegate{
    
    public func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        
        cropViewController.dismiss(animated: false, completion: nil)
        let img = image
        img.accessibilityHint = "1"
        
        self.delegate?.didSelect(image: img, video: nil)
    }
    
}

