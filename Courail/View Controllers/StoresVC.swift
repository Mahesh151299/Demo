//
//  StoresVC.swift
//  Courail
//
//  Created by mac on 30/01/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos
import DZNEmptyDataSet
import GooglePlaces
import SwiftGifOrigin

class StoresCell: UITableViewCell {
    
    //MARK: OUTLETS
    @IBOutlet weak var imgGrocery: UIImageView!
    @IBOutlet weak var lblTittle: UILabel!
    @IBOutlet weak var milFee: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var rating : UILabel!
    @IBOutlet weak var lblClosed: UILabel!
    
    var businessDetail : YelpStoreBusinesses?{
        didSet{
            self.lblTittle.text = businessDetail?.name
            if businessDetail?.categories?.count != 0{
                let categories = businessDetail?.categories?.sorted(by: { (cat1, cat2) -> Bool in
                    (cat1.title ?? "") < (cat2.title ?? "")
                })
                self.lblType.text = "\(categories?.first?.title ?? "")"
            }else{
                self.lblType.text = ""
            }
            
            let reviews = JSON(businessDetail?.reviewCount ?? 0).stringValue + " Reviews"
            
            self.lblType.text = self.lblType.text! + " • " + reviews
            self.imgGrocery.sd_setImage(with: URL.init(string: (businessDetail?.imageUrl ?? "")), placeholderImage: UIImage(named: "imgNoLogo"), options: [], completed: nil)
            self.rating.text = "\(businessDetail?.rating ?? 0.0)"
            
            if let address = businessDetail?.location?.address1{
                self.lblAddress.text = "\(address) - \(businessDetail?.location?.city ?? "")"
            } else{
                self.lblAddress.text = businessDetail?.location?.city ?? ""
            }
            
            let duration = businessDetail?.duration ?? ""
            var distance = (businessDetail?.distance ?? "")
            let distanceMiles = JSON(distance).doubleValue * 0.000621371192
                distance = String(format: "%.02f", distanceMiles) + " mi"
            
            let mileage = 9.95 + ((distanceMiles < 1) ? 1.11 : (1.11 * distanceMiles))
            self.milFee.text = "$" + String(format: "%.02f", mileage) + " fee"
            
                self.lblTiming.isHidden = false
                self.lblClosed.isHidden = true
                
                if duration == "NO TIME"{
                    self.lblTiming.text = " • " + distance + " • " + duration + " away"
                } else{
                    let durationInt = JSON(duration).intValue
                    let formatter = DateComponentsFormatter()
                    formatter.allowedUnits = [.hour, .minute]
                    formatter.unitsStyle = .short
                    let formattedString = formatter.string(from: TimeInterval(durationInt)) ?? ""
                    self.lblTiming.text = " • " + distance + " • " + formattedString + " away"
                }   
            }
    }
    
    func openingTime(_ model: YelpStoreBusinesses?,_ dayCount: Int, result: @escaping(String)->Void){
        //0 Mon to 6 sun
        let today = Calendar.current.date(byAdding: .day, value: dayCount, to: Date())!
        guard let day = model?.openingHours?.filter({$0.day == (dayOfWeek(today))}).first else{
            result("")
            return
        }
        
        let hour = Int(day.start?.prefix(2) ?? "0") ?? 0
        let min = Int(day.start?.suffix(2) ?? "0") ?? 0
        
        guard let openDate = Calendar.current.date(bySettingHour: hour, minute: min, second: 0, of: today) else{
            result("")
            return
        }
        let dateDiff = openDate.timeBetweenDates()
        if dateDiff.contains("-"){
            //check for next Day
            result("")
        } else{
            result(" • Opens in " + openDate.timeBetweenDates())
        }
    }
    
}


class SubCatCell: UICollectionViewCell {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var catName : UILabel!
    @IBOutlet weak var innerView : UIView!
    
}


