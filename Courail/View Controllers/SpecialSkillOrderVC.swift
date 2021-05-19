//
//  SpecialSkillOrderVC.swift
//  Courail
//
//  Created by Omeesh Sharma on 03/09/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SKPhotoBrowser
import RangeSeekSlider

class SpecialSkillOrderVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerTittleLbl: UILabel!
    @IBOutlet weak var headerSubTitleLbl: UILabel!
    
    @IBOutlet weak var prepaidBtn: UIButton!
    @IBOutlet weak var courailPayBtn: UIButton!
    @IBOutlet weak var courialFieldView: UIViewCustomClass!
    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var itemCostLbl: UILabel!
    
    @IBOutlet weak var reviewBtnBgView: UIView!
    @IBOutlet weak var deliveryAdd: UIButton!
    @IBOutlet weak var deliveryFee: UILabel!
    @IBOutlet weak var lblDelivery: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionWidth: NSLayoutConstraint!
    
    @IBOutlet weak var itemNotesTV: IQTextView!
    @IBOutlet weak var itemNotesTVHeight: NSLayoutConstraint!
    
    @IBOutlet weak var selectedTransport: UIImageView!
    @IBOutlet weak var transportDesc: UILabel!
    
    @IBOutlet weak var choosePickLbl: UILabel!
    
    @IBOutlet weak var collectionImages: UICollectionView!
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var avgTimeView: UIView!
    @IBOutlet weak var avgTimeViewLead: NSLayoutConstraint!
    
    @IBOutlet weak var avgTimeLbl: UILabel!
    @IBOutlet weak var timeSliderLbl: UILabel!
    @IBOutlet weak var timeSlider: RangeSeekSlider!
    
    @IBOutlet weak var offerView: UIView!
    @IBOutlet weak var avgOfferView: UIView!
    @IBOutlet weak var avgOfferViewLead: NSLayoutConstraint!
    
    @IBOutlet weak var avgOfferLbl: UILabel!
    @IBOutlet weak var offerSliderLbl: UILabel!
    @IBOutlet weak var offerSlider: RangeSeekSlider!
    
    @IBOutlet weak var textViewBg: UIViewCustomClass!
    
    @IBOutlet weak var specialLinkView: UIViewCustomClass!
    @IBOutlet weak var specialLinkTF: UITextField!
    
    @IBOutlet weak var transportStack: UIStackView!
    @IBOutlet weak var towTruckIcon: UIImageView!
    
    //MARK:- VARIABLES
    
    var businessDetail : YelpStoreBusinesses?
    
    var photoBrowser = SKPhotoBrowser()
    
    var transportImg =                [#imageLiteral(resourceName: "imgWalking"),#imageLiteral(resourceName: "imgBike"),#imageLiteral(resourceName: "imgE-scooter"),#imageLiteral(resourceName: "imgMoped"),#imageLiteral(resourceName: "imgMotorcycle"),#imageLiteral(resourceName: "imgCar"),#imageLiteral(resourceName: "imgPickup"),#imageLiteral(resourceName: "imgVan"),#imageLiteral(resourceName: "imgTruck") ,#imageLiteral(resourceName: "imgTowTruck")]
    var transportSize  : [CGFloat] =  [30,45,32,45,45,55,55,55,50,50]
    var skillVehicleTypes = ["Walker","Bicycle","E-Scooter","Moped","Motorcycle","Car","Pickup","Van","Truck","Tow Truck"]

    var transportDescArr =  [
        "Best for nearby services during rush hour.",
        "Best for services under 2 miles away.",
        "Best for light weight items on trips under five miles.",
        "Best for medium sized-light weight items on trips under a five miles.",
        "Best for services during rush hour.",
        "Best for services where lots of equipment is needed.",
        "Best for large items that can easily fit in bed usually\n4 x 6 feet (If you do not select two Courials,\nyou agree to help move this item)",
        "Best for large items that fit in a van usually\n5 x 8 feet requiring two Courials.",
        "Best for several large items requiring two Courials.",
        "Use this option only for towing services."
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.field.delegate = self
        self.field.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .editingChanged)
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.tableViewSDaddToQueue.reloadData()
        self.deliveryAdd.setTitle(DeliveryAddressInterface.shared.selectedAddress.address ?? "", for: .normal)
        
        self.lblDelivery.text = "MEETING WITH " + (isLoggedIn() ? (userInfo.firstName ?? "").uppercased() : "YOU")
        self.lblDelivery.textColor = appColor
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.collectionView.contentSize.width > (self.view.frame.size.width - 50){
            self.collectionWidth.constant = (self.view.frame.size.width - 50)
        }else{
            self.collectionWidth.constant = self.collectionView.contentSize.width
        }

        self.timeView.addShadowsRadius(shadowRadius: 1.5)
        self.offerView.addShadowsRadius(shadowRadius: 1.5)
        self.textViewBg.addShadowsRadius(shadowRadius: 1.5)
        self.specialLinkView.addShadowsRadius(shadowRadius: 1.5)
        self.textViewBg.layer.borderColor = appColor.cgColor
        self.textViewBg.layer.borderWidth = 1
        
        self.specialLinkView.layer.borderColor = appColor.cgColor
        self.specialLinkView.layer.borderWidth = 1
    }
    
    func configSubTotal(_ type: String){
        switch type{
        case "PRE-PAID":
            self.prepaidBtn.isHidden = false
            self.courailPayBtn.isHidden = true
            self.courialFieldView.isHidden = true
        case "COURIAL PAYS":
            self.prepaidBtn.isHidden = true
            self.courailPayBtn.isHidden = false
            self.courialFieldView.isHidden = false
        default:
            self.prepaidBtn.isHidden = false
            self.courailPayBtn.isHidden = false
            self.courialFieldView.isHidden = true
            self.businessDetail?.courialFee = ""
        }
        
        self.getDeliveryFee()
    }
    
    //MARK:- BUTTONS ACTIONS
    @IBAction func backBtnAction(_ sender: Any) {
        deleteOrderFlag = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func prepaidBtn(_ sender: UIButton){
        guard self.businessDetail?.subTotalType != "PRE-PAID" else{
            self.businessDetail?.subTotalType = ""
            self.configSubTotal("")
            return
        }
        self.businessDetail?.subTotalType = "PRE-PAID"
        self.configSubTotal("PRE-PAID")
    }
    
    @IBAction func courialBtn(_ sender: UIButton) {
        guard self.businessDetail?.subTotalType != "COURIAL PAYS" else{
            self.businessDetail?.subTotalType = ""
            self.configSubTotal("")
            return
        }
        
        self.businessDetail?.subTotalType = "COURIAL PAYS"
        self.configSubTotal("COURIAL PAYS")
    }
    
    @IBAction func ReviewOrderDetailBtn(_ sender: Any) {
        guard (self.businessDetail?.pickUpTime ?? "Choose") != "Choose" else{
            self.choosePickLbl.alpha = 0.2
            self.choosePickLbl.textColor = .red
            
            UIView.animate(withDuration: 1, animations: {
                self.choosePickLbl.alpha = 1
            }) { (_) in
                self.choosePickLbl.textColor = appColorBlue
            }
            return
        }
        
        let pickupDate = (self.businessDetail?.pickUpTime ?? "").convertStampToDate(.current) ?? Date()
        guard pickupDate > Date() else{
            showSwiftyAlert("", "Unfortunately, the meeting time has already passed. Please select new meeting time. Thanks!", false)
            return
        }
        
        let specialURL = URL(string: self.specialLinkTF.text ?? "")
        
        if ((self.specialLinkTF.text ?? "") != "") && specialURL != nil
                && UIApplication.shared.canOpenURL(specialURL!) == false{
            showSwiftyAlert("", "Please enter a valid special instructions link", false)
        }else if self.businessDetail?.subTotalType == ""{
            self.prepaidBtn.backgroundColor = .red
            self.prepaidBtn.alpha = 0.2
            
            self.courailPayBtn.backgroundColor = .red
            self.courailPayBtn.alpha = 0.2
            
            self.itemCostLbl.textColor = .red
            self.itemCostLbl.alpha = 0.2
            
            UIView.animate(withDuration: 1, animations: {
                self.prepaidBtn.alpha = 1
                self.courailPayBtn.alpha = 1
                self.itemCostLbl.alpha = 1
            }) { (_) in
                self.prepaidBtn.backgroundColor = appColorBlue
                self.courailPayBtn.backgroundColor = appColor
                self.itemCostLbl.textColor = appColorBlue
            }
        }else if self.businessDetail?.subTotalType == "COURIAL PAYS" && JSON(self.businessDetail?.courialFee ?? "").doubleValue < 1 {
            showSwiftyAlert("", "Courial Pay amount must be greater than $1", false)
            self.courailPayBtn.backgroundColor = .red
            self.courailPayBtn.alpha = 0.2
            
            self.itemCostLbl.textColor = .red
            self.itemCostLbl.alpha = 0.2
            
            UIView.animate(withDuration: 1, animations: {
                self.courailPayBtn.alpha = 1
                self.itemCostLbl.alpha = 1
            }) { (_) in
                self.courailPayBtn.backgroundColor = appColor
                self.itemCostLbl.textColor = appColorBlue
            }
        }else{
            let catName = (self.businessDetail?.category ?? "").uppercased()
            self.businessDetail?.name = catName
            self.businessDetail?.itemDescription = catName
            self.businessDetail?.additionalNotes = self.itemNotesTV.text
            self.businessDetail?.dropAddress?.notes = self.itemNotesTV.text
            self.businessDetail?.isSkillService = true
            self.businessDetail?.estimatedServiceTime = "\(JSON(self.timeSlider.selectedMaxValue).intValue)"
            self.businessDetail?.estimatedServiceOffer = "\(JSON(self.offerSlider.selectedMaxValue).intValue).00"
            self.businessDetail?.specialLink = self.specialLinkTF.text
            
            if self.businessDetail?.orderID != nil{
                self.goToQueue()
            } else{
                self.generateOrderID()
            }
        }
    }
    
    @IBAction func tittleAction(_ sender: Any) {
        changingDeliveryAdd = true
        deleteOrderFlag = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetAddressVC") as! SetAddressVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func pickUpTimeBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        let DTvc = storyboard?.instantiateViewController(withIdentifier: "DateAndTimeVC") as! DateAndTimeVC
        DTvc.stringKey = "4"
        DTvc.businessDetail = self.businessDetail
        DTvc.completion = { model in
            self.businessDetail = model
            self.choosePickLbl.text = self.checkDate(self.businessDetail?.pickUpTime ?? "")
        }
        DTvc.modalPresentationStyle = .overCurrentContext
        self.view.addSubview(DTvc.view)
        self.addChild(DTvc)
    }
    
    @IBAction func infoBtn(_ sender: UIButton) {
        self.getPricingApi()
    }
    
    
    func checkDate(_ stamp: String)-> String{
        guard let date = stamp.convertToDate() else{
            return "Select Time"
        }
        
        if Calendar.current.isDateInToday(date){
            return date.convertToFormat("'Today, 'MMM dd, hh:mm a", timeZone: .current)
        } else if Calendar.current.isDateInTomorrow(date){
            return date.convertToFormat("'Tomorrow, 'MMM dd, hh:mm a", timeZone: .current)
        } else{
            return date.convertToFormat("EEE, MMM dd, hh:mm a", timeZone: .current)
        }
    }
    
    func setupUI(){
        self.courialFieldView.isHidden = true
        self.headerTittleLbl.text = (self.businessDetail?.category ?? "").uppercased() + " SERVICE"
        
        switch (self.businessDetail?.category ?? "").lowercased(){
        case "fixer":
            self.headerSubTitleLbl.isHidden = false
            self.headerSubTitleLbl.text = "Handyperson, skilled in multiple home repairs"
        case "gas & battery":
            self.headerSubTitleLbl.isHidden = false
            self.headerSubTitleLbl.text = "A gallon of gas or Jump a dead battery"
        default:
            self.headerSubTitleLbl.isHidden = true
        }
        
        switch (self.businessDetail?.category ?? "").lowercased(){
        case "towing":
            self.transportStack.isHidden = true
            self.towTruckIcon.isHidden = false
            
            self.transportImg =  [#imageLiteral(resourceName: "imgTowTruck")]
            self.transportSize =  [50]
            self.skillVehicleTypes = ["Tow Truck"]

            self.transportDescArr =  ["Use this option only for towing services."]
            
            self.businessDetail?.vehicleTypeIndex = 0
            self.selectedTransport.image = transportImg[0]
            self.transportDesc.text = transportDescArr[0]

        default:
            self.transportStack.isHidden = false
            self.towTruckIcon.isHidden = true
            
            self.transportImg =   [#imageLiteral(resourceName: "imgWalking"),#imageLiteral(resourceName: "imgBike"),#imageLiteral(resourceName: "imgE-scooter"),#imageLiteral(resourceName: "imgMoped"),#imageLiteral(resourceName: "imgMotorcycle"),#imageLiteral(resourceName: "imgCar"),#imageLiteral(resourceName: "imgPickup"),#imageLiteral(resourceName: "imgVan"),#imageLiteral(resourceName: "imgTruck") ,#imageLiteral(resourceName: "imgTowTruck")]
            self.transportSize =  [30,45,32,45,45,55,55,55,50,50]
            self.skillVehicleTypes = ["Walker","Bicycle","E-Scooter","Moped","Motorcycle","Car","Pickup","Van","Truck","Tow Truck"]
            self.transportDescArr =  [
                "Best for nearby services during rush hour.",
                "Best for services under 2 miles away.",
                "Best for light weight items on trips under five miles.",
                "Best for medium sized-light weight items on trips under a five miles.",
                "Best for services during rush hour.",
                "Best for services where lots of equipment is needed.",
                "Best for large items that can easily fit in bed usually\n4 x 6 feet (If you do not select two Courials,\nyou agree to help move this item)",
                "Best for large items that fit in a van usually\n5 x 8 feet requiring two Courials.",
                "Best for several large items requiring two Courials.",
                "Use this option only for towing services."
            ]
            
            self.businessDetail?.vehicleTypeIndex = 0
            self.selectedTransport.image = transportImg[0]
            self.transportDesc.text = transportDescArr[0]
            
            self.collectionView.reloadData()
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: IndexPath.init(item: 5, section: 0), at: .centeredHorizontally, animated: false)
            }
            self.collectionView(self.collectionView, didSelectItemAt: IndexPath.init(item: 5, section: 0))
        }
        
        self.timeSlider.selectedHandleDiameterMultiplier = 1.0
        self.offerSlider.selectedHandleDiameterMultiplier = 1.0
                
        switch self.businessDetail?.category?.lowercased(){
        case "notary":
            self.timeSlider.selectedMaxValue = 10
            self.offerSlider.selectedMaxValue = 50
            
        case "barber":
            self.timeSlider.selectedMaxValue = 20
            self.offerSlider.selectedMaxValue = 25
            
        case "fixer / handyperson":
            self.timeSlider.selectedMaxValue = 30
            self.offerSlider.selectedMaxValue = 30
            
        case "photographer":
            self.timeSlider.selectedMaxValue = 60
            self.offerSlider.selectedMaxValue = 100
            
        case "personal assistant","multiple deliveries":
            self.timeSlider.selectedMaxValue = 60
            self.offerSlider.selectedMaxValue = 25
            
        case "locksmith":
            self.timeSlider.selectedMaxValue = 20
            self.offerSlider.selectedMaxValue = 50
            
        case "towing":
            self.timeSlider.selectedMaxValue = 60
            self.offerSlider.selectedMaxValue = 75
            
        case "manicurist":
            self.timeSlider.selectedMaxValue = 30
            self.offerSlider.selectedMaxValue = 30
            
        case "gas / battery / flat":
            self.timeSlider.selectedMaxValue = 20
            self.offerSlider.selectedMaxValue = 20
            
        default:
            self.timeSlider.selectedMaxValue = 10
            self.offerSlider.selectedMaxValue = 10
        }
        
        self.avgTimeLbl.text = "\(Int(self.timeSlider.selectedMaxValue))"
        self.avgOfferLbl.text = "$\(Int(self.offerSlider.selectedMaxValue))"
        
        self.timeSlider.selectedMaxValue = 10
        self.offerSlider.selectedMaxValue = 10
        
        self.rangeSeekSlider(self.timeSlider, didChange: self.timeSlider.minValue, maxValue: self.timeSlider.maxValue)
        self.rangeSeekSlider(self.offerSlider, didChange: self.timeSlider.minValue, maxValue: self.timeSlider.maxValue)
        
        
        let devWidth = ((self.avgTimeView.frame.width - 5) / 50)
        self.avgTimeViewLead.constant = ((self.timeSlider.selectedMaxValue - 10)  * (devWidth)) - 5
        
        self.timeSliderLbl.text = "\(Int(self.timeSlider.selectedMaxValue)) min"
        self.offerSliderLbl.text =  "$\(Int(self.offerSlider.selectedMaxValue))"
        
        self.timeSlider.delegate = self
        self.offerSlider.delegate = self
        
        self.getDeliveryFee()
    }
    
}


