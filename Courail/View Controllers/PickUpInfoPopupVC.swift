//
//  PickUpInfoPopupVC.swift
//  Courail
//
//  Created by Omeesh Sharma on 12/06/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlaces

class PickUpInfoPopupVC: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var venueTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var notesTV: IQTextView!
    @IBOutlet weak var heartIcon: UIImageView!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var centerConst: NSLayoutConstraint!
    //MARK:- VARIABLES
    
    var completion: ((YelpStoreBusinesses?)->())?
    
    var businessName = ""
    
    var businessDetail : YelpStoreBusinesses?
    var addressInfo = AddressModel.init(json: JSON())
    
    var selectedIndex = 0

    var results = [JSON]()
    
    var savedPickUps = [AddressModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isLoggedIn(){
            self.getDelAddressApi()
        }else{
//            self.savedPickUps = [DeliveryAddressInterface.shared.courialHub]
            self.savedPickUps.removeAll()
            self.savedPickUps.append(contentsOf: PickUpAddressInterface.shared.savedAddresses)
            self.table.reloadData()
        }
        self.table.tableFooterView = UIView()
        
        self.titleLbl.text = "ADD \(businessName) PICKUP INFO"
        self.notesTV.text = self.businessDetail?.additionalNotes ?? ""
        
        self.addressTF.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .editingChanged)
        self.addressTF.addTarget(self, action: #selector(self.textFieldBegin(_:)), for: .editingDidBegin)
        self.addressTF.addTarget(self, action: #selector(self.textFieldEnd(_:)), for: .editingDidEnd)

        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.removeView()
    }
    
    @IBAction func continueBtn(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        
        let address = (self.addressTF.text ?? "").components(separatedBy: ", ")
        if address.count > 1{
            let lastAddress = address.last ?? ""
            let firstAdress = (self.addressTF.text ?? "").replacingOccurrences(of: ", \(lastAddress)", with: "")
            
            self.businessDetail?.location?.address1 = firstAdress
            self.businessDetail?.location?.address2 = lastAddress
            self.businessDetail?.location?.address3 = (self.addressTF.text ?? "")
            self.businessDetail?.location?.displayAddress = [firstAdress,lastAddress]
        }else{
            self.businessDetail?.location?.address1 = (self.addressTF.text ?? "")
            self.businessDetail?.location?.address2 = (self.addressTF.text ?? "")
            self.businessDetail?.location?.address3 = (self.addressTF.text ?? "")
            self.businessDetail?.location?.displayAddress = [(self.addressTF.text ?? "")]
        }
        
        self.businessDetail?.additionalNotes = self.notesTV.text ?? ""
        self.businessDetail?.category = self.businessName
        self.businessDetail?.itemDescription = "Package from \(self.businessName.capitalized)"
        self.businessDetail?.courialFee = ""
        self.businessDetail?.subTotalType = "PRE-PAID"
        
        if self.venueTF.text?.isEmpty == true{
            self.businessDetail?.name = self.businessName
        } else{
            self.businessDetail?.name = self.venueTF.text!
        }
        
        hideLoader()
        guard let result = self.completion else {
            self.removeView()
            return
        }
        result(self.businessDetail)
        self.removeView()
    }
    
    @IBAction func heartBtn(_ sender: UIButton) {
        let address = (self.addressTF.text ?? "").components(separatedBy: ", ")
        if address.count > 1{
            let lastAddress = address.last ?? ""
            let firstAdress = (self.addressTF.text ?? "").replacingOccurrences(of: ", \(lastAddress)", with: "")
            
            self.businessDetail?.location?.address1 = firstAdress
            self.businessDetail?.location?.address2 = lastAddress
            self.businessDetail?.location?.address3 = (self.addressTF.text ?? "")
            self.businessDetail?.location?.displayAddress = [firstAdress,lastAddress]
        }else{
            self.businessDetail?.location?.address1 = (self.addressTF.text ?? "")
            self.businessDetail?.location?.address2 = (self.addressTF.text ?? "")
            self.businessDetail?.location?.address3 = (self.addressTF.text ?? "")
            self.businessDetail?.location?.displayAddress = [(self.addressTF.text ?? "")]
        }
        
        
        self.businessDetail?.additionalNotes = self.notesTV.text ?? ""
        self.businessDetail?.category = self.businessName
        self.businessDetail?.itemDescription = "Package from \(self.businessName.capitalized)"
        self.businessDetail?.courialFee = ""
        self.businessDetail?.subTotalType = "PRE-PAID"
        
        if self.venueTF.text?.isEmpty == true{
            self.businessDetail?.name = self.businessName
        } else{
            self.businessDetail?.name = self.venueTF.text!
        }
        
        if checkLogin(){
            if (self.businessDetail?.isFav ?? false) == false{
                self.addFavApi()
            } else{
                self.removeFavApi()
            }
        }
    }
    
    func removeView(){
        DispatchQueue.main.async {
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    
    
    @objc func textFieldBegin(_ sender: UITextField){
        guard sender.text?.isEmpty == true else{
            return
        }
        self.table.isHidden = false
        self.centerConst.constant = -200
    }
    
    @objc func textFieldEnd(_ sender: UITextField){
        guard sender.text?.isEmpty == true else{
            return
        }
        
        self.table.isHidden = false
        self.centerConst.constant = 0
    }
    
    
    @objc func textFieldChanged(_ sender: UITextField){
        if sender.text == ""{
            self.results.removeAll()
            self.table.reloadData()
        } else{
            self.searchStore(sender.text!)
        }
    }
    
    func searchStore(_ search: String){
        MapHelper.sharedInstance.googleNearby(cords: DeliveryAddressInterface.shared.getDeliveryCords(), name: search , success: { (json) in
            
            guard json["results"].arrayValue.isEmpty == false else {
                self.results.removeAll()
                self.table.reloadData()
                return
            }
            
            for (i, result) in json["results"].arrayValue.enumerated(){
                if i < 5{
                    let fullAdd = result["vicinity"].stringValue
                    let data = JSON([
                        "addrres_1": fullAdd.components(separatedBy: ", ").first ?? fullAdd,
                        "addrres_2": fullAdd.components(separatedBy: ", ").last ?? "",
                        "full_address": fullAdd,
                        "place_id": result["place_id"].stringValue,
                        "lats": result["geometry"]["location"]["lat"].stringValue,
                        "longs": result["geometry"]["location"]["lng"].stringValue,
                        "name":result["name"].stringValue]
                    )
                    self.results.append(data)
                } else{
                    break;
                }
            }
            
            self.table.reloadData()
        }) { (error) in
            print(error)
            self.results.removeAll()
            self.table.reloadData()
        }
    }
    
}


extension PickUpInfoPopupVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appCourialServices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCVC", for: indexPath) as! CategoryCVC
        
        cell.icon.image = UIImage(named: appCourialServices[indexPath.item]["icon"].stringValue)
        cell.iconBGView.backgroundColor = hexStringToUIColor(hex: appCourialServices[indexPath.item]["hex"].stringValue)
        
        if indexPath.item == self.selectedIndex{
            cell.lineView.isHidden = false
        } else{
            cell.lineView.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width) / 5
        return .init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.item
        collectionView.reloadData()
        self.loadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.collectionViewHeight.constant = (collectionView.frame.width) / 5
    }
    
    func loadData(){
        if self.selectedIndex == 0{
            self.venueTF.text = self.businessName
            self.addressTF.placeholder = "Search for " + self.venueTF.text!.capitalized
        } else{
            self.venueTF.text = appCourialServices[self.selectedIndex]["category"].stringValue
            self.addressTF.placeholder = "Search for " + self.venueTF.text!
        }
        
        self.businessDetail?.webStoreType = appCourialServices[self.selectedIndex]["category"].stringValue
        self.addressTF.text = ""
        self.addressTF.resignFirstResponder()
        self.centerConst.constant = 0
        self.results.removeAll()
        self.table.reloadData()
        self.table.isHidden = false
         
       self.searchStore(self.venueTF.text!)
    }
        
        
}


