//
//  PastDeliveryVC.swift
//  Courail
//
//  Created by mac on 10/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class PastDeliveryTVC: UITableViewCell {
    
    @IBOutlet weak var btnCurrentDelivery: UIButtonCustomClass!
}

class PastDeliveryVC: UIViewController {

    @IBOutlet weak var tableViewPastDelivery: UITableView!
     var isFromSideMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func MenuOrGoBack(_ sender:UIButton)
     {
         if isFromSideMenu
         {
             GoToHome()
         }else
         {
             self.navigationController?.popViewController(animated: true)
         }
     }
    
    @IBAction func btnBack(_ sender: Any) {
    self.navigationController?.view.layer.add(CATransition().segueFromTop(), forKey: nil)
    self.navigationController?.popViewController(animated: true)
    }


}

extension PastDeliveryVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = PastDeliveryTVC()
        if indexPath.section == 0 {
        cell = tableViewPastDelivery.dequeueReusableCell(withIdentifier: "PastDeliveryTVC", for: indexPath) as! PastDeliveryTVC
        } else {
            cell = tableViewPastDelivery.dequeueReusableCell(withIdentifier: "bottomCell", for: indexPath) as! PastDeliveryTVC
            cell.btnCurrentDelivery.addTarget(self, action: #selector(btnCurrentDeliveryAction), for: .touchUpInside)
            
        }
        
        return cell
    }
    
    @objc func btnCurrentDeliveryAction(sender: UIButton) {
      //  self.navigationController?.popToRootViewController(animated: false)
        let vc = storyboard?.instantiateViewController(withIdentifier: "CD_SeeDetailVC") as! CD_SeeDetailVC
        vc.isFromSideMenu = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