extension SpecialSkillOrderVC: UIPopoverPresentationControllerDelegate, RangeSeekSliderDelegate{
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        guard slider != self.timeSlider else {
            self.timeSliderLbl.text = "\(Int(self.timeSlider.selectedMaxValue)) min"
                        
            let devWidth = ((self.avgTimeView.frame.width - 5) / 50)
            self.avgTimeViewLead.constant = ((self.timeSlider.selectedMaxValue - 10)  * (devWidth)) - 5
            
            return
        }
        
        self.offerSliderLbl.text = "$\(Int(self.offerSlider.selectedMaxValue))"
        
        let devWidth = ((self.avgOfferView.frame.width - 5) / 190)
        self.avgOfferViewLead.constant = ((self.offerSlider.selectedMaxValue - 10)  * (devWidth)) - 5
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        guard slider != self.timeSlider else {
            return
        }
        
        self.offerSliderLbl.text =  "$\(Int(self.offerSlider.selectedMaxValue))"
        self.getDeliveryFee()
    }
}


extension SpecialSkillOrderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard collectionView == self.collectionImages else{
            return transportImg.count
        }
        
        let attachedCount = (self.businessDetail?.attachedPhoto.count ?? 0)
        switch attachedCount {
        case 0:
            return 1
        case 3:
            return 3
        default:
            return attachedCount + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard collectionView == self.collectionImages else{
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThirdCell", for: indexPath) as! SpecialDeliveryCVC
            
            cell.TypeImgView.image = transportImg[indexPath.item].withRenderingMode(.alwaysOriginal)
            
            if self.businessDetail?.vehicleTypeIndex == indexPath.item{
                cell.TypeImgView.alpha = 1
            }else{
                cell.TypeImgView.alpha = 0.3
            }
            
            switch indexPath.row{
            case 0:
                cell.centerConstraint.constant = 0.2
            case 1:
                cell.centerConstraint.constant = 1
            case 2:
                cell.centerConstraint.constant = 0.9
            case 3:
                cell.centerConstraint.constant = 2.7
            case 4:
                cell.centerConstraint.constant = 2.5
            default:
                cell.centerConstraint.constant = 5
            }
            
            return cell
        }
        
        let attachedCount = (self.businessDetail?.attachedPhoto.count ?? 0)
        if attachedCount == 0{
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as! AddImagesCVC
            cell.title.text = "Attach Photos"
            
            return cell
        } else if indexPath.item == attachedCount{
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreCell", for: indexPath) as! AddImagesCVC
            return cell
        } else{
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImagesCVC", for: indexPath) as! AddImagesCVC
            cell.attachedImage.image = self.businessDetail?.attachedPhoto[indexPath.item]
            cell.title.text = "VIEW IMAGE"
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard collectionView == self.collectionImages else{
            return .init(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard collectionView == self.collectionImages else{
            return 0
        }
        let attachedCount = (self.businessDetail?.attachedPhoto.count ?? 0)
        if attachedCount == 3{
            return 5
        } else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard collectionView == self.collectionImages else{
            return 30
        }
        
        let attachedCount = (self.businessDetail?.attachedPhoto.count ?? 0)
        if attachedCount != 0{
            return 5
        } else{
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard collectionView == self.collectionImages else{
            let width = self.transportSize[indexPath.item]
            return CGSize(width: width , height: 45)
        }
        
        let attachedCount = (self.businessDetail?.attachedPhoto.count ?? 0)
        
        if attachedCount == 0{
            return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
        } else if indexPath.item == attachedCount{
            return CGSize(width: collectionView.frame.width * 0.2 , height: collectionView.frame.height)
        }else if attachedCount == 3{
            let width = (collectionView.frame.width - 10) / CGFloat(attachedCount)
            return CGSize(width: width , height: collectionView.frame.height)
        } else{
            var width = (collectionView.frame.width - 15 - (collectionView.frame.width * 0.2))
            width = width / CGFloat(attachedCount)
            return CGSize(width: width , height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == self.collectionImages else{
            guard (self.businessDetail?.category ?? "").lowercased() != "towing" else{
                return
            }
            self.businessDetail?.vehicleTypeIndex = indexPath.item
            self.selectedTransport.image = transportImg[indexPath.item]
            self.transportDesc.text = transportDescArr[indexPath.item]
            collectionView.reloadData()
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            return
        }
        
        let attachedCount = (self.businessDetail?.attachedPhoto.count ?? 0)
        if attachedCount == 0 || indexPath.item == attachedCount{
            let vc = storyboard?.instantiateViewController(withIdentifier: "OpenCameraAlertVC") as! OpenCameraAlertVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self
            self.view.addSubview(vc.view)
            self.addChild(vc)
        } else{
            let imagePop = ImagePopup.init(frame: screenFrame()) { (result) in
                if result == "1"{
                    self.businessDetail?.attachedPhoto.remove(at: indexPath.item)
                    collectionView.reloadData()
                } else{
                    guard let img = self.businessDetail?.attachedPhoto[indexPath.item] else {return}
                    let photo = SKPhoto.photoWithImage(img)
                    self.photoBrowser = SKPhotoBrowser(photos: [photo])
                    super.present(self.photoBrowser, animated: true, completion: nil)
                }
            }
            rootVC?.view.addSubview(imagePop)
        }
    }
    
}


extension SpecialSkillOrderVC: CameraAlertDelegate{
    
    func imageSelected(_ img: UIImage) {
        img.accessibilityHint = "image"
        if self.businessDetail?.attachedPhoto == nil{
            self.businessDetail?.attachedPhoto = [img]
        } else{
            self.businessDetail?.attachedPhoto.append(img)
        }
        self.collectionImages.reloadData()
    }
    
}

extension SpecialSkillOrderVC {
    
    //MARK: API
    
    func getPricingApi(){
        let params : Parameters = [
            "isSkill" : "1"
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.pricing_info, method: .get, encoding: URLEncoding.httpBody , success: { (json) in
            hideLoader()
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubtotalExplainedVC") as! SubtotalExplainedVC
            
            vc.pricingHeader = json["data"]["pricing_info"].arrayValue.map({$0["title"].stringValue})
            vc.pricingText = json["data"]["pricing_info"].arrayValue.map({$0["value"].stringValue})
            vc.isSkill = true
            vc.modalPresentationStyle = .overCurrentContext
            self.view.addSubview(vc.view)
            self.addChild(vc)
            
        }) { (error, json) in
            hideLoader()
        }
    }
    
    func getDeliveryFee(){
        let params : Parameters = [
            "category": self.businessDetail?.category ?? "",
            "dropOfOption": DeliveryAddressInterface.shared.selectedAddress.dropPickupoptions ?? "",
            "drop_floor": DeliveryAddressInterface.shared.selectedAddress.elevatorFloor ?? "0",
            "drop_elevator_walk_both": DeliveryAddressInterface.shared.selectedAddress.elevator_walk_both ?? "0",
            "estimatedServiceOffer": "\(Int(self.offerSlider.selectedMaxValue))"
        ]
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.special_calculation_fee , success: { (json) in
            hideLoader()
            
            self.businessDetail?.baseFee = String(format: "%.02f", json["data"]["basefee"].doubleValue)
            self.businessDetail?.stairsElevatorFee = String(format: "%.02f", json["data"]["stareFee"].doubleValue)
            self.businessDetail?.deliveryFee = String(format: "%.02f", json["data"]["serviceFee"].doubleValue)
            
            self.deliveryFee.text = "$" + (self.businessDetail?.deliveryFee ?? "")
        }) { (error, json) in
            hideLoader()
            self.deliveryFee.text = "--"
        }
    }
    
    func addressChanged(){
        self.viewWillAppear(true)
        self.getDeliveryFee()
    }
    
    
    func generateOrderID(){
        let params : Parameters = [
            "category": self.businessDetail?.category ?? "",
            "isSkill" : "1"
            
        ]
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.generate_order_id , success: { (json) in
            hideLoader()
            self.businessDetail?.orderID = json["data"]["orderid"].stringValue
            self.goToQueue()
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    func goToQueue(){
        let dropAdd = DeliveryAddressInterface.shared.selectedAddress
        self.businessDetail?.dropAddress = dropAdd
        
        let popup = ViewArea.init(frame: screenFrame()) { (result) in
            switch result{
            case 1: // MapView
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NearbyCourialsVC")as! NearbyCourialsVC
                vc.type = 0
                vc.businessDetail = self.businessDetail
                vc.transportIcon = self.skillVehicleTypes[self.businessDetail?.vehicleTypeIndex ?? 0]
                self.navigationController?.pushViewController(vc, animated: true)
                
            default: // Skip
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "QueueDeliveryDetailVC") as! QueueDeliveryDetailVC
                vc.businessDetail = self.businessDetail
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.view.addSubview(popup)
    }
    
}

extension SpecialSkillOrderVC: UITextFieldDelegate{
    @objc func textFieldChanged(_ sender: UITextField){
        self.businessDetail?.courialFee = sender.text!
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if JSON(textField.text!).doubleValue > 200 {
            textField.text = "200.00"
            textField.placeholder = "0000.00"
            showSwiftyAlert("", "Enter an amount between $1.00 and $200.00", false)
        } else if textField.text?.isEmpty == true{
            textField.text = ""
            textField.placeholder = "0000.00"
        } else{
            textField.text = String(format: "%.02f", JSON(textField.text!).doubleValue)
            textField.placeholder = "00"
        }
        self.businessDetail?.courialFee = textField.text
        self.getDeliveryFee()
    }
    
}