extension PickUpInfoPopupVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 1 else{
            return self.results.count
        }
        
        return self.savedPickUps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchLocationTVC
        
        guard indexPath.section == 1 else{
            let data  = self.results[indexPath.row]
            
            cell.addressLine1.text = data["name"].stringValue
            cell.addressLine2.text = data["full_address"].stringValue
            
            cell.addressLine1.textColor = .white
            cell.addressLine2.textColor = .white
            
            return cell
        }
        
        let data  = self.savedPickUps[indexPath.row]
        
        let address1 = (data.address ?? "") + ", "
        let addressFull = data.fullAddress ?? ""
        let address2 = addressFull.replacingOccurrences(of: address1, with: "")
        
        
        cell.addressLine2.text = address2
        
        if indexPath.row == 0{
            cell.addressLine1.text = data.placeName ?? ""
            cell.addressLine2.text = data.fullAddress ?? ""
            
            cell.addressLine1.textColor = appColor
            cell.addressLine2.textColor = appColor
        } else{
            cell.addressLine1.text = data.address ?? ""
            cell.addressLine2.text = address2
            
            cell.addressLine1.textColor = .white
            cell.addressLine2.textColor = .white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 5))
            header.backgroundColor = .white
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 1 else{
            return 0
        }
        
        if self.savedPickUps.count == 0 || self.results.count == 0{
            return 0
        } else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.addressTF.resignFirstResponder()
        self.centerConst.constant = 0
        tableView.isHidden = true
        
        guard indexPath.section == 1 else{
            let result = self.results[indexPath.row]
            showLoader()
            
            let fullAdd = result["full_address"].stringValue
            self.businessDetail?.googlePlaceID = result["place_id"].stringValue
            self.businessDetail?.location?.address1 = result["addrres_1"].stringValue
            self.businessDetail?.location?.address2 = result["full_address"].stringValue
            self.businessDetail?.location?.address3 = fullAdd
            self.businessDetail?.location?.aptInfo = ""
            self.businessDetail?.additionalNotes = self.notesTV.text ?? ""
            self.businessDetail?.coordinates?.latitude = result["lats"].floatValue
            self.businessDetail?.coordinates?.longitude = result["longs"].floatValue
            self.businessDetail?.location?.pickOption = ""
            self.businessDetail?.location?.pickElevatorFloor = ""
            self.businessDetail?.location?.pick_elevator_walk_both = ""
            self.businessDetail?.category = self.businessName
            
            self.businessDetail?.itemDescription = "Package from \(self.businessName.capitalized)"
            self.businessDetail?.courialFee = ""
            self.businessDetail?.subTotalType = "PRE-PAID"
            
            self.businessDetail?.location?.displayAddress = [result["addrres_1"].stringValue,result["addrres_2"].stringValue]
            
            self.businessDetail?.distance = ""
            self.businessDetail?.duration = ""
            
            self.venueTF.text = result["name"].stringValue
            self.addressTF.text = fullAdd
            
            self.getDistance(self.businessDetail?.coordinates?.latitude,self.businessDetail?.coordinates?.longitude)
            
            return
        }
        
        let data = self.savedPickUps[indexPath.row]
        
        self.businessDetail?.location?.address1 = data.address
        self.businessDetail?.location?.address2 = data.fullAddress
        self.businessDetail?.location?.address3 = data.fullAddress
        self.businessDetail?.location?.aptInfo = data.apartmentInfo
        self.businessDetail?.coordinates?.latitude = data.latitude
        self.businessDetail?.coordinates?.longitude = data.longitude
        self.businessDetail?.location?.pickOption = data.dropPickupoptions
        self.businessDetail?.location?.pickFlightStairs = data.flightofStairs
        self.businessDetail?.location?.pickElevatorFloor = data.elevatorFloor
        self.businessDetail?.location?.pick_elevator_walk_both = data.elevator_walk_both
        
        let addresses = (data.fullAddress ?? "").components(separatedBy: ", ")
        if addresses.count < 3{
            self.businessDetail?.location?.displayAddress = addresses
        } else{
            let line1 = addresses.first ?? ""
            let line2 = addresses[(addresses.count - 2)] + ", " + addresses[(addresses.count - 1)]
            self.businessDetail?.location?.displayAddress = [line1, line2]
        }
        
        self.businessDetail?.distance = ""
        self.businessDetail?.duration = ""
        
        
        let add2 = (data.fullAddress ?? "").replacingOccurrences(of: ((data.address ?? "") + ", "), with: "").components(separatedBy: ", ").first ?? ""
        if add2 != ""{
            self.addressTF.text = (data.address ?? "") + ", " + add2
        } else{
            self.addressTF.text = (data.address ?? "")
        }
        
        if (data.placeName ?? "") != ""{
            self.venueTF.text = data.placeName
        }
        
        
        showLoader()
        self.getDistance(self.businessDetail?.coordinates?.latitude,self.businessDetail?.coordinates?.longitude)
    }
    
}

