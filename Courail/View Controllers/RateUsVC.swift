//
//  RateUsVC.swift
//  Courail
//
//  Created by mac on 24/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Cosmos

class RateUsCVC: UICollectionViewCell {
    
    @IBOutlet weak var lblTxt: UILabel!
    @IBOutlet weak var TxtTipAmount: UITextField!
    @IBOutlet weak var enterCostomTipView: UIViewCustomClass!
    
}

class RateUsVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var favLbl: UILabel!
    @IBOutlet weak var partnerImage: UIImageViewCustomClass!
    @IBOutlet weak var partner2Image: UIImageViewCustomClass!
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var reviewField: UITextField!
    @IBOutlet weak var tellUsBtnOut: UIButton!
    
    @IBOutlet weak var favLblTop: NSLayoutConstraint!
    
    @IBOutlet weak var tippingView: UIView!
    @IBOutlet weak var applyRatingBtnOut: UIButtonCustomClass!
    @IBOutlet weak var applyRatingHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tipView: UIView!
    
    @IBOutlet weak var skipTipBtnOut: UIButton!
    @IBOutlet weak var favBtnOut: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var percentage: UIButton!
    @IBOutlet weak var doller: UIButton!
    @IBOutlet weak var lbBottomTxt: UILabel!
    
    @IBOutlet weak var tipTitle: UILabel!
    @IBOutlet weak var tipTitle2: UILabel!
    @IBOutlet weak var thanksTitle: UILabel!
    @IBOutlet weak var tipAmountLbl: UILabel!
    //MARK:- VARIABLES
    var isDoller = false
    var selectedIndex = 1
    var isEdit = false
    
    var percentArr = ["5","10","15","20"]
    var dollarArr = ["$3","$5","$10","Other"]
    
    var ratingDone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        
        self.ratingView.didFinishTouchingCosmos = { rating in
            if rating == 5.0{
                self.favBtnOut.isHidden = false
            } else{
                self.favBtnOut.isHidden = true
            }
            
            guard self.applyRatingBtnOut.backgroundColor != appColor else {return}
            
            self.applyRatingBtnOut.isUserInteractionEnabled = true
            self.tellUsBtnOut.isHidden = false
            self.applyRatingBtnOut.backgroundColor = appColor
        }
        
        self.isDoller = (userInfo.tiptype == "2") ? true : false
        if self.isDoller{
            self.dollerAction(self.doller)
            if userInfo.isOtherTip == "1"{
                self.selectedIndex = 3
            } else{
                self.selectedIndex = self.dollarArr.firstIndex(where: {JSON($0.replacingOccurrences(of: "$", with: "")).doubleValue == JSON(userInfo.tipevalue ?? "0").doubleValue}) ?? 0
            }
        } else{
            self.percentageAction(self.percentage)
            self.selectedIndex = self.percentArr.firstIndex(where: {$0 == userInfo.tipevalue}) ?? 0
        }
        
        if self.isDoller && self.selectedIndex == 3{
            self.dollarArr[3] = "$" + (userInfo.tipevalue ?? "0.00")
        }
        
        self.collectionView.reloadData()
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
    
    func loadData(){
        let courialFirstName = (currentOrder?.provider?.firstName ?? "").capitalized
        let courial2FirstName = (currentOrder?.secondCourial?.firstName ?? "").capitalized
        
        
        self.partnerImage.sd_setImage(with: URL(string: currentOrder?.provider?.image ?? ""), placeholderImage: nil, options: [], completed: nil)
        
        if JSON(currentOrder?.twoCourials ?? "0").boolValue == false{
            self.partner2Image.isHidden = true
            
            self.headerTitle.text = "How Awesome was \(courialFirstName)?"
            self.tipTitle.text = "Thank \(courialFirstName) with a tip!"
            self.tipTitle2.text = "Thank \(courialFirstName) with a tip!"
            self.thanksTitle.text = "THANKS FOR TIPPING!"
        } else{
            self.partner2Image.isHidden = false
            self.partner2Image.sd_setImage(with: URL(string: currentOrder?.secondCourial?.image ?? ""), placeholderImage: nil, options: [], completed: nil)
            
            self.headerTitle.text = "How Awesome were\n\(courialFirstName) & \(courial2FirstName)?"
            self.tipTitle.text = "Thank them with a tip!"
            self.tipTitle2.text = "Thank them with a tip!"
            self.thanksTitle.text = "THANKS FOR TIPPING!"
        }
        
        
    }
    
    
    //MARK:- BUTTONS ACTIONS
    @IBAction func percentageAction(_ sender: UIButton) {
        selectedIndex = 1
        self.isDoller = false
        self.percentage.setImage(UIImage.init(named: "radio_1"), for: .normal)
        self.doller.setImage(UIImage.init(named: "radio_2"), for: .normal)
        self.lbBottomTxt.isHidden = false
        self.skipTipBtnOut.isHidden = false
        self.collectionView.reloadData()
    }
    
    @IBAction func dollerAction(_ sender: UIButton) {
        selectedIndex = 1
        self.isDoller = true
        self.doller.setImage(UIImage.init(named: "radio_1"), for: .normal)
        self.percentage.setImage(UIImage.init(named: "radio_2"), for: .normal)
        self.lbBottomTxt.isHidden = true
        self.skipTipBtnOut.isHidden = true
        self.collectionView.reloadData()
    }
    
    @IBAction func BackBtnAction(_ sender: Any) {
        if self.ratingDone{
            currentOrder = nil
            GoToHome()
        }else{
            self.skipRating()
        }
    }
    
    @IBAction func favBtn(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        if sender.currentImage == UIImage(named:"heart2_2"){
            self.removeFavCourial()
            
            sender.setImage(UIImage(named:"heart3_2-1"), for: .normal)
            self.favLbl.alpha = 1
            UIView.animate(withDuration: 0.2, animations: {
                self.favLbl.alpha = 0
            }) { (_) in
                self.favLbl.isHidden = true
                sender.isUserInteractionEnabled = true
            }
        } else{
            
            if JSON(currentOrder?.twoCourials ?? "0").boolValue == false{
                self.addFavCourial(id: "\(currentOrder?.provider?.internalIdentifier ?? 0)")
            } else{
                self.addFavCourial(id: "\(currentOrder?.provider?.internalIdentifier ?? 0)")
                self.addFavCourial(id: "\(currentOrder?.secondCourial?.internalIdentifier ?? 0)")
            }
            sender.setImage(UIImage(named:"heart2_2"), for: .normal)
            
            self.favLbl.isHidden = false
            self.favLbl.alpha = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.favLbl.alpha = 1
            }) { (_) in
                sender.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func tellUsBtn(_ sender: UIButton) {
        self.tellUsBtnOut.isHidden = true
        self.reviewField.isHidden = false
        self.reviewField.becomeFirstResponder()
    }
    
    @IBAction func applyRating(_ sender: UIButton) {
        self.rateCourial()
    }
    
    @IBAction func applyTip(_ sender: Any) {
        self.defaultTipApi()
    }
    
    @IBAction func skipTip(_ sender: Any) {
        if self.ratingDone{
            currentOrder = nil
            GoToHome()
        }else{
            self.skipRating()
        }
    }
    
}

