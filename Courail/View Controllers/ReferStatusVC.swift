//
//  ReferStatusVC.swift
//  Courail
//
//  Created by Omeesh Sharma on 04/12/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ReferTVC: UITableViewCell {
    
    @IBOutlet weak var courialImage: UIImageView!
    @IBOutlet weak var courialName: UILabel!
    @IBOutlet weak var courialDeliveries: UILabel!
    @IBOutlet weak var courialCredits: UILabel!
    
    @IBOutlet weak var applyBtn: UIButton!
    
}

class ReferStatusVC: UIViewController {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var referCode: UILabel!
    
    //MARK: VARIABLES
    
    var refers = [ReferModel]()
    var totalAmount : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.referCode.text = "(" + (userInfo.refrel?.uppercased() ?? "") + ")"
        
        self.getStatusApi()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: BUTTONS ACTIONS
    
    @IBAction func backBtnAct(_ sender: Any) {
        toggleMenu(self)
    }
    
    @objc func applyBtn(_ sender: UIButton){
        self.creditApi()
    }
    
    
    
}

extension ReferStatusVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.refers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReferTVC") as! ReferTVC
        let data = self.refers[indexPath.row]
        cell.courialImage.sd_setImage(with: URL(string: data.image ?? ""), placeholderImage: UIImage(named: "imgPartnerPlaceholder"), options: [], completed: nil)

        let firstName = (data.firstName ?? "").capitalized
        var lastName = ""
        if let lastChar = (data.lastName ?? "").capitalized.first{
            lastName = "\(lastChar)"
        }
        let courialName = firstName + " " + lastName
        cell.courialName.text = courialName

        cell.courialDeliveries.text = JSON(data.deliveries ?? 0).stringValue
        cell.courialCredits.text = "$" + String(format: "%.02f", JSON(data.amount ?? 0.0).doubleValue)

        if (data.deliveries ?? 0) < 11{
            cell.courialName.textColor = .lightGray
            cell.courialDeliveries.textColor = .lightGray
            cell.courialCredits.textColor = .lightGray
        }else{
            cell.courialName.textColor = .black
            cell.courialDeliveries.textColor = .black
            cell.courialCredits.textColor = .black
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReferApplyTVC") as! ReferTVC
        
        cell.courialCredits.text = "$" + String(format: "%.02f", self.totalAmount)
        
        if self.totalAmount < 1{
            cell.courialCredits.textColor = .lightGray
            cell.applyBtn.backgroundColor = .lightGray
            cell.applyBtn.isUserInteractionEnabled = false
        } else{
            cell.courialCredits.textColor = UIColor.init(red: 0/255, green: 128/255, blue: 129/255, alpha: 1)
            cell.applyBtn.backgroundColor = appColorBlue
            cell.applyBtn.isUserInteractionEnabled = true
        }

        cell.applyBtn.addTarget(self, action: #selector(self.applyBtn(_:)), for: .touchUpInside)
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.refers.count == 0{
            return 0
        }else if self.refers.count < 10{
            return 140
        }else{
            return 100
        }
    }
    
    
}

extension ReferStatusVC {
    
    //MARK: API
    
    func getStatusApi(){
        showLoader()
        ApiInterface.requestApi(params: [:], api_url: API.get_refreluser, method: .get, encoding: URLEncoding.httpBody , success: { (json) in
            hideLoader()
            if let data = json["data"]["referraluser"].array{
                self.refers = data.map({ReferModel.init(json: $0)})
            }
            self.totalAmount = json["data"]["totalamount"].doubleValue
            userInfo.referralamount = self.totalAmount
            self.table.reloadData()
        }) { (error, json) in
            hideLoader()
            self.table.reloadData()
        }
    }
    
    func creditApi(){
        showLoader()
        ApiInterface.requestApi(params: [:], api_url: API.creditrefrelamount , success: { (json) in
            hideLoader()
            self.getStatusApi()
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
}
