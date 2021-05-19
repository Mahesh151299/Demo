//
//  ReceiptViewController.swift
//  Courail
//
//  Created by Omeesh Sharma on 03/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var storeName: UILabel!
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDesc: UILabel!
    @IBOutlet weak var notes: UILabel!
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var totalFee: UILabel!
    
    
    //MARK:- VARIABLES
    
    var fares = JSON([
        [
            "title":"Delivery Fee",
            "value" :"0.00",
            "type" : ""
        ],
        [
            "title":"Base Fee",
            "value" :"0.00",
            "type" : "sub"
        ],
        [
            "title":"Discount / Promo",
            "value" :"0.00",
            "type" : "sub"
        ],
        [
            "title":"Stairs/Elevator",
            "value" :"0.00",
            "type" : "sub"
        ],
        [
            "title":"Heavy",
            "value" :"0.00",
            "type" : "sub"
        ],
        [
            "title":"Wait Time",
            "value" :"0.00",
            "type" : "sub"
        ],
        [
            "title":"Item Cost",
            "value" :"0.00",
            "type" : "(Paid by Courial)"
        ],
        [
            "title":"Courial Pay Fee",
            "value" :"0.00",
            "type" : "(5%)",
        ],
        [
            "title":"Courial Tip",
            "value" :"0.00",
            "type" : ""
        ],
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.separatorStyle = .none
        self.table.tableFooterView = UIView()
        
        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableHeight.constant = self.table.contentSize.height
    }
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func crossBtn(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func loadData(){
        self.storeName.text = currentOrder?.name ?? " "
        self.itemName.text = currentOrder?.itemName?.uppercased() ?? ""
        self.itemDesc.text = self.itemDetails()
//        self.notes.text = currentOrder?.deliveryInfo?.notes ?? ""
        
        let cp = JSON(currentOrder?.itemCost ?? "0.00").doubleValue
        let cpFee = cp  * 0.05
        let discount = JSON(currentOrder?.promoDiscount ?? "0.00").doubleValue
        
        let pickWaitCharges = JSON(currentOrder?.pickupWaitCharges ?? "0.00").doubleValue
        let DropWaitCharges = JSON(currentOrder?.dropOffWaitCharges ?? "0.00").doubleValue
        let waitCharges = abs(pickWaitCharges) + abs(DropWaitCharges)
        
        //Delivery Fee
        let deliveryFee = (JSON(currentOrder?.deliveryFee ?? "0.00").doubleValue - discount) + waitCharges
        self.fares[0]["value"].stringValue = String(format: "%.02f", deliveryFee)
        
        //Base Fare
        self.fares[1]["value"].stringValue = currentOrder?.baseFee ?? "0.00"
        
        //Discount
        self.fares[2]["value"].stringValue = String(format: "%.02f", discount)
        
        //Stairs/Elevator
        self.fares[3]["value"].stringValue = currentOrder?.stairsElevatorFee ?? "0.00"
        
        //Heavy
        self.fares[4]["value"].stringValue = currentOrder?.heavyFee ?? "0.00"
        
        //Wait Time
        self.fares[5]["value"].stringValue = String(format: "%.02f", waitCharges)
        
        //Item Cost //Courial Pay Fee
        if currentOrder?.subTotalType == "COURIAL PAYS"{
            self.fares[6]["type"].stringValue = "(Paid by Courial)"
            self.fares[6]["value"].stringValue = (currentOrder?.itemCost ?? "0.00")
            
            //Courial Pay Fee
            self.fares[7]["value"].stringValue = String(format: "%.02f", cpFee)
        } else{
            self.fares[6]["type"].stringValue = "(Pre-Paid)"
            self.fares[6]["value"].stringValue = "0.00"
            
            //Courial Pay Fee
            self.fares[7]["value"].stringValue = "0.00"
        }
        
        //Tip
        let courialTip = JSON(currentOrder?.courialTip ?? "0.00").doubleValue
        self.fares[8]["value"].stringValue = String(format: "%.02f", courialTip)
        
        
        //Total
        let totalAmount = deliveryFee  + cp + cpFee + courialTip
        self.totalFee.text = "$" + String(format: "%.02f", totalAmount)
        
        self.fares = JSON(self.fares.arrayValue.filter({($0["value"].doubleValue != 0) || ($0["title"].stringValue.contains("Item Cost") == true)}))
        self.table.reloadData()
    }
    
    
    func itemDetails()-> String{
        let twoCourial =  JSON(currentOrder?.twoCourials ?? 0).boolValue ? "Two Courials • " : ""
        let over45Lbs =  JSON(currentOrder?.over45Lbs ?? "0").boolValue ? "Over 45 lbs • " : ""
        
        let vehicle = "By " + (currentOrder?.trasnportMode ?? "")
        return twoCourial + over45Lbs + vehicle
    }
    
    
}



extension ReceiptViewController: UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fares.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "FeeCell", for: indexPath) as! DeliveryDetailTVC
        
        let title = self.fares[indexPath.row]["title"].stringValue
        let value = self.fares[indexPath.row]["value"].stringValue
        let type = self.fares[indexPath.row]["type"].stringValue
        
        switch type{
        case "sub":
            cell = tableView.dequeueReusableCell(withIdentifier: "SubCell", for: indexPath) as! DeliveryDetailTVC
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "FeeCell", for: indexPath) as! DeliveryDetailTVC
            cell.feeType.text = type
        }
        
        cell.feeTitle.text = title
        
        if title == "Discount / Promo"{
            cell.feeValue.text = "-$" + value
        } else{
            cell.feeValue.text = "$" + value
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
