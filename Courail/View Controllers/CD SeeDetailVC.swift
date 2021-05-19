//
//  CD SeeDetailVC.swift
//  Courail
//
//  Created by mac on 10/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import GoogleMaps
import Cosmos
import MapKit

class CD_SeeDetailVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var headerTittleLbl: UILabel!
    
    @IBOutlet weak var arrivalStatusLbl: UILabel!
    
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var durationStatusLbl: UILabel!
    
    @IBOutlet weak var timerView: UIView!
    
    @IBOutlet weak var prgoressView: UIView!
    
    @IBOutlet weak var progressWidth: NSLayoutConstraint!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var timerInfo: UILabel!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var partnerImage: UIImageViewCustomClass!
    @IBOutlet weak var partner2Image: UIImageViewCustomClass!
    
    @IBOutlet weak var partnerName: UILabel!
    @IBOutlet weak var partnerRating: CosmosView!
    
    @IBOutlet weak var vehicle: UIImageView!
    
    @IBOutlet weak var disabledCallView: UIView!
    @IBOutlet weak var disabledMessageView: UIView!
    
    @IBOutlet weak var endCallView: UIViewCustomClass!
    
    @IBOutlet weak var serviceInfoBtnOut: UIButtonCustomClass!
    
    @IBOutlet weak var orderDeclinedView: UIView!
    @IBOutlet weak var thumbsDownIcon: UIImageView!
    @IBOutlet weak var declineIcon: UIImageViewCustomClass!
    
    @IBOutlet weak var meterView: UIView!
    @IBOutlet weak var meterImage: UIImageView!
    @IBOutlet weak var meterPin: UIImageView!
    
    @IBOutlet weak var meterPinVertical: NSLayoutConstraint!
    @IBOutlet weak var meterPinHorizontal: NSLayoutConstraint!
    
    @IBOutlet weak var meterBottom: NSLayoutConstraint!
    @IBOutlet weak var meterHeight: NSLayoutConstraint!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var refreshBtnOut: UIButton!
    
    //MARK:- VARIABLES
    
    var timer = Timer()
    
    var dropMarker = GMSMarker()
    var pickMarker = GMSMarker()
    var courialMarker = GMSMarker()
    
    private var waitCharges : Double = 0.0
    var freeTime = 5 * 60 //seconds
    
    var shouldHideTabBar = false
    
    let vehicleTypes = ["Walker","Bicycle","E-Scooter","Moped","Motorcycle","Car","Pickup","Van","Truck","Tow Truck"]
    let transportImg =  [#imageLiteral(resourceName: "imgWalking"),#imageLiteral(resourceName: "imgBike"),#imageLiteral(resourceName: "imgE-scooter"),#imageLiteral(resourceName: "imgMoped"),#imageLiteral(resourceName: "imgMotorcycle"),#imageLiteral(resourceName: "imgCar"),#imageLiteral(resourceName: "imgPickup"),#imageLiteral(resourceName: "imgVan"),#imageLiteral(resourceName: "imgTruck") ,#imageLiteral(resourceName: "imgTowTruck")]
    
    var isTimerPaused = false
    var isTimerPlayed = true
    var timerScheduled = false
    var isOrderAlreadyCompleted = false
    
    var partnerAnimating = false
    
    var polyline : GMSPolyline?
    
    var waitTimeMultiplier = 0.35
    
    var isDataLoaded = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timerView.isHidden = true
        self.timerInfo.isHidden = true
        
        if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
            let estimatedServiceTime = JSON(currentOrder?.estimatedServiceTime ?? "0").intValue + 5
            self.timeLbl.text = "\(estimatedServiceTime):00"
        }else{
            self.timeLbl.text = "05:00"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timerScheduled = false
        
        //Remove observer
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        // add notification observers
        NotificationCenter.default.addObserver(self, selector: #selector(self.socketRestart), name: UIApplication.willEnterForegroundNotification, object: nil)
        
//        self.headerTittleLbl.text = "Current Order"
        let str = (userInfo.firstName ?? "") + "'s"
        self.headerTittleLbl.text = str + " Order"
        
        self.tabBarController?.tabBar.isHidden = self.shouldHideTabBar
        self.navigationController?.view.setNeedsLayout()
        self.shouldHideTabBar = false
        
        SocketBase.sharedInstance.delegate = self
        SocketBase.sharedInstance.establishConnection()
        
        self.loadData()
        self.setupMarkers()
        
        if (currentOrderPoints?.isEmpty ?? true) == true{
            if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
//                self.getPath(courialToDrop: true)
                self.calculateDuration(courialToPick: false)
            }else{
//                self.getPath(courialToDrop: false)
                self.calculateDuration(courialToPick: true)
            }
        } else{
            currentOrder?.points = currentOrderPoints
            self.loadPath()
        }
        
        
        let pickUpTime = (currentOrder?.pickUpTime ?? "0").convertStampToDate(.current) ?? Date()
        if Date() < pickUpTime{
            let pickTimer = Timer(fireAt: pickUpTime, interval: 0, target: self, selector: #selector(self.pickUpTimerFire), userInfo: nil, repeats: false)
            RunLoop.main.add(pickTimer, forMode: .common)
        }
        
        self.isDataLoaded = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isDataLoaded = true
        }
        
    }
    
    @objc func pickUpTimerFire(){
        self.loadData()
    }
    
    deinit {
        //Remove observer
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        self.timer.invalidate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Remove observer
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        self.timer.invalidate()
        SocketBase.sharedInstance.delegate = nil
        
    }
    
    
    @objc func reloadView(){
        self.viewDidLoad()
        self.viewWillAppear(true)
    }
    
    @objc func socketRestart(){
        ApiInterface.getCurrentOrder {_ in }
        SocketBase.sharedInstance.delegate = self
        SocketBase.sharedInstance.establishConnection()
        
        if currentOrder?.status == orderStatus.confirmPickupPointArrival || currentOrder?.status == orderStatus.confirmDeliveryPointArrival || currentOrder?.status == orderStatus.userIdentityVerified{
            if (currentOrder?.isPlayed ?? "0") == "1"{
                self.isTimerPlayed = true
                self.timerView.alpha = 1.0
                self.startFreeTimer()
            }
        }
        self.loadData()
        
        if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
//            self.getPath(courialToDrop: true)
            self.calculateDuration(courialToPick: false)
        }
        
        if currentOrder?.status == orderStatus.Accepted{
            if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
                self.calculateDuration(courialToPick: false)
            }else{
                self.calculateDuration(courialToPick: true)
            }
        }else if currentOrder?.status == orderStatus.confirmPickup || currentOrder?.status == orderStatus.confirmDeliveryPointArrival || currentOrder?.status == orderStatus.userIdentityVerified{
            self.calculateDuration(courialToPick: false)
        }
    }
    
    func loadData(){
        let courialFirstName = (currentOrder?.provider?.firstName ?? "").capitalized
        let courial2FirstName = (currentOrder?.secondCourial?.firstName ?? "").capitalized
        
        let duration = currentOrder?.livePathEstimatedTime ?? 1
        
        if duration == 0{
            if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
//                self.getPath(courialToDrop: true)
                self.calculateDuration(courialToPick: false)
            }
        }
        
        if currentOrder?.status == orderStatus.Accepted{
            if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
                self.calculateDuration(courialToPick: false)
            }else{
                self.calculateDuration(courialToPick: true)
            }
        }else if currentOrder?.status == orderStatus.confirmPickup || currentOrder?.status == orderStatus.confirmDeliveryPointArrival || currentOrder?.status == orderStatus.userIdentityVerified{
            self.calculateDuration(courialToPick: false)
        }
        
        self.serviceInfoBtnOut.isHidden = true
        
        if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
            let estimatedServiceTime = JSON(currentOrder?.estimatedServiceTime ?? "0").doubleValue
            let estimatedOfferPrice = JSON(currentOrder?.estimatedServiceOffer ?? "0").doubleValue
            self.waitTimeMultiplier = estimatedOfferPrice / estimatedServiceTime
            
            let totalFreetime = JSON(estimatedServiceTime).intValue + 5
            self.timerInfo.text = "First \(totalFreetime) mins included. Then, $\(String(format: "%.02f", self.waitTimeMultiplier)) per minute."
        }else{
            self.waitTimeMultiplier = 0.35
            self.timerInfo.text = "First 5 mins free. Then, $.35 per minute."
        }
                
        switch currentOrder?.status ?? 0{
        case orderStatus.pending, orderStatus.cancel:
            self.arrivalStatusLbl.text = "Finding Courial"
            SocketBase.sharedInstance.nearbyPartnersCount()
            self.removeCourialDetails()
            
        case orderStatus.Accepted:
            self.loadCourialDetails()
            
            if courial2FirstName == ""{
                self.arrivalStatusLbl.text = "\(courialFirstName) is on the move"
            }else{
                self.arrivalStatusLbl.text = "\(courialFirstName) & \(courial2FirstName) are on the move"
            }
            
            self.addressLbl.isHidden = true
            self.durationView.isHidden = false
            
            if duration == 0{
                self.durationLbl.text =  " mins"
            }else{
                self.durationLbl.text =  "\(duration) mins"
            }
            self.updateCurrentOrder()
            if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
                self.durationStatusLbl.text = " away"
            }else{
                self.durationStatusLbl.text = " from pickup"
            }
            
        case orderStatus.confirmPickupPointArrival:
            self.loadCourialDetails()
            if courial2FirstName == ""{
                self.arrivalStatusLbl.text = "\(courialFirstName) has arrived at pickup"
            }else{
                self.arrivalStatusLbl.text = "\(courialFirstName) & \(courial2FirstName) has arrived at pickup"
            }
            
            self.addressLbl.isHidden = false
