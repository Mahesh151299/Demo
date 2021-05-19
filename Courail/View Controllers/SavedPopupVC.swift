//
//  SavedPopupVC.swift
//  Courail
//
//  Created by Omeesh Sharma on 16/06/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class SavedPopupVC: UIViewController {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var switchLbl: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    //MARK: VARIABLES
    
    var selectedForDelivery = true
    var addressDeivery = true
    
    var referenceVc : SpecialDeliveryAddToQueueVC?
    
    var completion: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        self.table.tableFooterView = UIView()
        
        self.titleLbl.text = (self.addressDeivery) ? "Saved Delivery Addresses" : "Saved Pick Up Addresses"
        self.switchLbl.text = self.addressDeivery ? "Switch to Saved Pick Up Addresses" : "Switch to Saved Delivery Addresses"
        self.getAddressApi()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: BUTTONS ACTIONS
    @IBAction func switchBtn(_ sender: UIButton) {
        self.addressDeivery = !self.addressDeivery
        self.titleLbl.text = (self.addressDeivery) ? "Saved Delivery Addresses" : "Saved Pick Up Addresses"
        self.switchLbl.text = self.addressDeivery ? "Switch to Saved Pick Up Addresses" : "Switch to Saved Delivery Addresses"
        self.table.reloadData()
        self.getAddressApi()
    }
    
    @IBAction func crossBtn(_ sender: UIButton) {
        self.removeView()
    }
    
    func addressSelected(){
        guard let result = self.completion else {
            self.removeView()
            return
        }
        result()
        self.removeView()
    }
    
    func removeView(){
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
}