extension RateUsVC: UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isDoller{
            return self.dollarArr.count
        } else{
            return self.percentArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((self.view.frame.width - 50) - 15) / 4
        return CGSize(width: width , height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RateUsCVC", for: indexPath) as! RateUsCVC
        
        if self.isDoller{
            cell.lblTxt.text = self.dollarArr[indexPath.row]
        } else{
            cell.lblTxt.text = self.percentArr[indexPath.row] + "%"
        }
        
        if self.selectedIndex == indexPath.row{
            cell.lblTxt.backgroundColor = appColorBlue
            cell.lblTxt.textColor = .white
        }else{
            cell.lblTxt.backgroundColor = .clear
            cell.lblTxt.textColor = .black
        }
        
        cell.TxtTipAmount.delegate = self
        
        cell.enterCostomTipView.isHidden = true
        cell.lblTxt.isHidden = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        if selectedIndex == 3 && self.isDoller{
            self.isEdit = true
            
            let indexes = [IndexPath(item: 0, section: 0),IndexPath(item: 1, section: 0),IndexPath(item: 2, section: 0)]
            collectionView.reloadItems(at: indexes)
            
            if let cell = collectionView.cellForItem(at: indexPath)as? RateUsCVC{
                cell.enterCostomTipView.isHidden = false
                cell.enterCostomTipView.backgroundColor = appColorBlue
                cell.lblTxt.isHidden = true
                
                if self.dollarArr[3] == "Other"{
                    cell.TxtTipAmount.text = ""
                } else{
                    cell.TxtTipAmount.text = self.dollarArr[3].replacingOccurrences(of: "$", with: "")
                }
                
                cell.TxtTipAmount.becomeFirstResponder()
            }
        } else{
            self.isEdit = false
            collectionView.reloadData()
        }
        
    }
    
}

extension RateUsVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if JSON(textField.text!).doubleValue > 9999.99 {
            textField.text = "9999.99"
        } else{
            textField.text = String(format: "%.2f", JSON(textField.text!).doubleValue)
        }
        self.dollarArr[3] = "$" + (textField.text ?? "")
        isEdit = false
        self.collectionView.reloadData()
    }
    
}


extension RateUsVC {
    
    //MARK: API
    
