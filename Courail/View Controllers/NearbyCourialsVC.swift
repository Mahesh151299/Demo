//
//  NearbyCourialsVC.swift
//  Courail
//
//  Created by Omeesh Sharma on 27/01/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import GoogleMaps

class NearbyCourialsVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet var mapView: GMSMapView!
    
    @IBOutlet var weatherBtnOut: UIButton!
    
    //MARK: VARIABLES
    
    var type = 0
    
    
    var businessDetail : YelpStoreBusinesses?
    var transportIcon = ""
    
    var dropMarker = GMSMarker()
    var pickMarker = GMSMarker()
    
    var courialMarkers = [GMSMarker]()
    
    var polyline : GMSPolyline?
    
    var points = [String]()

    var courials = [NearbyCourialsModel]()
    
    var lastTarget : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherBtnOut.setTitle("", for: .normal)
        
        self.mapView.delegate = self
        
        if self.type == 1{
            self.businessDetail = .init(json: JSON())
            self.businessDetail?.dropAddress = .init(json: JSON())
            self.businessDetail?.dropAddress?.latitude = LocationInterface.shared.lats
            self.businessDetail?.dropAddress?.longitude = LocationInterface.shared.longs
        }
        
        let dropLats = CLLocationDegrees(self.businessDetail?.dropAddress?.latitude ?? 0.0)
        let dropLongs = CLLocationDegrees(self.businessDetail?.dropAddress?.longitude ?? 0.0)
        let dropCords = CLLocationCoordinate2D.init(latitude: dropLats, longitude: dropLongs)
        
        self.dropMarker = GMSMarker(position: dropCords)
        self.dropMarker.iconView = self.markerShadow(marker: self.dropMarker, img: UIImage(named: "imgMarkerDeliveryShadow"))
        self.dropMarker.map = self.mapView
        
        if self.businessDetail?.isSkillService == true || self.type == 1{
            self.BtnCurrentLocation(UIButton.init())
        }else{
            let pickLats = CLLocationDegrees(self.businessDetail?.coordinates?.latitude ?? 0.0)
            let pickLongs = CLLocationDegrees(self.businessDetail?.coordinates?.longitude ?? 0.0)
            let pickCords = CLLocationCoordinate2D.init(latitude: pickLats, longitude: pickLongs)
            
            self.pickMarker = GMSMarker(position: pickCords)
            self.pickMarker.iconView = self.markerShadow(marker: self.pickMarker, img: UIImage(named: "imgMarkerPickShadow"))
            self.pickMarker.map = self.mapView
            
            let bounds = GMSCoordinateBounds(coordinate: self.pickMarker.position, coordinate: self.dropMarker.position)
//            let update = GMSCameraUpdate.fit(bounds, with: .init(top: 150, left: 50, bottom: 150, right: 50))
            let update = GMSCameraUpdate.fit(bounds, withPadding: 120)
            self.mapView.animate(with: update)
            self.getWeatherReport(cords: self.mapView.camera.target)

            self.getPath()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        SocketBase.sharedInstance.delegate = self
        SocketBase.sharedInstance.nearbyCourialsLocation(cords: self.mapView.camera.target, type: self.transportIcon)
        self.lastTarget = self.mapView.camera.target
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        SocketBase.sharedInstance.delegate = nil
//        self.mapView.delegate = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.buttonShadow()
    }
    
    func buttonShadow(){
        // Shadow Color and Radius
        self.weatherBtnOut.layer.shadowColor = UIColor.lightGray.cgColor
        self.weatherBtnOut.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.weatherBtnOut.layer.shadowOpacity = 0.5
        self.weatherBtnOut.layer.shadowRadius = 3
        self.weatherBtnOut.layer.masksToBounds = false
    }
    
    
    //MARK: BUTTONS ACTIONS
    
    @IBAction func BtnCurrentLocation(_ sender: UIButton) {
        if self.type == 1{
            self.businessDetail?.dropAddress?.latitude = LocationInterface.shared.lats
            self.businessDetail?.dropAddress?.longitude = LocationInterface.shared.longs
            
            let dropLats = CLLocationDegrees(self.businessDetail?.dropAddress?.latitude ?? 0.0)
            let dropLongs = CLLocationDegrees(self.businessDetail?.dropAddress?.longitude ?? 0.0)
            let dropCords = CLLocationCoordinate2D.init(latitude: dropLats, longitude: dropLongs)
            self.dropMarker.position = dropCords
            self.dropMarker.map = self.mapView
        }
        
        let camera = GMSCameraPosition.camera(withTarget: self.dropMarker.position, zoom: 15)
        self.mapView.camera = camera
        SocketBase.sharedInstance.nearbyCourialsLocation(cords: self.mapView.camera.target, type: self.transportIcon)
        self.lastTarget = self.mapView.camera.target
        
        self.getWeatherReport(cords: self.mapView.camera.target)
    }
    
    @IBAction func weatherBtn(_ sender: UIButton) {
        guard let url = URL(string: "https://weather.com") else {return}
        UIApplication.shared.open(url, options: [:]) { (_) in
        }
    }
        
    
    @IBAction func closeBtn(_ sender: UIButton) {
        switch type{
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QueueDeliveryDetailVC") as! QueueDeliveryDetailVC
            vc.businessDetail = self.businessDetail
            self.navigationController?.pushViewController(vc, animated: true)
            if let index = self.navigationController?.viewControllers.lastIndex(where: {($0 as? NearbyCourialsVC) != nil}){
                self.navigationController?.viewControllers.remove(at: index)
            }
        default:
            GoToHome()
        }
        
    }
    
}

