//
//  MapHelper.swift


import UIKit
import CoreLocation
import GooglePlaces
import GoogleMaps
import GoogleMapsBase
import MapKit

typealias failure = (_ Error : String)  -> Void
typealias  returnPlacemarks = (_ placemarks: [CLPlacemark]?) -> Void

class MapHelper: NSObject {
static let sharedInstance = MapHelper()
    
    var googleGeoCoder : GMSGeocoder?
    
    
    func getFileData(_ fileName: String,_ fileType: String) -> JSON{
        if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray else {
                    print("serialization failed in get country code data")
                    return  JSON()
                }
                return  JSON(json)
                
            } catch let error {
                print(error.localizedDescription)
                return  JSON()
                
            }
        } else {
            print("Invalid filename/path.")
            return  JSON()
        }
    }
    
    
    func reverseGeocoding(location:CLLocation,success:@escaping returnPlacemarks, failure:@escaping failure) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                failure(error!.localizedDescription)
                return
            }
            else if placemarks!.count > 0 {
                success(placemarks)
                
            }else{
                failure("Not able to find address for your location")
            }
        })
    }
    
    
    
    func reverseGeoCode(location: CLLocationCoordinate2D,success:@escaping (GMSAddress) -> Void, failure:@escaping failure){
        googleGeoCoder = nil
        googleGeoCoder = GMSGeocoder()
        
        googleGeoCoder?.reverseGeocodeCoordinate(location) { (response, error) in
            guard error == nil else {
                failure(error!.localizedDescription)
                return
            }
            guard let first = response?.firstResult() else {
                failure("Could not find any results for this area")
                return
            }
            success(first)
        }
    }
    
    func GeocodeAppleMaps(address: String, failure: @escaping failure,success: @escaping returnPlacemarks) {
        let geocod = CLGeocoder()
        
        geocod.geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                failure(error!.localizedDescription)
                return
            }
            if placemarks!.count > 0 {
                success(placemarks)
            }else{
                failure("Not able to find location for this Address.")
            }
        })
    }
    
    
    func googleNearby(cords: CLLocationCoordinate2D, name: String,success:@escaping (JSON) -> Void, failure:@escaping (String) -> ()){
//        &radius=48280
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(cords.latitude),\(cords.longitude)&rankby=distance&fields=name,rating,formatted_phone_number&keyword=\(name)&key=\(gooleMapKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        Alamofire.request(url, method: .get, parameters: [:], encoding: URLEncoding.default , headers: nil).responseJSON { (responseObject) -> Void in
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                if resJson["results"].isEmpty == false{
                    success(resJson)
                } else{
                    failure("Error")
                }
            }
            if responseObject.result.isFailure {
                let error : Error? = responseObject.result.error
                failure(error?.localizedDescription ?? "Error")
            }
        }
    }
    
    
    func placeAutocomplete(searchText: String ,success:@escaping ([GMSAutocompletePrediction]) -> Void, failure: @escaping (String) -> ()) {
       
        let token = GMSAutocompleteSessionToken.init()
        let placesClient = GMSPlacesClient()
        let filter = GMSAutocompleteFilter()
        filter.country = "us"
        
        let cords = LocationInterface.shared.cords ?? CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
        filter.locationBias = locationBias(cords: cords)
        
        placesClient.findAutocompletePredictions(fromQuery: searchText, filter: filter, sessionToken: token) { (results, error) in
            if let error = error {
                failure(error.localizedDescription)
                return
            }
            if let results = results {
                success(results)
            }
        }
    }
    
    func getCordsBounds(cords:CLLocationCoordinate2D)->GMSCoordinateBounds{
        let distance = 0.1
        let northEast = CLLocationCoordinate2D(latitude: cords.latitude + distance, longitude: cords.longitude + distance)
        let southWest = CLLocationCoordinate2D(latitude: cords.latitude - distance, longitude: cords.longitude - distance)
        
        return GMSCoordinateBounds(coordinate: northEast,
                                   coordinate: southWest)
        
    }
    
    func locationBias(cords:CLLocationCoordinate2D)-> GMSPlaceLocationBias{
        let distance = 0.1
        let northEast = CLLocationCoordinate2D(latitude: cords.latitude + distance, longitude: cords.longitude + distance)
        let southWest = CLLocationCoordinate2D(latitude: cords.latitude - distance, longitude: cords.longitude - distance)
        
        return  GMSPlaceRectangularLocationOption(northEast, southWest)
    }

    
    func LookupPlace(with Id: String,success:@escaping (GMSPlace) -> Void, failure: @escaping (String) -> ()){
        let placeClient = GMSPlacesClient()
        placeClient.lookUpPlaceID(Id) { (place, error) in
            if error == nil {
                if let result = place{
                    success(result)
                } else{
                    failure("place not found")
                }
            }else{
                failure(error?.localizedDescription ?? "")
            }
        }
    }
    
    func getPath(startLoc : CLLocationCoordinate2D , endLoc : CLLocationCoordinate2D ,success:@escaping (String) -> Void, failure:@escaping (String) -> ()){
        let url = "https://maps.googleapis.com/maps/api/directions/json?"
        print(url)
//        let str = "origin=\(startLoc.latitude),\(startLoc.longitude)&destination=\(endLoc.latitude),\(endLoc.longitude)&mode=driving&key=\(kGoogleApiKey)"

        let str = "origin=\(startLoc.latitude),\(startLoc.longitude)&destination=\(endLoc.latitude),\(endLoc.longitude)&mode=driving&key=\(gooleMapKey)"
        guard let escapedString = str.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else{
            return
        }
        
        Alamofire.request(url + escapedString, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: nil).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let json = JSON(responseObject.result.value!)
                guard (json["status"].stringValue ==  "OK")  else {
                    failure("Result Not Found")
                    return
                }
                let routes = json["routes"].arrayValue
                guard (routes.count > 0) else {
                    failure("Result Not Found")
                    return
                }
                let overViewPolyline = routes.first?["overview_polyline"]["points"].stringValue ?? ""
                success(overViewPolyline)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error.localizedDescription)
            }
        }
    }
 
    
    func googleGeoCode(address: String ,success:@escaping (PlaceDetails?) -> Void, failure:@escaping (String) -> ()){
        let url = "https://maps.googleapis.com/maps/api/geocode/json?key=\(gooleMapKey)&address=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        Alamofire.request(url, method: .get, parameters: [:], encoding: URLEncoding.default , headers: nil).responseJSON { (responseObject) -> Void in
        
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                if resJson["results"].isEmpty == false{
                    success(PlaceDetails(json: resJson))
                } else{
                    failure("error")
                }
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error.localizedDescription)
            }
        }
    }
    
     func googleCustomSearch(search: String ,success:@escaping (JSON) -> Void, failure:@escaping (String) -> ()){
            
        let url = "https://www.googleapis.com/customsearch/v1?key=\(gooleMapKey)&cx=\(googleCX)&q=\(search)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            Alamofire.request(url, method: .get, parameters: [:], encoding: URLEncoding.default , headers: nil).responseJSON { (responseObject) -> Void in
            
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    if resJson["items"].isEmpty == false{
                        success(resJson)
                    } else{
                        failure("error")
                    }
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error.localizedDescription)
                }
            }
    }
    
    func getAddressFromLatLon(pdblLatitude: CLLocationDegrees, withLongitude pdblLongitude: CLLocationDegrees, success:@escaping (_ address: String,_ addressFull: String) -> Void){
        var addressString : String = ""
        var fullAddressString : String = ""
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil){
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                
                if let pm = placemarks{
                    var arr = [String]()
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        
                        addressString = fullAddressString + (pm.subLocality ?? pm.thoroughfare ?? pm.locality ?? "")
                        
                        if pm.subLocality != nil {
                            fullAddressString = fullAddressString + pm.subLocality! + ", "
                            arr.append(fullAddressString)
                        }
                        if pm.thoroughfare != nil {
                            fullAddressString = fullAddressString + pm.thoroughfare! + ", "
                            arr.append(fullAddressString)
                        }
                        if pm.locality != nil {
                            fullAddressString = fullAddressString + pm.locality! + ", "
                            arr.append(fullAddressString)
                        }
                        
                        if pm.country != nil {
                            fullAddressString = fullAddressString + pm.country! + ", "
                            arr.append(fullAddressString)
                        }
                        if pm.postalCode != nil {
                            fullAddressString = fullAddressString + pm.postalCode! + " "
                            arr.append(fullAddressString)
                        }
                        print(fullAddressString)
                        success(addressString,fullAddressString)
                    } else{
//                         hideSpinner()
                    }
                }
        })
    }
    
    func calculateDistance(coordinateOrigin: CLLocationCoordinate2D , coordinateDestination: CLLocationCoordinate2D, result : @escaping(Double)-> Void){
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
                    let milesAway = quickestRouteForSegment.distance * 0.000621371192
                    result(milesAway)
                }
            }else{
                print("Unable to detect distance")
            }
        }
    }
    
    
    func caluclateTollFee(from: String , to: String, vehicle: String, result: @escaping(Double)->Void){
        guard self.getTollVehicleType(vehicle: vehicle) != "" else {
            result(0)
            return
        }
        
        let params: Parameters = [
            "from": [
                "address" : from
            ],
            "to": [
                "address" : to
            ],
            "vehicleType": self.getTollVehicleType(vehicle: vehicle)
        ]
        
        let headers = [
            "x-api-key": tollGuruKey
        ]
        
        let url = URL.init(string: "https://dev.TollGuru.com/v1/calc/gmaps")!
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            let json = JSON(response.result.value as Any)
            let tollFee = json["routes"].arrayValue.first?["costs"]["cash"].doubleValue ?? 0.0
            result(tollFee)
        }
    }
    
    func getTollVehicleType(vehicle: String)->String{
    switch vehicle{
        case "Walker","Bicycle":
            return ""
        case "E-Scooter","Moped","Motorcycle":
            return "2AxlesMotorcycle";
        case "Car","Pickup","Van":
            return "2AxlesAuto"
        case "Truck":
            return "2AxlesTruck"
        case "Tow Truck":
            return "3AxlesAuto"
        default:
            return "2AxlesAuto"
        }
        
    }
    
}




