//
//  FavViewModel.swift
//  Courail
//
//  Created by Omeesh Sharma on 23/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation
import MapKit

class FavViewModel {
    
    //MARK: VARIABLES
    
    var count = 0
    var yelpToken = "L3UGIOhGivBYaU4HZss-1XgNTzyMK3pL0XYNb52srIRU4dH9LstX_O4TgrxXvnH0iEdk5-caR94XRY5zU6Cr24RMGcr9Wrlpr0Nd_HOWK5Xv3jW12I4Mv99pbmUvXnYx"
    
    var favorites = [FavoriteModel]()
    
    var sortingType = 0
    var filterArr = ["Name","Use","Category","Distance"]
    
    
    //MARK:- API
    
    func getFavApi(onSuccess:@escaping (()->())){
        showLoader()
        ApiInterface.requestApi(params: [:], api_url: API.get_fav_businesss, method: .get , encoding: URLEncoding.httpBody , success: { (json) in
            if let data = json["data"].array{
                self.favorites = data.map({FavoriteModel.init(json: $0)})
            }
            
            guard self.favorites.count != 0 else{
                hideLoader()
                onSuccess()
                return
            }
            
            self.count = 0
            for i in 0..<(self.favorites.count){
                self.getStoreDetails(i, self.favorites[i].data?.internalIdentifier ?? "") { (result) in
                    if result == (self.favorites.count){
                        self.sortData {
                            hideLoader()
                            onSuccess()
                        }
                    }
                }
                usleep(300000)
            }
            
        }) { (error, json) in
            self.favorites.removeAll()
            hideLoader()
            onSuccess()
        }
    }
    
    func removeFavApi(_ id: Int, _ index: Int, onSuccess:@escaping (()->())){
        let params: Parameters = [
            "fav_id" : "\(id)"
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.remove_fav_businesss, method: .delete , success: { (json) in
            hideLoader()
            self.favorites.remove(at: index)
            onSuccess()
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
            onSuccess()
        }
    }
    
    
    func FavOpenedApi(_ id: Int){
        let params: Parameters = [
            "id" : "\(id)"
        ]
        ApiInterface.requestApi(params: params, api_url: API.Increase_fav_count, method: .post , success: { (json) in
            print(json["msg"].stringValue)
        }) { (error, json) in
            print(error)
        }
    }
    
    func getPlaceDetails(_ index: Int , result: @escaping()-> Void){
        let model = self.favorites[index].data
        let storeLats = CLLocationDegrees(model?.coordinates?.latitude ?? 0.0)
        let storeLongs = CLLocationDegrees(model?.coordinates?.longitude ?? 0.0)
        let cords = CLLocationCoordinate2D(latitude: storeLats, longitude: storeLongs)
        
        MapHelper.sharedInstance.googleNearby(cords: cords, name: model?.name ?? "", success: { (json) in
            let placeID = json["results"].arrayValue.map({$0["place_id"].stringValue}).first ?? ""
            self.favorites[index].data?.googlePlaceID = placeID
            
            MapHelper.sharedInstance.LookupPlace(with: placeID, success: { (place) in
                self.favorites[index].data?.details = place
                result()
            }) { (error) in
                self.favorites[index].data?.details = nil
                result()
            }
        }) { (error) in
            self.favorites[index].data?.details = nil
            result()
        }
    }
    
    
    
    func getStoreDetails(_ index: Int,_ id: String,result: @escaping(_ index: Int)-> Void){
        let urlStr = "https://api.yelp.com/v3/businesses/\(id)"
        let yelpHeaders: HTTPHeaders = ["Authorization" : "Bearer \(yelpToken)"]
        
        guard let url = URL(string: urlStr) else{
            self.count += 1
            result(self.count)
            return
        }
        
        Alamofire.request(url, headers: yelpHeaders).responseJSON { response in
            print(response)
            
            let json = JSON(response.result.value ?? "")
            
            let isOpen = json["hours"].arrayValue.map({$0["is_open_now"].boolValue}).first ?? false
            self.favorites[index].data?.isClosed = !isOpen
            
            
            let openHours = json["hours"].arrayValue.map({$0["open"]}).first ?? JSON()
            self.favorites[index].data?.openingHours = openHours.arrayValue.map({OpenHoursModel.init(json: $0)})
            
            
            let originLats = CLLocationDegrees(DeliveryAddressInterface.shared.selectedAddress.latitude ?? 0.0)
            let originLongs = CLLocationDegrees(DeliveryAddressInterface.shared.selectedAddress.longitude ?? 0.0)
            
            let storeLats = CLLocationDegrees(self.favorites[index].data?.coordinates?.latitude ?? 0.0)
            let storeLongs = CLLocationDegrees(self.favorites[index].data?.coordinates?.longitude ?? 0.0)
            
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
                        self.favorites[index].data?.distance = "\(quickestRouteForSegment.distance)"
                        self.favorites[index].data?.duration = "\(quickestRouteForSegment.expectedTravelTime)"
                        self.count += 1
                        result(self.count)
                    }else{
                        self.count += 1
                        result(self.count)
                    }
                } else{
                    self.count += 1
                    result(self.count)
                }
            }
        }
        
    }
    
    func sortData(onSuccess:@escaping (()->())){
        self.favorites = self.favorites.sorted(by: { (store1, store2) -> Bool in
            switch self.filterArr[self.sortingType]{
            case "Price":
                let cost1 = (store1.data?.price ?? "$$")
                let cost2 = (store2.data?.price ?? "$$")
                return cost1 < cost2
            case "Distance":
                let distance1 = (store1.data?.distance ?? "0")
                let distance2 = (store2.data?.distance ?? "0")
                return JSON(distance1).doubleValue < JSON(distance2).doubleValue
            case "Category":
                let cat1 = (store1.data?.category ?? "")
                let cat2 = (store2.data?.category ?? "")
                
                return cat1 < cat2
            case "Use":
                let cat1 = (store1.favcount ?? 0)
                let cat2 = (store2.favcount ?? 0)
                
                return cat1 > cat2
            default :
                return (store1.data?.name ?? "").lowercased() < (store2.data?.name ?? "").lowercased()
            }
        })
        
        //          self.table.reloadData()
        //          if self.table.numberOfRows(inSection: 0) > 0 {
        //              self.table.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
        //          }
        onSuccess()
    }
    
}