extension NearbyCourialsVC : GMSMapViewDelegate{
    
    //Special Polyline and Distance
    
    func getPath(){
        let pickLats = CLLocationDegrees(self.businessDetail?.coordinates?.latitude ?? 0.0)
        let pickLongs = CLLocationDegrees(self.businessDetail?.coordinates?.longitude ?? 0.0)
        
        let dropLats = CLLocationDegrees(self.businessDetail?.dropAddress?.latitude ?? 0.0)
        let dropLongs = CLLocationDegrees(self.businessDetail?.dropAddress?.longitude ?? 0.0)
        
        guard let url = URL.init(string: "https://maps.googleapis.com/maps/api/directions/json?&mode=driving&origin=\(pickLats),\(pickLongs)&destination=\(dropLats),\(dropLongs)&sensor=false&key=\(gooleMapKey)") else {return}
        
        showLoader()
        
        Alamofire.request(url).responseJSON { response in
            let jsonData = JSON(response.result.value as Any)
            
            guard jsonData["routes"].count != 0 else {
                hideLoader()
                return
            }
            
            if (jsonData["routes"].array?.count ?? 0) > 0{
                if (jsonData["routes"][0]["legs"].array?.count ?? 0) > 0{
                    let routes = jsonData["routes"].arrayValue
                    var points = [String]()
                    for route in routes{
                        let routeOverviewPolyline = route["overview_polyline"].dictionary
                        points.append(routeOverviewPolyline?["points"]?.stringValue ?? "")
                    }
                    
                    self.points = points
                }
            }
            
            self.loadPath()
            hideLoader()
        }
    }
    
    func loadPath(){
        self.polyline?.map = nil
        
        for point in self.points{
            let path = GMSPath.init(fromEncodedPath: point)
            self.polyline = GMSPolyline(path: path)
            polyline?.strokeColor = .black
            polyline?.strokeWidth = 2
            polyline?.map = self.mapView
        }
    }
    
