//
//  PromoView.swift
//  Courail
//
//  Created by apple on 08/02/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class PromoView: UIView {

    //MARK: OUTLETS
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var promoField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    //MARK: VARIABLES
    
    var orderID = ""
    var businessDetail : YelpStoreBusinesses?
    
    var completion : ((YelpStoreBusinesses?)->Void)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, completion: @escaping ((YelpStoreBusinesses?)-> ())) {
        super.init(frame: frame)
        self.completion = completion
        self.setup()
    }
    
    
    func setup(){
        self.bgView = Bundle.main.loadNibNamed("PromoView", owner: self, options: nil)?.first as? UIView
        self.bgView.frame = self.bounds
        self.addSubview(self.bgView)
    }
    
    //MARK: BUTTONS ACTIONS
    
    @IBAction func appleBtn(_ sender: UIButton) {
        self.errorLbl.isHidden = true
        
        guard self.promoField.text?.isEmpty == false  else {
            return
        }
        self.endEditing(true)
        self.addPromoApi(code: self.promoField.text ?? "")
    }
    
    @IBAction func closeBtn(_ sender: UIButton){
        self.removeFromSuperview()
    }
    
    //MARK: API
    
    func addPromoApi(code: String){
        showLoader()
        let params: Parameters = [
            "orderid" : self.businessDetail?.orderID ?? "",
            "promocode" : code
        ]
        ApiInterface.requestApi(params: params, api_url: API.apply_promo , success: { (json) in
            hideLoader()
            let percent = json["data"]["discount_percentage"].doubleValue
            let deliveryFee = JSON(self.businessDetail?.deliveryFee ?? "0").doubleValue
            
            if percent != 0.0{
                let price =  deliveryFee * (percent/100)
                self.businessDetail?.promoPrice = String(format: "%.02f", price)
            } else{
                self.businessDetail?.promoPrice = String(format: "%.02f", json["data"]["discount_price"].doubleValue)
            }
            
            self.businessDetail?.promoCode = self.promoField.text!
            self.businessDetail?.promoApplied = true
            self.businessDetail?.validPromo = true
            
            guard let completion = self.completion else{
                self.removeFromSuperview()
                return
            }
            completion(self.businessDetail)
            self.removeFromSuperview()
        }) { (error, json) in
            hideLoader()
            self.businessDetail?.promoApplied = true
            self.businessDetail?.validPromo = false
            
            self.errorLbl.isHidden = false
            if error.contains("expired"){
                self.businessDetail?.expiredPromo = true
                self.errorLbl.text = "expired code"
            }else{
                self.errorLbl.text = "invalid code"
                self.businessDetail?.expiredPromo = false
            }
        }
    }
    
   
}
