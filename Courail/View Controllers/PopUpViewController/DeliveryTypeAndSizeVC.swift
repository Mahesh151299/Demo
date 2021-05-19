//
//  DeliveryTypeAndSizeVC.swift
//  Courail
//
//  Created by mac on 28/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class DeliveryTypeAndSizeVC: UIViewController {
    
    @IBOutlet weak var tittleHeader: UILabel!
    
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    
    var textString = ""
    var referenceVc = SpecialDeliveryAddToQueueVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if textString == "0" {
            self.tittleHeader.text = "Delivery Type explained"
            self.lblText.text =
                   "Here's where you let your Courial know what type of package they should expect. Typical types include: envelope, box, crate, luggage, grocery, take out, bag,bottles, glass, and laundry."
        } else {
            self.tittleHeader.text = "Package Size explained"
            self.heightConst.constant = 200
            self.lblText.text = """
            Here’s where you let your Courial know the relative
            size of your package. Sizes listed as: S, M, L and XL.
            """
            
        }
        

 
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        tabBarController?.tabBar.isHidden = false
        self.removeFromParent()
        self.view.removeFromSuperview()
        
    }
    
    @IBAction func submitBtnAct(_ sender: Any) {
        backBtn(self)
    }
    
}