    func courialMarkerView(transport: String)-> UIView{
        let markerView = UIView.init(frame: .init(x: 0, y: 0, width: 40, height: 40))
        markerView.backgroundColor = .clear
        
        let markerIcon = UIImageView.init(frame: .init(x: 0, y: 0, width: 33, height: 33))
        
        if transport.lowercased() == "tow truck"{
            markerIcon.image = UIImage(named: "towtruckMarker")
        }else{
            markerIcon.image = UIImage(named: "\(transport.lowercased())Marker")
        }
        
        markerView.addSubview(markerIcon)
        markerIcon.center = markerView.center
        
        markerIcon.layoutIfNeeded()
        markerIcon.layer.masksToBounds = false
        markerIcon.layer.cornerRadius = 33
        markerIcon.layer.shadowColor = UIColor.black.cgColor
        markerIcon.layer.shadowPath = UIBezierPath(roundedRect: markerIcon.bounds, cornerRadius: markerIcon.layer.cornerRadius).cgPath
        markerIcon.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        markerIcon.layer.shadowOpacity = 0.3
        markerIcon.layer.shadowRadius = 1
        
        return markerView
    }
    
    func markerShadow(marker: GMSMarker, img: UIImage?)-> UIView{
        let markerIcon = UIImageView.init(image: img)
        markerIcon.image = img
        markerIcon.contentMode = .scaleAspectFit
        
        markerIcon.layer.shadowColor = UIColor.black.cgColor
        markerIcon.layer.shadowOpacity = 0.3
        markerIcon.layer.shadowRadius = 1
        markerIcon.layer.shadowOffset = CGSize.zero
        
        return markerIcon
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let centerCords = mapView.camera.target
        let centerLoc = CLLocation.init(latitude: centerCords.latitude, longitude: centerCords.longitude)
        
        guard let previousCords = self.lastTarget else {return}
        let previousLoc = CLLocation.init(latitude: previousCords.latitude, longitude: previousCords.longitude)
        
        self.getWeatherReport(cords: centerCords)
        
        guard centerLoc.distance(from: previousLoc) > 16000 else {return}
        SocketBase.sharedInstance.nearbyCourialsLocation(cords: centerCords, type: self.transportIcon)
        self.lastTarget = centerCords
    }
    
}

extension NearbyCourialsVC : SocketDelegate{
    
    func socketResponse(data: JSON, method: String) {
        guard method == socketMethods.nearbypartnerlist_listener else {
            return
        }
        
        self.courialMarkers.forEach({$0.map = nil})
        self.courialMarkers.removeAll()
        
        if let json = data.array{
            self.courials = json.map({NearbyCourialsModel.init(json: $0)})
        }
        
        for courial in self.courials{
            let partnerLats = CLLocationDegrees(JSON(courial.latitude ?? "0").doubleValue)
            let partnerLongs = CLLocationDegrees(JSON(courial.longitude ?? "0").doubleValue)
            let partnerCords = CLLocationCoordinate2D.init(latitude: partnerLats, longitude: partnerLongs)
            let marker = GMSMarker.init(position: partnerCords)
            marker.iconView = self.courialMarkerView(transport: courial.transport ?? "car")
            marker.map = self.mapView
            self.courialMarkers.append(marker)
        }
    }
    
    func getWeatherReport(cords: CLLocationCoordinate2D){
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(cords.latitude)&lon=\(cords.longitude)&appid=\(openWeatherKey)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (responseObject) -> Void in
            
            if responseObject.result.isSuccess {
                let json = JSON(responseObject.result.value!)
                let weather = json["weather"].arrayValue.first?["main"].stringValue.lowercased()
                switch weather {
                case "thunderstorm","rain","drizzle":
                    self.weatherBtnOut.setImage(UIImage(named: "imgThunderstoms"), for: .normal)
                case "snow":
                    self.weatherBtnOut.setImage(UIImage(named: "imgSnow"), for: .normal)
                case "clear":
                    self.weatherBtnOut.setImage(UIImage(named: "imgSunny"), for: .normal)
                case "clouds":
                    self.weatherBtnOut.setImage(UIImage(named: "imgCloudy"), for: .normal)
                default:
                    self.weatherBtnOut.setImage(UIImage(named: "imgHail"), for: .normal)
                }
            }
        }
    }
    
}
