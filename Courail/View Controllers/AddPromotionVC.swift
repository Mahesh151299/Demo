//
//  AddPromotionVC.swift
//  Courail
//
//  Created by mac on 11/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AddPromotionVC: UIViewController {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var field: UITextField!
    
    //MARK: VARIABLES
    var businessDetail : YelpStoreBusinesses?
    
    var completion : ((YelpStoreBusinesses?)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          self.tabBarController?.tabBar.isHidden = true
      }
      
      override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          self.tabBarController?.tabBar.isHidden = false
      }
    
    @IBAction func actionAddPromo(_ sender: UIButton) {
        guard self.field.text?.isEmpty == false else {
            showSwiftyAlert("", "Please enter a code", false)
            return
        }
        self.addPromoApi()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}


extension AddPromotionVC {
    
    //MARK:- API
    
    func addPromoApi(){
        showLoader()
        let params: Parameters = [
            "orderid" : self.businessDetail?.orderID ?? "",
            "promocode" : self.field.text!
        ]
        ApiInterface.requestApi(params: params, api_url: API.apply_promo , success: { (json) in
            hideLoader()
            let percent = json["data"]["discount_percentage"].doubleValue
            
            let serviceFee = JSON(self.businessDetail?.serviceFee ?? "0").doubleValue
            let deliveryFee = JSON(self.businessDetail?.deliveryFee ?? "0").doubleValue
            let total = (serviceFee + deliveryFee)
            
            if percent != 0.0{
                let price =  total * (percent/100)
                self.businessDetail?.promoPrice = String(format: "%.02f", price)
            } else{
                self.businessDetail?.promoPrice = String(format: "%.02f", json["data"]["discount_price"].doubleValue)
            }
            
            self.businessDetail?.promoApplied = true
            
            guard let completion = self.completion else{
                return
            }
            completion(self.businessDetail)
            self.pop()
            showSwiftyAlert("", json["msg"].stringValue, true)
        }) { (error, json) in
            hideLoader()
            self.businessDetail?.promoApplied = false
            showSwiftyAlert("", error, false)
        }
    }
    
}
