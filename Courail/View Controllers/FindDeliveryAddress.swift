//
//  FindDeliveryAddress.swift
//  Courail
//
//  Created by mac on 14/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import GoogleMaps

class FindDeliveryAddress: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet var mapVw: GMSMapView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var imgPin: UIImageView!
    
    //MARK:- VARIABLES
    var shouldDrag = true
    var isDelivery = true
    var index = ""
    var isSwitched = false
    var isReversedDel = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapVw.delegate = self
        
        if self.isDelivery{
            self.imgPin.image = UIImage(named: "imgMarkerDelivery")
        } else{
            self.imgPin.image = UIImage(named: "imgMarkerPick")
        }
        
        self.searchField.text = ""
        
        
        if let currentCords = LocationInterface.shared.cords{
            self.mapVw.animate(toLocation: currentCords)
            self.mapVw.animate(toZoom: 15)
        } else{
            let cords = CLLocationCoordinate2D(latitude: 41.279747, longitude: -104.228202)
            self.mapVw.animate(toLocation: cords)
            self.mapVw.animate(toZoom: 10)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK:- BUTTONS ACTIONS
    @IBAction func backAction(_ sender: Any) {
        guard goToCurrentOrder(self, false) == false else { return }
        
        if isSwitched{
            if self.isDelivery{
                goToSpecialDelivery(self)
            } else{
                GoToHome()
            }
        } else{
            if self.isDelivery{
                GoToHome()
            } else{
                goToSpecialDelivery(self)
            }
        }
    }
  
    
    @IBAction func useAddressbtn(_ sender: Any) {
        if self.isDelivery{
            DeliveryAddressInterface.shared.currentAddress = DeliveryAddressInterface.shared.tempAddress
        } else{
            PickUpAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.tempAddress
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditAddressVC")as! EditAddressVC
            vc.isDelivery = self.isDelivery
            vc.index = self.index
            vc.isSwitched = self.isSwitched
            vc.isReversedDel = self.isReversedDel
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    @IBAction func searchBtn(_ sender: UIButton){
        self.shouldDrag = true
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
        vc.fromMapScreen = true
        vc.isDelivery = self.isDelivery
        vc.isReversedDel = self.isReversedDel
        navigationController?.pushViewController(vc, animated: false)
        vc.completion = { address in
            let state = DeliveryAddressInterface.shared.tempAddress.fullAddress?.components(separatedBy: ", ").last ?? ""
            let filterAdd = DeliveryAddressInterface.shared.tempAddress.fullAddress?.replacingOccurrences(of: ", \(state)", with: "")
            self.searchField.text = filterAdd
            let lats = DeliveryAddressInterface.shared.tempAddress.latitude ?? 0.0
            let longs = DeliveryAddressInterface.shared.tempAddress.longitude ?? 0.0
            let cords = CLLocationCoordinate2D(latitude: CLLocationDegrees(lats), longitude: CLLocationDegrees(longs))
            self.shouldDrag = false
            self.mapVw.animate(toLocation: cords)
            self.mapVw.animate(toZoom: 15)
        }
    }
    
    @IBAction func BtnCurrentLocation(_ sender: Any) {
        if let cords = LocationInterface.shared.cords{
            self.mapVw.animate(toLocation: cords)
            self.mapVw.animate(toZoom: 15)
        }
    }
    
}

extension FindDeliveryAddress: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        guard shouldDrag else {
            self.shouldDrag = true
            return
        }
        let centerCords = mapView.camera.target
        
        MapHelper.sharedInstance.reverseGeoCode(location: centerCords, success: { (address) in
            let line1 = address.lines?.first ?? ""
            
            let city = address.locality ?? ""
            let state = address.administrativeArea ?? ""
            
            var fullAdd = (address.thoroughfare ?? line1) + ", " + city + ", " + state
            
            if (address.thoroughfare ?? line1) == city || city == state || city ==  ""{
                fullAdd = (address.thoroughfare ?? line1) + ", " + state
                self.searchField.text = (address.thoroughfare ?? line1)
            } else{
                fullAdd = (address.thoroughfare ?? line1) + ", " + city + ", " + state
                self.searchField.text = (address.thoroughfare ?? line1) + ", " + city
            }
            
                
            DeliveryAddressInterface.shared.tempAddress.addressType = address.thoroughfare ?? line1
            DeliveryAddressInterface.shared.tempAddress.address = address.thoroughfare ?? line1
//            DeliveryAddressInterface.shared.tempAddress.fullAddress = address.lines?.joined(separator: ",") ?? ""
            DeliveryAddressInterface.shared.tempAddress.fullAddress = fullAdd
            DeliveryAddressInterface.shared.tempAddress.latitude = JSON(centerCords.latitude).floatValue
            DeliveryAddressInterface.shared.tempAddress.longitude = JSON(centerCords.longitude).floatValue
            
            PickUpAddressInterface.shared.tempAddress = DeliveryAddressInterface.shared.tempAddress
            
        }) { (error) in
            print(error)
            self.searchField.text = ""
        }
    }
    
    
}
