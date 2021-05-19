//
//  SetAddressVC.swift
//  Courail
//
//  Created by apple on 24/01/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import LGSideMenuController
import GoogleMaps

class SetAddressTVC: UITableViewCell{
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblAddressType: UILabel!
    @IBOutlet weak var addressLine2: UILabel!
    @IBOutlet var imgViewRight: UIImageView!
    @IBOutlet weak var imgViewLeft: UIImageView!
}

struct AddressData{
    var typeStr: [String]?,
        addressStr: [String]?,
        imgArr:[UIImage]?
}

class SetAddressVC: UIViewController, UITextFieldDelegate {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var tblViewAddressList: UITableView!
    @IBOutlet weak var addAddView: UIView!
    @IBOutlet weak var crossBtnOut: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var searchField: UITextField!
    
    //MARK: VARIABLES
    
    var isReversedDel = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.endEditing(true)
        _ = LocationInterface.shared
        tblViewAddressList.tableFooterView = UIView()
        
        DeliveryAddressInterface.shared.fetchCurrentAddress { (address) in
            self.tblViewAddressList.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if DeliveryAddressInterface.shared.selectedAddress.internalIdentifier == nil{
            self.crossBtnOut.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            
            self.titleLbl.text = "What's the delivery address?"
        }else{
            self.crossBtnOut.isHidden = false
            self.tabBarController?.tabBar.isHidden = false
            
            self.titleLbl.text = "Update delivery address?"
        }
        
        self.tblViewAddressList.reloadData()
        if isLoggedIn(){
            self.getAddressApi()
        }
        
        self.addAddView.isHidden = false
    }
    
    
    @IBAction func crossBtnAction(_ sender: Any) {
        guard goToCurrentOrder(self, false) == false else { return }
        
        self.pop()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
        vc.isReversedDel = self.isReversedDel
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func setOnMapBtn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FindDeliveryAddress") as! FindDeliveryAddress
        vc.isReversedDel = self.isReversedDel
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension SetAddressVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 3
        }else if section == 2{
            return DeliveryAddressInterface.shared.searchedAddresses.count
        } else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SetAddressTVC()
        switch indexPath.section {
        case 0:
            cell = tblViewAddressList.dequeueReusableCell(withIdentifier: "SetAddressTVC", for: indexPath) as! SetAddressTVC
            
            var address = AddressModel.init(json: JSON())
            
            if indexPath.row == 0{
                address = DeliveryAddressInterface.shared.currentAddress
                cell.lblAddressType.text = "Use This Address"
                cell.imgViewLeft.image = UIImage(named: "loco-pointer")
                
                cell.separatorInset = .init(top: 0, left: 60, bottom: 0, right: 30)
            }else if indexPath.row == 1{
                address = DeliveryAddressInterface.shared.homeAddress
                cell.lblAddressType.text = "Home"
                cell.imgViewLeft.image = UIImage(named: "homei")
                
                if DeliveryAddressInterface.shared.homeAddress.internalIdentifier != nil && DeliveryAddressInterface.shared.homeAddress.internalIdentifier == DeliveryAddressInterface.shared.selectedAddress.internalIdentifier{
                    cell.lblAddressType.textColor = appColor
                    cell.lblAddress.textColor = appColor
                    cell.addressLine2.textColor = appColor
                } else{
                    cell.lblAddressType.textColor = .black
                    cell.lblAddress.textColor = .black
                    cell.addressLine2.textColor = .black
                }
                
                cell.separatorInset = .init(top: 0, left: 60, bottom: 0, right: 30)
            }else{
                address = DeliveryAddressInterface.shared.workAddress
                cell.lblAddressType.text = "Work"
                cell.imgViewLeft.image = UIImage(named: "briefcase2")
                
                if DeliveryAddressInterface.shared.workAddress.internalIdentifier != nil && DeliveryAddressInterface.shared.workAddress.internalIdentifier == DeliveryAddressInterface.shared.selectedAddress.internalIdentifier{
                    cell.lblAddressType.textColor = appColor
                    cell.lblAddress.textColor = appColor
                    cell.addressLine2.textColor = appColor
                } else{
                    cell.lblAddressType.textColor = .black
                    cell.lblAddress.textColor = .black
                    cell.addressLine2.textColor = .black
                }
                
                cell.separatorInset = .init(top: 0, left: cell.frame.size.width, bottom: 0, right: 0)
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
            guard indexPath.row != 0 else {
                cell = tableView.dequeueReusableCell(withIdentifier: "PickUpFromMeCell", for: indexPath) as! SetAddressTVC
                let address1 = DeliveryAddressInterface.shared.selectedAddress.address ?? ""
//                let addressFull = DeliveryAddressInterface.shared.selectedAddress.fullAddress ?? ""
//                var address2 = addressFull.replacingOccurrences(of: address1, with: "").components(separatedBy: ", ").filter({$0 != ""}).first ?? ""
//                address2 = (address2 == "") ? "" : (", " + address2)
                
                cell.lblAddress.text = address1
                
                cell.separatorInset = .init(top: 0, left: cell.frame.size.width, bottom: 0, right: 0)
                return cell
            }
            
            cell = tblViewAddressList.dequeueReusableCell(withIdentifier: "SavedAddressCell", for: indexPath) as! SetAddressTVC
            cell.separatorInset = .init(top: 0, left: cell.frame.size.width, bottom: 0, right: 0)
            
        default:
            cell = tblViewAddressList.dequeueReusableCell(withIdentifier: "SetAddressTVC", for: indexPath) as! SetAddressTVC
            
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
        if indexPath.section == 1 && indexPath.row == 0 && self.isReversedDel == false{
            return 0
        }else{
            return UITableView.automaticDimension
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                DeliveryAddressInterface.shared.tempAddress = DeliveryAddressInterface.shared.currentAddress
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditAddressVC")as! EditAddressVC
                vc.isReversedDel = self.isReversedDel
                navigationController?.pushViewController(vc, animated: true)
            }else{
                if checkLogin(){
                    if indexPath.row == 1 {
                        if (DeliveryAddressInterface.shared.homeAddress.latitude ?? 0.0) == 0.0{
                            //Address is empty
                            let vc = storyboard?.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
                            vc.index = "Home"
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
                        //work
                        if (DeliveryAddressInterface.shared.workAddress.latitude ?? 0.0) == 0.0{
                            //Address is empty
                            let vc = storyboard?.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
                            vc.index = "Work"
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
                }
            }
            
        case 1:
            guard indexPath.row != 0 else{
                self.pop()
                return
            }
            let vc = storyboard?.instantiateViewController(withIdentifier: "SavedDeliveryAddressVC") as! SavedDeliveryAddressVC
            vc.isReversedDel = self.isReversedDel
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            DeliveryAddressInterface.shared.tempAddress = DeliveryAddressInterface.shared.searchedAddresses[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditAddressVC")as! EditAddressVC
            vc.isReversedDel = self.isReversedDel
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




extension SetAddressVC {
    
    //MARK:- API
    
    func getAddressApi(){
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
            self.tblViewAddressList.reloadData()
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
            if goToCurrentOrder(self, true) == false{
                GoToHome()
            }
        }) { (error, json) in
            hideLoader()
        }
    }
    
}
