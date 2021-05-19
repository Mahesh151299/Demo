//
//  PickUpAddressInterface.swift
//  Courail
//
//  Created by Omeesh Sharma on 27/03/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import GooglePlaces

class PickUpAddressInterface: NSObject {
    
    
    static let shared = PickUpAddressInterface()
    
    var currentAddress = AddressModel(json: JSON())
    
    var savedAddresses = [AddressModel]()
    
    var tempAddress = AddressModel.init(json: JSON())
    var selectedAddress = AddressModel.init(json: JSON())
    var addressSelected = false
    
    
    private override init() {
        super.init()
        self.setData()
        _ = LocationInterface.shared
    }
    
    
    func setData(){
        let currentAddress = AddressModel.init(json: JSON([
            "latitude" : LocationInterface.shared.lats,
            "longitude" : LocationInterface.shared.longs,
            "addressType" : "Use Current Location",
            "placeName" : "Use Current Location",
            "is_selected" : true,
            "notes" : "",
            "address" : "",
            "fullAddress" : "",
            "icon": "loco-pointer"
        ]))
        self.currentAddress = currentAddress
    }
    
    func getPickupCords() -> CLLocationCoordinate2D{
        let lats = self.selectedAddress.latitude ?? 0.0
        let longs = self.selectedAddress.longitude ?? 0.0
        return .init(latitude: CLLocationDegrees(lats), longitude: CLLocationDegrees(longs))
    }
    
    func filterHomeWork(){
        self.savedAddresses = DeliveryAddressInterface.shared.removeDuplicates(self.savedAddresses.filter({($0.addressType != "1") && ($0.addressType != "2") && ($0.addressType != "4")}))
    }
    
    func getDetails(isReversedDel: Bool, success: @escaping(YelpStoreBusinesses)->Void){
        let originLats = DeliveryAddressInterface.shared.getDeliveryCords().latitude
        let originLongs = DeliveryAddressInterface.shared.getDeliveryCords().longitude
        
        let storeLats = PickUpAddressInterface.shared.getPickupCords().latitude
        let storeLongs = PickUpAddressInterface.shared.getPickupCords().longitude
        
        guard let url = URL.init(string: "https://maps.googleapis.com/maps/api/directions/json?&mode=driving&origin=\(originLats),\(originLongs)&destination=\(storeLats),\(storeLongs)&sensor=false&key=\(gooleMapKey)") else {return}
        
        showLoader()
        
        Alamofire.request(url).responseJSON { response in
            let jsonData = JSON(response.result.value as Any)
                var businessDetail = YelpStoreBusinesses.init(json: JSON())
                businessDetail.isReversedDel = isReversedDel
                businessDetail.category = "Special"
                businessDetail.location?.address1 = PickUpAddressInterface.shared.selectedAddress.address
                businessDetail.location?.address2 = PickUpAddressInterface.shared.selectedAddress.fullAddress
                businessDetail.location?.address3 = PickUpAddressInterface.shared.selectedAddress.fullAddress
                businessDetail.location?.aptInfo = PickUpAddressInterface.shared.selectedAddress.apartmentInfo
                businessDetail.additionalNotes = PickUpAddressInterface.shared.selectedAddress.notes ?? ""
                businessDetail.coordinates?.latitude = JSON(storeLats).floatValue
                businessDetail.coordinates?.longitude = JSON(storeLongs).floatValue
                
                businessDetail.location?.pickOption = PickUpAddressInterface.shared.selectedAddress.dropPickupoptions
                businessDetail.location?.pickFlightStairs = PickUpAddressInterface.shared.selectedAddress.flightofStairs
                businessDetail.location?.pickElevatorFloor = PickUpAddressInterface.shared.selectedAddress.elevatorFloor
                businessDetail.location?.pick_elevator_walk_both = PickUpAddressInterface.shared.selectedAddress.elevator_walk_both
                
                let addresses = (PickUpAddressInterface.shared.selectedAddress.fullAddress ?? "").components(separatedBy: ", ")
                if addresses.count < 3{
                    businessDetail.location?.displayAddress = addresses
                } else{
                    let line1 = addresses.first ?? ""
                    let line2 = addresses[(addresses.count - 2)] + ", " + addresses[(addresses.count - 1)]
                    businessDetail.location?.displayAddress = [line1, line2]
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
                    
                    businessDetail.points = points
                        businessDetail.duration = duration
                        businessDetail.distance = distance
                } else{
                        businessDetail.distance = "0 mi"
                        businessDetail.duration = "NO TIME"
                }
            } else{
                    businessDetail.distance = "0 mi"
                    businessDetail.duration = "NO TIME"
            }

            hideLoader()
            success(businessDetail)
        }
    }
    
}
