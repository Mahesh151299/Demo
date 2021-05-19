//
//  PaymentHistoryVC.swift
//  Courail
//
//  Created by mac on 18/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class PaymentHistoryTVC: UITableViewCell {
    
}

class PaymentHistoryVC: UIViewController {
    
    @IBOutlet weak var tableViewHistory: UITableView!
    
    
     var headerTittle = ["February 2020","January 2020","December 2019","October 2019"]
    
    var headercolor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func GoBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension PaymentHistoryVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
       }
       func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return headerTittle[section]
       }
       func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
           view.tintColor = headercolor
           let header = view as! UITableViewHeaderFooterView
           header.textLabel?.textColor = UIColor.black
          
       }
       func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 50
           
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if section == 0 {
           return 1
           } else {
               return 3
           }
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           var cell = PaymentHistoryTVC()
           if indexPath.section == 0 {
           cell = tableViewHistory.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! PaymentHistoryTVC
           } else if indexPath.section == 1 {
              cell = tableViewHistory.dequeueReusableCell(withIdentifier: "HistoryCell1", for: indexPath) as! PaymentHistoryTVC
           } else if indexPath.section == 2 {
              cell = tableViewHistory.dequeueReusableCell(withIdentifier: "HistoryCell2", for: indexPath) as! PaymentHistoryTVC
           } else {
               cell = tableViewHistory.dequeueReusableCell(withIdentifier: "HistoryCell3", for: indexPath) as! PaymentHistoryTVC
               
           }
           return cell
       }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let VC = storyboard?.instantiateViewController(withIdentifier: "PaymentHistoryDetails") as! PaymentHistoryDetails
            self.navigationController?.view.layer.add(CATransition().segueFromBottom(), forKey: nil)
                      self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
}
