//
//  SavedPickUpAddressVC.swift
//  Courail
//
//  Created by mac on 03/03/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SavedPickUpAddressVC: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak fileprivate var tblViewAddress: UITableView!
    @IBOutlet weak fileprivate var MenuOrBackBtn: UIButton!
    @IBOutlet weak var tittleHeader: UILabel!
    
    //MARK:- VARIABLES
    var fromMenu = false
    var isSwitched = false
    var isReversedDel = false
    var category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewAddress.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.tblViewAddress.reloadData()
        if isLoggedIn(){
            self.getDelAddressApi()
        }
    }
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func MenuOrGoBack(_ sender:UIButton){
        if fromMenu{
            toggleMenu(self)
        } else{
            guard goToCurrentOrder(self, false) == false else { return }
            
            if isSwitched{
                self.pop()
//                GoToHome()
            } else{
                goToSpecialDelivery(self)
            }
        }
    }
    
    
    
    @objc func EditBtnAction(sender: UIButton) {
        if sender.accessibilityHint == "1"{
            if checkLogin(){
                if sender.tag == 0{
                    //Home
                    if (DeliveryAddressInterface.shared.homeAddress.latitude ?? 0.0) == 0.0{
                        //Address is emty
                        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
                        vc.index = "Home"
                        vc.isDelivery = false
                        vc.isSwitched = self.isSwitched
                        vc.isReversedDel = self.isReversedDel
                        navigationController?.pushViewController(vc, animated: true)
                    } else{
                        //Address is filled
                        PickUpAddressInterface.shared.tempAddress = DeliveryAddressInterface.shared.homeAddress
                        let vc = storyboard?.instantiateViewController(withIdentifier: "EditAddressVC") as! EditAddressVC
                        vc.isDelivery = false
                        vc.isEdit = true
                        vc.index = "Home"
                        vc.isSwitched = self.isSwitched
                        vc.isReversedDel = self.isReversedDel
                        navigationController?.pushViewController(vc, animated: true)
                    }
                }else if sender.tag == 1{
                    //Work
                    if (DeliveryAddressInterface.shared.workAddress.latitude ?? 0.0) == 0.0{
                        //Address is emty
                        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
                        vc.index = "Work"
                        vc.isDelivery = false
                        vc.isSwitched = self.isSwitched
                        vc.isReversedDel = self.isReversedDel
                        navigationController?.pushViewController(vc, animated: true)
                    } else{
                        //Address is filled
                        PickUpAddressInterface.shared.tempAddress = DeliveryAddressInterface.shared.workAddress
                        let vc = storyboard?.instantiateViewController(withIdentifier: "EditAddressVC") as! EditAddressVC
                        vc.isDelivery = false
                        vc.isEdit = true
                        vc.index = "Work"
                        vc.isSwitched = self.isSwitched
                        vc.isReversedDel = self.isReversedDel
                        navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
            }
        }else{
            PickUpAddressInterface.shared.tempAddress = PickUpAddressInterface.shared.savedAddresses[sender.tag]
            let vc = storyboard?.instantiateViewController(withIdentifier: "EditAddressVC") as! EditAddressVC
            vc.index = "\(sender.tag)"
            vc.isEdit = true
            vc.isDelivery = false
            vc.isSwitched = self.isSwitched
            vc.isReversedDel = self.isReversedDel
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension SavedPickUpAddressVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            //Home,Work
            return 2
        }else if section == 2{
            //Saved
            return PickUpAddressInterface.shared.savedAddresses.count
        } else{
            //courial Hub, New add, Switch
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SavedAddressDataTVC()
        switch indexPath.section{
        case 0: //Courial Hub
            cell = tblViewAddress.dequeueReusableCell(withIdentifier: "SavedAddressDataTVC", for: indexPath) as! SavedAddressDataTVC
            
            let address = DeliveryAddressInterface.shared.courialHub
            cell.imgView.image = UIImage(named: "logo_main")
            
            if address.internalIdentifier != nil && address.internalIdentifier == DeliveryAddressInterface.shared.selectedAddress.internalIdentifier{
                cell.lblAddressType.textColor = appColor
                cell.lblAddress.textColor = appColor
                cell.addressLine2.textColor = appColor
            } else{
                cell.lblAddressType.textColor = .black
                cell.lblAddress.textColor = .black
                cell.addressLine2.textColor = .black
            }
            
            cell.lblAddressType.text = address.placeName ?? ""
            
            let address1 = (address.address ?? "") + ", "
            let addressFull = address.fullAddress ?? ""
            let address2 = addressFull.replacingOccurrences(of: address1, with: "")
            
            cell.lblAddress.text = address.address ?? ""
            cell.addressLine2.text = address2
            
            cell.EditBtn.isHidden = true
            cell.editImg.isHidden = true
            
        case 1: //Home,Work
            cell = tblViewAddress.dequeueReusableCell(withIdentifier: "SavedAddressDataTVC", for: indexPath) as! SavedAddressDataTVC
            
            var address = AddressModel.init(json: JSON())
            
            if indexPath.row == 0{
                //Home
                address = DeliveryAddressInterface.shared.homeAddress
                cell.imgView.image = UIImage(named: "homei")
            } else{
                //Work
                address = DeliveryAddressInterface.shared.workAddress
                cell.imgView.image = UIImage(named: "briefcase2")
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
            
            cell.lblAddressType.text = address.placeName ?? ""
            
            let address1 = (address.address ?? "") + ", "
            let addressFull = address.fullAddress ?? ""
            let address2 = addressFull.replacingOccurrences(of: address1, with: "")
            
            cell.lblAddress.text = address.address ?? ""
            
            if indexPath.row == 0{
                //Home
                cell.addressLine2.text = (DeliveryAddressInterface.shared.homeAddress.latitude ?? 0.0) == 0.0 ? "" : address2
            } else{
                //Work
                cell.addressLine2.text = (DeliveryAddressInterface.shared.workAddress.latitude ?? 0.0) == 0.0 ? "" : address2
            }
            
            cell.EditBtn.tag = indexPath.row
            cell.EditBtn.accessibilityHint = "\(indexPath.section)"
            cell.EditBtn.addTarget(self, action: #selector(EditBtnAction), for: .touchUpInside)
        case 2: //Saved
            cell = tblViewAddress.dequeueReusableCell(withIdentifier: "SavedAddressDataTVC", for: indexPath) as! SavedAddressDataTVC
            
            let address = PickUpAddressInterface.shared.savedAddresses[indexPath.row]
            cell.lblAddressType.text = address.placeName ?? ""
            
            if address.internalIdentifier == DeliveryAddressInterface.shared.selectedAddress.internalIdentifier{
                cell.lblAddressType.textColor = appColor
                cell.lblAddress.textColor = appColor
                cell.addressLine2.textColor = appColor
            } else{
                cell.lblAddressType.textColor = .black
                cell.lblAddress.textColor = .black
                cell.addressLine2.textColor = .black
            }
            
            cell.imgView.image = UIImage(named: "star-1")
            
            let address1 = (address.address ?? "") + ", "
            let addressFull = address.fullAddress ?? ""
            let address2 = addressFull.replacingOccurrences(of: address1, with: "")
            
            cell.lblAddress.text = address.address ?? ""
            cell.addressLine2.text = address2
            
            cell.EditBtn.tag = indexPath.row
            cell.EditBtn.accessibilityHint = "\(indexPath.section)"
            cell.EditBtn.addTarget(self, action: #selector(EditBtnAction), for: .touchUpInside)
            
            if indexPath.row == (PickUpAddressInterface.shared.savedAddresses.count - 1){
                cell.separatorInset = .init(top: 0, left: cell.frame.size.width, bottom: 0, right: 0)
            }else{
                cell.separatorInset = .init(top: 0, left: 60, bottom: 0, right: 35)
            }
            
        case 3: //New Address
            cell = tblViewAddress.dequeueReusableCell(withIdentifier: "AddAddressCell", for: indexPath) as! SavedAddressDataTVC
            cell.separatorInset = .init(top: 0, left: cell.frame.size.width, bottom: 0, right: 0)
            
        default: //Switch
            cell = tblViewAddress.dequeueReusableCell(withIdentifier: "SavedPickUpAddressCell", for: indexPath) as! SavedAddressDataTVC
            
            cell.separatorInset = .init(top: 0, left: cell.frame.size.width, bottom: 0, right: 0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section != 0 else{
            return 0
        }
        
        if indexPath.section > 2{
            return 65
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{ // Courial Hub
            if self.isSwitched{
                if self.isReversedDel{
                    PickUpAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.courialHub
                    if goToCurrentOrder(self, true) == false{
                        self.goToSelectedAddress(isReverse: true)
                    }
                } else{
                    DeliveryAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.courialHub
                    if isLoggedIn(){
                        self.selectAddressApi(model: DeliveryAddressInterface.shared.selectedAddress)
                    } else{
                        if goToCurrentOrder(self, true) == false {
                            GoToHome()
                        }
                    }
                }
            } else{
                PickUpAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.courialHub
                if goToCurrentOrder(self, true) == false {
                    self.goToSelectedAddress(isReverse: self.isReversedDel)
                }
            }
        } else if indexPath.section == 1 { // Home,work
            if checkLogin(){
                if self.isSwitched{
                    //Delivery address to be chosen
                    if indexPath.row == 0{
                        if (DeliveryAddressInterface.shared.homeAddress.latitude ?? 0.0) == 0.0{
                            //Address is DeliveryAddressInterface
                            let vc = storyboard?.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
                            vc.index = "Home"
                            vc.isDelivery = false
                            vc.isSwitched = self.isSwitched
                            vc.isReversedDel = self.isReversedDel
                            navigationController?.pushViewController(vc, animated: true)
                        } else{
                            //Address is filled
                            if self.isReversedDel{
                                PickUpAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.homeAddress
                                if goToCurrentOrder(self, true) == false{
                                    self.goToSelectedAddress(isReverse: true)
                                }
                            } else{
                                DeliveryAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.homeAddress
                                self.selectAddressApi(model: DeliveryAddressInterface.shared.selectedAddress)
                            }
                        }
                    } else{
                        if (DeliveryAddressInterface.shared.workAddress.latitude ?? 0.0) == 0.0{
                            //Address is empty
                            let vc = storyboard?.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
                            vc.index = "Work"
                            vc.isDelivery = false
                            vc.isSwitched = self.isSwitched
                            vc.isReversedDel = self.isReversedDel
                            navigationController?.pushViewController(vc, animated: true)
                        } else{
                            //Address is filled
                            if self.isReversedDel{
                                PickUpAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.workAddress
                                if goToCurrentOrder(self, true) == false{
                                    self.goToSelectedAddress(isReverse: true)
                                }
                            } else{
                                DeliveryAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.workAddress
                                self.selectAddressApi(model: DeliveryAddressInterface.shared.selectedAddress)
                            }
                        }
                    }
                } else{
                    //PickUp address to be chosen
                    if indexPath.row == 0{
                        if (DeliveryAddressInterface.shared.homeAddress.latitude ?? 0.0) == 0.0{
                            //Address is empty
                            let vc = storyboard?.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
                            vc.index = "Home"
                            vc.isDelivery = false
                            vc.isSwitched = self.isSwitched
                            vc.isReversedDel = self.isReversedDel
                            navigationController?.pushViewController(vc, animated: true)
                        } else{
                            //Address is filled
                            PickUpAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.homeAddress
                            if goToCurrentOrder(self, true) == false {
                                self.goToSelectedAddress(isReverse: self.isReversedDel)
                            }
                        }
                    } else{
                        if (DeliveryAddressInterface.shared.workAddress.latitude ?? 0.0) == 0.0{
                            //Address is empty
                            let vc = storyboard?.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
                            vc.index = "Work"
                            vc.isDelivery = false
                            vc.isSwitched = self.isSwitched
                            vc.isReversedDel = self.isReversedDel
                            navigationController?.pushViewController(vc, animated: true)
                        } else{
                            //Address is filled
                            PickUpAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.workAddress
                            if goToCurrentOrder(self, true) == false {
                                self.goToSelectedAddress(isReverse: self.isReversedDel)
                            }
                        }
                    }
                }
            }
        } else if indexPath.section == 2{
            //Saved
            if self.isSwitched{
                if self.isReversedDel{
                    PickUpAddressInterface.shared.selectedAddress = PickUpAddressInterface.shared.savedAddresses[indexPath.row]
                    if goToCurrentOrder(self, true) == false{
                        self.goToSelectedAddress(isReverse: true)
                    }
                } else{
                    DeliveryAddressInterface.shared.selectedAddress = PickUpAddressInterface.shared.savedAddresses[indexPath.row]
                    if isLoggedIn(){
                        self.selectAddressApi(model: DeliveryAddressInterface.shared.selectedAddress)
                    } else{
                        if goToCurrentOrder(self, true) == false {
                            GoToHome()
                        }
                    }
                }
            } else{
                PickUpAddressInterface.shared.selectedAddress = PickUpAddressInterface.shared.savedAddresses[indexPath.row]
                if goToCurrentOrder(self, true) == false {
                    self.goToSelectedAddress(isReverse: self.isReversedDel)
                }
            }
            
        }  else if indexPath.section == 3 {
            //New
            let vc = storyboard?.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
            vc.isDelivery = false
            vc.isSwitched = self.isSwitched
            vc.isReversedDel = self.isReversedDel
            navigationController?.pushViewController(vc, animated: true)
        } else {
            //Switch
            if self.isSwitched{
                self.navigationController?.popViewController(animated: false)
            } else{
                let vc = storyboard?.instantiateViewController(withIdentifier: "SavedDeliveryAddressVC") as! SavedDeliveryAddressVC
                vc.isSwitched = true
                vc.category = self.category
                vc.isReversedDel = self.isReversedDel
                navigationController?.pushViewController(vc, animated: false)
            }
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

extension SavedPickUpAddressVC {
    
    //MARK:- API
    
    func getDelAddressApi(){
        let params: Parameters = [
            "type" : "0"
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.get_address , success: { (json) in
            //            hideLoader()
            if let data = json["data"].array{
                DeliveryAddressInterface.shared.savedAddresses = data.map({AddressModel.init(json: $0)})
            }
            DeliveryAddressInterface.shared.filterHomeWork()
            self.tblViewAddress.reloadData()
            self.getAddressApi()
        }) { (error, json) in
            //            hideLoader()
            self.getAddressApi()
        }
    }
    
    
    
    func getAddressApi(){
        let params: Parameters = [
            "type" : "1"
        ]
        
        //        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.get_address , success: { (json) in
            hideLoader()
            if let data = json["data"].array{
                PickUpAddressInterface.shared.savedAddresses = data.map({AddressModel.init(json: $0)})
            }
            PickUpAddressInterface.shared.filterHomeWork()
            self.tblViewAddress.reloadData()
        }) { (error, json) in
            hideLoader()
        }
    }
    
    func selectAddressApi(model: AddressModel?){
        let params: Parameters = [
            "address_id" : "\(model?.internalIdentifier ?? 0)"
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.select_default_address , method: .put, success: { (json) in
            hideLoader()
            userInfo.selectedAddress = model
            if goToCurrentOrder(self, true) == false {
                GoToHome()
            }
        }) { (error, json) in
            hideLoader()
        }
    }
    
    
}

