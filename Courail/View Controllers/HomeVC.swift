//
//  HomeVC.swift
//  Courail
//
//  Created by apple on 24/01/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import CoreLocation

class HomeVC: UIViewController {
    //MARK:- OUTLETS
    
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var deliveryAdd: UIButton!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var specialView: UIView!
    @IBOutlet weak var specialBgView: UIViewCustomClass!
    
    @IBOutlet weak var farAwayView: UIView!
    //MARK:- VARIABLES
    
    var homeCategories = appCategories
    var homeAds = [OfferModel]()
    var homeOffers = [OfferModel]()
    var showDistanceWarning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splashTransistion = false
        _ = LocationInterface.shared
        
        self.table.delegate = self
        self.table.dataSource = self
        self.table.tableFooterView = UIView()
        self.table.isScrollEnabled = false
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        if isLoggedIn(){
            self.getOnlineBusinessApi()
        }
        
        DispatchQueue.main.async {
            self.table.reloadData()
            self.setupCategories()
        }
    }
    
    func setupCategories(){
        let GroceryCat = appCategories.arrayValue.filter({$0["category"].stringValue.lowercased() == "grocery"})
        let ConvCat = appCategories.arrayValue.filter({$0["category"].stringValue.lowercased() == "convenience"})
        let otherCats = appCategories.arrayValue.filter({($0["category"].stringValue.lowercased() != "grocery") && ($0["category"].stringValue.lowercased() != "convenience")})
        
        var combineCats = GroceryCat + ConvCat + otherCats
        
        combineCats = combineCats.sorted(by: { (cat1, cat2) -> Bool in
            cat1["count"].intValue > cat2["count"].intValue
        })
        
        self.homeCategories = JSON(combineCats)
        
        self.homeCategories.arrayObject?.insert(JSON([
            "category":"Special",
            "icon":"imgPersAsst",
            "hex":"F1F2F3",
            "info":""
        ]), at: 0)
        self.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UpdateAvailable.isUpdateAvailable()
        
        
//        self.checkDistance()
        self.tabBarController?.tabBar.isHidden = false
        self.setupCategories()
        self.deliveryAdd.setTitle(DeliveryAddressInterface.shared.selectedAddress.address ?? "", for: .normal)
        self.lblDelivery.text = "DELIVERING TO " + (isLoggedIn() ? (userInfo.firstName ?? "").uppercased() : "YOU")
        
        ApiInterface.getCurrentOrder {_ in }
        self.getAds()
        self.getOffers()
        ApiInterface.updateVersion()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let adCell = self.table.visibleCells.first as? HomeTVC{
            adCell.timer.invalidate()
        }
    }
    
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupCollectionHeight()
        self.collectionView.reloadData()
        self.specialBgView.addShadowsRadius()
    }
    
    func setupCollectionHeight(){
        let padding : CGFloat = 20
        let minSpacing : CGFloat = 15
        let width = (self.view.frame.size.width - (padding + minSpacing)) / 4
        self.collectionViewHeight.constant = width
    }
    
    func checkDistance(){
        let delLats = CLLocationDegrees(DeliveryAddressInterface.shared.selectedAddress.latitude ?? 0.0)
        let delLongs = CLLocationDegrees(DeliveryAddressInterface.shared.selectedAddress.longitude ?? 0.0)
        let coordinateDestination = CLLocation(latitude: delLats, longitude: delLongs)
        let coordinateOrigin = CLLocation.init(latitude: LocationInterface.shared.cords?.latitude ?? 0.0, longitude: LocationInterface.shared.cords?.longitude ?? 0.0)
        
        let distanceMiles = coordinateDestination.distance(from: coordinateOrigin) * 0.000621371192
        guard distanceMiles > 2 else{
            self.showDistanceWarning = false
            return
        }
        
        self.showDistanceWarning = true
    }
    
    //MARK:- BUTTONS ACTIONS
    @IBAction func farAwayCrossBtn(_ sender: UIButton) {
        self.showDistanceWarning = false
        DispatchQueue.main.async {
            self.farAwayView.isHidden = true
        }
    }
    
    @IBAction func tittleBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SetAddressVC") as! SetAddressVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func specialBtn(_ sender: UIButton) {
        guard self.showDistanceWarning == false else {
            self.farAwayView.isHidden = false
            return
        }

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SpecialDeliveryVC")as! SpecialDeliveryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func greetingLogic() -> String {
        let date = NSDate()
        let calendar = NSCalendar.current
        let currentHour = calendar.component(.hour, from: date as Date)
        let hourInt = Int(currentHour.description)!
        var greeting = ""
        if hourInt >= 12 && hourInt <= 16 {
            greeting = "Good Afternoon"
        }
        else if hourInt >= 5 && hourInt <= 12 {
            greeting = "Good Morning"
        }
        else if hourInt >= 16 && hourInt <= 20 {
            greeting = "Good Evening"
        }
        else {
            greeting = "Good Night"
        }
        
        if isLoggedIn(){
            return greeting + ", \(userInfo.firstName ?? "")"
        } else{
            return greeting
        }
    }
}