//            self.addressLbl.text = currentOrder?.pickupInfo?.fullAddress ?? ""
            
            let add1 = currentOrder?.pickupInfo?.address1 ?? ""
            var add2 = currentOrder?.pickupInfo?.address2 ?? ""
            add2 = (add2 == "") ? "" : (", " + add2)
            self.addressLbl.text = add1 + add2
            
            self.durationView.isHidden = true
            
            let pickUpTime = (currentOrder?.pickUpTime ?? "0").convertStampToDate(.current) ?? Date()
            
            guard Date() >= pickUpTime else{
                self.timerView.isHidden = true
                self.timerInfo.isHidden = true
                self.timer.invalidate()
                return
            }
            
            self.timerView.isHidden = false
            self.timerInfo.isHidden = false
            
            if (currentOrder?.isPlayed ?? "0") == "1"{
                self.isTimerPlayed = true
                self.timerView.alpha = 1.0
                if self.timer.isValid == false{
                    self.startFreeTimer()
                }
            }else{
                self.timerScheduled = false
                self.pauseTimer()
            }
        case orderStatus.confirmPickup:
            self.loadCourialDetails()
            self.timer.invalidate()
            self.timerView.isHidden = true
            self.timerInfo.isHidden = true
            self.addressLbl.isHidden = true
            
            if courial2FirstName == ""{
                if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
                    self.arrivalStatusLbl.text = "\(courialFirstName) is on the way to you"
                }else{
                    self.arrivalStatusLbl.text = "\(courialFirstName) is on the way to dropoff"
                }
                
            }else{
                self.arrivalStatusLbl.text = "\(courialFirstName) & \(courial2FirstName) are on the way to dropoff"
            }
            
            self.durationView.isHidden = false
            
            if duration == 0{
                self.durationLbl.text =  " mins"
            }else{
                self.durationLbl.text =  "\(duration) mins"
            }
            self.updateCurrentOrder()
            self.durationStatusLbl.text = " away"
            
        case orderStatus.confirmDeliveryPointArrival, orderStatus.userIdentityVerified:
            
            if courial2FirstName == ""{
                if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
                    self.arrivalStatusLbl.text = "\(courialFirstName) has arrived"
                }else{
                    self.arrivalStatusLbl.text = "\(courialFirstName) has arrived at dropoff"
                }
            }else{
                self.arrivalStatusLbl.text = "\(courialFirstName) & \(courial2FirstName) has arrived at dropoff"
            }
            self.durationView.isHidden = true
            
            self.addressLbl.isHidden = false