open class PlaceDetails: CustomStringConvertible {
    
    public var description =  ""
    
    public var formattedAddress =  ""
    open var streetNumber =  ""
    open var route =  ""
    open var postalCode =  ""
    
    open var country =  ""
    open var countryCode =  ""
    
    open var city =  ""
    open var subLocality =  ""
    
    open var state =  ""
    open var stateCode =  ""
    
    open var subAdministrativeArea =  ""
    
    open var latitude : Float =  0.0
    open var longitude : Float =  0.0
    
    
    init?(json: JSON) {
        guard json["results"].arrayValue.indices.contains(0) else {return}
        let results =  json["results"][0]
        
        self.formattedAddress = json["results"][0]["formatted_address"].stringValue
        
        streetNumber = self.getValue(data: results["address_components"].arrayValue.filter({$0["types"].contains(where: {$0.1 == "street_number"})}), short: true)
        
        route = self.getValue(data: results["address_components"].arrayValue.filter({$0["types"].contains(where: {$0.1 == "route"})}), short: true)
        
        postalCode = self.getValue(data: results["address_components"].arrayValue.filter({$0["types"].contains(where: {$0.1 == "postal_code"})}), short: false)
        
        country = self.getValue(data: results["address_components"].arrayValue.filter({$0["types"].contains(where: {$0.1 == "country"})}), short: false)
        
        countryCode = self.getValue(data: results["address_components"].arrayValue.filter({$0["types"].contains(where: {$0.1 == "country"})}), short: true)
        
        city = self.getValue(data: results["address_components"].arrayValue.filter({$0["types"].contains(where: {$0.1 == "locality"})}), short: false)
        
        if city == ""{
            city = self.getValue(data: results["address_components"].arrayValue.filter({$0["types"].contains(where: {$0.1 == "administrative_area_level_3"})}), short: false)
        }
        
        subLocality = self.getValue(data: results["address_components"].arrayValue.filter({$0["types"].contains(where: {$0.1 == "sublocality_level_1"})}), short: false)
        if subLocality == ""{
            subLocality = self.getValue(data: results["address_components"].arrayValue.filter({$0["types"].contains(where: {$0.1 == "sublocality"})}), short: false)
        }
        
        
        state = self.getValue(data: results["address_components"].arrayValue.filter({$0["types"].contains(where: {$0.1 == "administrative_area_level_1"})}), short: false)
        
        stateCode = self.getValue(data: results["address_components"].arrayValue.filter({$0["types"].contains(where: {$0.1 == "administrative_area_level_1"})}), short: true)
        
        subAdministrativeArea = self.getValue(data: results["address_components"].arrayValue.filter({$0["types"].contains(where: {$0.1 == "administrative_area_level_2"})}), short: false)
        
        //  let geometry = json["results"][0]["geometry"]
        let location = json["results"][0]["geometry"]["location"]
        latitude = location["lat"].floatValue
        longitude = location["lng"].floatValue
    }
        
    func getValue(data: [JSON], short: Bool)-> String{
        if data.isEmpty == false{
            if short == true{
                return data.first!["short_name"].stringValue
            } else{
                return data.first!["long_name"].stringValue
            }
        } else{
            return ""
        }
    }
    
}

