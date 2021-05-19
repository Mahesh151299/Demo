//
//  DefaultTipVC.swift
//  Courail
//
//  Created by mac on 20/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class DefaultTipVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var percentage: UIButton!
    @IBOutlet weak var doller: UIButton!
    @IBOutlet weak var lbBottomTxt: UILabel!
    
    //MARK:- VARIABLES
    var isDoller = false
    var selectedIndex = 0
    var isEdit = false
    
    var isLiveEdit = false
    
    var percentArr = ["5","10","15","20"]
    var dollarArr = ["$3","$5","$10","Other"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
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
       
    
    //MARK:- BUTTONS ACTIONS
    @IBAction func percentageAction(_ sender: UIButton) {
        self.isDoller = false
        self.percentage.setImage(UIImage.init(named: "radio_1"), for: .normal)
        self.doller.setImage(UIImage.init(named: "radio_2"), for: .normal)
        self.lbBottomTxt.isHidden = false
        self.collectionView.reloadData()
    }
    
    @IBAction func dollerAction(_ sender: UIButton) {
        self.isDoller = true
        self.doller.setImage(UIImage.init(named: "radio_1"), for: .normal)
        self.percentage.setImage(UIImage.init(named: "radio_2"), for: .normal)
        self.lbBottomTxt.isHidden = true
        self.collectionView.reloadData()
    }
    
    @IBAction func BackBtnAction(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        self.defaultTipApi()
    }
    
}

extension DefaultTipVC: UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
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
        let width = (collectionView.frame.width - 15) / 4
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


extension DefaultTipVC: UITextFieldDelegate {
    
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



extension DefaultTipVC {
    
    //MARK:- API
    
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
            self.tipApplied()
        }) { (error, json) in
            hideLoader()
            userInfo.tiptype = self.isDoller ? "2" : "1"
            userInfo.tipevalue = self.isDoller ? self.dollarArr[self.selectedIndex].replacingOccurrences(of: "$", with: "") : self.percentArr[self.selectedIndex]
            userInfo.isOtherTip = isOther
            self.tipApplied()
        }
    }
    
    func tipApplied(){
        guard !self.isLiveEdit else {
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
            currentOrder?.courialTip = finalTip
            
            SocketBase.sharedInstance.editOrder("7")
            
            if let vc = self.navigationController?.viewControllers.last(where: {($0 as? CurrentOrderVC) != nil}){
                (vc as? CurrentOrderVC)?.refreshData()
                self.pop()
            } else{
                self.pop()
            }
            return
        }
        
        if let vc = self.navigationController?.viewControllers.last(where: {($0 as? QueueDeliveryDetailVC) != nil}){
            (vc as? QueueDeliveryDetailVC)?.addTip()
            self.navigationController?.popToViewController(vc, animated: true)
        } else{
            self.pop()
        }

    }
    
}