//            self.addressLbl.text = currentOrder?.deliveryInfo?.fullAddress ?? ""
            let add1 = currentOrder?.deliveryInfo?.address1 ?? ""
            var add2 = currentOrder?.deliveryInfo?.address2 ?? ""
            add2 = (add2 == "") ? "" : (", " + add2)
            self.addressLbl.text = add1 + add2
            
            
            self.loadCourialDetails()
            
            self.timerView.isHidden = false
            self.timerInfo.isHidden = false
            
            if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
                if self.timer.isValid == false{
                    let estimatedServiceTime = JSON(currentOrder?.estimatedServiceTime ?? "0").intValue + 5
                    self.timeLbl.text = "\(estimatedServiceTime):00"
                }
            } else{
                self.timeLbl.text = "05:00"
            }
            
            let pickUpTime = (currentOrder?.pickUpTime ?? "0").convertStampToDate(.current) ?? Date()
            
            if Date() < pickUpTime && JSON(currentOrder?.isSkill ?? "0").boolValue == true{
                self.timerView.isHidden = true
                self.timerInfo.isHidden = true
                self.timer.invalidate()
                return
            }else{
                if (currentOrder?.isPlayed ?? "0") == "1"{
                    self.isTimerPlayed = true
                    self.timerView.alpha = 1.0
                    if self.timer.isValid == false{
                        self.startFreeTimer()
                    }
                }else{
                    self.timerScheduled = false
                    self.pauseTimer()
                }
            }
        case orderStatus.complete:
            guard self.isOrderAlreadyCompleted == false else {return}
            
            self.isOrderAlreadyCompleted = true
            self.orderCompleted()
        default:
            if courialFirstName == ""{
                self.arrivalStatusLbl.text = "Finding Courial"
                self.removeCourialDetails()
            }else{
                self.loadCourialDetails()
            }
        }
        
        let vehicleTypeIndex = vehicleTypes.firstIndex(of: (currentOrder?.provider?.transport ?? currentOrder?.trasnportMode ?? ""))
        self.vehicle.image = transportImg[vehicleTypeIndex ?? 0]
    }
    
    func loadCourialDetails(){
        self.arrivalStatusLbl.textColor = .black
        
        self.partnerName.alpha = 1.0
        self.meterView.isHidden = true
        
        self.partnerAnimating = false
        
        self.disabledCallView.isHidden = true
        self.disabledMessageView.isHidden = true
        
        let courialFirstName = (currentOrder?.provider?.firstName ?? "").capitalized
        var courialLastName = ""
        
        if let lastChar = (currentOrder?.provider?.lastName ?? "")?.uppercased().first{
            courialLastName = "\(lastChar)"
        }
        
        let courialName = (courialFirstName + " " + courialLastName).capitalized
        
        if JSON(currentOrder?.isSkill ?? "0").boolValue == true && currentOrder?.provider?.credentials_Website != ""{
            self.serviceInfoBtnOut.isHidden = false
        }else{
            self.serviceInfoBtnOut.isHidden = true
        }
        
        self.partnerImage.sd_setImage(with: URL(string: currentOrder?.provider?.image ?? ""), placeholderImage: nil, options: [], completed: nil)
        
        if JSON(currentOrder?.twoCourials ?? "0").boolValue == false{
            self.partner2Image.isHidden = true
            self.partnerName.text = "   \(courialName)   "
        } else{
            let courial2FirstName = (currentOrder?.secondCourial?.firstName ?? "").capitalized
            if courial2FirstName != ""{
                self.partnerName.text = "     \(courialFirstName) & \(courial2FirstName)     "
                
                self.partner2Image.isHidden = false
                self.partner2Image.sd_setImage(with: URL(string: currentOrder?.secondCourial?.image ?? ""), placeholderImage: nil, options: [], completed: nil)
            }else{
                self.partnerName.text = "            \(courialFirstName)            "
                
                self.partner2Image.isHidden = false
                self.partner2Image.image = UIImage(named: "imgPartnerPlaceholder2")
            }
        }
        
        if JSON(currentOrder?.provider?.rating ?? "5").doubleValue < 4.5{
            self.partnerRating.rating = 4.5
        }else{
            self.partnerRating.rating = JSON(currentOrder?.provider?.rating ?? "5").doubleValue
        }
        
        
        //Courial Partner Marker position update
        let courialLats = JSON(currentOrder?.provider?.latitude ?? "0").doubleValue
        let courialLongs = JSON(currentOrder?.provider?.longitude ?? "0").doubleValue
        let courialLocation = CLLocationCoordinate2D(latitude: courialLats, longitude: courialLongs)
        
        self.courialMarker.iconView = self.courialMarkerView()
        
        self.updateVehicle(from: self.courialMarker.position, to: courialLocation)
    }
    
    func removeCourialDetails(){
        self.serviceInfoBtnOut.isHidden = true
        
        self.disabledCallView.isHidden = false
        self.disabledMessageView.isHidden = false
        
        self.arrivalStatusLbl.textColor = .black
        
        self.addressLbl.isHidden = true
        self.durationView.isHidden = true
        self.timerView.isHidden = true
        self.timerInfo.isHidden = true
        
        self.courialMarker.map = nil
        self.partnerRating.rating = 5
        
        self.partnerImage.image = UIImage(named: "imgPartnerPlaceholder")
        self.partner2Image.image = UIImage(named: "imgPartnerPlaceholder2")
        
        currentOrder?.provider = CurrentOrderProvider.init(json: JSON())
        currentOrder?.secondCourial = CurrentOrderProvider.init(json: JSON())
        
        self.partner2Image.isHidden = true
        
        let orderPlaceTime = JSON(currentOrder?.createdAt ?? 0).stringValue.convertStampToDate(TimeZone.init(identifier: "UTC") ?? .current) ?? Date()
        
        if (currentOrder?.nearbyPartnersCount ?? 0) == 0 || abs(Date().minutesBetweenDate(toDate: orderPlaceTime)) > 29{
            self.partnerName.text = "  Unavailable  "
            self.meterView.isHidden = false
            self.meterPin.isHidden = true
            self.meterImage.alpha = 0.4
            self.partnerName.alpha = 1.0
            
            self.arrivalStatusLbl.textColor = .red
            self.arrivalStatusLbl.text = "Sorry, Courials unavailable"
            
            self.addressLbl.isHidden = false
            self.addressLbl.text = "we'll keep searching"
        }else{
            self.partnerName.text = "  Searching  "
        }
        
        guard self.partnerAnimating == false else{
            return
        }
        
        DispatchQueue.main.async {
            self.animatePartner()
        }
    }
    
    func animatePartner(){
        self.partnerAnimating = true
        
        guard currentOrder?.status == orderStatus.pending || currentOrder?.status == orderStatus.cancel else{
            self.partnerName.alpha = 1.0
            self.meterView.isHidden = true
            
            self.partnerAnimating = false
            return
        }
        
        self.meterView.isHidden = false
        
        let orderPlaceTime = JSON(currentOrder?.createdAt ?? 0).stringValue.convertStampToDate(TimeZone.init(identifier: "UTC") ?? .current) ?? Date()
        
        guard abs(Date().minutesBetweenDate(toDate: orderPlaceTime)) < 30 else{
            self.partnerName.text = "  Unavailable  "
            self.meterView.isHidden = false
            self.meterPin.isHidden = true
            self.meterImage.alpha = 0.4
            
            self.partnerName.alpha = 1.0
            self.partnerAnimating = false
            return
        }
        
        let nearbyPartners = currentOrder?.nearbyPartnersCount ?? 0
        guard nearbyPartners != 0 else{
            self.partnerName.text = "  Unavailable  "
            self.meterView.isHidden = false
            self.meterPin.isHidden = true
            self.meterImage.alpha = 0.4
            
            self.partnerName.alpha = 1.0
            self.partnerAnimating = false
            return
        }
        
        if nearbyPartners > 25{
            self.meterPin.isHidden = false
            self.meterImage.alpha = 1
            
            self.meterPinVertical.constant = 2
            self.meterPinHorizontal.constant = 5
            self.meterPin.image = UIImage(named: "imgMeterPinPlenty")
        }else if nearbyPartners > 5{
            self.meterPin.isHidden = false
            self.meterImage.alpha = 1
            
            self.meterPinVertical.constant = -5
            self.meterPinHorizontal.constant = 0
            self.meterPin.image = UIImage(named: "imgMeterPinMany")
        }else{
            self.meterPin.isHidden = false
            self.meterImage.alpha = 1
            
            self.meterPinVertical.constant = 2
            self.meterPinHorizontal.constant = -5
            self.meterPin.image = UIImage(named: "imgMeterPinFew")
        }
        
        UIView.animate(withDuration: 0.8,
                       delay:0.0,
                       options:[.curveEaseInOut],
                       animations: {
                        self.partnerName.alpha = (self.partnerName.alpha == 1.0) ? 0.0 : 1.0
                        self.meterPin.alpha = (self.meterPin.alpha == 1.0) ? 0.0 : 1.0
                       },
                       completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.8) {
            self.animatePartner()
        }
    }
    
    func orderDeclined(type: String){
        self.orderDeclinedView.backgroundColor = .clear
        guard currentOrder?.status == orderStatus.pending else{
            self.orderDeclinedView.isHidden = true
            return
        }
        
        if type == "0"{
            self.declineIcon.image = UIImage(named: "imgDistance")
        }else{
            self.declineIcon.image = UIImage(named: "imgMoney")
        }
        
        self.orderDeclinedView.isHidden = false
        
        self.thumbsDownIcon.alpha = 0
        self.declineIcon.alpha = 0
        
        UIView.animate(withDuration: 0.8,
                       delay: 0.0,
                       options:[.curveEaseInOut, .autoreverse,.repeat],
                       animations: {
                        self.orderDeclinedView.isHidden = false
                        self.thumbsDownIcon.alpha = (self.thumbsDownIcon.alpha == 1.0) ? 0.0 : 1.0
                        self.declineIcon.alpha = (self.declineIcon.alpha == 1.0) ? 0.0 : 1.0
                       }, completion: {_ in
                        self.thumbsDownIcon.alpha = (self.thumbsDownIcon.alpha == 1.0) ? 0.0 : 1.0
                        self.declineIcon.alpha = (self.declineIcon.alpha == 1.0) ? 0.0 : 1.0
                       })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.8) {
                self.thumbsDownIcon.alpha = 0
                self.declineIcon.alpha = 0
            } completion: { (_) in
                self.orderDeclinedView.isHidden = true
            }
        }
    }
    
    
    func setupMarkers(){
        let deliveryLats = CLLocationDegrees(JSON(currentOrder?.deliveryInfo?.latitude ?? "0.0").doubleValue)
        let deliveryLongs = CLLocationDegrees(JSON(currentOrder?.deliveryInfo?.longitude ?? "0.0").doubleValue)
        let deliveryCords = CLLocationCoordinate2D.init(latitude: deliveryLats, longitude: deliveryLongs)
        
        self.dropMarker.map = nil
        self.dropMarker = GMSMarker.init(position: deliveryCords)
        self.dropMarker.iconView = self.markerShadow(marker: self.dropMarker, img: UIImage(named: "imgMarkerDeliveryShadow"))
        //        self.dropMarker.icon = UIImage(named: "imgMarkerDeliveryShadow")
        self.dropMarker.map = self.mapView
        
        if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
            self.pickMarker.map = nil
            if self.courialMarker.position.latitude != self.courialMarker.position.longitude{
                let bounds = GMSCoordinateBounds(coordinate: self.dropMarker.position, coordinate: self.courialMarker.position)
                let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
                self.mapView.animate(with: update)
            } else{
                self.mapView.animate(toLocation: self.dropMarker.position)
                self.mapView.animate(toZoom: 15)
            }
        } else{
            let storeLats = CLLocationDegrees(JSON(currentOrder?.pickupInfo?.latitude ?? "0.0").doubleValue)
            let storeLongs = CLLocationDegrees(JSON(currentOrder?.pickupInfo?.longitude ?? "0.0").doubleValue)
            let storeCords = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(storeLats), longitude: CLLocationDegrees(storeLongs))
            
            self.pickMarker.map = nil
            self.pickMarker = GMSMarker.init(position: storeCords)
            self.pickMarker.iconView = self.markerShadow(marker: self.pickMarker, img: UIImage(named: "imgMarkerPickShadow"))
            //            self.pickMarker.icon = UIImage(named: "imgMarkerPickShadow")
            self.pickMarker.map = self.mapView
            
            let bounds = GMSCoordinateBounds(coordinate: self.dropMarker.position, coordinate: self.pickMarker.position)
            let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
            self.mapView.animate(with: update)
        }
        
    }
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func helpBtn(_ sender: UIButton) {
        guard self.endCallView.isHidden else {
            showSwiftyAlert("", "Please End Call to continue", false)
            return
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "OrderHelpVC") as! OrderHelpVC
        vc.modalPresentationStyle = .overCurrentContext
        self.view.addSubview(vc.view)
        self.addChild(vc)
    }
    
    
    @IBAction func refreshBtn(_ sender: UIButton) {
        self.refreshBtnOut.isHidden = true
        self.indicator.isHidden = false
        self.reloadView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.refreshBtnOut.isHidden = false
            self.indicator.isHidden = true
        }
    }
    
    
    
    @IBAction func serviceInfoBtn(_ sender: UIButton) {
        let serviceInfoView = SpecialServiceInfoView.init(frame: screenFrame())
        self.view.addSubview(serviceInfoView)
    }
    
    @IBAction func callBtn(_ sender: UIButton) {
        guard self.endCallView.isHidden else {
            showSwiftyAlert("", "Please End Call to continue", false)
            return
        }
        
        MediaShareInterface.shared.endCallView = self.endCallView
        MediaShareInterface.shared.tabBarShowAtEnd = true
        
        let courialFirstName = (currentOrder?.provider?.firstName ?? "").uppercased()
        var courialLastName = ""
        if let lastChar = (currentOrder?.provider?.lastName ?? "").uppercased().first{
            courialLastName = "\(lastChar)"
        }
        let courialName = courialFirstName + " " + courialLastName
        
        let courialNPhone = (currentOrder?.provider?.phone ?? "").replacingOccurrences(of: "[- ()]", with: "", options: .regularExpression, range: nil)
        MediaShareInterface.shared.twilioCall(vc: self,no: courialNPhone, name: courialName, hideDetails: true)
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
    
    @IBAction func msgBtn(_ sender: UIButton) {
        guard self.endCallView.isHidden else {
            showSwiftyAlert("", "Please End Call to continue", false)
            return
        }
        
        let courialNPhone = (currentOrder?.provider?.phone ?? "").replacingOccurrences(of: "[- ()]", with: "", options: .regularExpression, range: nil)
        let countryCode = (currentOrder?.provider?.countryCode ?? "").replacingOccurrences(of: "[- ()]", with: "", options: .regularExpression, range: nil)
        MediaShareInterface.shared.sendSms(countryCode + courialNPhone, self)
    }
    
    @IBAction func seeDetailBtnAction(sender: UIButton) {
        if self.isDataLoaded{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CurrentOrderVC") as! CurrentOrderVC
            self.navigationController?.pushViewController(vc, animated: false)
        } else{
            showLoader()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                hideLoader()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CurrentOrderVC") as! CurrentOrderVC
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
        
    }
    
    func editOrder(isAddress: Bool){
        let vc = storyboard?.instantiateViewController(withIdentifier: "CurrentOrderVC") as! CurrentOrderVC
        if isAddress{
            vc.isChangeAddress = true
        }else{
            vc.isChangeTime = true
        }
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func orderCompleted(){
        self.endCallBtn(UIButton())
        self.timer.invalidate()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryCompletedVC") as! DeliveryCompletedVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateCurrentOrder(){
        NotificationCenter.default.post(name: NSNotification.Name("updateCurrentOrder"), object: nil, userInfo: nil)
    }
}

extension CD_SeeDetailVC: GMSMapViewDelegate {
    
    func pauseTimer(){
        self.timer.invalidate()
        self.progressWidth.constant = 0
        
        if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
            let estimatedServiceTime = JSON(currentOrder?.estimatedServiceTime ?? "0").intValue + 5
            freeTime = estimatedServiceTime * 60
        }else{
            freeTime = 5 * 60
        }
        
        let pausedTime = JSON(currentOrder?.totalPauseTime ?? "0").intValue
        
        var pickUpStartDate = currentOrder?.pickUpTime?.convertStampToDate(.current) ?? Date()
        
        let pickUpTimeDate = (currentOrder?.pickUpTime ?? "0").convertStampToDate(.current) ?? Date()
        let pickupPointArrivalTimeDate = (currentOrder?.PickupPointArrivalTime ?? "0").convertStampToDate(.current) ?? Date()
        let deliveryArrivalTime = currentOrder?.DeliveryPointArrivalTime?.convertStampToDate(.current) ?? Date()
        
        if pickupPointArrivalTimeDate > pickUpTimeDate{
            pickUpStartDate = pickupPointArrivalTimeDate
        }else{
            pickUpStartDate = pickUpTimeDate
        }
        
        
        if currentOrder?.status == orderStatus.confirmDeliveryPointArrival || currentOrder?.status == orderStatus.userIdentityVerified{
            if JSON(currentOrder?.isSkill ?? "0").boolValue{
                if deliveryArrivalTime > pickUpTimeDate{
                    pickUpStartDate = deliveryArrivalTime
                }else{
                    pickUpStartDate = pickUpTimeDate
                }
            }else{
                pickUpStartDate = deliveryArrivalTime
            }
        }
        
        let pauseDate = currentOrder?.pausePlayDate?.convertStampToDate(.current) ?? Date()
        
        let timeDifferenceFromArrival = pickUpStartDate.secondsBetweenDate(toDate: Date())
        let pausedDifference = pauseDate.secondsBetweenDate(toDate: Date())
        
        let wastedSeconds = timeDifferenceFromArrival - pausedTime - pausedDifference
//        let wastedSeconds = pausedTime
        let totalSeconds = self.freeTime
        let remainingSec = totalSeconds - wastedSeconds
        
        let seconds = remainingSec % 60
        let minutes = (remainingSec / 60) % 60
        let diff = String(format: "%.02d:%.02d", minutes, seconds)
        
        let fullWidth = self.timeLbl.frame.width
        
        self.timeLbl.text = diff.replacingOccurrences(of: "-", with: "")
        let devidedWidth = JSON(fullWidth).doubleValue / JSON(self.freeTime).doubleValue
        
        self.progressWidth.constant = CGFloat(totalSeconds - remainingSec) *  CGFloat(devidedWidth)
        
        self.isTimerPlayed = false
        if self.isTimerPaused == false{
            self.animateTimer()
        }
    }
    
    func animateTimer(){
        guard self.isTimerPlayed == false else {
            self.isTimerPaused = false
            return
        }
        
        self.isTimerPaused = true
        
        UIView.animate(withDuration: 0.3) {
            self.timerView.alpha = (self.timerView.alpha == 1.0) ? 0.0 : 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
            self.animateTimer()
        }
    }
    
    func startFreeTimer(){
        if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
            let estimatedServiceTime = JSON(currentOrder?.estimatedServiceTime ?? "0").intValue + 5
            freeTime = estimatedServiceTime * 60
        }else{
            freeTime = 5 * 60
        }
        
        guard self.timerScheduled == false else {return}
        self.timerScheduled = true
        
        self.timer.invalidate()
        self.progressWidth.constant = 0
        
        var pickUpStartDate = currentOrder?.pickUpTime?.convertStampToDate(.current) ?? Date()
        
        let pickUpTimeDate = (currentOrder?.pickUpTime ?? "0").convertStampToDate(.current) ?? Date()
        let pickupPointArrivalTimeDate = (currentOrder?.PickupPointArrivalTime ?? "0").convertStampToDate(.current) ?? Date()
        let deliveryArrivalTime = currentOrder?.DeliveryPointArrivalTime?.convertStampToDate(.current) ?? Date()
        
        if pickupPointArrivalTimeDate > pickUpTimeDate{
            pickUpStartDate = pickupPointArrivalTimeDate
        }else{
            pickUpStartDate = pickUpTimeDate
        }
        
        if currentOrder?.status == orderStatus.confirmDeliveryPointArrival || currentOrder?.status == orderStatus.userIdentityVerified{
            if JSON(currentOrder?.isSkill ?? "0").boolValue{
                if deliveryArrivalTime > pickUpTimeDate{
                    pickUpStartDate = deliveryArrivalTime
                }else{
                    pickUpStartDate = pickUpTimeDate
                }
            }else{
                pickUpStartDate = deliveryArrivalTime
            }
        }
        
        let pauseDate = currentOrder?.pausePlayDate?.convertStampToDate(.current) ?? Date()
        
        let pausedTime = JSON(currentOrder?.totalPauseTime ?? "0").intValue
        let timeDifferenceFromArrival = pickUpStartDate.secondsBetweenDate(toDate: Date())
        let pausedDifference = pauseDate.secondsBetweenDate(toDate: Date())
        let wastedSeconds = timeDifferenceFromArrival - pausedTime - pausedDifference
        let remainingSeconds = self.freeTime - wastedSeconds
        pickUpStartDate = pauseDate
        
        guard let endTime = Calendar.current.date(byAdding: .second, value: remainingSeconds, to: pickUpStartDate) else {return}
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            self.setProgress(endTime)
        })
    }
    
    func setProgress(_ endTime: Date){
        let interval = Calendar.current.dateComponents([.minute,.second], from: Date(), to: endTime)
        let minutes = interval.minute ?? 0
        let seconds = interval.second ?? 0
        let diff = String(format: "%.02d:%.02d", minutes, seconds)
        
        let fullWidth = self.timeLbl.frame.width
        
        if diff == "00:00"{
            self.startPaidTimer()
        }else if diff.contains("-"){
            self.setupPaidCharges()
        } else{
            self.timeLbl.text = diff.replacingOccurrences(of: "-", with: "")
            let devidedWidth = JSON(fullWidth).doubleValue / JSON(self.freeTime).doubleValue
            
            let secondsDiff = abs(endTime.secondsBetweenDate(toDate: Date()))
            let totalSeconds = self.freeTime
            self.progressWidth.constant = CGFloat(totalSeconds - secondsDiff) *  CGFloat(devidedWidth)
        }
    }
    
    func setupPaidCharges(){
        self.progressWidth.constant = self.timeLbl.frame.width
        
        var pickUpStartDate = currentOrder?.pickUpTime?.convertStampToDate(.current) ?? Date()
        
        let pickUpTimeDate = (currentOrder?.pickUpTime ?? "0").convertStampToDate(.current) ?? Date()
        let pickupPointArrivalTimeDate = (currentOrder?.PickupPointArrivalTime ?? "0").convertStampToDate(.current) ?? Date()
        let deliveryArrivalTime = currentOrder?.DeliveryPointArrivalTime?.convertStampToDate(.current) ?? Date()
        
        if pickupPointArrivalTimeDate > pickUpTimeDate{
            pickUpStartDate = pickupPointArrivalTimeDate
        }else{
            pickUpStartDate = pickUpTimeDate
        }
        
        if currentOrder?.status == orderStatus.confirmDeliveryPointArrival || currentOrder?.status == orderStatus.userIdentityVerified{
            if JSON(currentOrder?.isSkill ?? "0").boolValue{
                if deliveryArrivalTime > pickUpTimeDate{
                    pickUpStartDate = deliveryArrivalTime
                }else{
                    pickUpStartDate = pickUpTimeDate
                }
            }else{
                pickUpStartDate = deliveryArrivalTime
            }
        }
        
        var remainingSeconds = 0
        
        if let pauseDate = currentOrder?.pausePlayDate?.convertStampToDate(.current){
            let pausedTime = JSON(currentOrder?.totalPauseTime ?? "0").intValue
            let timeDifferenceFromArrival = pickUpStartDate.secondsBetweenDate(toDate: Date())
            let pausedDifference = pauseDate.secondsBetweenDate(toDate: Date())
            let wastedSeconds = timeDifferenceFromArrival - pausedTime - pausedDifference
            remainingSeconds = self.freeTime - wastedSeconds
            pickUpStartDate = pauseDate
        } else{
            remainingSeconds = self.freeTime
        }
        
        guard let paidStartDate = Calendar.current.date(byAdding: .second, value: remainingSeconds, to: pickUpStartDate) else {return}
        
        let paidStartSec = JSON(paidStartDate.convertToFormat("ss", timeZone: .current)).intValue
        let currentSec = JSON(Date().convertToFormat("ss", timeZone: .current)).intValue
        
        var fireDate = Date()
        var isNextMinute = false
        if paidStartSec > currentSec{
            fireDate = Calendar.current.date(bySetting: .second, value: paidStartSec, of: Date())!
        } else{
            isNextMinute = true
            fireDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
            fireDate = Calendar.current.date(bySetting: .second, value: paidStartSec, of: fireDate)!
        }
        
        let minutes = JSON(paidStartDate.minutesBetweenDate(toDate: fireDate)).doubleValue
        
        if minutes < 1 && fireDate < Date(){
            self.startPaidTimer()
        }else if minutes > 0{
            if isNextMinute == false{
                self.waitCharges = minutes * waitTimeMultiplier
                if currentOrder?.status == orderStatus.confirmDeliveryPointArrival || currentOrder?.status == orderStatus.userIdentityVerified{
                    currentOrder?.dropOffWaitCharges = "\(self.waitCharges)"
                }else{
                    currentOrder?.pickupWaitCharges = "\(self.waitCharges)"
                }
            }else{
                self.waitCharges = (minutes - 1) * waitTimeMultiplier
                if currentOrder?.status == orderStatus.confirmDeliveryPointArrival || currentOrder?.status == orderStatus.userIdentityVerified{
                    currentOrder?.dropOffWaitCharges = "\(self.waitCharges)"
                }else{
                    currentOrder?.pickupWaitCharges = "\(self.waitCharges)"
                }
            }
            self.timeLbl.text = "$" + String(format: "%.02f", self.waitCharges)
            
            self.timer.invalidate()
            self.timer = Timer(fireAt: fireDate, interval: 0, target: self, selector: #selector(self.startPaidTimer), userInfo: nil, repeats: false)
            RunLoop.main.add(self.timer, forMode: .common)
        }
    }
    
    @objc func startPaidTimer(){
        self.waitCharges += waitTimeMultiplier
        DispatchQueue.main.async {
            if currentOrder?.status == orderStatus.confirmDeliveryPointArrival || currentOrder?.status == orderStatus.userIdentityVerified{
                currentOrder?.dropOffWaitCharges = "\(self.waitCharges)"
            }else{
                currentOrder?.pickupWaitCharges = "\(self.waitCharges)"
            }
            self.timeLbl.text = "$" + String(format: "%.02f", self.waitCharges)
        }
        
        self.timer.invalidate()
        self.progressWidth.constant = self.timeLbl.frame.width
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { (_) in
            self.waitCharges += self.waitTimeMultiplier
            DispatchQueue.main.async {
                if currentOrder?.status == orderStatus.confirmDeliveryPointArrival || currentOrder?.status == orderStatus.userIdentityVerified{
                    currentOrder?.dropOffWaitCharges = "\(self.waitCharges)"
                }else{
                    currentOrder?.pickupWaitCharges = "\(self.waitCharges)"
                }
                self.timeLbl.text = "$" + String(format: "%.02f", self.waitCharges)
            }
        })
    }
    
}

