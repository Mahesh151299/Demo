//
//  ViewModel.swift
//  yelp_Api
//
//  Created by mac on 12/03/2020.
//  Copyright © 2020 Vivek thakur. All rights reserved.
//

import Foundation
import GooglePlaces
import CoreLocation
import MapKit

class BussinessViewModel{
    
    //MARK: VARIABLES
    var businessData = YelpStoreModel(json: JSON())
    var baseClassObj = BaseClass()
    
    var sortingType = "Name"
    var count = 0
    var yelpToken = "L3UGIOhGivBYaU4HZss-1XgNTzyMK3pL0XYNb52srIRU4dH9LstX_O4TgrxXvnH0iEdk5-caR94XRY5zU6Cr24RMGcr9Wrlpr0Nd_HOWK5Xv3jW12I4Mv99pbmUvXnYx"
    
    var timer = Timer()
    
    //MARK: API
    func searchforbusiness(search_by : String, cats: String, lats: Double , longs: Double ,onSuccess:@escaping (()->())){
        
        let key = search_by.replacingOccurrences(of: "’s", with: "").replacingOccurrences(of: "'s", with: "")
        
        let urlStr = "https://api.yelp.com/v3/businesses/search?term=\(key)&latitude=\(lats)&longitude=\(longs)&radius=40000&limit=50&categories=\(cats)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: urlStr) else{
            onSuccess()
            return
        }
        let yelpHeaders: HTTPHeaders = ["Authorization" : "Bearer \(yelpToken)"]
        
        Alamofire.request(url, headers: yelpHeaders).responseJSON { response in
            print(response)
            self.businessData = YelpStoreModel.init(json: JSON())
            
            guard response.result.error == nil else {
                onSuccess()
                hideLoader()
                return
            }
            
            guard let value = response.result.value else {
                onSuccess()
                hideLoader()
                return
            }
            
            let json = JSON(value)
            
            self.businessData = YelpStoreModel(json: json)
            
            for i in 0..<(self.businessData.businesses?.count ?? 0){
                if (self.businessData.businesses?[i].categories?.firstIndex(where: {($0.title?.lowercased().contains("cannabis") == true) || ($0.title?.lowercased().contains("dispensary") == true)})) != nil{
                    self.businessData.businesses?[i].isCannabis = true
                }
            }
            
            self.businessData.businesses = self.businessData.businesses?.filter({$0.isCannabis == false})
            
            guard (self.businessData.businesses?.count ?? 0) != 0 else{
                onSuccess()
                hideLoader()
                return
            }
            
            self.count = 0

            for i in 0..<(self.businessData.businesses?.count ?? 0){
                let distance = JSON(self.businessData.businesses?[i].distance ?? "0").doubleValue
                let speed = 11.0 // m/sec
                let time = distance / speed
                if time < 60{
                    self.businessData.businesses?[i].duration = "60"
                }else{
                    self.businessData.businesses?[i].duration = "\(time)"
                }
            }
            
            self.sort()
            onSuccess()
            hideLoader()
        }
    }
    
    func getStoreDetails(_ index: Int,_ id: String,result: @escaping(_ index: Int)-> Void){
        //        let urlStr = "https://api.yelp.com/v3/businesses/\(id)"
        //        let yelpHeaders: HTTPHeaders = ["Authorization" : "Bearer \(yelpToken)"]
        //
        //        guard let url = URL(string: urlStr) else{
        //            self.count += 1
        //            result(self.count)
        //            return
        //        }
        //
        //        Alamofire.request(url, headers: yelpHeaders).responseJSON { response in
        //            print(response)
        //
        //            let json = JSON(response.result.value ?? "")
        if let bizIndex = self.businessData.businesses?.firstIndex(where: {$0.internalIdentifier == id}){
            //                let isOpen = json["hours"].arrayValue.map({$0["is_open_now"].boolValue}).first ?? false
            //                self.businessData.businesses?[bizIndex].isClosed = !isOpen
            //
            //                let openHours = json["hours"].arrayValue.map({$0["open"]}).first ?? JSON()
            //                self.businessData.businesses?[bizIndex].openingHours = openHours.arrayValue.map({OpenHoursModel.init(json: $0)})
            
            let originLats = CLLocationDegrees(DeliveryAddressInterface.shared.selectedAddress.latitude ?? 0.0)
            let originLongs = CLLocationDegrees(DeliveryAddressInterface.shared.selectedAddress.longitude ?? 0.0)
            
            let storeLats = CLLocationDegrees(self.businessData.businesses?[bizIndex].coordinates?.latitude ?? 0.0)
            let storeLongs = CLLocationDegrees(self.businessData.businesses?[bizIndex].coordinates?.longitude ?? 0.0)
            
            let coordinateOrigin = CLLocationCoordinate2D(latitude: originLats, longitude: originLongs)
            let coordinateDestination = CLLocationCoordinate2D(latitude: storeLats, longitude: storeLongs)
            
            let sourceLocation: MKMapItem = .init(placemark: .init(coordinate: coordinateOrigin))
            let destinationLocation: MKMapItem = .init(placemark: .init(coordinate: coordinateDestination))
            
            let request = MKDirections.Request()
            request.source = sourceLocation
            request.destination = destinationLocation
            request.requestsAlternateRoutes = true
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            directions.calculate { (directions, error) in
                if var routeResponse = directions?.routes {
                    routeResponse.sort(by: {$0.expectedTravelTime <
                                        $1.expectedTravelTime})
                    if let quickestRouteForSegment: MKRoute = routeResponse.first{
                        self.businessData.businesses?[bizIndex].distance = "\(quickestRouteForSegment.distance)"
                        self.businessData.businesses?[bizIndex].duration = "\(quickestRouteForSegment.expectedTravelTime)"
                        self.count += 1
                        result(self.count)
                    } else{
                        self.count += 1
                        result(self.count)
                    }
                }else{
                    self.count += 1
                    result(self.count)
                }
            }
        } else{
            self.count += 1
            result(self.count)
        }
        //        }
    }
    
    func sort(){
        self.businessData.businesses = self.businessData.businesses?.sorted(by: { (store1, store2) -> Bool in
            if self.sortingType == "Name"{
                return (store1.name ?? "").lowercased() < (store2.name ?? "").lowercased()
            } else{
                let distance1 = (store1.distance ?? "0")
                let distance2 = (store2.distance ?? "0")
                return JSON(distance1).doubleValue < JSON(distance2).doubleValue
            }
        })
    }
    
}
