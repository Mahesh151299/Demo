//
//  PaymentMethodVC.swift
//  Courail
//
//  Created by mac on 10/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class PaymentMethodTVC: UITableViewCell {
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var cardNo: UILabel!
    
    @IBOutlet weak var PaymentLogo: UIImageView!
    @IBOutlet weak var imgTick: UIImageView!
    
    
}

class PaymentMethodVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var tableViewPaymentMethod: UITableView!
    
    @IBOutlet weak var backBtnOut: UIButton!
    
    
    //MARK: VARIABLES
    var fromMenu = false
    var savedCards = [CardModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewPaymentMethod.tableFooterView = UIView()
        
        if self.fromMenu{
            self.backBtnOut.setImage(UIImage(named: "newBar"), for: .normal)
        } else{
            self.backBtnOut.setImage(UIImage(named: "arrow_3Temp"), for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCardsApi()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK: BUTTONS ACTIONS
    @IBAction func MenuOrGoBack(_ sender:UIButton){
        if fromMenu{
            toggleMenu(self)
        }else{
            self.pop()
        }
    }
    
}

extension PaymentMethodVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.savedCards.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTVC")as! PaymentMethodTVC
        if section == 0{
            cell.lblHeader.text = "Previous Payment Methods"
        } else{
            cell.lblHeader.text = "Add Payment Method"
        }
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && self.savedCards.count == 0{
            return 0
        } else{
            return 50
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemoveCardTVC")as! PaymentMethodTVC
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 && self.savedCards.count != 0{
            return 40
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section == 1 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTVC")as! PaymentMethodTVC
            
            let card = self.savedCards[indexPath.row]
            cell.PaymentLogo.image = UIImage(named: card.cardType?.lowercased() ?? "") ?? UIImage(named: "ccardbck")
            
            cell.lblHeader.text = cardNameAbb(name: card.cardType ?? "")
            
            let cardLast = card.cardNumber?.suffix(4) ?? ""
            cell.cardNo.text = "\(cardLast)"
            
            if userInfo.card_default?.internalIdentifier == card.internalIdentifier{
                cell.imgTick.isHidden = false
                cell.lblHeader.textColor = appColor
                cell.cardNo.textColor = appColor
            } else{
                cell.imgTick.isHidden = true
                cell.lblHeader.textColor = .black
                cell.cardNo.textColor = .black
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCardTVC")as! PaymentMethodTVC
        cell.lblHeader.text = "Credit Card"
        cell.PaymentLogo.image = UIImage(named: "ccardbck")
        cell.separatorInset = .init(top: 0, left: cell.frame.width, bottom: 0, right: 0)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard indexPath.section == 1 else{
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            self.deleteCardApi(indexPath.row)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.defaultCardApi(index: indexPath.row)
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "AddCardDetailVC") as! AddCardDetailVC
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension PaymentMethodVC {
    
    //MARK:- API
    
    func getCardsApi(){
        showLoader()
        ApiInterface.requestApi(params: [:], api_url: API.get_card, method: .get, encoding: URLEncoding.httpBody , success: { (json) in
            hideLoader()
            if let data = json["data"].array{
                self.savedCards = data.map({CardModel.init(json: $0)})
            }
            self.tableViewPaymentMethod.reloadData()
        }) { (error, json) in
            hideLoader()
            self.tableViewPaymentMethod.reloadData()
        }
    }
    
    func deleteCardApi(_ index: Int){
        let params: Parameters = [
            "card_id" : "\(self.savedCards[index].internalIdentifier ?? 0)"
        ]
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.delete_card, method: .delete,  success: { (json) in
            hideLoader()
            if userInfo.card_default?.internalIdentifier == self.savedCards[index].internalIdentifier{
                userInfo.card_default = nil
            }
            self.savedCards.remove(at: index)
            self.tableViewPaymentMethod.reloadData()
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", json["msg"].stringValue, false)
            self.tableViewPaymentMethod.reloadData()
        }
    }
    
    
    func defaultCardApi(index: Int){
        let params: Parameters = [
            "card_id": "\(self.savedCards[index].internalIdentifier ?? 0)"
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.select_default_card, method: .put, success: { (json) in
            hideLoader()
            userInfo.card_default = self.savedCards[index]
            if self.fromMenu{
                self.tableViewPaymentMethod.reloadData()
            } else{
                self.pop()
            }
        }) { (error, json) in
            hideLoader()
            userInfo.card_default = self.savedCards[index]
            showSwiftyAlert("", error, false)
        }
    }
    
    
}

