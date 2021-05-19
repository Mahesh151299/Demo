//
//  SelectedStoreVC.swift
//  Courail
//
//  Created by mac on 03/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import GoogleMaps
import Cosmos
import Speech

protocol SelectedStoreDelegate : class {
    func willEditInfo()
}

class SelectedStoreCell: UITableViewCell {
    
    @IBOutlet weak var imgGrocery: UIImageView!
    @IBOutlet weak var lblTittle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var addressLine2: UILabel!
    @IBOutlet weak var milFee: UILabel!
    @IBOutlet weak var lblTiming: UILabel!
    
    @IBOutlet weak var titleDeliveryLbl: UILabel!
    
    @IBOutlet weak var aptInfo: UILabel!
    
    @IBOutlet weak var storeNameView: UIViewCustomClass!
    @IBOutlet weak var storeNameTF: UITextField!
    
    @IBOutlet weak var storeNumberTF: UITextField!
    @IBOutlet weak var storeNumberView: UIViewCustomClass!
    
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var nickNameView: UIView!
    @IBOutlet weak var btnBusinessImage: UIButton!
    @IBOutlet weak var cameraIcon: UIImageView!
    
    var businessDetail : YelpStoreBusinesses?{
        didSet{
            self.lblTittle.text = businessDetail?.name
            
            let address = businessDetail?.location
            if (address?.displayAddress?.count ?? 0) > 2{
                let line1 = self.businessDetail?.location?.displayAddress?.first ?? ""
                let line2 = self.businessDetail?.location?.displayAddress?.last ?? ""
                
                let zipCode = address?.zipCode ?? "------"
                var line2filter = line2.replacingOccurrences(of: ", \(zipCode)", with: "")
                line2filter = line2filter.replacingOccurrences(of: " \(zipCode)", with: "")
                self.lblAddress.text = line1 + "\n" + line2filter
            } else{
                let zipCode = address?.zipCode ?? "------"
                var filterAdd = self.businessDetail?.location?.displayAddress?.joined(separator: "\n").replacingOccurrences(of: ", \(zipCode)", with: "")
                filterAdd = filterAdd?.replacingOccurrences(of: " \(zipCode)", with: "")
                self.lblAddress.text = filterAdd
            }
            
            var distance = (businessDetail?.distance ?? "")
            let distanceMiles = JSON(distance).doubleValue * 0.000621371192
            distance = String(format: "%.02f", distanceMiles) + " mi"
            
            let mileage = 9.95 + ((distanceMiles < 1) ? 1.11 : (1.11 * distanceMiles))

            self.milFee.text = "$\(String(format: "%.02f", mileage)) fee • "
            self.lblTiming.text = distance + " away"
        }
    }
    
}