extension CD_SeeDetailVC {
    
    //Special Polyline and Distance
    
    func getPath(courialToDrop: Bool){
        let dropLats = CLLocationDegrees(JSON(currentOrder?.deliveryInfo?.latitude ?? "0.0").doubleValue)
        let dropLongs = CLLocationDegrees(JSON(currentOrder?.deliveryInfo?.longitude ?? "0.0").doubleValue)
        
        var pickLats = CLLocationDegrees(JSON(currentOrder?.pickupInfo?.latitude ?? "0.0").doubleValue)
        var pickLongs = CLLocationDegrees(JSON(currentOrder?.pickupInfo?.longitude ?? "0.0").doubleValue)
        
        if courialToDrop{
            pickLats = self.courialMarker.position.latitude
            pickLongs = self.courialMarker.position.longitude
        }else{
            showLoader()
        }
        
        guard let url = URL.init(string: "https://maps.googleapis.com/maps/api/directions/json?&mode=driving&origin=\(pickLats),\(pickLongs)&destination=\(dropLats),\(dropLongs)&sensor=false&key=\(gooleMapKey)") else {return}
        
        Alamofire.request(url).responseJSON { response in
            let jsonData = JSON(response.result.value as Any)
            
            guard jsonData["routes"].count != 0 else {
                currentOrder?.googleDistance = "0 mi"
                currentOrder?.googleDuration = "NO TIME"
                
                currentOrder?.livePathDistance = 0
                currentOrder?.livePathDuration = 0
                
                hideLoader()
                return
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
                    
                    currentOrderPoints = points
                    currentOrder?.points = points
                    currentOrder?.googleDistance = distance
                    currentOrder?.googleDuration = duration
                    
                    currentOrder?.livePathDistance = JSON(distance).intValue
                    currentOrder?.livePathDuration = JSON(duration).intValue
                } else{
                    currentOrder?.googleDistance = "0 mi"
                    currentOrder?.googleDuration = "NO TIME"
                    
                    currentOrder?.livePathDistance = 0
                    currentOrder?.livePathDuration = 0
                }
            } else{
                currentOrder?.googleDistance = "0 mi"
                currentOrder?.googleDuration = "NO TIME"
                
                currentOrder?.livePathDistance = 0
                currentOrder?.livePathDuration = 0
            }
            
            
            let durationInt = currentOrder?.livePathDuration ?? 0
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute]
            formatter.unitsStyle = .positional
            var formattedString = formatter.string(from: TimeInterval(durationInt)) ?? ""
            formattedString = formattedString.replacingOccurrences(of: ",", with: "")
            
