//
//  AgreementView.swift
//  Courail
//
//  Created by Omeesh Sharma on 29/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AgreementView: UIView {
    
    
    //MARK: OUTLETS
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var iconView: UIViewCustomClass!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var warningLbl: UILabel!
    
    @IBOutlet weak var checkBox: UIImageView!
    
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var idImage: UIImageViewCustomClass!
    @IBOutlet weak var continueBtnOut: UIButtonCustomClass!
    
    //MARK: VARIABLES
    
    var completion : (()-> ())?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect,category: String, completion: @escaping (()-> ())) {
        super.init(frame: frame)
        self.completion = completion
        self.setup(category: category)
    }
    
    //MARK:- ACTIVITY CYCLE
    
    func setup(category: String){
        DispatchQueue.main.async {
            self.bgView = Bundle.main.loadNibNamed("AgreementView", owner: self, options: nil)?.first as? UIView
            self.bgView.frame = self.bounds
            self.addSubview(self.bgView)
            self.checkBox.image = UIImage(named: "imgCheckBox")
            self.continueBtnOut.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            
            if let data = appCategories.arrayValue.first(where: {$0["category"].stringValue.lowercased() == category.lowercased()}){
                self.icon.image = UIImage(named: data["icon"].stringValue)
                self.iconView.backgroundColor = hexStringToUIColor(hex: data["hex"].stringValue)
            }
            
            var warningInfo =  NSMutableAttributedString(string: "")
            var warningRange = NSRange()
            switch category.lowercased(){
            case "cannabis":
                self.infoLbl.text = "CANNABIS PRODUCTS REQUIRE VERIFICATION THAT YOU ARE AT LEAST 21 YEARS OF AGE OR AT LEAST 18 YEARS OF AGE WITH A VALID MEDICAL RECOMMENDATION. DO YOU AGREE TO  ATTACH A COPY OF ID HERE AS WELL AS PRESENT MATCHING IDENTIFICATION TO THE COURIAL?"
                warningInfo = NSMutableAttributedString(string: "WARNING: Keep out of reach of children. For use only by adults 21 years of age and older. In compliance with MAUCRSA. For more Information go to https://cannabis.ca.gov/cannabis-regulations.")
                warningRange = warningInfo.mutableString.range(of: "WARNING:")
            case "wine":
                self.infoLbl.text = "ALCOHOLIC BEVERAGES REQUIRE VERIFICATION THAT YOU ARE AT LEAST 21 YEARS OF AGE. DO YOU AGREE TO  ATTACH A COPY OF YOUR ID HERE AS WELL AS PRESENT MATCHING IDENTIFICATION TO THE COURIAL?"
                warningInfo = NSMutableAttributedString(string: "WARNING: Drinking distilled spirits, beer, coolers, wine and other alcoholic beverages may Increase cancer risk, and during pregnancy, can cause birth defects. For more Information go to www.P65Warnings.ca.gov/alcohol.")
                warningRange = warningInfo.mutableString.range(of: "WARNING:")
                
                if let data = appCategories.arrayValue.first(where: {$0["category"].stringValue.lowercased() == "alcohol"}){
                    self.icon.image = UIImage(named: data["icon"].stringValue)
                    self.iconView.backgroundColor = hexStringToUIColor(hex: data["hex"].stringValue)
                }
                
            case "pharmacy":
                self.infoLbl.text = "PRESCRIPTIONS DELIVERY REQUIRE VERIFICATION OF IDENTIFICATION AND PRESCRIPTION. DO YOU AGREE TO  ATTACH A COPY OF PHOTO ID AND PRESCRIPTION HERE AS WELL AS PRESENT MATCHING IDENTIFICATION TO THE COURIAL?"
                warningInfo = NSMutableAttributedString(string: "\n\n")
                warningRange = warningInfo.mutableString.range(of: "WARNING:")
            default:
                self.infoLbl.text = "TOBACCO PRODUCTS REQUIRE VERIFICATION THAT YOU ARE AT LEAST 21 YEARS OF AGE. DO YOU AGREE TO  ATTACH A COPY OF YOUR ID HERE AS WELL AS PRESENT MATCHING IDENTIFICATION TO THE COURIAL?"
                warningInfo = NSMutableAttributedString(string: "SURGEON GENERAL’S WARNING: Smoking Causes Lung Cancer, Heart Disease, Emphysema, and May Complicate Pregnancy. Quitting Smoking Now Greatly Reduces Serious Risks to Your Health.")
                warningRange = warningInfo.mutableString.range(of: "SURGEON GENERAL’S WARNING:")
                
                self.icon.image = UIImage(named: "imgTobacco")
                self.iconView.backgroundColor = hexStringToUIColor(hex: "F1F2F3")
            }
            
            warningInfo.addAttributes([NSAttributedString.Key.font: UIFont.init(name: "Roboto-Medium", size: 10) ?? UIFont.boldSystemFont(ofSize: 10)], range: warningRange)
            
            self.warningLbl.attributedText = warningInfo
            
            if (userInfo.Identification_image ?? "") != ""{
                self.continueBtnOut.setTitle("CONTINUE", for: .normal)
            }else{
                self.continueBtnOut.setTitle("TAKE PHOTO OF ID", for: .normal)
            }
        }
    }
    
    //MARK:- BUTTONS ACTIONS
    @IBAction func backBtn(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func checkBoxBtn(_ sender: UIButton) {
        if self.checkBox.image == UIImage(named: "imgCheckBox"){
            self.checkBox.image = UIImage(named: "imgCheckBoxFilled")
            self.continueBtnOut.backgroundColor = appColorBlue
        } else{
            self.checkBox.image = UIImage(named: "imgCheckBox")
            self.continueBtnOut.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        }
    }
    
    @IBAction func continueBtn(_ sender: UIButtonCustomClass) {
        if sender.backgroundColor == appColorBlue{
            if (userInfo.Identification_image ?? "") == ""{
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "OpenCameraAlertVC") as! OpenCameraAlertVC
                vc.modalPresentationStyle = .overCurrentContext
                vc.delegate = self
                vc.spaceBottom = 50
                vc.view.isHidden = true
                super.viewContainingController()?.view.addSubview(vc.view)
                super.viewContainingController()?.addChild(vc)
                vc.openCameraAct(sender)
                //                vc.galleryBtn(sender)
            }else{
                self.idView.isHidden = false
                self.idImage.sd_setImage(with: URL(string: (userInfo.Identification_image ?? "")), placeholderImage: nil, options: [], completed: nil)
                self.continueBtnOut.backgroundColor = appColor
                self.continueBtnOut.setTitle("CONTINUE", for: .normal)
            }
        } else if sender.backgroundColor == appColor{
            guard let completion = self.completion else{
                self.removeFromSuperview()
                return
            }
            completion()
            self.removeFromSuperview()
        }
    }
    
    @IBAction func imgUploadBtn(_ sender: UIButton) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "OpenCameraAlertVC") as! OpenCameraAlertVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.spaceBottom = 50
        vc.view.isHidden = true
        super.viewContainingController()?.view.addSubview(vc.view)
        super.viewContainingController()?.addChild(vc)
        vc.openCameraAct(sender)
        //        vc.galleryBtn(sender)
    }
    
}

extension AgreementView : CameraAlertDelegate{
    
    func imageSelected(_ img: UIImage) {
        img.accessibilityHint = "idImage"
        self.uploadImage(img)
        
        self.idView.isHidden = false
        self.idImage.image = img
        self.continueBtnOut.backgroundColor = appColor
        self.continueBtnOut.setTitle("CONTINUE", for: .normal)
    }
    
    func uploadImage(_ img: UIImage?){
        showLoader()
        ApiInterface.formDataApi(params: [:], api_url: API.upload_Identification, image: img, imageName: "Identification_image", success: { (json) in
            hideLoader()
            userInfo.Identification_image = json["data"]["Identification"].stringValue
        }) { (error, json) in
            hideLoader()
        }
    }
    
}