extension HomeVC: UITableViewDelegate , UITableViewDataSource , HomeDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section != 0 else {
            return (self.homeAds.isEmpty) ? 0 : 1
        }
        
        return (self.homeOffers.isEmpty) ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section == 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OfferTVC") as! HomeTVC
            cell.header.text = "Popular Searches"
            cell.setupData(type: 1, data: self.homeOffers)
            cell.delegate = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdTVC") as! HomeTVC
        cell.setupData(type: 0, data: self.homeAds)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableHeight = tableView.frame.height
        let tableWidth = tableView.frame.width
        let adHeight = tableWidth / 2
        
        guard indexPath.section != 0 else {
            return adHeight
        }
        
        let offerHeight = tableHeight - adHeight
        return offerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableHeight = tableView.frame.height
        let tableWidth = tableView.frame.width
        let adHeight = tableWidth / 2
        
        guard indexPath.section != 0 else {
            return adHeight
        }
        
        let offerHeight = tableHeight - adHeight
        return offerHeight
    }
    
    
    func CollectionItemClicked(data: OfferModel, type: Int){
        guard self.showDistanceWarning == false else {
            self.farAwayView.isHidden = false
            return
        }
        
        guard type != 0 else {
            if let vc = (self.tabBarController?.viewControllers?[1] as? UINavigationController){
                if data.url == "" || data.url?.lowercased() == "search"{
                    vc.popToRootViewController(animated: false)
                    (vc.viewControllers.first as? SearchPlaceVC)?.searchType = 1
                    if (vc.viewControllers.first as? SearchPlaceVC)?.collectionURL != nil{
                        (vc.viewControllers.first as? SearchPlaceVC)?.searchField.text = ""
                        (vc.viewControllers.first as? SearchPlaceVC)?.arrangeViews()
                    }
                }else{
                    (vc.viewControllers.first as? SearchPlaceVC)?.searchType = 2
                    vc.popToRootViewController(animated: false)
                    if (vc.viewControllers.first as? SearchPlaceVC)?.collectionURL != nil{
                        (vc.viewControllers.first as? SearchPlaceVC)?.searchField.text = ""
                        (vc.viewControllers.first as? SearchPlaceVC)?.arrangeViews()
                    }
                    
                    let vcWeb = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleGroceryDeliveryVC") as! ScheduleGroceryDeliveryVC
                    var model = YelpStoreBusinesses.init(json: JSON())
                    model.url =  (data.url ?? "")
                    model.name = (data.title ?? "").htmlToString.htmlToString
                    model.isWebStore = true
                    vcWeb.businessDetail = model
                    (vc.viewControllers.first as? SearchPlaceVC)?.navigationController?.pushViewController(vcWeb, animated: false)
                }
                self.tabBarController?.selectedIndex = 1
            }

            return
        }
        
        if let vc = (self.tabBarController?.viewControllers?[1] as? UINavigationController){
            (vc.viewControllers.first as? SearchPlaceVC)?.searchType = 1
            
            if isLoggedIn(){
                self.offerClicked("\(data.internalIdentifier ?? 0)")
            }
            
            vc.popToRootViewController(animated: false)
            if (vc.viewControllers.first as? SearchPlaceVC)?.collectionURL != nil{
                (vc.viewControllers.first as? SearchPlaceVC)?.searchField.text = ""
                (vc.viewControllers.first as? SearchPlaceVC)?.arrangeViews()
            }
            
            let vcStore = self.storyboard?.instantiateViewController(withIdentifier: "StoresVC") as! StoresVC
            vcStore.isSearch = true
            vcStore.category = (data.title ?? "").htmlToString.htmlToString
            (vc.viewControllers.first as? SearchPlaceVC)?.navigationController?.pushViewController(vcStore, animated: false)
            
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.setupCollectionHeight()
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCVC", for: indexPath) as! CategoryCVC
                        
        var category = self.homeCategories[indexPath.item]["category"].stringValue
        if category.lowercased() == "special"{
            category = "Service"
        }
        cell.title.text = category
        cell.icon.image = UIImage(named: self.homeCategories[indexPath.item]["icon"].stringValue)
        cell.iconBGView.backgroundColor = hexStringToUIColor(hex: self.homeCategories[indexPath.item]["hex"].stringValue)
        
        cell.icon.contentMode = .scaleAspectFit
        cell.iconHeight.constant = -10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: -2, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding : CGFloat = 20
        let minSpacing : CGFloat = 15
        let width = (self.view.frame.size.width - (padding + minSpacing)) / 4
        return .init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard self.showDistanceWarning == false else {
            self.farAwayView.isHidden = false
            return
        }
        
        guard indexPath.row != 0 else{
            if let vc = (self.tabBarController?.viewControllers?[1] as? UINavigationController){
                (vc.viewControllers.first as? SearchPlaceVC)?.searchType = 3
                vc.popToRootViewController(animated: false)
                if (vc.viewControllers.first as? SearchPlaceVC)?.collectionURL != nil{
                    (vc.viewControllers.first as? SearchPlaceVC)?.searchField.text = ""
                    (vc.viewControllers.first as? SearchPlaceVC)?.arrangeViews()
                }
            }
            self.tabBarController?.selectedIndex = 1
            return
        }
                
        if let vc = (self.tabBarController?.viewControllers?[1] as? UINavigationController){
            if self.homeCategories[indexPath.item]["category"].stringValue.lowercased() == "last mile"{
                (vc.viewControllers.first as? SearchPlaceVC)?.searchType = 2
            }else{
                if isLoggedIn(){
                    self.incCatCount(self.homeCategories[indexPath.item]["category"].stringValue)
                }
                (vc.viewControllers.first as? SearchPlaceVC)?.searchType = 1
            }
            
            vc.popToRootViewController(animated: false)
            if (vc.viewControllers.first as? SearchPlaceVC)?.collectionURL != nil{
                (vc.viewControllers.first as? SearchPlaceVC)?.searchField.text = ""
                (vc.viewControllers.first as? SearchPlaceVC)?.arrangeViews()
            }
            self.tabBarController?.selectedIndex = 1
            
            if self.homeCategories[indexPath.item]["category"].stringValue.lowercased() != "last mile"{
                let vcStore = self.storyboard?.instantiateViewController(withIdentifier: "StoresVC") as! StoresVC
                vcStore.category = self.homeCategories[indexPath.item]["category"].stringValue
                (vc.viewControllers.first as? SearchPlaceVC)?.navigationController?.pushViewController(vcStore, animated: false)
            }
        }
    }
    
}

