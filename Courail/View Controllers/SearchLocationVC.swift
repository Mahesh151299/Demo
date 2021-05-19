//
//  SearchLocationVC.swift
//  Courail
//
//  Created by mac on 13/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchLocationTVC: UITableViewCell {
    
    @IBOutlet weak var addressLine1: UILabel!
    @IBOutlet weak var addressLine2: UILabel!
    
}

class SearchLocationVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var tableViewSearchLocation: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var screenTitle: UILabel!
    
    @IBOutlet weak var topTitleView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var setOnMapView: UIView!
    //MARK: VARIABLES
    
    var results = [GMSAutocompletePrediction]()
    var fromMapScreen = false
    var completion: ((AddressModel)->())?
    var index = ""
    var isDelivery = true
    var isSwitched = false
    var isReversedDel = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isDelivery{
            self.screenTitle.text = "What’s the delivery address?"
//            self.topView.backgroundColor = appColorBlue
//            self.topTitleView.backgroundColor = appColorBlue
        } else{
            self.screenTitle.text = "What’s the pick up address?"
            self.topView.backgroundColor = appColor
            self.topTitleView.backgroundColor = appColor
        }
        
        self.textField.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .editingChanged)
        self.textField.becomeFirstResponder()
        self.tableViewSearchLocation.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        if self.fromMapScreen{
            self.setOnMapView.isHidden = true
        } else{
            self.setOnMapView.isHidden = false
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.view.endEditing(true)
        
        guard goToCurrentOrder(self, false) == false else { return }
        
        if isSwitched{
            if self.isDelivery{
                goToSpecialDelivery(self)
            } else{
                self.pop()
//                GoToHome()
            }
        } else{
            if self.isDelivery{
                self.pop()
//                GoToHome()
            } else{
                goToSpecialDelivery(self)
            }
        }
    }
    
    @IBAction func cancelTextField(_ sender: Any) {
        self.textField.text = ""
        self.results.removeAll()
        self.tableViewSearchLocation.reloadData()
    }
    
    @IBAction func setOnMapBtn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FindDeliveryAddress") as! FindDeliveryAddress
        vc.isDelivery = self.isDelivery
        vc.index = self.index
        vc.isSwitched = self.isSwitched
        vc.isReversedDel = self.isReversedDel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: BUTTONS ACTIONS
    
    @objc func textFieldChanged(_ sender: UITextField){
        if sender.text == ""{
            self.results.removeAll()
            self.tableViewSearchLocation.reloadData()
        } else{
            MapHelper.sharedInstance.placeAutocomplete(searchText: sender.text!, success: { (results) in
                if results.isEmpty == false{
                    self.results = results
                } else{
                    self.results.removeAll()
                }
                self.tableViewSearchLocation.reloadData()
                self.tableViewSearchLocation.reloadData()
            }) { (error) in
                self.results.removeAll()
                self.tableViewSearchLocation.reloadData()
            }
        }
    }
    
    
}

extension SearchLocationVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SearchLocationTVC()
        
        cell = tableViewSearchLocation.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchLocationTVC
        
        let data  = self.results[indexPath.row]
        cell.addressLine1.text = data.attributedPrimaryText.string
        var address2 = data.attributedSecondaryText?.string ?? " "
        address2 = address2.components(separatedBy: ", ").dropLast().joined(separator: ", ")
        cell.addressLine2.text = address2
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        
        self.view.endEditing(true)
        
        let result = self.results[indexPath.row]
        showLoader()
        MapHelper.sharedInstance.LookupPlace(with: self.results[indexPath.row].placeID, success: { (place) in
            
            var city = place.addressComponents?.filter({$0.type == "locality"}).first?.name ?? ""
            if city == ""{
                city = place.addressComponents?.filter({$0.type == "administrative_area_level_3"}).first?.name ?? ""
            }
            //                var stateCode = place.addressComponents?.filter({$0.type == "administrative_area_level_1"}).first?.shortName ?? ""
            
            let state = place.addressComponents?.filter({$0.type == "administrative_area_level_1"}).first?.name ?? ""
            //                var postalCode = place.addressComponents?.filter({$0.type == "postal_code"}).first?.name ?? ""
            
            var fullAdd = ""
            
            if result.attributedPrimaryText.string == city || city == state || city ==  ""{
                fullAdd = result.attributedPrimaryText.string + ", " + state
            } else{
                fullAdd = result.attributedPrimaryText.string + ", " + city
                fullAdd = fullAdd + ", " + state
            }
            
            DeliveryAddressInterface.shared.tempAddress.address = result.attributedPrimaryText.string
            //                DeliveryAddressInterface.shared.tempAddress.fullAddress = result.attributedFullText.string
            DeliveryAddressInterface.shared.tempAddress.fullAddress = fullAdd
            DeliveryAddressInterface.shared.tempAddress.latitude = JSON(place.coordinate.latitude).floatValue
            DeliveryAddressInterface.shared.tempAddress.longitude = JSON(place.coordinate.longitude).floatValue
            
            if isLoggedIn(){
                self.addAddressApi(DeliveryAddressInterface.shared.tempAddress)
            } else{
                DeliveryAddressInterface.shared.insertSearchAdd(model: DeliveryAddressInterface.shared.tempAddress, prediction: result)
                DeliveryAddressInterface.shared.filterSeaches()
            }
            
            PickUpAddressInterface.shared.tempAddress = DeliveryAddressInterface.shared.tempAddress
            hideLoader()
            
            if self.fromMapScreen{
                if let result = self.completion{
                    result(DeliveryAddressInterface.shared.tempAddress)
                }
                self.navigationController?.popViewController(animated: true)
            } else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditAddressVC")as! EditAddressVC
                vc.isDelivery = self.isDelivery
                vc.index = self.index
                vc.isSwitched = self.isSwitched
                vc.isReversedDel = self.isReversedDel
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }) { (error) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
        
    }
    
    
}

extension SearchLocationVC{
    
    //MARK: API
    
    func addAddressApi(_ model: AddressModel?){
        let params: Parameters = [
            "address": model?.address ?? "",
            "address_full": model?.fullAddress ?? "",
            "place_name": model?.address ?? "",
            "address_phone": model?.addressPhone ?? "",
            "latitude": "\(model?.latitude ?? 0.0)",
            "longitude": "\(model?.longitude ?? 0.0)",
            "apartment_info": model?.apartmentInfo ?? "",
            "parking_info": model?.parkingInfo ?? "",
            "address_type": "4" , // Home, Work, Custom / search
            "delivery_pickUp": "0",
            "notes": model?.notes ?? "",
            
        ]
        
        ApiInterface.requestApi(params: params, api_url: API.add_address , success: { (json) in
            print(json)
        }) { (error, json) in
            print(error)
        }
    }
    
}