class StoresVC: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var groceryDeliveryTableView: UITableView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblStoreNearBy : UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var sortTable: UITableView!
    @IBOutlet weak var sortTableHeight: NSLayoutConstraint!
    @IBOutlet weak var sortBGView: UIView!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var collectionLine: UIView!
        
    @IBOutlet weak var gifImage: UIImageView!
    //MARK:- VARIABLES
    
    var category = ""
    var isSearch = false
    var bussinessViewModel = BussinessViewModel()
    
    var emptyView : SearchEmptyView?
    
    var pushedToNextVC = false
    
    var selectedFoodCat = ""
    var foodCategories = [
        "American",
        "Breakfast",
        "Burgers",
        "BBQ",
        "Caribbean",
        "Chinese",
        "Desserts",
        "Fast Food",
        "Ice Cream",
        "Indian",
        "Italian",
        "Japanese",
        "Korean",
        "Mexican",
        "Pizza",
        "Sandwiches",
        "Seafood",
        "Soul Food",
        "Steakhouses",
        "Sushi",
        "Thai",
        "Vegetarian",
        "Vietnamese"
    ]
    
    var filterArr = ["Cost","Distance","Time","Reviews","Name","Rating"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLoadingView()
        self.stack.subviews.forEach({$0.isHidden = true})
        groceryDeliveryTableView.tableFooterView = UIView()
        
        
        lblTitle.text = ""
        
        lblStoreNearBy.text = "Options Nearby"
        
        self.lblTitle.alpha = 0.1
        
        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [ .repeat, .autoreverse], animations: {
            self.lblTitle.alpha = 1
        }) { (_) in
            
        }

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.groceryDeliveryTableView.emptyDataSetDelegate = self
        self.groceryDeliveryTableView.emptyDataSetSource = self
        
        //api call
        if self.selectedFoodCat != ""{
            let keyword = self.selectedFoodCat.uppercased() + " FOOD RESTAURANTS"
            self.searchforbusiness(search_by: keyword,  false)
        } else{
            let cat = self.category.lowercased().replacingOccurrences(of: " ", with: "")
            if (restrictedKeywords.first(where: {$0.lowercased().replacingOccurrences(of: " ", with: "") == cat}) != nil){
                if isLoggedIn(){
                    self.bannedKeywordsApi(self.category)
                }
                self.lblTitle.layer.removeAllAnimations()
                if let data = appCategories.arrayValue.first(where: {$0["category"].stringValue.lowercased() == self.category.lowercased()}){
                    self.lblTitle.text = (data["info"].stringValue).capitalized.replacingOccurrences(of: "Loading ", with: "")
                } else{
                    self.lblTitle.text = self.category.capitalized + " Options"
                }

                self.noStoresView()
                self.removeLoadingView()
                self.groceryDeliveryTableView.reloadData()

            }else{
                self.searchforbusiness(search_by: self.category,  false)
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pushedToNextVC = false
        self.bussinessViewModel.sortingType = "Distance"
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.sortTable.addShadows()
        self.sortTableHeight.constant = self.sortTable.contentSize.height
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.lblTitle.layer.removeAllAnimations()
        if self.pushedToNextVC == false{
            self.bussinessViewModel.timer.invalidate()
            self.bussinessViewModel = BussinessViewModel()
            ApiManager.sharedInstance.cancelAllRequests()
        }
    }
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func backBtnAction(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        }

    
    @IBAction func filterBtnAct(_ sender: UIButton) {
        self.sortView.isHidden = false
    }
    
    @IBAction func hideSortBtn(_ sender: UIButton) {
        self.sortView.isHidden = true
    }
    
    func sortData(_ selectedOption: String){
        self.bussinessViewModel.businessData.businesses = self.bussinessViewModel.businessData.businesses?.sorted(by: { (store1, store2) -> Bool in
            switch selectedOption{
            case "Cost":
                
                let distanceMiles1 = JSON(store1.distance ?? "0").doubleValue * 0.000621371192
                let mileage1 = 9.95 + ((distanceMiles1 < 1) ? 1.11 : (1.11 * distanceMiles1))
                
                let distanceMiles2 = JSON(store2.distance ?? "0").doubleValue * 0.000621371192
                let mileage2 = 9.95 + ((distanceMiles2 < 1) ? 1.11 : (1.11 * distanceMiles2))
                
                return mileage1 < mileage2
            case "Distance":
                let distance1 = (store1.distance ?? "0")
                let distance2 = (store2.distance ?? "0")
                return JSON(distance1).doubleValue < JSON(distance2).doubleValue
            case "Time":
                let time1 = (store1.duration ?? "")
                let time2 = (store2.duration ?? "")
                return JSON(time1).doubleValue < JSON(time2).doubleValue
            case "Reviews":
                let reviews1 = store1.reviewCount ?? 0
                let reviews2 = store2.reviewCount ?? 0
                return reviews1 > reviews2
            case "Rating":
                return (store1.rating ?? 0) > (store2.rating ?? 0)
            default :
                //"Name"
                return (store1.name ?? "").lowercased() < (store2.name ?? "").lowercased()
            }
        })
        
        self.bussinessViewModel.sortingType = selectedOption
        self.groceryDeliveryTableView.reloadData()
        if self.groceryDeliveryTableView.numberOfRows(inSection: 0) > 0 {
            self.groceryDeliveryTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    @IBAction func refreshBtn(_ sender: UIButton) {
        if self.groceryDeliveryTableView.numberOfRows(inSection: 0) > 0 {
            self.groceryDeliveryTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
        }
        
        if self.selectedFoodCat != ""{
            let keyword = self.selectedFoodCat.uppercased() + " FOOD RESTAURANTS"
            self.searchforbusiness(search_by: keyword,  true)
        } else{
            self.searchforbusiness(search_by: self.category,  true)
        }
    }
    
}

extension StoresVC: UIPopoverPresentationControllerDelegate{
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension StoresVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableView != self.sortTable else{
            return self.filterArr.count
        }
        return self.bussinessViewModel.businessData.businesses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tableView != self.sortTable else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopOverTVC")as! PopOverTVC
            cell.lblName.text = self.filterArr[indexPath.row]
            
            if self.bussinessViewModel.sortingType == cell.lblName.text{
                cell.lblName.textColor = appColor
                cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
            } else{
                cell.lblName.textColor = .black
                cell.contentView.backgroundColor = .white
            }
            
            return cell
        }
        
        var cell = StoresCell()
        cell = groceryDeliveryTableView.dequeueReusableCell(withIdentifier: "StoresCell", for: indexPath) as! StoresCell
        let data = self.bussinessViewModel.businessData.businesses?[indexPath.row]
        cell.businessDetail = data
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushedToNextVC = true
        
        guard tableView != self.sortTable else{
            self.bussinessViewModel.sortingType = self.filterArr[indexPath.row]
            tableView.reloadData()
            self.sortView.isHidden = true
            self.sortData(self.filterArr[indexPath.row])
            return
        }
        
        self.getStoreDetails(index: indexPath.row)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


extension StoresVC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCatCell", for: indexPath) as! SubCatCell
        
        cell.catName.text = self.foodCategories[indexPath.item]
        
        cell.catName.textColor = (self.selectedFoodCat == cell.catName.text) ? .white : .black
        cell.innerView.backgroundColor = (self.selectedFoodCat == cell.catName.text) ? appColorBlue : UIColor.lightGray.withAlphaComponent(0.2)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let customLbl = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: collectionView.frame.height))
        customLbl.text = self.foodCategories[indexPath.item]
        customLbl.sizeToFit()
        return .init(width: customLbl.frame.width + 20, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectedFoodCat == self.foodCategories[indexPath.item]{
            self.selectedFoodCat = ""
        } else{
            self.selectedFoodCat = self.foodCategories[indexPath.item]
        }
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if self.groceryDeliveryTableView.numberOfRows(inSection: 0) > 0 {
            self.groceryDeliveryTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
        }
        
        if self.selectedFoodCat != ""{
            let keyword = self.selectedFoodCat.uppercased() + " FOOD RESTAURANTS"
            self.searchforbusiness(search_by: keyword,  true)
        } else{
            self.searchforbusiness(search_by: self.category,  true)
        }
    }
    
}