extension HomeVC{
    
    //MARK: API
    
    func getOnlineBusinessApi(){
        ApiInterface.requestApi(params: [:], api_url: API.get_online_business, method: .get, encoding: URLEncoding.httpBody , success: { (json) in
            if let data = json["data"].array{
                appUrls = data.map({OnlineBusinessModel.init(json: $0)})
            }
            modifyURLs()
        }) { (error, json) in
        }
    }
    
    
    func getAds(){
        ApiInterface.requestApi(params: [:], api_url: API.get_ads, method: .get, encoding: URLEncoding.httpBody , success: { (json) in
            print(json)
            if let data = json["data"].array{
                self.homeAds = data.map({OfferModel.init(json: $0)})
            }
            UIView.performWithoutAnimation {
                self.table.reloadSections(IndexSet.init(integer: 0), with: .automatic)
            }
//            self.table.reloadData()
        }) { (error, json) in
        }
    }
    
    func getOffers(){
        let params: Parameters = [
            "user_id" : userInfo.internalIdentifier ?? ""
        ]
        
        ApiInterface.requestApi(params: params, api_url: API.get_offers, method: .get, encoding: URLEncoding.httpBody , success: { (json) in
            if let data = json["data"].array{
                self.homeOffers = data.map({OfferModel.init(json: $0)})
            }
            
            UIView.performWithoutAnimation{
                self.table.reloadSections(IndexSet.init(integer: 1), with: .automatic)
            }
//            self.table.reloadData()
        }) { (error, json) in
        }
    }
    
    func incCatCount(_ cat: String){
        let params: Parameters = [
            "categoryname" : cat
        ]
        ApiInterface.requestApi(params: params, api_url: API.increase_category_count , success: { (json) in
            if let index = appCategories.arrayValue.firstIndex(where: {$0["category"].stringValue.lowercased() == cat.lowercased()}){
                appCategories[index]["count"].intValue += 1
            }
        }) { (error, json) in
            print(error)
        }
    }
    
    
    func offerClicked(_ id: String){
        let params: Parameters = [
            "offerid" : id
        ]
        ApiInterface.requestApi(params: params, api_url: API.viewoffers , success: { (json) in
        }) { (error, json) in
        }
    }
    
}
