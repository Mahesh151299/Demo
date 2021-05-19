//
//  PastDeliveryVC.swift
//  Courail
//
//  Created by mac on 10/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class CompletedDeliveryTVC: UITableViewCell {
    
    @IBOutlet weak var StoreName: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var againBtn: UIButton!
    
}

class CompletedDeliveryVC: UIViewController {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var backBtnOut: UIButton!
    
    
    //MARK: VARIABLES
    
    var fromMenu = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.tableFooterView = UIView()
        
        if self.fromMenu{
            self.backBtnOut.setImage(UIImage(named: "newBar"), for: .normal)
        } else{
            self.backBtnOut.setImage(UIImage(named: "arrow_3Temp"), for: .normal)
        }
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
    
    @IBAction func MenuOrGoBack(_ sender:UIButton){
        if fromMenu{
            toggleMenu(self)
        }else{
            self.pop()
        }
    }
    
    @IBAction func currentOrder(_ sender:UIButton){
        if let vc = self.navigationController?.viewControllers.last(where: {($0 as? NoDeliveryVC) != nil}){
            self.navigationController?.popToViewController(vc, animated: true)
        } else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoDeliveryVC")as! NoDeliveryVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func doItAgain(_ sender:UIButton){
        
    }
    
    
}

extension CompletedDeliveryVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedDeliveryTVC")as! CompletedDeliveryTVC
        
        cell.StoreName.text = "Safeway"
        cell.amount.text = "$203.32"
        cell.date.text = "21 May, 2020"
        cell.address.text = "600 California St, San Francisco"
        cell.orderId.text = "Order #A12345"
        
        cell.againBtn.tag = indexPath.row
        cell.againBtn.addTarget(self, action: #selector(self.doItAgain(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