extension StoresVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource{
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
//        guard self.isSearch == false else {
            return nil
//        }
        
//        let data = appCategories.arrayValue.first(where: {$0["category"].stringValue.lowercased() == self.category.lowercased()})
//        var icon = data?["icon"].stringValue ?? ""
//
//        if data?["icon"].stringValue == "imgArtsupply"{
//            icon = "imgArtsupplyBG"
//        }else if data?["icon"].stringValue == "imgConveniencestore"{
//            icon = "imgConveniencestoreBG"
//        }else if data?["icon"].stringValue == "imgFashion"{
//            icon = "imgFashionBG"
//        }else{
//            icon = data?["icon"].stringValue ?? ""
//        }
//
//        let emptyView = EmptyView.init(frame: scrollView.bounds, icon: icon)
//        return emptyView
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136, 1334 , 1920, 2208:
                return -15
            default:
                return -80
            }
        }else{
            return -15
        }
    }
    
    
    func addLoadingView(){
        var gifType = "category"
        if self.category.uppercased() == "TAKE OUT"{
            gifType = "takeout"
        }
        
        self.gifImage.isHidden = false
        self.gifImage.image = UIImage.gif(name: gifType)
//        DispatchQueue.main.async {
//            let customFrame = CGRect.init(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height)
//            self.emptyView = SearchEmptyView.init(frame: customFrame, gifName: gifType)
//            self.view.addSubview(self.emptyView!)
//        }
    }
    
    func removeLoadingView(){
        self.gifImage.alpha = 1
        UIView.animate(withDuration: 0.5, animations: {
            self.gifImage.alpha = 0
        }) { (_) in
            self.gifImage.image = nil
            self.gifImage.isHidden = true
        }
    }
    
    func noStoresView(){
        self.groceryDeliveryTableView.emptyDataSetDelegate = nil
        self.groceryDeliveryTableView.emptyDataSetSource = nil
        self.groceryDeliveryTableView.reloadData()
        
        let imgView = UIImageView.init(frame: self.groceryDeliveryTableView.bounds)
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "imgEmptyStores")
        self.groceryDeliveryTableView.backgroundView = imgView
    }
    
    
}

