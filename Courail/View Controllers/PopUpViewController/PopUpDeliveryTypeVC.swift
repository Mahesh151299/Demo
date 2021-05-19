//
//  PopUpDeliveryTypeVC.swift
//  Courail
//
//  Created by mac on 07/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit


struct transportData {
    var tranportImg: [UIImage]?,
    TransportName: [String]?
}

class PopUpTVC: UITableViewCell {
    
    @IBOutlet weak var lblPopUpTxt: UILabel!
    @IBOutlet weak var checkMarkSign: UIImageView!
    @IBOutlet weak var transportImg: UIImageView!
    
}

class PopUpDeliveryTypeVC: UIViewController {
    
    @IBOutlet weak var tableViewPopUp: UITableView!
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var tableViewHeightCont: NSLayoutConstraint!
    
    var selectedindex = 0
    
    var stringValue = ""
    
    var popUpData = ["Envelope","Box","Crate","Luggage","Groceries","Take Out","Bag","Bottles / Glass","Laundry / Dry Cleaning"]
    var PackageSizeData = ["Small","Medium","Large","Extra Large"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewDidLayoutSubviews() {
        self.tableViewHeightCont?.constant = self.tableViewPopUp.contentSize.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
         
    }
    
    @IBAction func popUpDismiss(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
}

extension PopUpDeliveryTypeVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if stringValue == "1" {
        return popUpData.count
        } else if stringValue == "2" {
         return PackageSizeData.count
        } else if stringValue == "3" {
         return 0//showTransportData.TransportName!.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = PopUpTVC()
        
        if stringValue == "1" {
           cell = tableViewPopUp.dequeueReusableCell(withIdentifier: "PopUpTVC", for: indexPath) as! PopUpTVC
                            cell.lblPopUpTxt.text = popUpData[indexPath.row]
                            
                            if selectedindex == indexPath.row
                            {
                                cell.checkMarkSign.image = #imageLiteral(resourceName: "imgCheckmark")
                            }else{
                                cell.checkMarkSign.image = nil
                            }
        } else if stringValue == "2" {
           
            cell = tableViewPopUp.dequeueReusableCell(withIdentifier: "PackageSizeCell", for: indexPath) as! PopUpTVC
            cell.lblPopUpTxt.text = PackageSizeData[indexPath.row]
            
            if selectedindex == indexPath.row
            {
                cell.checkMarkSign.image = #imageLiteral(resourceName: "imgCheckmark")
            }else{
                cell.checkMarkSign.image = nil
            }
            
        } else if stringValue == "3" {
            cell = tableViewPopUp.dequeueReusableCell(withIdentifier: "TransportCell", for: indexPath) as! PopUpTVC
//            cell.lblPopUpTxt.text = showTransportData.TransportName?[indexPath.row]
//            cell.transportImg.image = showTransportData.tranportImg?[indexPath.row]
            headerText.text = "Transport By"
                      
                      if selectedindex == indexPath.row
                      {
                          cell.checkMarkSign.image = #imageLiteral(resourceName: "imgCheckmark")
                      }else{
                          cell.checkMarkSign.image = nil
                      }
                      
            
        }
     
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        self.tableViewHeightCont?.constant = self.tableViewPopUp.contentSize.height
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedindex = indexPath.row
    tableViewPopUp.reloadData()
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
}