extension SavedPopupVC : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            //Home,Work
            return 2
        }else{
            //Saved
            if self.addressDeivery{
                return DeliveryAddressInterface.shared.savedAddresses.count
            } else{
                return PickUpAddressInterface.shared.savedAddresses.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SavedAddressDataTVC()
        switch indexPath.section{
        case 0: //Home,Work
            cell = tableView.dequeueReusableCell(withIdentifier: "SavedAddressDataTVC", for: indexPath) as! SavedAddressDataTVC
            
            var address = AddressModel.init(json: JSON())
            
            if indexPath.row == 0{
                //Home
                address = DeliveryAddressInterface.shared.homeAddress
                cell.imgView.image = UIImage(named: "homei")
                
                if DeliveryAddressInterface.shared.homeAddress.internalIdentifier != nil && DeliveryAddressInterface.shared.homeAddress.internalIdentifier == DeliveryAddressInterface.shared.selectedAddress.internalIdentifier{
                    cell.lblAddressType.textColor = appColor
                    cell.lblAddress.textColor = appColor
                    cell.addressLine2.textColor = appColor
                } else{
                    cell.lblAddressType.textColor = .black
                    cell.lblAddress.textColor = .black
                    cell.addressLine2.textColor = .black
                }
            } else{
                //Work
                address = DeliveryAddressInterface.shared.workAddress
                cell.imgView.image = UIImage(named: "briefcase2")
                
                if DeliveryAddressInterface.shared.workAddress.internalIdentifier != nil && DeliveryAddressInterface.shared.workAddress.internalIdentifier == DeliveryAddressInterface.shared.selectedAddress.internalIdentifier{
                    cell.lblAddressType.textColor = appColor
                    cell.lblAddress.textColor = appColor
                    cell.addressLine2.textColor = appColor
                } else{
                    cell.lblAddressType.textColor = .black
                    cell.lblAddress.textColor = .black
                    cell.addressLine2.textColor = .black
                }
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
            
        default: //Saved
            cell = tableView.dequeueReusableCell(withIdentifier: "SavedAddressDataTVC", for: indexPath) as! SavedAddressDataTVC
            
            var address = AddressModel.init(json: JSON())
            
            if self.addressDeivery{
                address = DeliveryAddressInterface.shared.savedAddresses[indexPath.row]
                
//                if address.internalIdentifier == DeliveryAddressInterface.shared.selectedAddress.internalIdentifier{
//                    cell.lblAddressType.textColor = appColor
//                    cell.lblAddress.textColor = appColor
//                    cell.addressLine2.textColor = appColor
//                } else{
//                    cell.lblAddressType.textColor = .black
//                    cell.lblAddress.textColor = .black
//                    cell.addressLine2.textColor = .black
//                }
                
            } else{
                address = PickUpAddressInterface.shared.savedAddresses[indexPath.row]
                
//                if address.internalIdentifier == PickUpAddressInterface.shared.selectedAddress.internalIdentifier{
//                    cell.lblAddressType.textColor = appColor
//                    cell.lblAddress.textColor = appColor
//                    cell.addressLine2.textColor = appColor
//                } else{
//                    cell.lblAddressType.textColor = .black
//                    cell.lblAddress.textColor = .black
//                    cell.addressLine2.textColor = .black
//                }
            }
            
            cell.lblAddressType.text = address.placeName ?? ""
            cell.imgView.image = UIImage(named: "star-1")
            
            let address1 = (address.address ?? "") + ", "
            let addressFull = address.fullAddress ?? ""
            let address2 = addressFull.replacingOccurrences(of: address1, with: "")
            
            cell.lblAddress.text = address.address ?? ""
            cell.addressLine2.text = address2
           
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            let address = (indexPath.row == 0) ? DeliveryAddressInterface.shared.homeAddress : DeliveryAddressInterface.shared.workAddress
            if (address.latitude ?? 0.0) == 0.0{
                return 0
            } else{
                return 65
            }
        } else{
            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            let address = (indexPath.row == 0) ? DeliveryAddressInterface.shared.homeAddress : DeliveryAddressInterface.shared.workAddress
            if (address.latitude ?? 0.0) == 0.0{
                return 0
            } else{
                return UITableView.automaticDimension
            }
        } else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if indexPath.section == 0{ // Home,work
            if self.selectedForDelivery{
                if indexPath.row == 0{
                    DeliveryAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.homeAddress
                } else if indexPath.row == 1{
                    DeliveryAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.workAddress
                }
                self.selectAddressApi(model: DeliveryAddressInterface.shared.selectedAddress)
            } else{
                if indexPath.row == 0{
                    PickUpAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.homeAddress
                } else if indexPath.row == 1{
                    PickUpAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.workAddress
                }
                self.storePickUp()
            }
        } else{ //Saved
            if self.selectedForDelivery{
                if self.addressDeivery{
                    DeliveryAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.savedAddresses[indexPath.row]
                } else{
                    DeliveryAddressInterface.shared.selectedAddress = PickUpAddressInterface.shared.savedAddresses[indexPath.row]
                }
                self.selectAddressApi(model: DeliveryAddressInterface.shared.selectedAddress)
            }else{
                if self.addressDeivery{
                    PickUpAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.savedAddresses[indexPath.row]
                } else{
                    PickUpAddressInterface.shared.selectedAddress = PickUpAddressInterface.shared.savedAddresses[indexPath.row]
                }
                self.storePickUp()
            }
            
        }
    }
    
}

extension SavedPopupVC {
    
    //MARK:- API
    
    func getAddressApi(){
        let params: Parameters = [
            "type" : self.addressDeivery ? "0" : "1"
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.get_address , success: { (json) in
            if self.addressDeivery{
                if let data = json["data"].array{
                    DeliveryAddressInterface.shared.savedAddresses = data.map({AddressModel.init(json: $0)})
                }
                DeliveryAddressInterface.shared.filterHomeWork()
            } else{
                if let data = json["data"].array{
                    PickUpAddressInterface.shared.savedAddresses = data.map({AddressModel.init(json: $0)})
                }
                PickUpAddressInterface.shared.filterHomeWork()
            }
            self.table.emptyDataSetDelegate = self
            self.table.emptyDataSetSource = self
            self.table.reloadData()
            hideLoader()
        }) { (error, json) in
            hideLoader()
            self.table.emptyDataSetDelegate = self
            self.table.emptyDataSetSource = self
            
            self.table.reloadData()
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
            self.getSpecialDetails()
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    func storePickUp(){
        let storeLats = PickUpAddressInterface.shared.getPickupCords().latitude
        let storeLongs = PickUpAddressInterface.shared.getPickupCords().longitude
        
        self.referenceVc?.businessDetail?.location?.address1 = PickUpAddressInterface.shared.selectedAddress.address
        self.referenceVc?.businessDetail?.location?.address2 = PickUpAddressInterface.shared.selectedAddress.fullAddress
        self.referenceVc?.businessDetail?.location?.address3 = PickUpAddressInterface.shared.selectedAddress.fullAddress
        self.referenceVc?.businessDetail?.location?.aptInfo = PickUpAddressInterface.shared.selectedAddress.apartmentInfo
        self.referenceVc?.businessDetail?.additionalNotes = PickUpAddressInterface.shared.selectedAddress.notes ?? ""
        self.referenceVc?.businessDetail?.coordinates?.latitude = JSON(storeLats).floatValue
        self.referenceVc?.businessDetail?.coordinates?.longitude = JSON(storeLongs).floatValue
        self.referenceVc?.businessDetail?.location?.pickOption = PickUpAddressInterface.shared.selectedAddress.dropPickupoptions
        self.referenceVc?.businessDetail?.location?.pickFlightStairs = PickUpAddressInterface.shared.selectedAddress.flightofStairs
        self.referenceVc?.businessDetail?.location?.pickElevatorFloor = PickUpAddressInterface.shared.selectedAddress.elevatorFloor
        self.referenceVc?.businessDetail?.location?.pick_elevator_walk_both = PickUpAddressInterface.shared.selectedAddress.elevator_walk_both
        
        let addresses = (PickUpAddressInterface.shared.selectedAddress.fullAddress ?? "").components(separatedBy: ", ")
        if addresses.count < 3{
            self.referenceVc?.businessDetail?.location?.displayAddress = addresses
        } else{
            let line1 = addresses.first ?? ""
            let line2 = addresses[(addresses.count - 2)] + ", " + addresses[(addresses.count - 1)]
            self.referenceVc?.businessDetail?.location?.displayAddress = [line1, line2]
        }
        
        self.getSpecialDetails()
    }
    
    func getSpecialDetails(){
        let originLats = DeliveryAddressInterface.shared.getDeliveryCords().latitude
        let originLongs = DeliveryAddressInterface.shared.getDeliveryCords().longitude
        
        let storeLats = self.referenceVc?.businessDetail?.coordinates?.latitude ?? 0.0
        let storeLongs = self.referenceVc?.businessDetail?.coordinates?.longitude ?? 0.0
        
        let url = URL.init(string: "https://maps.googleapis.com/maps/api/directions/json?&mode=driving&origin=\(originLats),\(originLongs)&destination=\(storeLats),\(storeLongs)&sensor=false&key=\(gooleMapKey)")!
        
        showLoader()
        
        Alamofire.request(url).responseJSON { response in
            let jsonData = JSON(response.result.value as Any)
           
            guard jsonData["routes"].count != 0 else {
                self.referenceVc?.businessDetail?.distance = "0 mi"
                self.referenceVc?.businessDetail?.duration = "NO TIME"
                hideLoader()
                self.addressSelected()
                return
            }
            
            if (jsonData["routes"].array?.count ?? 0) > 0{
                if (jsonData["routes"][0]["legs"].array?.count ?? 0) > 0{
                    let duration = jsonData["routes"][0]["legs"][0]["duration"]["value"].stringValue // Seconds
                    let distance = jsonData["routes"][0]["legs"][0]["distance"]["value"].stringValue // Meters
                    let routes = jsonData["routes"].arrayValue
                    var points = [String]()
                    for route in routes{
                        let routeOverviewPolyline = route["overview_polyline"].dictionary
                        points.append(routeOverviewPolyline?["points"]?.stringValue ?? "")
                    }
                    
                    self.referenceVc?.businessDetail?.points = points
                    self.referenceVc?.businessDetail?.duration = duration
                    self.referenceVc?.businessDetail?.distance = distance
                } else{
                    self.referenceVc?.businessDetail?.distance = "0 mi"
                    self.referenceVc?.businessDetail?.duration = "NO TIME"
                }
            } else{
                self.referenceVc?.businessDetail?.distance = "0 mi"
                self.referenceVc?.businessDetail?.duration = "NO TIME"
            }
            
            hideLoader()
            self.addressSelected()
        }
    }
    
}



extension SavedPopupVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource{
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = "No address found at the moment!"
        
        let font =  UIFont.boldSystemFont(ofSize: 20)
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
}
