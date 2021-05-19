//
//  SpecialDeliveryVC.swift
//  Courail
//
//  Created by mac on 29/01/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SpecialDeliveryVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var crossBtnOut: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var searchField: UITextField!
    
    //MARK: VARIABLES
    var category = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        
        DeliveryAddressInterface.shared.fetchCurrentAddress { (address) in
            PickUpAddressInterface.shared.currentAddress = DeliveryAddressInterface.shared.currentAddress
            self.table.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        let vcArray = (self.navigationController?.viewControllers)
        let lastVC = vcArray?.dropLast().last
        if (lastVC as? SpecialDeliveryAddToQueueVC) != nil || (lastVC as? QueueDeliveryDetailVC) != nil || (lastVC as? CurrentOrderVC) != nil{
            self.titleLbl.text = "Update pick up address?"
        }else{
            self.titleLbl.text = "What's the pick up address?"
        }
        
        self.table.reloadData()
        if isLoggedIn(){
            self.getSearchedAddressApi()
            self.getAddressApi()
        }
    }
    
    
    //MARK: BUTTONS ACTIONS
    
    @IBAction func crossBtnAction(_ sender: Any) {
        guard goToCurrentOrder(self, false) == false else { return }
        
        self.pop()
//        GoToHome()
        
    }
    
    
    @IBAction func txtFieldAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
        vc.isDelivery = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func setOnMapBtn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FindDeliveryAddress") as! FindDeliveryAddress
        vc.isDelivery = false
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SpecialDeliveryVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 3
        }else if section == 1{
                return 2
        }else if section == 2{
            return DeliveryAddressInterface.shared.searchedAddresses.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SetAddressTVC()
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "SetAddressTVC", for: indexPath) as! SetAddressTVC
            
            var address = AddressModel.init(json: JSON())
         
            if indexPath.row == 0{
                address = PickUpAddressInterface.shared.currentAddress
                cell.lblAddressType.text = "Use This Address"
                cell.imgViewLeft.image = UIImage(named: "loco-pointer")
                
                cell.separatorInset = .init(top: 0, left: 60, bottom: 0, right: 30)
            }else if indexPath.row == 1{
                address = DeliveryAddressInterface.shared.homeAddress
                cell.lblAddressType.text = "Home"
                cell.imgViewLeft.image = UIImage(named: "homei")
                
                cell.separatorInset = .init(top: 0, left: 60, bottom: 0, right: 30)
            }else{
                address = DeliveryAddressInterface.shared.workAddress
                cell.lblAddressType.text = "Work"
                cell.imgViewLeft.image = UIImage(named: "briefcase2")
                
                cell.separatorInset = .init(top: 0, left: cell.frame.size.width, bottom: 0, right: 0)
            }
            
            if address.internalIdentifier != nil && address.internalIdentifier == DeliveryAddressInterface.shared.selectedAddress.internalIdentifier{
                cell.lblAddressType.textColor = appColor
                cell.lblAddress.textColor = appColor
                cell.addressLine2.textColor = appColor
            } else{
                cell.lblAddressType.textColor = .black
                cell.lblAddress.textColor = .black
                cell.addressLine2.textColor = .black
            }
            
            cell.imgViewRight.isHidden = true
            
            let address1 = (address.address ?? "") + ", "
            let addressFull = address.fullAddress ?? ""
            let address2 = addressFull.replacingOccurrences(of: address1, with: "")
            
            cell.lblAddress.text = address.address ?? ""
            
            
            if indexPath.row == 0{
                cell.addressLine2.text = address2
            }else if indexPath.row == 1{
                cell.addressLine2.text = (DeliveryAddressInterface.shared.homeAddress.latitude ?? 0.0) == 0.0 ? "" : address2
            }else{
                cell.addressLine2.text = (DeliveryAddressInterface.shared.workAddress.latitude ?? 0.0) == 0.0 ? "" : address2
            }
            
            
        case 1:
            if indexPath.row == 0{
                cell = tableView.dequeueReusableCell(withIdentifier: "PickUpFromMeCell", for: indexPath) as! SetAddressTVC
                
                let address1 = DeliveryAddressInterface.shared.selectedAddress.address ?? ""
//                let addressFull = DeliveryAddressInterface.shared.selectedAddress.fullAddress ?? ""
//                var address2 = addressFull.replacingOccurrences(of: address1, with: "").components(separatedBy: ", ").filter({$0 != ""}).first ?? ""
//                address2 = (address2 == "") ? "" : (", " + address2)
                
                cell.lblAddress.text = address1
                
                cell.separatorInset = .init(top: 0, left: cell.frame.size.width, bottom: 0, right: 0)
            }  else{
                cell = tableView.dequeueReusableCell(withIdentifier: "SavedAddressCell", for: indexPath) as! SetAddressTVC
                cell.lblAddressType.text = "Saved Pick Up Addresses"
                
                cell.separatorInset = .init(top: 0, left: cell.frame.size.width, bottom: 0, right: 0)
            }
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "SetAddressTVC", for: indexPath) as! SetAddressTVC
            let address = DeliveryAddressInterface.shared.searchedAddresses[indexPath.row]
            cell.imgViewLeft.image = UIImage(named: "recent2")
            cell.imgViewRight.isHidden = address.isSelected
            
            let address1 = (address.address ?? "") + ", "
            let addressFull = address.fullAddress ?? ""
            let address2 = addressFull.replacingOccurrences(of: address1, with: "")
            
            cell.lblAddressType.text = address.address ?? ""
            cell.lblAddress.text = address2
            
            cell.imgViewRight.isHidden = true
            
            cell.separatorInset = .init(top: 0, left: 60, bottom: 0, right: 30)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0{
                PickUpAddressInterface.shared.tempAddress = PickUpAddressInterface.shared.currentAddress
                let vc = storyboard?.instantiateViewController(withIdentifier: "EditAddressVC") as! EditAddressVC
                vc.isDelivery = false
                navigationController?.pushViewController(vc, animated: true)
                
            } else{
                if checkLogin(){
                    if indexPath.row == 1{
                        if (DeliveryAddressInterface.shared.homeAddress.latitude ?? 0.0) == 0.0{
                            //Address is emty
                            let vc = storyboard?.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
                            vc.index = "Home"
                            vc.isDelivery = false
                            navigationController?.pushViewController(vc, animated: true)
                            
                        } else{
                            //Address is filled
                            
                            PickUpAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.homeAddress
                            if goToCurrentOrder(self, true) == false{
                                self.goToSelectedAddress(isReverse: false)
                            }
                        }
                    } else{
                        if (DeliveryAddressInterface.shared.workAddress.latitude ?? 0.0) == 0.0{
                            //Address is emty
                            let vc = storyboard?.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
                            vc.index = "Work"
                            vc.isDelivery = false
                            navigationController?.pushViewController(vc, animated: true)
                        } else{
                            //Address is filled
                            PickUpAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.workAddress
                            if goToCurrentOrder(self, true) == false{
                                self.goToSelectedAddress(isReverse: false)
                            }
                        }
                    }
                }
            }
            
        case 1:
            if indexPath.row == 0{
                let vc = storyboard?.instantiateViewController(withIdentifier: "SetAddressVC") as! SetAddressVC
                vc.isReversedDel = true
                navigationController?.pushViewController(vc, animated: true)
                
            } else{
                let vc = storyboard?.instantiateViewController(withIdentifier: "SavedPickUpAddressVC") as! SavedPickUpAddressVC
                vc.category = "Special"
                navigationController?.pushViewController(vc, animated: true)
            }
        default:
            PickUpAddressInterface.shared.tempAddress = DeliveryAddressInterface.shared.searchedAddresses[indexPath.row]
            let vc = storyboard?.instantiateViewController(withIdentifier: "EditAddressVC") as! EditAddressVC
            vc.isDelivery = false
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func goToSelectedAddress(isReverse: Bool){
        self.view.endEditing(true)
        
        if (PickUpAddressInterface.shared.selectedAddress.addressPhone ?? "").isValidateMobile() && (PickUpAddressInterface.shared.selectedAddress.placeName ?? "").isEmpty == false{
            
            PickUpAddressInterface.shared.getDetails(isReversedDel: isReverse) { (model) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedStoreVC")as! SelectedStoreVC
                vc.category = "Special"
                vc.businessDetail = model
                vc.businessDetail?.name = PickUpAddressInterface.shared.selectedAddress.placeName
                vc.businessDetail?.displayPhone = PickUpAddressInterface.shared.selectedAddress.addressPhone
                vc.isFilled = true
                vc.isReversedDel = isReverse
                vc.isliveOrderChanges = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedStoreVC")as! SelectedStoreVC
            vc.category = "Special"
            vc.isReversedDel = isReverse
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension SpecialDeliveryVC {
    
    //MARK:- API
    
    func getSearchedAddressApi(){
        let params: Parameters = [
            "type" : "0"
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.get_address , success: { (json) in
            hideLoader()
            if let data = json["data"].array{
                DeliveryAddressInterface.shared.savedAddresses = data.map({AddressModel.init(json: $0)})
            }
            DeliveryAddressInterface.shared.filterHomeWork()
            self.table.reloadData()
        }) { (error, json) in
            hideLoader()
        }
    }
    
    func getAddressApi(){
           let params: Parameters = [
               "type" : "1"
           ]
           
           showLoader()
           ApiInterface.requestApi(params: params, api_url: API.get_address , success: { (json) in
               hideLoader()
               if let data = json["data"].array{
                   PickUpAddressInterface.shared.savedAddresses = data.map({AddressModel.init(json: $0)})
               }
               PickUpAddressInterface.shared.filterHomeWork()
               self.table.reloadData()
           }) { (error, json) in
               hideLoader()
           }
       }
    
}