extension PickUpInfoPopupVC {
    
    func getDistance(_ lats: Float? ,_ longs: Float?){
        let originLats = DeliveryAddressInterface.shared.getDeliveryCords().latitude
        let originLongs = DeliveryAddressInterface.shared.getDeliveryCords().longitude
        
        let storeLats = lats ?? 0.0
        let storeLongs = longs ?? 0.0
        
        let url = URL.init(string: "https://maps.googleapis.com/maps/api/directions/json?&mode=driving&origin=\(originLats),\(originLongs)&destination=\(storeLats),\(storeLongs)&sensor=false&key=\(gooleMapKey)")!
        
        Alamofire.request(url).responseJSON { response in
            let jsonData = JSON(response.result.value as Any)
            
            var totalDistance = ""
            var totalDuration = ""
            
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
                    
                    totalDistance = distance
                    totalDuration = duration
                }
            }
            
            
            let distanceMiles = JSON(totalDistance).doubleValue * 0.000621371192
            let finalDistance = String(format: "%.02f", distanceMiles) + " mi"
            
            if totalDuration == "0"{
                self.distanceLbl.text = finalDistance + " • " + "0 min away"
            } else{
                let durationInt = JSON(totalDuration).intValue
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.hour, .minute]
                formatter.unitsStyle = .short
                let formattedString = formatter.string(from: TimeInterval(durationInt)) ?? ""
                self.distanceLbl.text = finalDistance + " • " + formattedString + " away"
            }
            
            hideLoader()
            
            self.businessDetail?.distance = totalDistance
            self.businessDetail?.duration = totalDuration
            
        }
    }
    
    func addFavApi(){
        let params: Parameters = [
            "json" : JSON(self.businessDetail?.dictionaryRepresentation() ?? [:]).debugDescription
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.add_fav_businesss , success: { (json) in
            hideLoader()
            self.businessDetail?.isFav = true
            self.businessDetail?.favId = json["data"]["id"].stringValue
            self.heartIcon.image = UIImage(named: "heart2_2")
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    func removeFavApi(){
        let params: Parameters = [
            "fav_id" : self.businessDetail?.favId ?? ""
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.remove_fav_businesss, method: .delete , success: { (json) in
            hideLoader()
            self.businessDetail?.isFav = false
            self.heartIcon.image = UIImage(named: "heart3_2-1")
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    
      func getDelAddressApi(){
            let params: Parameters = [
                "type" : "0"
            ]
            
            showLoader()
            ApiInterface.requestApi(params: params, api_url: API.get_address , success: { (json) in
                if let data = json["data"].array{
                    DeliveryAddressInterface.shared.savedAddresses = data.map({AddressModel.init(json: $0)})
                }
                DeliveryAddressInterface.shared.filterHomeWork()
                self.getAddressApi()
            }) { (error, json) in
                self.getAddressApi()
            }
        }
        
        func getAddressApi(){
            let params: Parameters = [
                "type" : "1"
            ]
            
            ApiInterface.requestApi(params: params, api_url: API.get_address , success: { (json) in
                
//                self.savedPickUps = [DeliveryAddressInterface.shared.courialHub]
                self.savedPickUps.removeAll()
                
                if DeliveryAddressInterface.shared.homeAddress.latitude != 0.0{
                    self.savedPickUps.append(DeliveryAddressInterface.shared.homeAddress)
                }
                
                if DeliveryAddressInterface.shared.workAddress.latitude != 0.0{
                    self.savedPickUps.append(DeliveryAddressInterface.shared.workAddress)
                }
                
                var pickUps = [AddressModel]()
                if let data = json["data"].array{
                    pickUps = data.map({AddressModel.init(json: $0)})
                }
                self.savedPickUps.append(contentsOf: pickUps)
                self.table.reloadData()
                hideLoader()
            }) { (error, json) in
//                self.savedPickUps = [DeliveryAddressInterface.shared.courialHub]
                self.savedPickUps.removeAll()
                if DeliveryAddressInterface.shared.homeAddress.latitude != 0.0{
                    self.savedPickUps.append(DeliveryAddressInterface.shared.homeAddress)
                }
                
                if DeliveryAddressInterface.shared.workAddress.latitude != 0.0{
                    self.savedPickUps.append(DeliveryAddressInterface.shared.workAddress)
                }
                self.table.reloadData()
                hideLoader()
            }
        }
    
    
}