class SelectedStoreVC: UIViewController, CLLocationManagerDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var deliveryAdd: UIButton!

    
    @IBOutlet var viewBottom: UIView!
    @IBOutlet var mapVw: GMSMapView!
    @IBOutlet weak var tableViewGroceryDelivery: UITableView!
    @IBOutlet weak var HeightTblVw: NSLayoutConstraint!
    
    @IBOutlet weak var imgCallNow: UIImageView!
    @IBOutlet weak var currentLocBtnOut: UIButton!
    
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var btnViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var heartView: UIView!
    @IBOutlet weak var heartIcon: UIImageView!
    @IBOutlet weak var callView: UIView!
    
    @IBOutlet weak var endCallView: UIViewCustomClass!
    //MARK: VARIABLES
    
    weak var delegate : SelectedStoreDelegate?
    
    var locationManager = CLLocationManager()
    
    var category = ""
    var isFilled = false
    
    var myMarker = GMSMarker()
    var storeMarker = GMSMarker()
    
    
    var businessDetail : YelpStoreBusinesses?
    var businessImage : UIImage?
    var isReversedDel = false
    
    var imagePicker : ImagePicker!
    var isStoreInfo = false
    
    var nameLbl : UILabel?
    
    var isliveOrderChanges = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.businessDetail?.category = self.category
        self.mapVw.delegate = self
        
        
        if self.isStoreInfo{
            self.imgCallNow.isHidden = false
            self.currentLocBtnOut.isHidden = true
        }else{
            self.imgCallNow.isHidden = true
            self.currentLocBtnOut.isHidden = false
        }
        
        if self.isFilled == false && self.isStoreInfo == false{
            self.getDetails(isSpecial: (self.category.lowercased() == "special"))
        }
        
        if self.category.lowercased() == "special"{
            if self.isFilled == false{
                self.btnView.isHidden = true
                self.btnViewHeight.constant = 0
                
                if let nameCell = self.tableViewGroceryDelivery.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? SelectedStoreCell{
                    nameCell.storeNameTF.text = PickUpAddressInterface.shared.selectedAddress.placeName ?? ""
                    self.textFieldChanged(nameCell.storeNameTF)
                }
                
            } else{
                self.btnView.isHidden = false
                self.btnViewHeight.constant = 35
                
                if let points = self.businessDetail?.points{
                    for point in points{
                        let path = GMSPath.init(fromEncodedPath: point)
                        let polyline = GMSPolyline(path: path)
                        polyline.strokeColor = .black
                        polyline.strokeWidth = 2
                        polyline.map = self.mapVw
                    }
                }
            }
            let storeCords = PickUpAddressInterface.shared.getPickupCords()
            self.storeMarker = GMSMarker.init(position: storeCords)
        } else{
            self.btnView.isHidden = false
            self.btnViewHeight.constant = 35
            
            let storeLats = self.businessDetail?.coordinates?.latitude ?? 0.0
            let storeLongs = self.businessDetail?.coordinates?.longitude ?? 0.0
            let storeCords = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(storeLats), longitude: CLLocationDegrees(storeLongs))
            self.storeMarker = GMSMarker.init(position: storeCords)
        }
        
        if self.isReversedDel{
            self.storeMarker.icon = UIImage(named: "imgMarkerDeliveryShadow")
        } else{
            self.storeMarker.icon = UIImage(named: "imgMarkerPickShadow")
        }
        
        self.storeMarker.map = self.mapVw
        
        self.myMarker = GMSMarker.init(position: DeliveryAddressInterface.shared.getDeliveryCords())
        
        if self.isReversedDel{
            self.myMarker.icon = UIImage(named: "imgMarkerPickShadow")
        } else{
            self.myMarker.icon = UIImage(named: "imgMarkerDeliveryShadow")
        }
        
        self.myMarker.map = self.mapVw
        
        let bounds = GMSCoordinateBounds(coordinate: self.myMarker.position, coordinate: self.storeMarker.position)
        let update = GMSCameraUpdate.fit(bounds, with: .init(top: 150, left: 50, bottom: 300, right: 50))
        //        let update = GMSCameraUpdate.fit(bounds, withPadding: 120)
        self.mapVw.animate(with: update)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deleteOrderFlag = true
        
        self.deliveryAdd.setTitle(DeliveryAddressInterface.shared.selectedAddress.address ?? "", for: .normal)
        if self.isReversedDel == true{
            self.lblDelivery.text = "PICKING UP FROM " + (isLoggedIn() ? (userInfo.firstName ?? "").uppercased() : "YOU")
        } else{
            self.lblDelivery.text = "DELIVERING TO " + (isLoggedIn() ? (userInfo.firstName ?? "").uppercased() : "YOU")
        }
        
        self.tabBarController?.tabBar.isHidden = false

        if self.category.lowercased() == "special"{
            self.callView.isHidden = false
            self.heartView.isHidden = !self.isFilled
            if self.isFilled && isLoggedIn(){
                self.getFavApi()
            }
        } else{
            if isLoggedIn(){
                self.getFavApi()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deleteOrderFlag = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.HeightTblVw.constant = self.tableViewGroceryDelivery.contentSize.height
    }
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func backBtn(_ sender: Any) {
        guard self.endCallView.isHidden else {
            showSwiftyAlert("", "Please End Call to continue", false)
            return
        }
        
        if self.category.lowercased() == "special" && self.isFilled == false{
            if self.isliveOrderChanges{
                self.pop()
            }else{
                goToSpecialDelivery(self)
            }
        } else{
            if self.isFilled{
                self.delegate?.willEditInfo()
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func tittleBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SetAddressVC") as! SetAddressVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func BtnCurrentLocation(_ sender: Any) {
        self.showDeliveryAdd()
    }
    
    @IBAction func callBtn(_ sender: UIButton) {
        MediaShareInterface.shared.endCallView = self.endCallView
        MediaShareInterface.shared.tabBarShowAtEnd = true
        MediaShareInterface.shared.twilioCall(vc: self,no: (self.businessDetail?.displayPhone ?? "") , name: (self.businessDetail?.name ?? "Store").uppercased())
    }
    
    @IBAction func showCallBtn(_ sender: UIButton) {
        MediaShareInterface.shared.voipView?.view.isHidden = false
        MediaShareInterface.shared.endCallView?.isHidden = true
    }
    
    @IBAction func endCallBtn(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.view.setNeedsLayout()
        
        MediaShareInterface.shared.endCallView?.isHidden = true
        guard MediaShareInterface.shared.voipView != nil else{
            return
        }
        MediaShareInterface.shared.voipView?.crossPressed = false
        MediaShareInterface.shared.voipView?.endCall()
    }
    
    @IBAction func heartBtnAction(sender: UIButton) {
        self.view.endEditing(true)
        if checkLogin(){
            if self.businessDetail?.isFav == true{
                self.removeFavApi()
            } else{
                if self.category.lowercased() == "special" && self.businessImage?.accessibilityHint != nil{
                    self.uploadSpecialImage(self.businessImage) { (_) in }
                } else{
                    self.addFavApi()
                }
            }
        }
    }
    
    
    
    @objc func imageBtn(sender: UIButton) {
        if checkLogin(){
            self.imagePicker = ImagePicker(presentationController: self, delegate: self)
            self.imagePicker.present(from: sender)
        }
    }
    
    
    @IBAction func btnScheduleDeliveryAction(sender: UIButton){
        self.view.endEditing(true)
        
        self.businessDetail?.itemDescription = ""
        self.businessDetail?.courialFee = "00.00"
        self.businessDetail?.subTotalType = "PRE-PAID"
        
        if self.isFilled == false && self.category.lowercased() == "special"{
            if (self.businessDetail?.name ?? "") == ""{
                showSwiftyAlert("", "Please enter Contact Person or Business name ", false)
            }else if (self.businessDetail?.displayPhone ?? "") == ""{
                showSwiftyAlert("", "Please enter Phone number ", false)
            } else if (self.businessDetail?.displayPhone ?? "").isValidateMobile() == false{
                showSwiftyAlert("", "Invalid Phone number ", false)
            } else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedStoreVC")as! SelectedStoreVC
                vc.category = self.category
                vc.businessImage = self.businessImage
                vc.businessDetail = self.businessDetail
                vc.isFilled = true
                vc.isReversedDel = self.isReversedDel
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else{
            guard self.isliveOrderChanges == false else{
                guard let vc = self.navigationController?.viewControllers.last(where: {$0 as? CurrentOrderVC != nil}) else {
                    return
                }
                
                let img = UIImage(named: specialCat["icon"].stringValue)
                img?.accessibilityHint = "png"
                self.uploadSpecialImage(img) { (imgStr) in
                    currentOrder?.name = self.businessDetail?.name ?? ""
                    currentOrder?.pickupInfo?.placeName = self.businessDetail?.name ?? ""
                    currentOrder?.storePhone = self.businessDetail?.displayPhone ?? ""
                    
                    currentOrder?.categoryImage = imgStr
                    currentOrder?.categoryImageColor = specialCat["hex"].stringValue
                    (vc as? CurrentOrderVC)?.getDetails()
                    self.navigationController?.popToViewController(vc, animated: true)
                }
                return
            }
            let vc = storyboard?.instantiateViewController(withIdentifier: "SpecialDeliveryAddToQueueVC") as! SpecialDeliveryAddToQueueVC
            vc.businessDetail = self.businessDetail
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showDeliveryAdd(){
        let camera = GMSCameraPosition.camera(withTarget: DeliveryAddressInterface.shared.getDeliveryCords(), zoom: 15)
        self.mapVw.camera = camera
    }
    
    
}


extension SelectedStoreVC: UITableViewDelegate,UITableViewDataSource,GMSMapViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SelectedStoreCell()
        
        if self.category.lowercased() == "special"{
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! SelectedStoreCell
            
            let address = PickUpAddressInterface.shared.selectedAddress
            let aptInfo = PickUpAddressInterface.shared.selectedAddress.apartmentInfo ?? ""
            
            let address1 = (address.address ?? "") + ", "
            let addressFull = address.fullAddress ?? ""
            let address2 = addressFull.replacingOccurrences(of: address1, with: "")
            
            cell.lblAddress.text = address.address ?? ""
            cell.addressLine2.text = address2
            
            if aptInfo != ""{
                cell.aptInfo.text =  " • " + aptInfo
            } else{
                cell.aptInfo.text =  ""
            }
            
            cell.storeNameTF.text = self.businessDetail?.name ?? ""
            cell.storeNumberTF.text = self.businessDetail?.displayPhone ?? ""
            
//            let duration = businessDetail?.duration ?? ""
            var distance = (businessDetail?.distance ?? "")
            let distanceMiles = JSON(distance).doubleValue * 0.000621371192
            distance = String(format: "%.02f", distanceMiles) + " mi"
            
            let mileage = 9.95 + ((distanceMiles < 1) ? 1.11 : (1.11 * distanceMiles))
            cell.milFee.text = "$\(String(format: "%.02f", mileage)) fee • "
            cell.lblTiming.text = distance + " away"
                        
            
            cell.storeNameTF.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .editingChanged)
            cell.storeNumberTF.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .editingChanged)
            
            cell.storeNumberTF.accessibilityHint = "number"
            cell.storeNumberTF.delegate = self
            
            
            self.nameLbl = cell.nickNameLbl
            
            
            cell.btnBusinessImage.addTarget(self, action: #selector(self.imageBtn(sender:)), for: .touchUpInside)
            
            
            if self.isFilled{
                cell.lblTittle.text = self.businessDetail?.name ?? ""
                //                cell.cameraIcon.isHidden = true
                cell.btnBusinessImage.isUserInteractionEnabled = false
                
                cell.storeNameView.isHidden = true
                cell.storeNumberView.isHidden = true
                
                let nameArr = self.businessDetail?.name?.components(separatedBy: " ")
                var firstChar = ""
                var lastChar = ""
                if let first = (nameArr?.first?.uppercased() ?? "").first{
                    firstChar = "\(first)"
                    if (nameArr?.count ?? 0 > 1) , let last = (nameArr?[1].uppercased() ?? "").first{
                        lastChar = "\(last)"
                    }
                }
                self.nameLbl?.text = firstChar + lastChar
                
            }else{
                cell.lblTittle.text = ""
                //                cell.cameraIcon.isHidden = false
                cell.btnBusinessImage.isUserInteractionEnabled = true
                
                cell.storeNameView.isHidden = false
                cell.storeNumberView.isHidden = false
            }
        } else{
            cell = tableView.dequeueReusableCell(withIdentifier: "SelectedStoreCell", for: indexPath) as! SelectedStoreCell
            cell.businessDetail = self.businessDetail
            cell.imgGrocery.sd_setImage(with: URL(string: self.businessDetail?.imageUrl ?? ""), placeholderImage: UIImage(named: "imgNoLogo"), options: [], completed: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.HeightTblVw.constant = tableView.contentSize.height
    }
}


extension SelectedStoreVC : UITextFieldDelegate , ImagePickerDelegate, SelectedStoreDelegate{
    
    func willEditInfo() {
        self.nameLbl?.text = ""
        self.businessDetail?.displayPhone = ""
        self.businessDetail?.name = ""
        self.tableViewGroceryDelivery.reloadData()
    }
    
    
    func didSelect(image: UIImage?,video : URL?) {
        guard let img = image else{return}
        img.accessibilityHint = "image"
        self.businessImage = img
        self.tableViewGroceryDelivery.reloadData()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.accessibilityHint == "number" && (self.businessDetail?.name ?? "").isEmpty{
            showSwiftyAlert("", "Please enter Contact Person or Business first", false)
            textField.resignFirstResponder()
        }
    }
    
    @objc func textFieldChanged(_ sender: UITextField){
        if sender.accessibilityHint == "number"{
            self.businessDetail?.displayPhone = sender.text!
        } else{
            self.businessDetail?.name = sender.text!
            
            let nameArr = self.businessDetail?.name?.components(separatedBy: " ")
            var firstChar = ""
            var lastChar = ""
            if let first = (nameArr?.first?.uppercased() ?? "").first{
                firstChar = "\(first)"
                if (nameArr?.count ?? 0 > 1) , let last = (nameArr?[1].uppercased() ?? "").first{
                    lastChar = "\(last)"
                }
            }
            self.nameLbl?.text = firstChar + lastChar
        }
        
        if (self.businessDetail?.displayPhone ?? "").isValidateMobile() && (self.businessDetail?.name ?? "").isEmpty == false{
            self.view.endEditing(true)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedStoreVC")as! SelectedStoreVC
            vc.category = self.category
            vc.businessImage = self.businessImage
            vc.businessDetail = self.businessDetail
            vc.isFilled = true
            vc.delegate = self
            vc.isReversedDel = self.isReversedDel
            vc.isliveOrderChanges = self.isliveOrderChanges
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.accessibilityHint == "number"{
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = newString.formattedNumber()
            self.textFieldChanged(textField)
            return false
        }
        return true
    }
    
    
    
}

extension SelectedStoreVC {
    
    //Special Polyline and Distance
    
    func getDetails(isSpecial: Bool){
        let originLats = DeliveryAddressInterface.shared.getDeliveryCords().latitude
        let originLongs = DeliveryAddressInterface.shared.getDeliveryCords().longitude
        
        var storeLats = CLLocationDegrees(self.businessDetail?.coordinates?.latitude ?? 0.0)
        var storeLongs = CLLocationDegrees(self.businessDetail?.coordinates?.longitude ?? 0.0)
        
        if isSpecial{
            storeLats = PickUpAddressInterface.shared.getPickupCords().latitude
            storeLongs = PickUpAddressInterface.shared.getPickupCords().longitude
        }
        
        guard let url = URL.init(string: "https://maps.googleapis.com/maps/api/directions/json?&mode=driving&origin=\(originLats),\(originLongs)&destination=\(storeLats),\(storeLongs)&sensor=false&key=\(gooleMapKey)") else {return}
        
        showLoader()
        
        Alamofire.request(url).responseJSON { response in
            let jsonData = JSON(response.result.value as Any)
            
            if isSpecial{
                self.businessDetail = YelpStoreBusinesses.init(json: JSON())
                self.businessDetail?.isReversedDel = self.isReversedDel
                self.businessDetail?.category = self.category
                self.businessDetail?.location?.address1 = PickUpAddressInterface.shared.selectedAddress.address
                self.businessDetail?.location?.address2 = PickUpAddressInterface.shared.selectedAddress.fullAddress
                self.businessDetail?.location?.address3 = PickUpAddressInterface.shared.selectedAddress.fullAddress
                self.businessDetail?.location?.aptInfo = PickUpAddressInterface.shared.selectedAddress.apartmentInfo
                self.businessDetail?.additionalNotes = PickUpAddressInterface.shared.selectedAddress.notes ?? ""
                self.businessDetail?.coordinates?.latitude = JSON(storeLats).floatValue
                self.businessDetail?.coordinates?.longitude = JSON(storeLongs).floatValue
                
                self.businessDetail?.location?.pickOption = PickUpAddressInterface.shared.selectedAddress.dropPickupoptions
                self.businessDetail?.location?.pickFlightStairs = PickUpAddressInterface.shared.selectedAddress.flightofStairs
                self.businessDetail?.location?.pickElevatorFloor = PickUpAddressInterface.shared.selectedAddress.elevatorFloor
                self.businessDetail?.location?.pick_elevator_walk_both = PickUpAddressInterface.shared.selectedAddress.elevator_walk_both
                
                let addresses = (PickUpAddressInterface.shared.selectedAddress.fullAddress ?? "").components(separatedBy: ", ")
                if addresses.count < 3{
                    self.businessDetail?.location?.displayAddress = addresses
                } else{
                    let line1 = addresses.first ?? ""
                    let line2 = addresses[(addresses.count - 2)] + ", " + addresses[(addresses.count - 1)]
                    self.businessDetail?.location?.displayAddress = [line1, line2]
                }
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
                    
                    self.businessDetail?.points = points
                    if isSpecial{
                        self.businessDetail?.duration = duration
                        self.businessDetail?.distance = distance
                    }
                } else{
                    if isSpecial{
                        self.businessDetail?.distance = "0 mi"
                        self.businessDetail?.duration = "NO TIME"
                    }
                }
            } else{
                if isSpecial{
                    self.businessDetail?.distance = "0 mi"
                    self.businessDetail?.duration = "NO TIME"
                }
            }
            
            if let points = self.businessDetail?.points{
                for point in points{
                    let path = GMSPath.init(fromEncodedPath: point)
                    let polyline = GMSPolyline(path: path)
                    polyline.strokeColor = .black
                    polyline.strokeWidth = 2
                    polyline.map = self.mapVw
                }
            }
            
            hideLoader()
            self.tableViewGroceryDelivery.reloadData()
            
            if self.category.lowercased() == "special"{
                if let nameCell = self.tableViewGroceryDelivery.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? SelectedStoreCell{
                    nameCell.storeNameTF.text = PickUpAddressInterface.shared.selectedAddress.placeName ?? ""
                    self.textFieldChanged(nameCell.storeNameTF)
                }
            }
        }
    }
    
    
    //MARK:- API
    
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
    
    
    func uploadSpecialImage(_ img: UIImage?, success: @escaping(String)-> Void){
        showLoader()
        ApiInterface.formDataApi(params: [:], api_url: API.upload_image, image: img, imageName: "image", success: { (json) in
            hideLoader()
            self.businessDetail?.imageUrl = json["data"]["image"].stringValue
            if self.isliveOrderChanges{
                success(json["data"]["image"].stringValue)
            }else{
                self.addFavApi()
            }
        }) { (error, json) in
            hideLoader()
            if self.isliveOrderChanges{
                success("")
            }else{
                self.addFavApi()
            }
        }
    }
        
    func getFavApi(){
        showLoader()
        ApiInterface.requestApi(params: [:], api_url: API.get_fav_businesss, method: .get , encoding: URLEncoding.httpBody , success: { (json) in
            hideLoader()
            var favArray = [FavoriteModel]()
            if let data = json["data"].array{
                favArray = data.map({FavoriteModel.init(json: $0)})
            }
            
            if self.category.lowercased() == "special"{
                if let index = favArray.firstIndex(where: {($0.data?.phone == self.businessDetail?.displayPhone) && ($0.data?.name == self.businessDetail?.name)}){
                    self.businessDetail?.isFav = true
                    self.businessDetail?.favId = "\(favArray[index].internalIdentifier ?? 0)"
                    
                    self.heartIcon.image = UIImage(named: "heart2_2")
                } else{
                    self.businessDetail?.isFav = false
                    self.businessDetail?.favId = ""
                    self.heartIcon.image = UIImage(named: "heart3_2-1")
                }
                
            } else{
                if let index = favArray.firstIndex(where: {($0.data?.googlePlaceID == self.businessDetail?.googlePlaceID) && ($0.data?.internalIdentifier == self.businessDetail?.internalIdentifier)}){
                    self.businessDetail?.isFav = true
                    self.businessDetail?.favId = "\(favArray[index].internalIdentifier ?? 0)"
                    
                    self.heartIcon.image = UIImage(named: "heart2_2")
                } else{
                    self.businessDetail?.isFav = false
                    
                    self.businessDetail?.favId = ""
                    
                    self.heartIcon.image = UIImage(named: "heart3_2-1")
                }
            }
            
        }) { (error, json) in
            hideLoader()
        }
    }
    
    
}

