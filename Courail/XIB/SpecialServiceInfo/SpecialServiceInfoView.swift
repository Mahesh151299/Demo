//
//  SpecialServiceInfoView.swift
//  Courail
//
//  Created by Omeesh Sharma on 11/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SpecialServiceInfoView: UIView {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var skillName: UILabel!
    
    @IBOutlet weak var websiteView: UIView!
    @IBOutlet weak var website: UILabel!
    
    @IBOutlet weak var licenseView: UIView!
    @IBOutlet weak var license: UILabel!
    
    @IBOutlet weak var experienceView: UIView!
    @IBOutlet weak var experience: UILabel!
    
    @IBOutlet weak var additionalInfoView: UIView!
    @IBOutlet weak var additionalInfo: UILabel!
    
    //MARK: VARIABLES
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    
    func setup(){
        self.bgView = Bundle.main.loadNibNamed("SpecialServiceInfoView", owner: self, options: nil)?.first as? UIView
        self.bgView.frame = self.bounds
        self.addSubview(self.bgView)
        
        self.providerName.text = currentOrder?.provider?.firstName ?? ""
        self.skillName.text = currentOrder?.category ?? ""
        self.website.text = currentOrder?.provider?.credentials_Website ?? ""
        self.license.text = currentOrder?.provider?.credentials_license_number ?? ""
        self.experience.text = currentOrder?.provider?.credentials_experience ?? ""
        self.additionalInfo.text = currentOrder?.provider?.credentials_notes ?? ""
    }
    
    //MARK: BUTTONS ACTIONS
    
    @IBAction func closeBtn(_ sender: UIButton){
        self.removeFromSuperview()
    }
    
    @IBAction func websiteBtn(_ sender: UIButton){
        var str = currentOrder?.provider?.credentials_Website ?? ""
        
        if str.hasPrefix("https://") || str.hasPrefix("http://"){}else {
            str = "http://\(str)"
        }
        guard let urlStr = URL(string: str)else{
            showSwiftyAlert("", "Sorry! We are not able to open this page.", false)
            return
        }
        
        if UIApplication.shared.canOpenURL(urlStr){
            UIApplication.shared.open(urlStr, options: [:], completionHandler: nil)
        }else{
            showSwiftyAlert("", "Sorry! We are not able to open this page.", false)
        }
    }

}