            if JSON(formattedString).intValue < 1{
                currentOrder?.estimatedTime = "1"
                currentOrder?.livePathEstimatedTime = 1
            }else{
                currentOrder?.estimatedTime = formattedString
                currentOrder?.livePathEstimatedTime = JSON(formattedString).intValue
            }
            
            self.durationLbl.text =  "\(currentOrder?.livePathEstimatedTime ?? 1) mins"
            self.updateCurrentOrder()
            
            self.loadPath()
            hideLoader()
        }
    }
    
    func loadPath(){
//        guard let points = currentOrder?.points else {return}
//        self.polyline?.map = nil
//
//        for point in points{
//            let path = GMSPath.init(fromEncodedPath: point)
//            self.polyline = GMSPolyline(path: path)
//            polyline?.strokeColor = .black
//            polyline?.strokeWidth = 2
//            polyline?.map = self.mapView
//        }
    }
    
    
    func courialMarkerView()-> UIView{
        let markerView = UIView.init(frame: .init(x: 0, y: 0, width: 40, height: 40))
        markerView.backgroundColor = .clear
        
        let markerIcon = UIImageView.init(frame: .init(x: 0, y: 0, width: 33, height: 33))
        
        let transportMode = (currentOrder?.provider?.transport?.lowercased() ?? currentOrder?.trasnportMode?.lowercased() ?? "car")
        
        if  transportMode == "tow truck"{
            markerIcon.image = UIImage(named: "towtruckMarker")
        }else{
            markerIcon.image = UIImage(named: "\(transportMode)Marker")
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
    
    
    func updateVehicle(from: CLLocationCoordinate2D , to :CLLocationCoordinate2D){
        self.courialMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        //        self.courialMarker.rotation = currentOrder?.provider?.course ?? 0
        
        //found bearing value by calculation when marker add
        self.courialMarker.position = from
        
        //this can be old position to make car movement to new position
        self.courialMarker.map = self.mapView
        self.courialMarker.zIndex = 1
        
        //marker movement animation
        CATransaction.begin()
        CATransaction.setAnimationDuration(3.0)
        CATransaction.setValue(Int(3.0), forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock({() -> Void in
            self.courialMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
            //            self.courialMarker.rotation = currentOrder?.provider?.course ?? 0
            //New bearing value from backend after car movement is done
        })
        self.courialMarker.appearAnimation = .pop
        self.courialMarker.position = to
        
        //this can be new position after car moved from old position to new position with animation
        self.courialMarker.map = self.mapView
        self.courialMarker.zIndex = 1
        
        self.courialMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        //        self.courialMarker.rotation = currentOrder?.provider?.course ?? 0
        
        //found bearing value by calculation
        CATransaction.commit()
    }
    
}


extension CD_SeeDetailVC : SocketDelegate{
    
    func socketResponse(data: JSON, method: String) {
        self.loadData()
        
        guard method != socketMethods.decline_listener else {
            self.orderDeclined(type: data.stringValue)
            return
        }
        
        guard method != socketMethods.CancelOrder_listener else {
            showSwiftyAlert("", "Unfortunately your Courial needed to cancel. We are finding the next available Courial.", false)
            return
        }
        
        guard method != socketMethods.assignotherpartner_listener else {
            showSwiftyAlert("", "Sorry your Courial needed to cancel. We have assigned you a new Courial!", false)
            return
        }
        
        guard method != socketMethods.userCancelOrder_listener else {
            currentOrder = nil
            GoToHome()
            MediaShareInterface.shared.playSound(.cancel)
            return
        }
        
        if method == socketMethods.courialpayrecipt_listener{
            if let vc = self.navigationController?.viewControllers.last(where: {($0 as? CurrentOrderVC) != nil}){
                (vc as? CurrentOrderVC)?.refreshData()
            }
        }
        
        guard method == socketMethods.update_location_listener else {return}
        
        if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
//            self.getPath(courialToDrop: true)
            self.calculateDuration(courialToPick: false)
        }
        
        if currentOrder?.status == orderStatus.Accepted{
            if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
                self.calculateDuration(courialToPick: false)
            }else{
                self.calculateDuration(courialToPick: true)
            }
        }else if currentOrder?.status == orderStatus.confirmPickup || currentOrder?.status == orderStatus.confirmDeliveryPointArrival || currentOrder?.status == orderStatus.userIdentityVerified{
            self.calculateDuration(courialToPick: false)
        }
    }
    
    
    func calculateDuration(courialToPick: Bool){
        let coordinateOrigin = self.courialMarker.position
        var coordinateDestination = self.dropMarker.position
        
        if courialToPick == true{
            coordinateDestination = self.pickMarker.position
        }
        
        if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
            coordinateDestination = self.dropMarker.position
        }
        
        let sourceLocation: MKMapItem = .init(placemark: .init(coordinate: coordinateOrigin))
        let destinationLocation: MKMapItem = .init(placemark: .init(coordinate: coordinateDestination))
        
        let request = MKDirections.Request()
        request.source = sourceLocation
        request.destination = destinationLocation
        request.requestsAlternateRoutes = true
        request.transportType = .any
        
        let directions = MKDirections(request: request)
        directions.calculate { (directions, error) in
            if var routeResponse = directions?.routes {
                routeResponse.sort(by: {$0.expectedTravelTime <
                                    $1.expectedTravelTime})
                if let quickestRouteForSegment: MKRoute = routeResponse.first{
                    currentOrder?.googleDistance = "\(quickestRouteForSegment.distance)"
                    currentOrder?.googleDuration = "\(quickestRouteForSegment.expectedTravelTime)"
                    
                    currentOrder?.livePathDistance = JSON(quickestRouteForSegment.distance).intValue
                    currentOrder?.livePathDuration = JSON(quickestRouteForSegment.expectedTravelTime).intValue
                    
                    let durationInt = currentOrder?.livePathDuration ?? 0
                    let formatter = DateComponentsFormatter()
                    formatter.allowedUnits = [.minute]
                    formatter.unitsStyle = .positional
                    var formattedString = formatter.string(from: TimeInterval(durationInt)) ?? ""
                    formattedString = formattedString.replacingOccurrences(of: ",", with: "")
                    
                    if JSON(formattedString).intValue < 1{
                        currentOrder?.estimatedTime = "1"
                        currentOrder?.livePathEstimatedTime = 1
                    }else{
                        currentOrder?.estimatedTime = formattedString
                        currentOrder?.livePathEstimatedTime = JSON(formattedString).intValue
                    }
                    
                    self.durationLbl.text =  "\(currentOrder?.livePathEstimatedTime ?? 1) mins"
                    self.updateCurrentOrder()
                }
            }
        }
    }
    
}
