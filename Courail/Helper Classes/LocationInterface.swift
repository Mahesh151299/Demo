//
//  LocationInterface.swift
//  InstaDate
//
//  Created by apple on 25/02/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class LocationInterface: NSObject , CLLocationManagerDelegate{
    
    //MARK: VARIABLES
    static let shared = LocationInterface()
    
    private let locationManager = CLLocationManager()
    public var lats : Float = 0.0
    public var longs : Float = 0.0
    public var cords : CLLocationCoordinate2D?
    
    var currentStatus = CLAuthorizationStatus.notDetermined
    
    var isFirstTime = true
    
    private override init() {
        super.init()
        self.setupCoreLocation()
    }
    
    func setupCoreLocation(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        self.currentStatus = CLLocationManager.authorizationStatus()
        self.getLocation()
    }
    
    func checkStatus(){
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            rootVC?.showAlert(msg: "Current Location is denied. Please, allow the current location from Settings to fetch nearby Stores.", doneBtnTitle: "Settings", cancelBtnTitle: "Cancel", handler: {
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
        case .restricted:
            rootVC?.showAlert(msg: "Current Location is restricted. Please, allow the current location from Settings.", doneBtnTitle: "Settings", cancelBtnTitle: "Cancel" ,handler: {
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
        default:
            break;
        }
    }
    
    
    func getLocation(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.lats = JSON(locValue.latitude).floatValue
        self.longs = JSON(locValue.longitude).floatValue
        self.cords = locValue
        
        if isFirstTime{
            isFirstTime = false
            DeliveryAddressInterface.shared.fetchCurrentAddress { (address) in
            }
        }
        
    }
    
}