    func rateCourial(){
        let params : Parameters = [
            "providerid": "\(currentOrder?.provider?.internalIdentifier ?? 0)",
            "rating" : "\(self.ratingView.rating)",
            "orderId" : currentOrder?.orderid ?? "",
            "review" : self.reviewField.text ?? "",
            
            "secondsFromGMT": "\(TimeZone.current.secondsFromGMT())",
            "timezoneID": TimeZone.current.identifier,
            "timezoneDate": "\(Date().timeIntervalSince1970)"
        ]
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.rate_courial , success: { (json) in
            hideLoader()
            
//            guard currentOrder?.courialTip == nil || (currentOrder?.courialTip == "0.00") else {
//                currentOrder = nil
//                GoToHome()
//                return
//            }
            
            self.favLblTop.constant = 15
            self.ratingView.isUserInteractionEnabled = false
            self.tellUsBtnOut.isHidden = true
            self.reviewField.isUserInteractionEnabled = false
            self.reviewField.borderStyle = .none
            self.applyRatingHeight.constant = 0
            self.applyRatingBtnOut.isHidden = true
            self.tipView.isHidden = false
            
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.reloadData()
            
            self.ratingDone = true
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }

        
    
    func skipRating(){
        let params : Parameters = [
            "orderId": currentOrder?.orderid ?? "",
            
            "secondsFromGMT": "\(TimeZone.current.secondsFromGMT())",
            "timezoneID": TimeZone.current.identifier,
            "timezoneDate": "\(Date().timeIntervalSince1970)"
        ]
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.skip_rate , success: { (json) in
            hideLoader()
            currentOrder = nil
            GoToHome()
        }) { (error, json) in
            hideLoader()
            currentOrder = nil
            GoToHome()
        }
    }
    
    
    func addFavCourial(id: String){
        let params : Parameters = [
            "providerid": id
        ]
        ApiInterface.requestApi(params: params, api_url: API.add_fav_courial , success: { (json) in
        }) { (error, json) in
            showSwiftyAlert("", error, false)
        }
    }
    
    func removeFavCourial(){
        let params : Parameters = [
            "providerid": "\(currentOrder?.provider?.internalIdentifier ?? 0)"
        ]
        ApiInterface.requestApi(params: params, api_url: API.remove_fav_courial , method: .delete , success: { (json) in
        }) { (error, json) in
            showSwiftyAlert("", error, false)
        }
    }
    
    func defaultTipApi(){
        var isOther = "0"
        if self.isDoller && self.selectedIndex == 3{
            isOther = "1"
        } else{
            isOther = "0"
        }
        
        let params: Parameters = [
            "tiptype": self.isDoller ? "2" : "1",
            "tipevalue": self.isDoller ? self.dollarArr[self.selectedIndex].replacingOccurrences(of: "$", with: "") : self.percentArr[self.selectedIndex],
            "isOther": isOther
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.select_default_tip,method: .put, success: { (json) in
            hideLoader()
            userInfo.tiptype = self.isDoller ? "2" : "1"
            userInfo.tipevalue = self.isDoller ? self.dollarArr[self.selectedIndex].replacingOccurrences(of: "$", with: "") : self.percentArr[self.selectedIndex]
            userInfo.isOtherTip = isOther
            self.addTip()
        }) { (error, json) in
            hideLoader()
            userInfo.tiptype = self.isDoller ? "2" : "1"
            userInfo.tipevalue = self.isDoller ? self.dollarArr[self.selectedIndex].replacingOccurrences(of: "$", with: "") : self.percentArr[self.selectedIndex]
            userInfo.isOtherTip = isOther
            self.addTip()
        }
    }
    
    func addTip(){
        let serviceFee = JSON(currentOrder?.serviceFee ?? "0").doubleValue
        let deliveryFee = JSON(currentOrder?.deliveryFee ?? "0").doubleValue
        let total = (serviceFee + deliveryFee)
        
        var tip = 0.0
        
        if userInfo.tiptype == "1"{
            let percentage = JSON(userInfo.tipevalue ?? "0").doubleValue
            tip = total * (percentage / 100)
            if tip < 1{
                tip = 1
            }
        } else{
            tip = JSON((userInfo.tipevalue ?? "0").replacingOccurrences(of: "$", with: "")).doubleValue
        }
        
        let finalTip = String(format: "%.02f", tip)
        guard tip != 0 else{
            currentOrder = nil
            GoToHome()
            return
        }
        
        SocketBase.sharedInstance.tipCourial(currentOrder?.orderid ?? "", tip: finalTip)
        
        self.tipAmountLbl.text =  "$\(finalTip) ADDED TO FINAL RECEIPT"
        self.tipView.isHidden = true
        self.tippingView.isHidden = false
    }
    
}