extension StoresVC{
    
    //MARK:- API
    func searchforbusiness(search_by:String,_ loader: Bool){
        var keyword = search_by
        
        let categoriesParam = ""
        if let data = appCategories.arrayValue.first(where: {$0["category"].stringValue.lowercased() == search_by.lowercased()}){
            keyword = data["terms"].stringValue.uppercased()
//            categoriesParam = data["keywords"].stringValue.lowercased().replacingOccurrences(of: " ", with: "")
        }
        
//        categoriesParam = ""
        
        if loader{
            showLoader()
        }
        
        bussinessViewModel.searchforbusiness(search_by: keyword, cats: categoriesParam, lats: DeliveryAddressInterface.shared.getDeliveryCords().latitude, longs: DeliveryAddressInterface.shared.getDeliveryCords().longitude) {
            
            if self.isSearch{
                let key = search_by.replacingOccurrences(of: "’s", with: "").replacingOccurrences(of: "'s", with: "")
                let serachedBusiness = self.bussinessViewModel.businessData.businesses?.filter({($0.name?.lowercased().contains(key.lowercased())) == true})
                if (serachedBusiness?.count ?? 0) != 0{
                    self.bussinessViewModel.businessData.businesses = serachedBusiness
                }
            }
             
            if self.bussinessViewModel.businessData.businesses?.isEmpty == true || self.bussinessViewModel.businessData.businesses?.isEmpty == nil{
                self.lblStoreNearBy.text = "No results found"
                self.noStoresView()
            } else{
                self.lblStoreNearBy.text = "\(self.bussinessViewModel.businessData.businesses?.count ?? 0) Options Nearby"
            }
            
            self.lblTitle.layer.removeAllAnimations()
            if let data = appCategories.arrayValue.first(where: {$0["category"].stringValue.lowercased() == self.category.lowercased()}){
                self.lblTitle.text = (data["info"].stringValue).capitalized.replacingOccurrences(of: "Loading ", with: "")
            } else{
                self.lblTitle.text = self.category.capitalized + " Options"
            }
            
            if self.bussinessViewModel.businessData.businesses?.isEmpty == false{
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.groceryDeliveryTableView.alpha = 0
//                }) { (_) in
                    self.removeLoadingView()
                    self.groceryDeliveryTableView.reloadData()
                    self.groceryDeliveryTableView.alpha = 1
                    self.sortBGView.isHidden = false
                    if self.category.uppercased() == "TAKE OUT"{
                        self.collectionView.isHidden = false
                        self.collectionLine.isHidden = false
                    } else{
                        self.collectionView.isHidden = true
                        self.collectionLine.isHidden = true
                    }
                    hideLoader()
//                }
                
            } else{
                self.removeLoadingView()
                self.groceryDeliveryTableView.reloadData()
                hideLoader()
            }

        }
    }
    
