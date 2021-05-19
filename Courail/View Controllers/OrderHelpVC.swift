//
//  OrderHelpVC.swift
//  Courail
//
//  Created by Omeesh Sharma on 06/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

class OrderHelpTVC: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var disableCallView: UIView!
    @IBOutlet weak var callBtn: UIButton!
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var disableMessageView: UIView!
    @IBOutlet weak var messageBtn: UIButton!
    
    @IBOutlet weak var supportView: UIView!
    @IBOutlet weak var supportBtn: UIButton!
    
    @IBOutlet weak var arrow: UIImageView!
    
}

class OrderHelpVC: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    var titleArr = ["Contact Store","Cancel Delivery","Change Delivery Address","Change Pickup Time","Change Tip","Contact Courial Courial","Contact Courial Support"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAct(_ sender: Any) {
        self.remove()
    }
    
    func remove(){
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
    
    @objc func callStoreBtn(_ sender: UIButton){
        //Call Store
        let firstName = userInfo.firstName ?? ""
        let lastName = userInfo.lastName ?? ""
        let fullUserName = firstName + " " + lastName
        
        var storeName = currentOrder?.name ?? ""
        if storeName.lowercased() == fullUserName.lowercased(){
            if fullUserName.lowercased() == currentOrder?.deliveryInfo?.placeName?.lowercased(){
                storeName = currentOrder?.pickupInfo?.placeName ?? ""
            }else{
                storeName = currentOrder?.deliveryInfo?.placeName ?? ""
            }
        }
        
        if let parentVC = (self.parent as? CurrentOrderVC){
            if let orderVC = parentVC.navigationController?.viewControllers.last(where: {($0 as? CD_SeeDetailVC) != nil}){
                (orderVC as? CD_SeeDetailVC)?.shouldHideTabBar = true
                MediaShareInterface.shared.endCallView = (orderVC as? CD_SeeDetailVC)?.endCallView
                
                MediaShareInterface.shared.tabBarShowAtEnd = true
                MediaShareInterface.shared.twilioCall(vc: orderVC,no: (currentOrder?.storePhone ?? "") , name: storeName.uppercased(), hideDetails: true)
                parentVC.navigationController?.popViewController(animated: false)
                self.remove()
            }
        } else{
            MediaShareInterface.shared.endCallView = (self.parent as? CD_SeeDetailVC)?.endCallView
            MediaShareInterface.shared.tabBarShowAtEnd = true
            MediaShareInterface.shared.twilioCall(vc: self.parent ?? self,no: (currentOrder?.storePhone ?? "") , name: storeName.uppercased(), hideDetails: true)
            self.remove()
        }
    }
    
    @objc func callPartnerBtn(_ sender: UIButton){
        //Call partner
        guard (currentOrder?.status ?? 0) != orderStatus.pending else {
            //If courial partner is not yet assigned
            return
        }
        
        let courialFirstName = (currentOrder?.provider?.firstName ?? "").uppercased()
        var courialLastName = ""
        if let lastChar = (currentOrder?.provider?.lastName ?? "").uppercased().first{
            courialLastName = "\(lastChar)"
        }
        let courialName = courialFirstName + " " + courialLastName
        
        let courialNPhone = (currentOrder?.provider?.phone ?? "").replacingOccurrences(of: "[- ()]", with: "", options: .regularExpression, range: nil)
        
        if let parentVC = (self.parent as? CurrentOrderVC){
            if let orderVC = parentVC.navigationController?.viewControllers.last(where: {($0 as? CD_SeeDetailVC) != nil}){
                (orderVC as? CD_SeeDetailVC)?.shouldHideTabBar = true
                MediaShareInterface.shared.endCallView = (orderVC as? CD_SeeDetailVC)?.endCallView
                
                MediaShareInterface.shared.tabBarShowAtEnd = true
                MediaShareInterface.shared.twilioCall(vc: orderVC,no: courialNPhone , name: courialName, hideDetails: true)
                parentVC.navigationController?.popViewController(animated: false)
                self.remove()
            }
        } else{
            MediaShareInterface.shared.endCallView = (self.parent as? CD_SeeDetailVC)?.endCallView
            MediaShareInterface.shared.tabBarShowAtEnd = true
            MediaShareInterface.shared.twilioCall(vc: self.parent ?? self,no: courialNPhone , name: courialName, hideDetails: true)
            self.remove()
        }
    }
    

    @objc func msgBtn(_ sender: UIButton){
        MediaShareInterface.shared.sendSms(twilioCallingNo, self)
    }
    
}

extension OrderHelpVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHelpTVC", for: indexPath) as! OrderHelpTVC
        switch indexPath.row{
        case 0:
            let firstName = userInfo.firstName ?? ""
            let lastName = userInfo.lastName ?? ""
            let fullUserName = firstName + " " + lastName
            
            var storeName = currentOrder?.name ?? ""
            if storeName.lowercased() == fullUserName.lowercased(){
                if fullUserName.lowercased() == currentOrder?.deliveryInfo?.placeName?.lowercased(){
                    storeName = currentOrder?.pickupInfo?.placeName ?? ""
                }else{
                    storeName = currentOrder?.deliveryInfo?.placeName ?? ""
                }
            }
            
            cell.title.text = "Contact " + storeName
            cell.callView.isHidden = false
            cell.disableCallView.isHidden = true
            cell.arrow.isHidden = true
            cell.messageView.isHidden = true
            cell.supportView.isHidden = true
            
            cell.callBtn.addTarget(self, action: #selector(self.callStoreBtn(_:)), for: .touchUpInside)
            
        case 5:
            cell.messageView.isHidden = false
            cell.callView.isHidden = false
            cell.arrow.isHidden = true
            cell.supportView.isHidden = true
            
            if (currentOrder?.status ?? 0) == orderStatus.pending {
                //If courial partner is not yet assigned
                cell.title.text = "Contact Courial"
                cell.disableMessageView.isHidden = false
                cell.disableCallView.isHidden = false
            } else{
                let courialFirstName = (currentOrder?.provider?.firstName ?? "")
                var courialLastName = ""
                if let lastChar = (currentOrder?.provider?.lastName ?? "").uppercased().first{
                    courialLastName = "\(lastChar)"
                }
                let courialName = courialFirstName + " " + courialLastName
                
                cell.title.text = "Contact Courial \(courialName)"
                cell.disableMessageView.isHidden = true
                cell.disableCallView.isHidden = true
            }
            
            cell.callBtn.addTarget(self, action: #selector(self.callPartnerBtn(_:)), for: .touchUpInside)
            
        case 6:
            cell.title.text = self.titleArr[indexPath.row]
            cell.supportView.isHidden = false
            cell.arrow.isHidden = true
            cell.messageView.isHidden = true
            cell.callView.isHidden = true
        default:

            if indexPath.row == 3{
                if JSON(currentOrder?.isSkill ?? "0").boolValue{
                    cell.title.text = "Change Meeting Time"
                }else{
                    cell.title.text = "Change Pickup Time"
                }
            }else{
                cell.title.text = self.titleArr[indexPath.row]
            }
            
            cell.arrow.isHidden = false
            cell.messageView.isHidden = true
            cell.callView.isHidden = true
            cell.supportView.isHidden = true
        }
        
        cell.callBtn.tag = indexPath.row
        
        cell.messageBtn.tag = indexPath.row
        cell.messageBtn.addTarget(self, action: #selector(self.msgBtn(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && JSON(currentOrder?.isSkill ?? "0").boolValue == true{
            return 0
        } else if indexPath.row == 2 || indexPath.row == 3{
            switch currentOrder?.status ?? 0{
            case orderStatus.pending, orderStatus.Accepted:
                return 50
            default:
                return 0
            }
        }else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 1:
            //Cancel Order
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelDeliveryVC") as! CancelDeliveryVC
            vc.modalPresentationStyle = .overCurrentContext
            self.view.addSubview(vc.view)
            self.addChild(vc)
        case 2:
            //Change Address
            switch currentOrder?.status ?? 0{
            case orderStatus.pending,orderStatus.Accepted:
                if let parentVC = (self.parent as? CurrentOrderVC){
                    parentVC.editDeliveryAddress(UIButton())
                }else{
                    (self.parent as? CD_SeeDetailVC)?.editOrder(isAddress: true)
                }
                self.remove()
            default:
                self.table.reloadData()
            }
            
        case 3:
            //Change Time
            switch currentOrder?.status ?? 0{
            case orderStatus.pending,orderStatus.Accepted:
                if let parentVC = (self.parent as? CurrentOrderVC){
                    parentVC.editPickUpTime(UIButton())
                }else{
                    (self.parent as? CD_SeeDetailVC)?.editOrder(isAddress: false)
                }
                self.remove()
            default:
                self.table.reloadData()
            }
            
        case 4:
//            change Tip
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DefaultTipVC")as! DefaultTipVC
                vc.isLiveEdit = true
            self.navigationController?.pushViewController(vc, animated: true)
            self.remove()
            
        case 6:
            //Support Email
            MediaShareInterface.shared.supportEmail(self)
        default:
            break;
        }
    }
    
    
}


extension OrderHelpVC: MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, SFSafariViewControllerDelegate{
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?)
    {
        switch result
        {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
        case MFMailComposeResult.saved:
            print("Mail saved")
        case MFMailComposeResult.sent:
            print("Mail sent")
        case MFMailComposeResult.failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
        default:
            print("Default case")
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func shareImageBySafari(socialURL:String,url:String)
    {
        let shareURL = socialURL + url
        
        if let url = URL(string:shareURL)
        {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate=self
            present(vc, animated: true)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
    {
        self.navigationController?.navigationBar.isHidden=true
        controller.dismiss(animated: true, completion: nil)
    }
}
