//
//  SpecialDeliveryAddToQueueVC.swift
//  Courail
//
//  Created by mac on 05/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SKPhotoBrowser

class SpecialDeliveryCVC: UICollectionViewCell {
    //MARK: OUTLETS
    @IBOutlet weak var TypeImgView: UIImageView!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var Aspect: NSLayoutConstraint!
    
}

class AddImagesCVC: UICollectionViewCell {
    //MARK: OUTLETS
    @IBOutlet weak var attachedImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
}


class SpecialDeliveryAddToQueueVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pickingUpFromLbl: UILabel!
    @IBOutlet weak var headerTittleLbl: UILabel!
    @IBOutlet weak var deliveryAdd: UIButton!
    @IBOutlet weak var deliveryFee: UILabel!
    @IBOutlet weak var lblDelivery: UILabel!
    
    @IBOutlet weak var reviewBtnBgView: UIView!
    @IBOutlet weak var reviewBtnOut: UIButtonCustomClass!
    
    @IBOutlet weak var pickUpArrow: UIImageView!
    
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address2: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionWidth: NSLayoutConstraint!
    @IBOutlet weak var itemNameView: UIView!
    @IBOutlet weak var itemNameTF: UITextField!
    @IBOutlet weak var itemNotesTV: IQTextView!
    @IBOutlet weak var itemNotesTVHeight: NSLayoutConstraint!
    
    @IBOutlet weak var itemCostLbl: UILabel!
    
    @IBOutlet weak var idReqView: UIView!
    @IBOutlet weak var idReqYesIcon: UIImageView!
    @IBOutlet weak var idReqNoIcon: UIImageView!
    @IBOutlet weak var idReqItemsView: UIView!
    
    @IBOutlet weak var idReqInfoLbl: UILabel!
    
    @IBOutlet weak var spiritsLbl: UILabel!
    @IBOutlet weak var spiritsIcon: UIImageView!
    
    @IBOutlet weak var cannabisLbl: UILabel!
    @IBOutlet weak var cannabisIcon: UIImageView!
    
    @IBOutlet weak var prescriptionLbl: UILabel!
    @IBOutlet weak var prescriptionIcon: UIImageView!
    
    @IBOutlet weak var tobaccoLbl: UILabel!
    @IBOutlet weak var tobaccoIcon: UIImageView!
    
    @IBOutlet weak var businessDistance: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    @IBOutlet weak var prepaidBtn: UIButton!
    @IBOutlet weak var courailPayBtn: UIButton!
    @IBOutlet weak var courialFieldView: UIViewCustomClass!
    @IBOutlet weak var field: UITextField!
    
    @IBOutlet weak var over45Icon: UIButton!
    @IBOutlet weak var over45View: UIView!
    
    @IBOutlet weak var twoCoruialIcon: UIButton!
    @IBOutlet weak var twoCourialView: UIView!
    
    @IBOutlet weak var selectedTransport: UIImageView!
    @IBOutlet weak var transportDesc: UILabel!
    
    @IBOutlet weak var choosePickLbl: UILabel!
    
    @IBOutlet weak var weightView: UIView!
    
    @IBOutlet weak var collectionImages: UICollectionView!
    
    @IBOutlet weak var specialLinkView: UIViewCustomClass!
    @IBOutlet weak var specialLinkTF: UITextField!
    
    //MARK:- VARIABLES
    
    var businessDetail : YelpStoreBusinesses?
    
    var photoBrowser = SKPhotoBrowser()
    
    var transportImg =                [#imageLiteral(resourceName: "imgWalking"),#imageLiteral(resourceName: "imgBike"),#imageLiteral(resourceName: "imgE-scooter"),#imageLiteral(resourceName: "imgMoped"),#imageLiteral(resourceName: "imgMotorcycle"),#imageLiteral(resourceName: "imgCar"),#imageLiteral(resourceName: "imgPickup"),#imageLiteral(resourceName: "imgVan"),#imageLiteral(resourceName: "imgTruck") ]
    var transportSize  : [CGFloat] =  [35,50,40,50,50,65,65,60,55]
    let vehicleTypes = ["Walker","Bicycle","E-Scooter","Moped","Motorcycle","Car","Pickup","Van","Truck"]
    
    var canChangeAddress = false
    
    var transportDescArr =  [
        "Ideal for light weight items on trips under 1 mile\nBest for rush hour.",
        "Ideal for light weight items on trips under five miles.",
        "Ideal for light weight items on trips under five miles.",
        "Ideal for medium sized-light weight items on trips under a five miles.",
        "Ideal for medium sized items.",
        "Ideal for anything that can easily fit in a sedan.",
        "Ideal for large items that can easily fit in bed usually\n4 x 6 feet (If you do not select two Courials,\nyou agree to help move this item)",
        "Ideal for large items that fit in a van usually\n5 x 8 feet requiring two Courials.",
        "Ideal for several large items requiring two Courials."
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.field.delegate = self
        self.field.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .editingChanged)
        if (self.businessDetail?.category?.lowercased() == "special") || (self.businessDetail?.isWebStore == true){
            self.canChangeAddress = true
            self.pickUpArrow.isHidden = false
        } else{
            self.canChangeAddress = false
            self.pickUpArrow.isHidden = true
        }
        
        self.loadData(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.tableViewSDaddToQueue.reloadData()
        self.deliveryAdd.setTitle(DeliveryAddressInterface.shared.selectedAddress.address ?? "", for: .normal)
        if self.businessDetail?.isReversedDel == true{
            self.lblDelivery.text = "PICKING UP FROM " + (isLoggedIn() ? (userInfo.firstName ?? "").uppercased() : "YOU")
            self.lblDelivery.textColor = appColorBlue
            self.pickingUpFromLbl.text = "DELIVERING TO"
        } else{
            self.lblDelivery.text = "DELIVERING TO " + (isLoggedIn() ? (userInfo.firstName ?? "").uppercased() : "YOU")
            self.lblDelivery.textColor = appColor
            self.pickingUpFromLbl.text = "PICKING UP FROM"
        }
        
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
    }

    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func backBtnAction(_ sender: Any) {
        deleteOrderFlag = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ReviewOrderDetailBtn(_ sender: Any) {
        self.view.endEditing(true)
        self.businessDetail?.itemDescription = self.itemNameTF.text
        self.businessDetail?.additionalNotes = self.itemNotesTV.text.replacingOccurrences(of: "Drive thru pickup: ", with: "")
        self.businessDetail?.specialLink = self.specialLinkTF.text
        
        let pickupDate = (self.businessDetail?.pickUpTime ?? "").convertStampToDate(.current) ?? Date()
//        let diffFromPickUpDate = Date().minutesBetweenDate(toDate: pickupDate)
        
        if (self.businessDetail?.pickUpTime ?? "Choose") == "Choose"{
            self.choosePickLbl.alpha = 0.2
            self.choosePickLbl.textColor = .red
            
            UIView.animate(withDuration: 1, animations: {
                self.choosePickLbl.alpha = 1
            }) { (_) in
                self.choosePickLbl.textColor = appColorBlue
            }
        }else if pickupDate < Date(){
            showSwiftyAlert("", "Unfortunately, the pickup time has already passed. Please select new pickup time. Thanks!", false)
        }else if (self.businessDetail?.itemDescription ?? "") == ""{
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
            
            let borderColor = self.itemNameView.layer.borderColor
            self.itemNameView.alpha = 0.2
            self.itemNameView.layer.borderColor = UIColor.red.cgColor
            
            UIView.animate(withDuration: 1, animations: {
                self.itemNameView.alpha = 1
            }) { (_) in
                self.itemNameView.layer.borderColor = borderColor
            }
            
        }else if self.businessDetail?.isWebStore == false && (self.businessDetail?.idReqYesNoSelected == false){
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
            
            self.idReqInfoLbl.alpha = 0.2
            self.idReqInfoLbl.textColor = .red
            
            UIView.animate(withDuration: 1, animations: {
                self.idReqInfoLbl.alpha = 1
            }) { (_) in
                self.idReqInfoLbl.textColor = appColorBlue
            }
        }else if self.businessDetail?.isWebStore == true &&  self.businessDetail?.showIDWarning == true && (self.businessDetail?.idReqYesNoSelected == false){
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
            
            self.idReqInfoLbl.alpha = 0.2
            self.idReqInfoLbl.textColor = .red
            
            UIView.animate(withDuration: 1, animations: {
                self.idReqInfoLbl.alpha = 1
            }) { (_) in
                self.idReqInfoLbl.textColor = appColorBlue
            }
        }else if self.idReqItemsView.isHidden == false && (self.businessDetail?.itemCategorySelected == false){
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
            
            self.prescriptionLbl.alpha = 0.2
            self.prescriptionLbl.textColor = .red
            
            self.spiritsLbl.alpha = 0.2
            self.spiritsLbl.textColor = .red
            
            self.tobaccoLbl.alpha = 0.2
            self.tobaccoLbl.textColor = .red
            
            self.cannabisLbl.alpha = 0.2
            self.cannabisLbl.textColor = .red
            
            UIView.animate(withDuration: 1, animations: {
                self.prescriptionLbl.alpha = 1
                self.spiritsLbl.alpha = 1
                self.tobaccoLbl.alpha = 1
                self.cannabisLbl.alpha = 1
            }) { (_) in
                self.prescriptionLbl.textColor = appColorBlue
                self.spiritsLbl.textColor = appColorBlue
                self.tobaccoLbl.textColor = appColorBlue
                self.cannabisLbl.textColor = appColorBlue
            }
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
        }else if let specialURL = URL(string: self.businessDetail?.specialLink ?? ""),  UIApplication.shared.canOpenURL(specialURL) == false{
            showSwiftyAlert("", "Please enter a valid special instructions link", false)
        }else{
            let itemnameStr = self.itemNameTF.text!.components(separatedBy: " ")
            var count = 0
            var keywordIndex = 0
            for item in itemnameStr{
                if let ind = restrictedKeywords.firstIndex(where: {$0.lowercased() == item.lowercased()}){
                    keywordIndex = ind
                    count += 1
                }
            }
            
            if count != 0  && self.businessDetail?.category?.lowercased() == "special"{
                if isLoggedIn(){
                    self.bannedKeywordsApi(restrictedKeywords[keywordIndex])
                    let name = userInfo.firstName ?? ""
                    showSwiftyAlert("", "\(name), it appears you are searching for cannabis products. Unfortunately for legal reasons we can not offer delivery of cannabis products in this area. If this is an error, please contact us at support@courial.com for further assistance. Thanks!", false, 6)
                }else{
                    showSwiftyAlert("", "It appears you are searching for cannabis products. Unfortunately for legal reasons we can not offer delivery of cannabis products in this area. If this is an error, please contact us at support@courial.com for further assistance. Thanks!", false, 6)
                }
            }else{
                switch self.businessDetail?.itemCategory?.lowercased() {
                case "cannabis","wine","alcohol","pharmacy","cigar","cigarette","cigarettes","tobacco":
                    let agreement = AgreementView(frame: screenFrame(), category: self.businessDetail?.itemCategory ?? "") {
                        self.businessDetail?.identificationImageURL = userInfo.Identification_image
                        if self.businessDetail?.orderID != nil{
                            self.goToQueue()
                        } else{
                            self.generateOrderID()
                        }
                    }
                    self.view.addSubview(agreement)
                default:
                    if self.businessDetail?.orderID != nil{
                        self.goToQueue()
                    } else{
                        self.generateOrderID()
                    }
                }
            }
        }
    }
    
    @IBAction func tittleAction(_ sender: Any) {
        guard self.canChangeAddress else{
            deleteOrder { (_) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetAddressVC") as! SetAddressVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        deleteOrderFlag = true
        
        if self.businessDetail?.isReversedDel == true{
            deleteOrder { (_) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetAddressVC") as! SetAddressVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else{
            changingDeliveryAdd = true
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetAddressVC") as! SetAddressVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func pickUpAddressBtn(_ sender: UIButton) {
        guard self.canChangeAddress else{
            return
        }
        deleteOrderFlag = true
        changingDeliveryAdd = false
        
        if self.businessDetail?.isReversedDel == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetAddressVC") as! SetAddressVC
            vc.isReversedDel = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SpecialDeliveryVC") as! SpecialDeliveryVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func pickUpTimeBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        let DTvc = storyboard?.instantiateViewController(withIdentifier: "DateAndTimeVC") as! DateAndTimeVC
        DTvc.stringKey = "4"
        DTvc.businessDetail = self.businessDetail
        DTvc.completion = { model in
            self.businessDetail = model
            self.choosePickLbl.text = self.checkDate(self.businessDetail?.pickUpTime ?? "")
            
//            let pickupDate = (self.businessDetail?.pickUpTime ?? "").convertStampToDate(.current) ?? Date()
//            let diffFromPickUpDate = Date().minutesBetweenDate(toDate: pickupDate)
//            if abs(diffFromPickUpDate) > 480{
//                showSwiftyAlert("", "Unfortunately, you can only book same day orders up to 8 Hours out. Please save this order and try booking later when you are within 8 Hours of the pickup time. Thanks!", false, 11)
//                self.reviewBtnBgView.backgroundColor = UIColor.init(red: 222/255, green: 222/255, blue: 222/255, alpha: 1.0)
//            }else{
//                self.reviewBtnBgView.backgroundColor = appColor
//            }
            
        }
        DTvc.modalPresentationStyle = .overCurrentContext
        self.view.addSubview(DTvc.view)
        self.addChild(DTvc)
    }
    
    
    @IBAction func infoBtn(_ sender: UIButton) {
        self.getPricingApi()
    }
    
    @IBAction func idItemsYesBtn(_ sender: UIButton) {
        self.idReqView.isHidden = true
        self.idReqItemsView.isHidden = false
        self.businessDetail?.idReqYesNoSelected = true
    }
    
    @IBAction func idItemsNoBtn(_ sender: UIButton) {
        self.idReqView.isHidden = true
        self.itemNotesTVHeight.constant = 55
        self.businessDetail?.idReqYesNoSelected = true
    }
    
    @IBAction func prescriptionBtn(_ sender: UIButton) {
        guard self.businessDetail?.itemCategory != "pharmacy" else{
            self.idReqView.isHidden = false
            self.idReqItemsView.isHidden = true
            self.businessDetail?.idReqYesNoSelected = false
            
            self.businessDetail?.itemCategorySelected = false
            self.businessDetail?.itemCategory = ""
            
            self.prescriptionIcon.image = UIImage(named: "radioBlue")
            self.spiritsIcon.image = UIImage(named: "radioBlue")
            self.tobaccoIcon.image = UIImage(named: "radioBlue")
            self.cannabisIcon.image = UIImage(named: "radioBlue")
            return
        }
        
        self.businessDetail?.itemCategorySelected = true
        self.businessDetail?.itemCategory = "pharmacy"
        self.prescriptionIcon.image = UIImage(named: "radioBlueFilled")
        self.spiritsIcon.image = UIImage(named: "radioBlue")
        self.tobaccoIcon.image = UIImage(named: "radioBlue")
        self.cannabisIcon.image = UIImage(named: "radioBlue")
        self.collectionImages.reloadData()
    }
    
    @IBAction func spiritsBtn(_ sender: UIButton) {
        guard self.businessDetail?.itemCategory != "wine" else{
            self.idReqView.isHidden = false
            self.idReqItemsView.isHidden = true
            self.businessDetail?.idReqYesNoSelected = false
            
            self.businessDetail?.itemCategorySelected = false
            self.businessDetail?.itemCategory = ""
            
            self.prescriptionIcon.image = UIImage(named: "radioBlue")
            self.spiritsIcon.image = UIImage(named: "radioBlue")
            self.tobaccoIcon.image = UIImage(named: "radioBlue")
            self.cannabisIcon.image = UIImage(named: "radioBlue")
            return
        }
        
        self.businessDetail?.itemCategorySelected = true
        self.businessDetail?.itemCategory = "wine"
        self.prescriptionIcon.image = UIImage(named: "radioBlue")
        self.spiritsIcon.image = UIImage(named: "radioBlueFilled")
        self.tobaccoIcon.image = UIImage(named: "radioBlue")
        self.cannabisIcon.image = UIImage(named: "radioBlue")
        self.collectionImages.reloadData()
    }
    
    @IBAction func tobaccoBtn(_ sender: UIButton) {
        guard self.businessDetail?.itemCategory != "tobacco" else{
            self.idReqView.isHidden = false
            self.idReqItemsView.isHidden = true
            self.businessDetail?.idReqYesNoSelected = false
            
            self.businessDetail?.itemCategorySelected = false
            self.businessDetail?.itemCategory = ""
            
            self.prescriptionIcon.image = UIImage(named: "radioBlue")
            self.spiritsIcon.image = UIImage(named: "radioBlue")
            self.tobaccoIcon.image = UIImage(named: "radioBlue")
            self.cannabisIcon.image = UIImage(named: "radioBlue")
            return
        }
        
        self.businessDetail?.itemCategorySelected = true
        self.businessDetail?.itemCategory = "tobacco"
        self.prescriptionIcon.image = UIImage(named: "radioBlue")
        self.spiritsIcon.image = UIImage(named: "radioBlue")
        self.tobaccoIcon.image = UIImage(named: "radioBlueFilled")
        self.cannabisIcon.image = UIImage(named: "radioBlue")
        self.collectionImages.reloadData()
    }
    
    @IBAction func cannabisBtn(_ sender: UIButton) {
        guard self.businessDetail?.itemCategory != "cannabis" else{
            self.idReqView.isHidden = false
            self.idReqItemsView.isHidden = true
            self.businessDetail?.idReqYesNoSelected = false
            
            self.businessDetail?.itemCategorySelected = false
            self.businessDetail?.itemCategory = ""
            
            self.prescriptionIcon.image = UIImage(named: "radioBlue")
            self.spiritsIcon.image = UIImage(named: "radioBlue")
            self.tobaccoIcon.image = UIImage(named: "radioBlue")
            self.cannabisIcon.image = UIImage(named: "radioBlue")
            return
        }
        
        self.businessDetail?.itemCategorySelected = true
        self.businessDetail?.itemCategory = "cannabis"
        self.prescriptionIcon.image = UIImage(named: "radioBlue")
        self.spiritsIcon.image = UIImage(named: "radioBlue")
        self.tobaccoIcon.image = UIImage(named: "radioBlue")
        self.cannabisIcon.image = UIImage(named: "radioBlueFilled")
        self.collectionImages.reloadData()
    }
    
    
    @IBAction func over45LbsBtn(_ sender : UIButton){
        guard !(0...4 ~= (self.businessDetail?.vehicleTypeIndex ?? 0)) else{
            return
        }
        
        if (self.businessDetail?.vehicleTypeIndex ?? 0) != 6 && (self.businessDetail?.vehicleTypeIndex ?? 0) != 7 && (self.businessDetail?.vehicleTypeIndex ?? 0) != 8{
            if self.businessDetail?.over45Lbs == true{
                self.businessDetail?.over45Lbs = false
                self.over45Icon.setImage(UIImage(named: "toggleNew"), for: .normal)
            } else{
                self.businessDetail?.over45Lbs = true
                self.over45Icon.setImage(UIImage(named: "toggle_on"), for: .normal)
            }
            if let index = self.businessDetail?.vehicleTypeIndex{
                let indexPath = IndexPath(item: index, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            
            self.collectionView.reloadData()
            self.getDeliveryFee()
        }
        
    }
    
    @IBAction func twoCourialBtn(_ sender : UIButton){
        guard 6...8 ~= (self.businessDetail?.vehicleTypeIndex ?? 0) else{
            return
        }
        
        if self.businessDetail?.two_courial == true{
            self.businessDetail?.two_courial = false
            self.twoCoruialIcon.setImage(UIImage(named: "toggleNew"), for: .normal)
        } else{
            self.businessDetail?.two_courial = true
            self.twoCoruialIcon.setImage(UIImage(named: "toggle_on"), for: .normal)
        }
        
        self.getDeliveryFee()
        
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
    
    func loadData(_ resetAll: Bool){
        if resetAll{
            self.businessDetail?.subTotalType = ""
//            let cat = self.businessDetail?.category ?? ""
            self.configSubTotal("")
            
            
            if self.businessDetail?.isWebStore == true && self.businessDetail?.showIDWarning == false{
                self.itemNotesTVHeight.constant = 55
                self.idReqView.isHidden = true
            } else{
                self.itemNotesTVHeight.constant = 30
                self.idReqView.isHidden = false
            }
            
            self.weightView.isHidden = true
            
            self.collectionView.reloadData()
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: IndexPath.init(item: 5, section: 0), at: .centeredHorizontally, animated: false)
            }
            self.collectionView(self.collectionView, didSelectItemAt: IndexPath.init(item: 5, section: 0))
        }
        
        self.headerTittleLbl.text  = (self.businessDetail?.name ?? "Business").uppercased()
        
        let address = self.businessDetail?.location
        if (address?.displayAddress?.count ?? 0) > 2{
            let line1 = self.businessDetail?.location?.displayAddress?.first ?? ""
            let line2 = self.businessDetail?.location?.displayAddress?.last ?? ""
            
            let zipCode = address?.zipCode ?? "------"
            var line2filter = line2.replacingOccurrences(of: ", \(zipCode)", with: "")
            line2filter = line2filter.replacingOccurrences(of: " \(zipCode)", with: "")
            self.address1.text = line1
            self.address2.text = line2filter
            
        } else{
            let zipCode = address?.zipCode ?? "------"
            var filterAdd = self.businessDetail?.location?.displayAddress?.joined(separator: "\n").replacingOccurrences(of: ", \(zipCode)", with: "")
            filterAdd = filterAdd?.replacingOccurrences(of: " \(zipCode)", with: "")
            if (filterAdd?.components(separatedBy: "\n").count ?? 0) > 1{
                self.address1.text = filterAdd?.components(separatedBy: "\n").first ?? ""
                self.address2.text = filterAdd?.components(separatedBy: "\n").last ?? ""
            } else{
                self.address1.text = filterAdd ?? ""
                self.address2.text = ""
            }
        }
        
        let distance = (self.businessDetail?.distance ?? "")
        let distanceMiles = JSON(distance).doubleValue * 0.000621371192
        self.businessDistance.text = String(format: "%.02f", distanceMiles) + " mi"
        
        self.duration.text = "-- mins"
        self.deliveryFee.text = "--"
        
        self.itemNameTF.text = self.businessDetail?.itemDescription ?? ""
        if self.businessDetail?.location?.pickOption == "Drive thru pickup"{
            self.itemNotesTV.text = "Drive thru pickup: " + (self.businessDetail?.additionalNotes ?? "").replacingOccurrences(of: "Drive thru pickup: ", with: "")
        }else{
            self.itemNotesTV.text = self.businessDetail?.additionalNotes ?? ""
        }
        
        if resetAll{
            DispatchQueue.main.async {
                if let index = self.businessDetail?.vehicleTypeIndex{
                    let indexPath = IndexPath(item: index, section: 0)
                    self.collectionView(self.collectionView, didSelectItemAt: indexPath)
                }
            }
        }
        
        self.getDeliveryFee()
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
    
}


extension SpecialDeliveryAddToQueueVC: UIPopoverPresentationControllerDelegate{
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


extension SpecialDeliveryAddToQueueVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard collectionView == self.collectionImages else{
            return transportImg.count
        }
        
        switch self.businessDetail?.category?.lowercased() {
        case "cannabis","wine","alcohol","pharmacy","cigar","cigarette","cigarettes","tobacco":
            return 1
        default:
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
                cell.centerConstraint.constant = 2
            case 2:
                cell.centerConstraint.constant = -0.3
            case 3:
                cell.centerConstraint.constant = 2.2
            case 4:
                cell.centerConstraint.constant = 2.8
            case 5:
                cell.centerConstraint.constant = 4.5
            case 6:
                cell.centerConstraint.constant = 3.5
            case 7:
                cell.centerConstraint.constant = 4.5
            case 8:
                cell.centerConstraint.constant = 2.5
            default:
                cell.centerConstraint.constant = 0
            }
            
            return cell
        }
        
        let attachedCount = (self.businessDetail?.attachedPhoto.count ?? 0)
        if attachedCount == 0{
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as! AddImagesCVC
            
            if self.businessDetail?.itemCategory?.lowercased() == "pharmacy"{
                cell.title.text = "Attach Copy of Prescription"
            } else{
                cell.title.text = "Attach Photos\nor Receipt"
            }
            
            return cell
        } else if indexPath.item == attachedCount{
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreCell", for: indexPath) as! AddImagesCVC
            return cell
        } else{
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImagesCVC", for: indexPath) as! AddImagesCVC
            cell.attachedImage.image = self.businessDetail?.attachedPhoto[indexPath.item]
            
            if self.businessDetail?.itemCategory?.lowercased() == "pharmacy"{
                cell.title.text = "VIEW PRESCRIPTION"
            } else{
                cell.title.text = "VIEW IMAGE"
            }
            
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
            return 25
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
            if self.businessDetail?.category?.lowercased() == "take out" && 6...8 ~= indexPath.item {
                return CGSize(width: 0 , height: 0)
            } else{
                let width = self.transportSize[indexPath.item]
//                return CGSize(width: width , height: 39)
                return CGSize(width: width , height: 50)
            }
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
            switch self.businessDetail?.category?.lowercased() {
            case "cannabis","wine","alcohol","pharmacy","cigar","cigarette","cigarettes","tobacco":
                return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
            default:
                var width = (collectionView.frame.width - 15 - (collectionView.frame.width * 0.2))
                width = width / CGFloat(attachedCount)
                return CGSize(width: width , height: collectionView.frame.height)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == self.collectionImages else{
            self.businessDetail?.vehicleTypeIndex = indexPath.item
            self.selectedTransport.image = transportImg[indexPath.item]
            self.transportDesc.text = transportDescArr[indexPath.item]
            collectionView.reloadData()
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            if  indexPath.item == 5 && ((self.businessDetail?.category ?? "") != "Take Out"){
                self.businessDetail?.two_courial = false
                self.twoCoruialIcon.setImage(UIImage(named: "toggleNew"), for: .normal)
                
                self.businessDetail?.over45Lbs = false
                self.over45Icon.setImage(UIImage(named: "toggleNew"), for: .normal)
            } else if  6...8 ~= indexPath.item && ((self.businessDetail?.category ?? "") != "Take Out"){
                self.businessDetail?.two_courial = true
                self.twoCoruialIcon.setImage(UIImage(named: "toggle_on"), for: .normal)
                
                self.businessDetail?.over45Lbs = true
                self.over45Icon.setImage(UIImage(named: "toggle_on"), for: .normal)
            } else{
                self.businessDetail?.two_courial = false
                self.twoCoruialIcon.setImage(UIImage(named: "toggleNew"), for: .normal)
                
                self.businessDetail?.over45Lbs = false
                self.over45Icon.setImage(UIImage(named: "toggleNew"), for: .normal)
            }
            
//            switch self.businessDetail?.category?.lowercased() {
//            case "take out","cannabis","spirits","wine","alcohol","pharmacy","cigar","cigarette","cigarettes","tobacco":
//                self.businessDetail?.two_courial = false
//                self.businessDetail?.over45Lbs = false
//            default:
//
//            }
            
            if indexPath.item < 5{
                self.weightView.isHidden = true
            }else{
                self.weightView.isHidden = false
            }
            
            self.getDeliveryFee()
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


extension SpecialDeliveryAddToQueueVC: CameraAlertDelegate, UITextFieldDelegate{
    func imageSelected(_ img: UIImage) {
        img.accessibilityHint = "image"
        if self.businessDetail?.attachedPhoto == nil{
            self.businessDetail?.attachedPhoto = [img]
        } else{
            self.businessDetail?.attachedPhoto.append(img)
        }
        self.collectionImages.reloadData()
    }
    
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

extension SpecialDeliveryAddToQueueVC {
    
    //MARK: API
    
    func getPricingApi(){
        let params : Parameters = [
            "isSkill" : "0"
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.pricing_info, method: .get, encoding: URLEncoding.httpBody , success: { (json) in
            hideLoader()
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubtotalExplainedVC") as! SubtotalExplainedVC
            
            vc.pricingHeader = json["data"]["pricing_info"].arrayValue.map({$0["title"].stringValue})
            vc.pricingText = json["data"]["pricing_info"].arrayValue.map({$0["value"].stringValue})
            
            vc.modalPresentationStyle = .overCurrentContext
            self.view.addSubview(vc.view)
            self.addChild(vc)
            
        }) { (error, json) in
            hideLoader()
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
    
    func getDeliveryFee(){
        let distance = (self.businessDetail?.distance ?? "")
        let distanceMiles = JSON(distance).doubleValue * 0.000621371192
        
        let durationInt = JSON(self.businessDetail?.duration ?? "0").intValue
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute]
        formatter.unitsStyle = .positional
        var formattedString = formatter.string(from: TimeInterval(durationInt)) ?? ""
        formattedString = formattedString.replacingOccurrences(of: ",", with: "")
        
        var itemCost = "0"
        if self.businessDetail?.subTotalType == "COURIAL PAYS"{
            itemCost = self.businessDetail?.courialFee ?? ""
        }
        
        let params : Parameters = [
            "category": self.businessDetail?.category ?? "",
            "weight": (self.businessDetail?.over45Lbs ?? false) ? "1" : "0",
            "two_courial" : (self.businessDetail?.two_courial ?? false) ? "1" : "0",
            "transport": vehicleTypes[self.businessDetail?.vehicleTypeIndex ?? 0],
            "distance": String(format: "%.02f", distanceMiles),
            "time": formattedString,
            "dropOfOption": DeliveryAddressInterface.shared.selectedAddress.dropPickupoptions ?? "",
            "drop_floor": DeliveryAddressInterface.shared.selectedAddress.elevatorFloor ?? "0",
            "drop_elevator_walk_both": DeliveryAddressInterface.shared.selectedAddress.elevator_walk_both ?? "0",
            "pickupOption":self.businessDetail?.location?.pickOption ?? "",
            "pick_floor": self.businessDetail?.location?.pickElevatorFloor ?? "0",
            "pick_elevator_walk_both": self.businessDetail?.location?.pick_elevator_walk_both ?? "0",
            "itemCost" : (itemCost == "") ? "0" : itemCost
        ]
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.calculation_fee , success: { (json) in
            hideLoader()
            
            let estimateTime = json["data"]["estimatetime"].intValue
            if estimateTime < 1{
                self.businessDetail?.estimatedDeliveryTime = "1"
            }else{
                self.businessDetail?.estimatedDeliveryTime = "\(estimateTime)"
            }
            
            var itemCost : Double = 0.00
            var cpFee : Double = 0.00
            if self.businessDetail?.subTotalType == "COURIAL PAYS"{
                itemCost = JSON(self.businessDetail?.courialFee ?? "0").doubleValue
                let serviceFee = JSON(self.businessDetail?.courialFee ?? "0").doubleValue * (5/100)
                cpFee = JSON(String(format: "%.02f", serviceFee)).doubleValue
            }
            self.businessDetail?.serviceFee = String(format: "%.02f", cpFee)
            
            let deliveryFee = json["data"]["deliveryfees"].doubleValue - cpFee - itemCost
            self.businessDetail?.deliveryFee = String(format: "%.02f", deliveryFee)
            
            self.businessDetail?.baseFee = String(format: "%.02f", json["data"]["basefee"].doubleValue)
            self.businessDetail?.stairsElevatorFee = String(format: "%.02f", json["data"]["stairsElevator"].doubleValue)
            self.businessDetail?.heavyFee = String(format: "%.02f", json["data"]["heavy"].doubleValue)
            self.businessDetail?.waitTimeFee = "0.00"
            
            let time = JSON(self.businessDetail?.estimatedDeliveryTime ?? "1").intValue
            self.duration.text = "\(time) mins"
            
            let delFee = JSON(self.businessDetail?.deliveryFee ?? "0").doubleValue
            self.deliveryFee.text = "$" + String(format: "%.02f", delFee)
            
        }) { (error, json) in
            hideLoader()
            self.duration.text = "-- mins"
            self.deliveryFee.text = "--"
        }
    }
    
    func addressChanged(){
        self.viewWillAppear(true)
        
        guard changingDeliveryAdd == false else {
            self.getSpecialDetails()
            return
        }
        
        let storeLats = PickUpAddressInterface.shared.getPickupCords().latitude
        let storeLongs = PickUpAddressInterface.shared.getPickupCords().longitude
        
        self.businessDetail?.location?.address1 = PickUpAddressInterface.shared.selectedAddress.address
        self.businessDetail?.location?.address2 = PickUpAddressInterface.shared.selectedAddress.fullAddress
        self.businessDetail?.location?.address3 = PickUpAddressInterface.shared.selectedAddress.fullAddress
        self.businessDetail?.location?.aptInfo = PickUpAddressInterface.shared.selectedAddress.apartmentInfo
        self.businessDetail?.additionalNotes = PickUpAddressInterface.shared.selectedAddress.notes ?? ""
        self.businessDetail?.coordinates?.latitude = JSON(storeLats).floatValue
        self.businessDetail?.coordinates?.longitude = JSON(storeLongs).floatValue
        self.businessDetail?.location?.pickOption = PickUpAddressInterface.shared.selectedAddress.dropPickupoptions
        self.businessDetail?.location?.pickFlightStairs = PickUpAddressInterface.shared.selectedAddress.flightofStairs
        self.businessDetail?.location?.pickElevatorFloor = PickUpAddressInterface.shared.selectedAddress.elevatorFloor
        self.businessDetail?.location?.pick_elevator_walk_both = PickUpAddressInterface.shared.selectedAddress.elevator_walk_both
        
        let addresses = (PickUpAddressInterface.shared.selectedAddress.fullAddress ?? "").components(separatedBy: ", ")
        if addresses.count < 3{
            self.businessDetail?.location?.displayAddress = addresses
        } else{
            let line1 = addresses.first ?? ""
            let line2 = addresses[(addresses.count - 2)] + ", " + addresses[(addresses.count - 1)]
            self.businessDetail?.location?.displayAddress = [line1, line2]
        }
        
        self.getSpecialDetails()
    }
    
    func getSpecialDetails(){
        let originLats = DeliveryAddressInterface.shared.getDeliveryCords().latitude
        let originLongs = DeliveryAddressInterface.shared.getDeliveryCords().longitude
        
        let storeLats = self.businessDetail?.coordinates?.latitude ?? 0.0
        let storeLongs = self.businessDetail?.coordinates?.longitude ?? 0.0
        
        let url = URL.init(string: "https://maps.googleapis.com/maps/api/directions/json?&mode=driving&origin=\(originLats),\(originLongs)&destination=\(storeLats),\(storeLongs)&sensor=false&key=\(gooleMapKey)")!
        
        showLoader()
        
        Alamofire.request(url).responseJSON { response in
            let jsonData = JSON(response.result.value as Any)
            
            guard jsonData["routes"].count != 0 else {
                self.businessDetail?.distance = "0 mi"
                self.businessDetail?.duration = "NO TIME"
                hideLoader()
                self.loadData(false)
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
                    
                    self.businessDetail?.points = points
                    self.businessDetail?.duration = duration
                    self.businessDetail?.distance = distance
                } else{
                    self.businessDetail?.distance = "0 mi"
                    self.businessDetail?.duration = "NO TIME"
                }
            } else{
                self.businessDetail?.distance = "0 mi"
                self.businessDetail?.duration = "NO TIME"
            }
            
            hideLoader()
            self.loadData(false)
        }
    }
    
    func generateOrderID(){
        let params : Parameters = [
            "category": self.businessDetail?.category ?? "",
            "isSkill" : "0"
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
                vc.transportIcon = self.vehicleTypes[self.businessDetail?.vehicleTypeIndex ?? 0]
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