    func bannedKeywordsApi(_ keyword: String){
        let params: Parameters = [
            "keywords" : keyword
        ]
        ApiInterface.requestApi(params: params, api_url: API.sendpushtosuse , success: { (json) in
        }) { (error, json) in
        }
    }
    
    
    func getStoreDetails(index: Int){
        let storeLats = CLLocationDegrees(self.bussinessViewModel.businessData.businesses?[index].coordinates?.latitude ?? 0.0)
        let storeLongs = CLLocationDegrees(self.bussinessViewModel.businessData.businesses?[index].coordinates?.longitude ?? 0.0)
        let cords = CLLocationCoordinate2D(latitude: storeLats, longitude: storeLongs)
        
        showLoader()
        MapHelper.sharedInstance.googleNearby(cords: cords, name: self.bussinessViewModel.businessData.businesses?[index].name ?? "", success: { (json) in
            let placeID = json["results"].arrayValue.map({$0["place_id"].stringValue}).first ?? ""
            self.bussinessViewModel.businessData.businesses?[index].googlePlaceID = placeID
            self.bussinessViewModel.businessData.businesses?[index].category = self.category
            
            MapHelper.sharedInstance.LookupPlace(with: placeID, success: { (place) in
                self.bussinessViewModel.businessData.businesses?[index].details = place
                hideLoader()
                self.goToStoreWebsite(business: self.bussinessViewModel.businessData.businesses?[index])
            }) { (error) in
                self.bussinessViewModel.businessData.businesses?[index].details = nil
                hideLoader()
                self.goToStoreInfo(business: self.bussinessViewModel.businessData.businesses?[index])
            }
        }) { (error) in
            self.bussinessViewModel.businessData.businesses?[index].details = nil
            hideLoader()
            self.goToStoreInfo(business: self.bussinessViewModel.businessData.businesses?[index])
        }
    }
    
    func goToStoreWebsite(business: YelpStoreBusinesses?){
        let vc = storyboard?.instantiateViewController(withIdentifier: "ScheduleGroceryDeliveryVC") as! ScheduleGroceryDeliveryVC
        vc.businessDetail = business
        vc.isStoreInfo = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToStoreInfo(business: YelpStoreBusinesses?){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedStoreVC") as! SelectedStoreVC
        vc.businessDetail = business
        vc.category = self.category
        vc.isStoreInfo = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
