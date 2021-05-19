//
//  NotificationPrefVC.swift
//  Courail
//
//  Created by mac on 20/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

struct NotificationData {
   var sectionData: [String]?,
    FirstRowData:[String]?,
    SecondRow:[String]
}

class NotificationPrefTVC: UITableViewCell {
    
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
}

class NotificationPrefVC: UIViewController {
    
    @IBOutlet weak var tableViewNotificationPref: UITableView!
    
    var showNotificationData = NotificationData(sectionData: ["Account and Delivery Updates","Updates, Promotions & Discounts"], FirstRowData: ["Push Notifications","Text Messages"], SecondRow: ["Push Notifications","Text Messages","Off"])
    
    var headercolor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.tableViewNotificationPref.tableFooterView = UIView()
    }

    @IBAction func backAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension NotificationPrefVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return showNotificationData.sectionData!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return showNotificationData.sectionData?[section]
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
           return 2
        } else {
          return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = NotificationPrefTVC()
        if indexPath.section == 0 {
        cell = tableViewNotificationPref.dequeueReusableCell(withIdentifier: "NotificationPrefTVC", for: indexPath) as! NotificationPrefTVC
        cell.lblText.text = showNotificationData.FirstRowData![indexPath.row]
            if indexPath.row == 0 {
                cell.checkImg.isHidden = false
            } else {
                cell.checkImg.isHidden = true
            }
        } else {
        cell = tableViewNotificationPref.dequeueReusableCell(withIdentifier: "NotificationPrefTVC", for: indexPath) as! NotificationPrefTVC
            cell.lblText.text = showNotificationData.SecondRow[indexPath.row]
            if indexPath.row == 1 {
                cell.checkImg.isHidden = false
            } else {
                cell.checkImg.isHidden = true
            }
        }
        
        return cell
    }
    
    
}
