//
//  PaymentHistoryDetails.swift
//  Courail
//
//  Created by mac on 19/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import GoogleMaps

class PaymentHistoryDetailTVC: UITableViewCell {
    
    @IBOutlet var mapVw: GMSMapView!
    
}

class PaymentHistoryDetails: UIViewController {
    
    @IBOutlet weak var tableViewHistoryDetail: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackBtnAct(_ sender: Any) {
        self.navigationController?.view.layer.add(CATransition().segueFromTop(), forKey: nil)
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension PaymentHistoryDetails: UITableViewDelegate,UITableViewDataSource,GMSMapViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = PaymentHistoryDetailTVC()
        if indexPath.section == 0 {
        cell = tableViewHistoryDetail.dequeueReusableCell(withIdentifier: "HistoryDetailCell", for: indexPath) as! PaymentHistoryDetailTVC
        } else if indexPath.section == 1 {
        cell = tableViewHistoryDetail.dequeueReusableCell(withIdentifier: "DeliveryDetailCell", for: indexPath) as! PaymentHistoryDetailTVC
        } else {
        cell = tableViewHistoryDetail.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as! PaymentHistoryDetailTVC
            cell.mapVw.delegate = self
        }
        
        return cell
    }
    

    
    
}
