//
//  BreakDownTotalCostVC.swift
//  Courail
//
//  Created by mac on 21/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class BreakDownTotalCostTVC: UITableViewCell {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblDollar: UILabel!
    @IBOutlet weak var bottomLine: UILabel!
    @IBOutlet weak var bottomCont: NSLayoutConstraint!
    @IBOutlet weak var topCont: NSLayoutConstraint!
}

class BreakDownTotalCostVC: UIViewController {
    
    @IBOutlet weak var tableViewBreakDownTC: UITableView!
    
    var Tittleheader = ["Courial Free","Service Free","Credit Card Authorization"]
    var BottomText = ["""
    This free covers the cost of delivery and is based on
    distance, time, availability of Courials, delivery schedule,
    as well as the size and weight of the delivered item. Courials
    keep 100% of this fee!
    ""","""
    All Courial Deliveries include a service fee of 25%. This fee
    covers Courial opertions, insurance, and background checks
    for Courials.
    ""","""
    Your card was temporarily authorized for $00.00. Your
    statement will reflect a final charge of $00.00 within 7
    business days of order completion.
    """]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnAct(_ sender: Any) {
        tabBarController?.tabBar.isHidden = false
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    @IBAction func submitBtnAct(_ sender: Any) {
        backBtnAct(self)
    }
    
}

extension BreakDownTotalCostVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tittleheader.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = BreakDownTotalCostTVC()
        cell = tableViewBreakDownTC.dequeueReusableCell(withIdentifier: "BreakDownTotalCostTVC", for: indexPath) as! BreakDownTotalCostTVC
        cell.lblHeader.text = Tittleheader[indexPath.row]
        cell.lblText.text = BottomText[indexPath.row]
        if indexPath.row == 2 {
            cell.lblDollar.isHidden = true
            cell.bottomLine.isHidden = false
        }
        if indexPath.row == 1 {
            cell.bottomCont.constant = 25
        }
        if indexPath.row == 2 {
            cell.topCont.constant = 25
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        backBtnAct(self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
