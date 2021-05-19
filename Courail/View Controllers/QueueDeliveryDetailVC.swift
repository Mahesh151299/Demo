//
//  QueueDeliveryDetailVC.swift
//  Courail
//
//  Created by mac on 06/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SKPhotoBrowser


class DeliveryDetailTVC: UITableViewCell {
    
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTittle: UILabel!
    @IBOutlet weak var lblAddress1: UILabel!
    @IBOutlet weak var lblAddress2: UILabel!
    @IBOutlet weak var adressOptions: UILabel!
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var bottomLine: UILabel!
    
    @IBOutlet weak var dashView: UIView!
    @IBOutlet weak var line0: UIView!
    @IBOutlet weak var line1: UIView!
    
    @IBOutlet weak var hideBtn: UIButton!
    
    @IBOutlet weak var feeTitle: UILabel!
    @IBOutlet weak var feeValue: UILabel!
    @IBOutlet weak var feeType: UILabel!
    

    
    @IBOutlet weak var editBtnView: UIView!
    @IBOutlet weak var editBtnOut: UIButtonCustomClass!
    
    @IBOutlet weak var topPadding: NSLayoutConstraint!
    
    @IBOutlet weak var bottomPadding: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.dashView != nil {
            self.addDashView(to: self.dashView)
        }
    }
    
    func addDashView(to view: UIView){
        let lineLayer = CAShapeLayer()
        lineLayer.strokeColor = appColorBlue.cgColor
        lineLayer.lineWidth = 2
        lineLayer.lineDashPattern = [4,4]
        DispatchQueue.main.async {
            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: view.frame.width / 2, y: 0),
                                    CGPoint(x: view.frame.width / 2, y: view.frame.height)])
            lineLayer.path = path
            view.layer.addSublayer(lineLayer)
        }
    }
    
}


class QueueDeliveryDetailVC: UIViewController{
    
    //MARK:- BUTTONS ACTIONS
    
    @IBOutlet weak var navTitle: UILabel!
    
    @IBOutlet weak var dropAddress: UILabel!
    @IBOutlet weak var dropNotes: ExpandableLabel!
    @IBOutlet weak var dropAddressView: UIView!
    
    @IBOutlet weak var specialServiceView: UIView!
    @IBOutlet weak var specialAddressArrow: UIImageView!
    
    @IBOutlet weak var pickName: UILabel!
    @IBOutlet weak var pickAddress: UILabel!
    @IBOutlet weak var pickAddress2: UILabel!
    @IBOutlet weak var pickApt: UILabel!
    @IBOutlet weak var pickNotes: ExpandableLabel!
    @IBOutlet weak var pickNotesEditView: UIView!
    
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var awayLbl: UILabel!
    
    @IBOutlet weak var iconBgView: UIViewCustomClass!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryIconHeight: NSLayoutConstraint!
    
    @IBOutlet weak var transportIcon: UIImageView!
    
    @IBOutlet weak var bookBGView: UIView!
    @IBOutlet weak var bookLbl: UILabel!
    @IBOutlet weak var bookBtnOut: UIButtonCustomClass!
    @IBOutlet weak var totalFee: UILabel!
    
    @IBOutlet weak var collectionLineView: UIView!
    @IBOutlet weak var collectionImages: UICollectionView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDetails: UILabel!
    
    @IBOutlet weak var skillServiceFeeView: UIView!
    @IBOutlet weak var skillServiceFee: UILabel!
    @IBOutlet weak var skillServicePromoAppliedLbl: UILabel!
    
    @IBOutlet weak var serviceFeeView: UIView!
    @IBOutlet weak var serviceFee: UILabel!
    
    @IBOutlet weak var deliveryFeeView: UIView!
    @IBOutlet weak var deliveryFee: UILabel!
    @IBOutlet weak var promoAppliedLbl: UILabel!
    
    @IBOutlet weak var itemCostView: UIView!
    @IBOutlet weak var itemCostLbl: UILabel!
    @IBOutlet weak var itemCostFee: UILabel!
    @IBOutlet weak var baseFee: UILabel!
    @IBOutlet weak var heavyFee: UILabel!
    @IBOutlet weak var effortFee: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var tollValue: UILabel!
    @IBOutlet weak var total: UILabel!
    
    
    @IBOutlet weak var tollView: UIView!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var baseFeeView: UIView!
    @IBOutlet weak var heavyView: UIView!
    @IBOutlet weak var dicountView: UIView!
    @IBOutlet weak var effortView: UIView!
    @IBOutlet weak var tipFee: UILabel!
    
    @IBOutlet weak var itemStack: UIStackView!
    
    @IBOutlet weak var addPromoView: UIView!
    
    @IBOutlet weak var paymentMethodView: UIView!
    @IBOutlet weak var PaymentMethodBtn: UIButton!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardNo: UILabel!
    @IBOutlet weak var addTipBtn: UIButton!
    
    @IBOutlet weak var pickUpTime: UILabel!
    
    @IBOutlet weak var swapBtnOut: UIButton!
    
    @IBOutlet weak var transportBtnOut: UIButton!
    
    @IBOutlet weak var specialInstructionsView: UIView!
    
    
    //MARK:- VARIABLES ACTIONS
    var photoBrowser = SKPhotoBrowser()
    
    var businessDetail : YelpStoreBusinesses?
    var isRepeat = false
    
    var itemStackOrgHeight : CGFloat = 0
    
    let vehicleTypes = ["Walker","Bicycle","E-Scooter","Moped","Motorcycle","Car","Pickup","Van","Truck"]
    let transportImg =  [#imageLiteral(resourceName: "imgWalking"),#imageLiteral(resourceName: "imgBike"),#imageLiteral(resourceName: "imgE-scooter"),#imageLiteral(resourceName: "imgMoped"),#imageLiteral(resourceName: "imgMotorcycle"),#imageLiteral(resourceName: "imgCar"),#imageLiteral(resourceName: "imgPickup"),#imageLiteral(resourceName: "imgVan"),#imageLiteral(resourceName: "imgTruck") ]
    
    var skillVehicleTypes = ["Walker","Bicycle","E-Scooter","Moped","Motorcycle","Car","Pickup","Van","Truck","Tow Truck"]
    var skillTransportImg =  [#imageLiteral(resourceName: "imgWalking"),#imageLiteral(resourceName: "imgBike"),#imageLiteral(resourceName: "imgE-scooter"),#imageLiteral(resourceName: "imgMoped"),#imageLiteral(resourceName: "imgMotorcycle"),#imageLiteral(resourceName: "imgCar"),#imageLiteral(resourceName: "imgPickup"),#imageLiteral(resourceName: "imgVan"),#imageLiteral(resourceName: "imgTruck") ,#imageLiteral(resourceName: "imgTowTruck")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstName = userInfo.firstName ?? ""
        let lastName = userInfo.lastName ?? ""
        let fullUserName = firstName + " " + lastName
        
        let dropAdd = DeliveryAddressInterface.shared.selectedAddress
        self.businessDetail?.dropAddress = dropAdd
        
        if (self.businessDetail?.isSkillService ?? false){
            let dropNotes = self.businessDetail?.additionalNotes ?? ""
            self.businessDetail?.dropAddress?.notes = dropNotes
            self.setupSkillTransports()
        }
        
        self.businessDetail?.dropAddress?.placeName = fullUserName
        
        self.loadData()
        if self.isRepeat{
            self.getDetails()
        }
        
        self.setupNotes()
        self.getTollFee()
        
        self.transportBtnOut.addTarget(self, action: #selector(self.transportBtnDoubleTap(_:event:)), for: .touchDownRepeat)
        // Do any additional setup after loading the view.
    }
    
    func setupSkillTransports(){
        switch (self.businessDetail?.category ?? "").lowercased(){
        case "towing":
            self.skillTransportImg =  [#imageLiteral(resourceName: "imgTowTruck")]
            self.skillVehicleTypes = ["Tow Truck"]
            
        default:
            self.skillTransportImg =  [#imageLiteral(resourceName: "imgWalking"),#imageLiteral(resourceName: "imgBike"),#imageLiteral(resourceName: "imgE-scooter"),#imageLiteral(resourceName: "imgMoped"),#imageLiteral(resourceName: "imgMotorcycle"),#imageLiteral(resourceName: "imgCar"),#imageLiteral(resourceName: "imgPickup"),#imageLiteral(resourceName: "imgVan"),#imageLiteral(resourceName: "imgTruck") ,#imageLiteral(resourceName: "imgTowTruck")]
            self.skillVehicleTypes = ["Walker","Bicycle","E-Scooter","Moped","Motorcycle","Car","Pickup","Van","Truck","Tow Truck"]
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.iconBgView.addShadowsRadius()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        orderInProgress = false
        
        let str = isLoggedIn() ? ((userInfo.firstName ?? "") + "'s") : "Your"
        self.navTitle.text = str + " Order"
        
        self.tabBarController?.tabBar.isHidden = true
        self.addTip()
        
        //        if (self.businessDetail?.category ?? "").lowercased() == "special"{
        //            self.swapBtnOut.isHidden = false
        //        }else{
        self.swapBtnOut.isHidden = true
        //        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadData(){
        self.bookLbl.text = self.isRepeat ? "BOOK AGAIN": "BOOK NOW"
        
        let address = self.businessDetail?.location
        if (address?.displayAddress?.count ?? 0) > 2{
            let line1 = self.businessDetail?.location?.displayAddress?.first ?? ""
            let line2 = self.businessDetail?.location?.displayAddress?.last ?? ""
            
            let zipCode = address?.zipCode ?? "------"
            var line2filter = line2.replacingOccurrences(of: ", \(zipCode)", with: "")
            line2filter = line2filter.replacingOccurrences(of: " \(zipCode)", with: "")
            
            if line2filter.components(separatedBy: ", ").count > 1{
                line2filter = line2filter.components(separatedBy: ", ").first ?? ""
            }
            
            self.businessDetail?.location?.address1 = line1
            self.businessDetail?.location?.address2 = line2filter
            self.businessDetail?.location?.address3 = line1 + ", " + line2filter
        } else{
            let zipCode = address?.zipCode ?? "------"
            var filterAdd = self.businessDetail?.location?.displayAddress?.joined(separator: "\n").replacingOccurrences(of: ", \(zipCode)", with: "")
            filterAdd = filterAdd?.replacingOccurrences(of: " \(zipCode)", with: "")
            
            if (filterAdd?.components(separatedBy: ", ").count ?? 0) > 1{
                filterAdd = filterAdd?.components(separatedBy: ", ").first ?? ""
            }
            
            if (filterAdd?.components(separatedBy: "\n").count ?? 0) > 1{
                self.businessDetail?.location?.address1 = filterAdd?.components(separatedBy: "\n").first ?? ""
                self.businessDetail?.location?.address2 = filterAdd?.components(separatedBy: "\n").last ?? ""
                self.businessDetail?.location?.address3 = (filterAdd?.components(separatedBy: "\n").first ?? "") + ", " + (filterAdd?.components(separatedBy: "\n").last ?? "")
            } else{
                self.businessDetail?.location?.address1 = filterAdd ?? ""
                self.businessDetail?.location?.address2 = ""
                self.businessDetail?.location?.address3 = filterAdd ?? ""
            }
        }
        
        if (self.businessDetail?.pickUpTime ?? "") == ""{
            if self.businessDetail?.isSkillService == true{
                self.pickUpTime.text = "CHOOSE NEW MEETING TIME"
            }else{
                self.pickUpTime.text = "CHOOSE NEW PICK UP TIME"
            }
        } else{
            self.pickUpTime.text = self.checkDate(self.businessDetail?.pickUpTime ?? "")
        }
        
        self.itemName.text = self.businessDetail?.itemDescription?.uppercased()
        self.specialInstructionsView.isHidden = ((self.businessDetail?.specialLink ?? "") == "") ? true : false
        
        if self.isRepeat && self.businessDetail?.attachedImagesURL?.count == 0 && (self.businessDetail?.identificationImageURL ?? "") == ""{
            self.collectionLineView.isHidden = true
        }else if self.isRepeat == false && self.businessDetail?.attachedPhoto.count == 0 && (self.businessDetail?.identificationImageURL ?? "") == ""{
            self.collectionLineView.isHidden = true
        } else{
            self.collectionImages.delegate = self
            self.collectionImages.dataSource = self
            self.collectionLineView.isHidden = false
        }
        
        self.awayLbl.text = "away"
        
        if (self.businessDetail?.isSkillService ?? false){
            self.transportIcon.image = self.skillTransportImg[self.businessDetail?.vehicleTypeIndex ?? 0]
            
            self.dropAddressView.isHidden = true
            self.awayLbl.text = ""
            
            let firstName = userInfo.firstName ?? "You"
            let lastName = userInfo.lastName ?? ""
            self.pickName.text = (firstName + " " + lastName)
            
            var options = DeliveryAddressInterface.shared.addressOptions(isDelivery: true, model: self.businessDetail, type: 0)
            options = (options == "") ? "" : (options + " • ")
            
            var notes = (self.businessDetail?.dropAddress?.notes ?? "")
            notes = (notes == "") ? "No notes" : notes
            self.pickNotes.text = options + notes
            
            let address1 = (self.businessDetail?.dropAddress?.address ?? "") + ", "
            let addressFull = self.businessDetail?.dropAddress?.fullAddress ?? ""
            var address2 = addressFull.replacingOccurrences(of: address1, with: "")
            
            if (address2.components(separatedBy: ", ").count) > 1{
                address2 = address2.components(separatedBy: ", ").first ?? ""
            }
            self.businessDetail?.dropAddress?.address2 = address2
            
            var aptInfo = self.businessDetail?.dropAddress?.apartmentInfo ?? ""
            aptInfo = (aptInfo == "") ? "" : ("• " + aptInfo)
            self.pickApt.text = aptInfo
            self.pickAddress.text = (self.businessDetail?.dropAddress?.address ?? "")
            self.pickAddress2.text = address2
            
            let floors = DeliveryAddressInterface.shared.addressOptions(isDelivery: true, model: self.businessDetail, type: 1)
            self.itemDetails.text = self.getItemDetails(floors: floors)
            self.itemDetails.isHidden = ((self.itemDetails.text ?? "") == "") ? true : false
            
        }else if self.businessDetail?.isReversedDel == true{
            self.transportIcon.image = self.transportImg[self.businessDetail?.vehicleTypeIndex ?? 0]
            
            
            var dropAptInfo = self.businessDetail?.location?.aptInfo ?? ""
            dropAptInfo = (dropAptInfo == "") ? "" : (" • " + dropAptInfo)
            
            let dropaddress = self.businessDetail?.location
            self.dropAddress.text = (dropaddress?.address1 ?? "") + dropAptInfo
            
            let firstName = userInfo.firstName ?? "You"
            let lastName = userInfo.lastName ?? ""
            self.pickName.text = (firstName + " " + lastName)
            
            var dropOptions = DeliveryAddressInterface.shared.addressOptions(isDelivery: false, model: self.businessDetail, type: 0)
            dropOptions = (dropOptions == "") ? "" : (dropOptions + " • ")
            
            var dropNotes = (self.businessDetail?.additionalNotes ?? "")
            dropNotes = (dropNotes == "") ? "No notes" : dropNotes
            self.dropNotes.text = dropOptions + dropNotes
            
            var options = DeliveryAddressInterface.shared.addressOptions(isDelivery: true, model: self.businessDetail, type: 0)
            options = (options == "") ? "" : (options + " • ")
            
            var notes = (self.businessDetail?.dropAddress?.notes ?? "")
            notes = (notes == "") ? "No notes" : notes
            self.pickNotes.text = options + notes
            
            let address1 = (self.businessDetail?.dropAddress?.address ?? "") + ", "
            let addressFull = self.businessDetail?.dropAddress?.fullAddress ?? ""
            var address2 = addressFull.replacingOccurrences(of: address1, with: "")
            if (address2.components(separatedBy: ", ").count) > 1{
                address2 = address2.components(separatedBy: ", ").first ?? ""
            }
            
            self.businessDetail?.dropAddress?.address2 = address2
            
            var aptInfo = self.businessDetail?.dropAddress?.apartmentInfo ?? ""
            aptInfo = (aptInfo == "") ? "" : ("• " + aptInfo)
            self.pickApt.text = aptInfo
            self.pickAddress.text =  (self.businessDetail?.dropAddress?.address ?? "")
            self.pickAddress2.text = address2
            
            let floors = DeliveryAddressInterface.shared.addressOptions(isDelivery: true, model: self.businessDetail, type: 1)
            self.itemDetails.text = self.getItemDetails(floors: floors)
            self.itemDetails.isHidden = ((self.itemDetails.text ?? "") == "") ? true : false
        } else{
            self.transportIcon.image = self.transportImg[self.businessDetail?.vehicleTypeIndex ?? 0]
            
            //            let pickAptInfo = self.businessDetail?.dropAddress?.apartmentInfo ?? ""
            let pickAddress1 = (self.businessDetail?.dropAddress?.address ?? "") + ", "
            let pickAddressFull = self.businessDetail?.dropAddress?.fullAddress ?? ""
            var pickAddress2 = pickAddressFull.replacingOccurrences(of: pickAddress1, with: "")
            
            if (pickAddress2.components(separatedBy: ", ").count) > 1{
                pickAddress2 = pickAddress2.components(separatedBy: ", ").first ?? ""
            }
            
            self.businessDetail?.dropAddress?.address2 = pickAddress2
            
            var dropAptInfo = self.businessDetail?.dropAddress?.apartmentInfo ?? ""
            dropAptInfo = (dropAptInfo == "") ? "" : (" • " + dropAptInfo)
            
            self.dropAddress.text = (self.businessDetail?.dropAddress?.address ?? "")  + dropAptInfo
            
            var dropOptions = DeliveryAddressInterface.shared.addressOptions(isDelivery: true, model: self.businessDetail, type: 0)
            dropOptions = (dropOptions == "") ? "" : (dropOptions + " • ")
            
            var dropNotes = (self.businessDetail?.dropAddress?.notes ?? "")
            dropNotes = (dropNotes == "") ? "No notes" : dropNotes
            self.dropNotes.text = dropOptions + dropNotes
            
            self.pickName.text = self.businessDetail?.name ?? ""
            
            var options = DeliveryAddressInterface.shared.addressOptions(isDelivery: false, model: self.businessDetail, type: 0)
            options = (options == "") ? "" : (options + " • ")
            
            var notes = (self.businessDetail?.additionalNotes ?? "")
            notes = (notes == "") ? "No notes" : notes
            self.pickNotes.text = options + notes
            
            var aptInfo = self.businessDetail?.location?.aptInfo ?? ""
            aptInfo = (aptInfo == "") ? "" : ("• " + aptInfo)
            self.pickApt.text = aptInfo
            
            let address = self.businessDetail?.location
            self.pickAddress.text = (address?.address1 ?? "")
            self.pickAddress2.text = (address?.address2 ?? "")
            
            let floors = DeliveryAddressInterface.shared.addressOptions(isDelivery: false, model: self.businessDetail, type: 1)
            self.itemDetails.text = self.getItemDetails(floors: floors)
            self.itemDetails.isHidden = ((self.itemDetails.text ?? "") == "") ? true : false
        }
        
        
        if self.isRepeat{
            self.categoryImage.sd_setImage(with: URL(string: (self.businessDetail?.imageCategoryURL ?? "")), placeholderImage: UIImage(named: "imgNoLogo"))
            self.iconBgView.backgroundColor = hexStringToUIColor(hex: (self.businessDetail?.imageCategoryColor ?? ""))
            
            if (self.businessDetail?.imageCategoryColor ?? "") == "clear"{
                self.categoryImage.contentMode = .scaleAspectFill
                self.categoryIconHeight.constant = 0
            } else{
                self.categoryImage.contentMode = .scaleAspectFit
                self.categoryIconHeight.constant = -10
            }
        } else{
            self.getCategoryImage(upload: false) { (categoryImage, imgColor) in
                if let imgLocal = UIImage(named: categoryImage){
                    if (self.businessDetail?.isWebStore ?? false){
                        self.categoryImage.contentMode = .scaleAspectFill
                        self.categoryIconHeight.constant = 0
                    } else{
                        switch categoryImage {
                        case "imgLocal-biz":
                            self.categoryImage.contentMode = .scaleAspectFill
                            self.categoryIconHeight.constant = 0
                        default:
                            self.categoryImage.contentMode = .scaleAspectFit
                            self.categoryIconHeight.constant = -10
                        }
                    }
                    
                    self.categoryImage.image = imgLocal
                    self.iconBgView.backgroundColor = hexStringToUIColor(hex: imgColor)
                } else{
                    self.categoryImage.contentMode = .scaleAspectFill
                    self.categoryIconHeight.constant = 0
                    
                    self.categoryImage.sd_setImage(with: URL(string: categoryImage), placeholderImage: UIImage(named: "imgNoLogo"), options: [], completed: nil)
                    self.iconBgView.backgroundColor = .white
                }
            }
        }
        
        let serviceFee = self.businessDetail?.serviceFee ?? "0.00"
        
        if JSON(serviceFee).doubleValue == 0.00{
            self.serviceFeeView.isHidden = true
        } else{
            self.serviceFee.text = "$" + serviceFee
            self.serviceFeeView.isHidden = false
        }
        
        let promoDiscount =  JSON(self.businessDetail?.promoPrice ?? "0").doubleValue
        var deliveryFee = JSON(self.businessDetail?.deliveryFee ?? "0").doubleValue
        deliveryFee = deliveryFee - promoDiscount
        
        if (self.businessDetail?.isSkillService ?? false) == true{
            self.specialServiceView.isHidden = false
            self.specialAddressArrow.isHidden = false
            
            self.deliveryFeeView.isHidden = true
            self.heavyView.isHidden = true
            self.baseFeeView.isHidden = true
            self.dicountView.isHidden = true
            self.effortView.isHidden = true
            self.skillServiceFeeView.isHidden = false
            
            self.itemCostLbl.text = "Offer Price"
            self.itemCostFee.text = "$" + (self.businessDetail?.estimatedServiceOffer ?? "")
            
            self.skillServiceFee.text = "$" + (self.businessDetail?.baseFee ?? "0.00")
            
            self.duration.text = ""
        }else{
            self.specialServiceView.isHidden = true
            self.specialAddressArrow.isHidden = true
            
            self.deliveryFeeView.isHidden = false
            self.heavyView.isHidden = (Double(self.businessDetail?.heavyFee ?? "") ?? 0) == 0
            self.baseFeeView.isHidden = (Double(self.businessDetail?.baseFee ?? "") ?? 0) == 0
            self.dicountView.isHidden = (Double(self.businessDetail?.promoPrice ?? "") ?? 0) == 0
            self.effortView.isHidden = (Double(self.businessDetail?.stairsElevatorFee ?? "") ?? 0) == 0
            self.skillServiceFeeView.isHidden = true
            
            self.heavyFee.text = "$" + (self.businessDetail?.heavyFee ?? "")
            self.effortFee.text = "$" + (self.businessDetail?.stairsElevatorFee ?? "")
            self.discount.text = "-$" + (self.businessDetail?.promoPrice ?? "")
            self.baseFee.text = "$" + (self.businessDetail?.baseFee ?? "")
            
            let time = JSON(self.businessDetail?.estimatedDeliveryTime ?? "1").intValue
            self.duration.text = "\(time) min"
            
            self.itemCostLbl.text = "Item Cost"
            self.itemCostFee.text = "$" + (self.businessDetail?.courialFee ?? "")
            
            self.deliveryFee.text = "$" + String(format: "%.02f", deliveryFee)
            
            if self.businessDetail?.subTotalType == "COURIAL PAYS"{
                self.itemCostView.isHidden = false
            }else{
                self.itemCostView.isHidden = true
            }
        }
        
        if self.businessDetail?.promoApplied == true && self.businessDetail?.validPromo == true{
            self.promoAppliedLbl.isHidden = false
            self.skillServicePromoAppliedLbl.isHidden = false
        } else{
            self.promoAppliedLbl.isHidden = true
            self.skillServicePromoAppliedLbl.isHidden = true
        }
        
        if self.businessDetail?.courialTip == nil{
            self.tipView.isHidden = true
            self.tipFee.text = "$0.00"
        } else{
            self.tipView.isHidden = false
            self.tipFee.text = "$" + (self.businessDetail?.courialTip ?? "1.00")
        }
        
        
        if self.businessDetail?.promoApplied == true{
            self.addPromoView.isHidden = true
        }else{
            self.addPromoView.isHidden = false
        }
        
        if isLoggedIn(){
            self.PaymentMethodBtn.setTitle("ADD PAYMENT METHOD", for: .normal)
        }else{
            self.PaymentMethodBtn.setTitle("PLEASE LOG IN TO CONTINUE", for: .normal)
        }
        
        if userInfo.card_default?.cardNumber == nil{
            self.paymentMethodView.isHidden = false
            self.cardView.isHidden = true
        } else{
            self.paymentMethodView.isHidden = true
            self.cardView.isHidden = false
            
            self.cardImage.image = UIImage(named: userInfo.card_default?.cardType?.lowercased() ?? "") ?? UIImage(named: "ccardbck")
            let cardLast = userInfo.card_default?.cardNumber?.suffix(4) ?? ""
            self.cardNo.text = cardNameAbb(name: userInfo.card_default?.cardType ?? "") + " " + cardLast
            
            let tipString = (self.businessDetail?.courialTip == nil) ? "ADD TIP" : "EDIT TIP"
            self.addTipBtn.setTitle(tipString, for: .normal)
        }
        
//        let pickupDate = (self.businessDetail?.pickUpTime ?? "").convertStampToDate(.current) ?? Date()
//        let diffFromPickUpDate = Date().minutesBetweenDate(toDate: pickupDate)
        
        if userInfo.card_default?.cardNumber == nil || (self.businessDetail?.pickUpTime ?? "") == ""{
            self.bookBGView.backgroundColor = UIColor.init(red: 222/255, green: 222/255, blue: 222/255, alpha: 1.0)
        } else{
            self.bookBGView.backgroundColor = self.isRepeat ? appColorBlue : appColor
        }
        
        let courialTip =  JSON(self.businessDetail?.courialTip ?? "0").doubleValue
        let cp = JSON(self.businessDetail?.courialFee ?? "0").doubleValue
        let total = deliveryFee + cp + JSON(serviceFee).doubleValue +  courialTip
        self.totalFee.text = "$" + String(format: "%.02f", total)
        self.total.text = "$" + String(format: "%.02f", total)
        self.businessDetail?.totalFee = String(format: "%.02f", total)
    }
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func MenuOrGoBack(_ sender:UIButton){
        //        let activeOrderView = ActiveOrderView.init(frame: screenFrame(), type: 0) { (result) in
        //            if result{
        self.navigationController?.popViewController(animated: true)
        //            }
        //        }
        //        self.view.addSubview(activeOrderView)
    }
    
    @objc func transportBtnDoubleTap(_ sender: UIButton , event: UIEvent) {
        guard (self.businessDetail?.category ?? "").lowercased() != "towing" else {return}
        guard let touch: UITouch = event.allTouches?.first , (touch.tapCount == 2) else { return }
        
        var vehicle = ""
        if self.businessDetail?.isSkillService == true{
            vehicle = self.skillVehicleTypes[self.businessDetail?.vehicleTypeIndex ?? 0]
        } else{
            vehicle = self.vehicleTypes[self.businessDetail?.vehicleTypeIndex ?? 0]
        }
        
        let transportPopup = TransportView(frame: screenFrame(), vehicle: vehicle , isSkill: (self.businessDetail?.isSkillService ?? false) , category : self.businessDetail?.category ?? "",over45: (self.businessDetail?.over45Lbs ?? false), twoCourial: (self.businessDetail?.two_courial ?? false)) { (vehicle, over45, twoCourial) in
            guard vehicle != "" else {return}
            self.businessDetail?.vehicleTypeIndex = self.skillVehicleTypes.firstIndex(where: {$0.lowercased() == vehicle?.lowercased()}) ?? 5
            
            if self.businessDetail?.isSkillService == false{
                self.businessDetail?.over45Lbs = over45
                self.businessDetail?.two_courial = twoCourial 
                self.getDeliveryFee()
            }else{
                self.loadData()
            }
        }
        
        self.view.addSubview(transportPopup)
    }
    
    @IBAction func pickUpTimeBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        let DTvc = storyboard?.instantiateViewController(withIdentifier: "DateAndTimeVC") as! DateAndTimeVC
        DTvc.stringKey = "4"
        DTvc.businessDetail = self.businessDetail
        DTvc.completion = { model in
            self.businessDetail = model
            self.loadData()
        }
        DTvc.modalPresentationStyle = .overCurrentContext
        self.view.addSubview(DTvc.view)
        self.addChild(DTvc)
    }
    
    @IBAction func pickNotesEditBtn(_ sender: UIButton){
        var prevNotes = (self.businessDetail?.isReversedDel ?? false) ? (self.businessDetail?.dropAddress?.notes ?? "") : (self.businessDetail?.additionalNotes ?? "")
        if (self.businessDetail?.isSkillService ?? false) == true{
            prevNotes = (self.businessDetail?.dropAddress?.notes ?? "")
        }
        
        let editView = UpdateNotesView(frame: screenFrame(), isSkill: (self.businessDetail?.isSkillService ?? false), notes: prevNotes, name: self.businessDetail?.itemDescription ?? "") { (itemName, notes) in
            self.businessDetail?.itemDescription = itemName
            
            if (self.businessDetail?.isSkillService ?? false) == true{
                self.businessDetail?.dropAddress?.notes = notes
                showSwiftyAlert("", "Additional notes updated", true)
            }else if (self.businessDetail?.isReversedDel ?? false) == true{
                self.businessDetail?.dropAddress?.notes = notes
                showSwiftyAlert("", "Pickup notes updated", true)
            }else{
                self.businessDetail?.additionalNotes = notes
                showSwiftyAlert("", "Pickup notes updated", true)
            }
            self.loadData()
        }
        self.view.addSubview(editView)
    }
    
    
    @IBAction func swapAddressBtn(_ sender: UIButton) {
        self.swapAddresses()
    }
    
    @IBAction func specialAddEditBtn(_ sender: UIButton) {
        guard (self.businessDetail?.isSkillService ?? false) else{
            return
        }
        deleteOrderFlag = true
        changingDeliveryAdd = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetAddressVC") as! SetAddressVC
        vc.isReversedDel = (self.businessDetail?.isReversedDel ?? false)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func addPromoBtn(sender: UIButton) {
        let promoPopup = PromoView.init(frame: screenFrame()) { (model) in
            self.businessDetail = model
            self.loadData()
        }
        promoPopup.businessDetail = self.businessDetail
        self.view.addSubview(promoPopup)
    }
    
    @IBAction func AboutUsBtnAction(sender: UIButton) {
        self.getPricingApi()
    }
    
    @IBAction func PaymentMethodAction(sender: UIButton) {
        if checkLogin(){
            let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodVC") as! PaymentMethodVC
            self.navigationController?.pushViewController(paymentVC, animated: true)
        } else{
            orderInProgress = true
        }
    }
    
    @IBAction func changeDelAddress(_ sender: UIButton) {
        deleteOrderFlag = true
        changingDeliveryAdd = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetAddressVC") as! SetAddressVC
        vc.isReversedDel = (self.businessDetail?.isReversedDel ?? false)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionBookNow(_ sender: UIButton) {
        let pickupDate = (self.businessDetail?.pickUpTime ?? "").convertStampToDate(.current) ?? Date()
//        let diffFromPickUpDate = Date().minutesBetweenDate(toDate: pickupDate)
        
        guard pickupDate > Date() else{
            let timeStr = (self.businessDetail?.isSkillService == true) ? "meeting" : "pickup"
            showSwiftyAlert("", "Unfortunately, the \(timeStr) time has already passed. Please select new \(timeStr) time. Thanks!", false)
            return
        }
        
        guard userInfo.card_default?.cardNumber != nil else { return }
        guard (self.businessDetail?.pickUpTime ?? "") != "" else { return }
        
        
        guard currentOrder == nil else{
            let activeOrderView = ActiveOrderView.init(frame: screenFrame(), type: 1) { (result) in
                if result{
                    SocketBase.sharedInstance.cancelOrder(currentOrder?.orderid ?? "")
                    currentOrder = nil
                    MediaShareInterface.shared.playSound(.cancel)
                }
            }
            self.view.addSubview(activeOrderView)
            return
        }
        
        showLoader()
        if self.isRepeat{
            self.placeOrder(categoryImage: self.businessDetail?.imageCategoryURL ?? "", categoryImageColor: self.businessDetail?.imageCategoryColor ?? "")
        }else{
            self.getCategoryImage(upload: true) { (categoryImage, imgColor) in
                self.placeOrder(categoryImage: categoryImage, categoryImageColor: imgColor)
            }
        }
        
    }
    
    @IBAction func tipBtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DefaultTipVC")as! DefaultTipVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func specialInstructionsBtn(_ sender: UIButton) {
        if let url = URL(string: self.businessDetail?.specialLink ?? ""), !url.absoluteString.isEmpty, (UIApplication.shared.canOpenURL(url)) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            showSwiftyAlert("", "Sorry! We are not able to open this page.", false)
        }
    }
    
    @IBAction func editInstructionsBtn(_ sender: UIButton) {
        let editView = InstructionsView(frame: screenFrame(), link: self.businessDetail?.specialLink ?? "") { (link) in
            self.businessDetail?.specialLink = link
            showSwiftyAlert("", "Special instructions link updated", true)
        }
        self.view.addSubview(editView)
    }
    
    func addTip(){
        guard userInfo.tipevalue != "" && userInfo.card_default != nil else{
            self.businessDetail?.courialTip = nil
            self.loadData()
            return
        }
        
        let serviceFee = JSON(self.businessDetail?.serviceFee ?? "0").doubleValue
        let deliveryFee = JSON(self.businessDetail?.deliveryFee ?? "0").doubleValue
        let total = (serviceFee + deliveryFee)
        
        var tip = 0.0
        
        if userInfo.tiptype == "1"{
            let percentage = JSON(userInfo.tipevalue ?? "0").doubleValue
            tip = total * (percentage / 100)
            if tip < 1{
                tip = 1
            }
        } else{
            tip = JSON((userInfo.tipevalue ?? "0").replacingOccurrences(of: "$", with: "")).doubleValue
        }
        
        self.businessDetail?.courialTip = String(format: "%.02f", tip)
        self.loadData()
    }
    
}

extension QueueDeliveryDetailVC {
    
    func getItemDetails(floors: String)-> String{
        guard self.businessDetail?.isSkillService == false else{
            var time = self.businessDetail?.estimatedServiceTime ?? ""
            time = time + " Min Service"
            
            let value = [time,floors].filter({$0 != ""}).joined(separator: " • ")
            return value
        }
        
        let twoCourial =  (self.businessDetail?.two_courial ?? false) ? "Two Courials" : ""
        let over45Lbs =  (self.businessDetail?.over45Lbs ?? false) ? "Over 45 lbs" : ""
        
        var idRequired = ""
        switch self.businessDetail?.itemCategory?.lowercased(){
        case "cannabis","wine","alcohol","pharmacy","cigar","cigarette","cigarettes","tobacco":
            idRequired = "ID Required"
        default:
            idRequired = ""
        }
        
        var value = [twoCourial,over45Lbs,idRequired,floors].filter({$0 != ""})
        if value.count > 3{
            value = [over45Lbs,idRequired,floors].filter({$0 != ""})
        }
        return value.joined(separator: " • ")
    }
    
    func checkDate(_ stamp: String)-> String{
        guard let date = stamp.convertToDate() else{
            return "Select Time"
        }
        
        if Calendar.current.isDateInToday(date){
            return date.convertToFormat("'TODAY, ' hh:mm a", timeZone: .current)
        } else if Calendar.current.isDateInTomorrow(date){
            return date.convertToFormat("'TOMORROW, ' hh:mm a", timeZone: .current)
        } else{
            let day = date.convertToFormat("EEEE", timeZone: .current).uppercased()
            let time = date.convertToFormat("MMM dd, hh:mm a", timeZone: .current)
            return day + ", " + time
        }
    }
    
    func getPricingApi(){
        let params : Parameters = [
            "isSkill" : (self.businessDetail?.isSkillService ?? false) ? "1" : "0"
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.pricing_info, method: .get, encoding: URLEncoding.httpBody , success: { (json) in
            hideLoader()
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubtotalExplainedVC") as! SubtotalExplainedVC
            
            vc.pricingHeader = json["data"]["pricing_info"].arrayValue.map({$0["title"].stringValue})
            vc.pricingText = json["data"]["pricing_info"].arrayValue.map({$0["value"].stringValue})
            vc.isSkill = (self.businessDetail?.isSkillService ?? false)
            
            vc.modalPresentationStyle = .overCurrentContext
            self.view.addSubview(vc.view)
            self.addChild(vc)
            
        }) { (error, json) in
            hideLoader()
        }
    }
    
}

extension QueueDeliveryDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let identificationImage = (self.businessDetail?.identificationImageURL ?? "") == "" ? 0 : 1
        if self.isRepeat{
            return (self.businessDetail?.attachedImagesURL?.count ?? 0) + identificationImage
        }else{
            return (self.businessDetail?.attachedPhoto.count ?? 0) + identificationImage
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImagesCVC", for: indexPath) as! AddImagesCVC
        let lastCell = collectionView.numberOfItems(inSection: 0) - 1
        
        switch self.businessDetail?.itemCategory?.lowercased(){
        case "pharmacy":
            if indexPath.item == lastCell {
                cell.title.text = "VIEW PHOTO ID"
                cell.title.textColor = appColorBlue
                
                cell.attachedImage.sd_setImage(with: URL(string: self.businessDetail?.identificationImageURL ?? ""), placeholderImage: nil, options: [], context: nil)
            } else{
                cell.title.text = "VIEW PRESCRIPTION"
                cell.title.textColor = .darkGray
                
                if self.isRepeat{
                    let imgStr = self.businessDetail?.attachedImagesURL?[indexPath.item] ?? ""
                    cell.attachedImage.sd_setImage(with: URL(string: imgStr), placeholderImage: nil, options: [], context: nil)
                } else{
                    cell.attachedImage.image = self.businessDetail?.attachedPhoto[indexPath.item]
                }
            }
        case "cannabis","wine","cigar","cigarette","cigarettes","tobacco":
            if indexPath.item == lastCell {
                cell.title.text = "VIEW PHOTO ID"
                cell.title.textColor = appColorBlue
                
                cell.attachedImage.sd_setImage(with: URL(string: self.businessDetail?.identificationImageURL ?? ""), placeholderImage: nil, options: [], context: nil)
            } else{
                cell.title.text = "VIEW IMAGE"
                cell.title.textColor = .darkGray
                
                if self.isRepeat{
                    let imgStr = self.businessDetail?.attachedImagesURL?[indexPath.item] ?? ""
                    cell.attachedImage.sd_setImage(with: URL(string: imgStr), placeholderImage: nil, options: [], context: nil)
                } else{
                    cell.attachedImage.image = self.businessDetail?.attachedPhoto[indexPath.item]
                }
            }
        default:
            cell.title.text = "VIEW IMAGE"
            cell.title.textColor = .darkGray
            
            if self.isRepeat{
                var imgStr = ""
                if self.businessDetail?.attachedImagesURL?.indices.contains(indexPath.item) == true{
                    imgStr = self.businessDetail?.attachedImagesURL?[indexPath.item] ?? ""
                }
                cell.attachedImage.sd_setImage(with: URL(string: imgStr), placeholderImage: nil, options: [], context: nil)
            } else{
                cell.attachedImage.image = self.businessDetail?.attachedPhoto[indexPath.item]
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let attachedCount = collectionView.numberOfItems(inSection: 0)
        
        if attachedCount == 1{
            return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
        }else if attachedCount == 2{
            let width = (collectionView.frame.width - 5) / 2
            return CGSize(width: width , height: collectionView.frame.height)
        }else{
            let width = (collectionView.frame.width - 10) / 3
            return CGSize(width: width , height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var photo = SKPhoto.photoWithImageURL("")
        
        switch self.businessDetail?.itemCategory?.lowercased(){
        case "pharmacy","alcohol","cannabis","wine","cigar","cigarette","cigarettes","tobacco":
            if indexPath.item == collectionView.numberOfItems(inSection: 0) - 1{
                photo = SKPhoto.photoWithImageURL(self.businessDetail?.identificationImageURL ?? "")
                self.photoBrowser = SKPhotoBrowser(photos: [photo])
                super.present(self.photoBrowser, animated: true, completion: nil)
            } else{
                let imagePop = ImagePopup.init(frame: screenFrame()) { (result) in
                    if result == "1"{
                        if self.isRepeat{
                            self.businessDetail?.attachedImagesURL?.remove(at: indexPath.item)
                        }else{
                            self.businessDetail?.attachedPhoto.remove(at: indexPath.item)
                        }
                        collectionView.reloadData()
                        
                        if self.isRepeat && self.businessDetail?.attachedImagesURL?.count == 0 && (self.businessDetail?.identificationImageURL ?? "") == ""{
                            self.collectionLineView.isHidden = true
                        }else if self.isRepeat == false && self.businessDetail?.attachedPhoto.count == 0 && (self.businessDetail?.identificationImageURL ?? "") == ""{
                            self.collectionLineView.isHidden = true
                        } else{
                            self.collectionImages.delegate = self
                            self.collectionImages.dataSource = self
                            self.collectionLineView.isHidden = false
                        }
                    } else{
                        if self.isRepeat{
                            photo = SKPhoto.photoWithImageURL(self.businessDetail?.attachedImagesURL?[indexPath.item] ?? "")
                        }else{
                            guard let img = self.businessDetail?.attachedPhoto[indexPath.item] else {return}
                            photo = SKPhoto.photoWithImage(img)
                        }
                        
                        self.photoBrowser = SKPhotoBrowser(photos: [photo])
                        super.present(self.photoBrowser, animated: true, completion: nil)
                    }
                }
                rootVC?.view.addSubview(imagePop)
            }
        default:
            let imagePop = ImagePopup.init(frame: screenFrame()) { (result) in
                if result == "1"{
                    if self.isRepeat{
                        self.businessDetail?.attachedImagesURL?.remove(at: indexPath.item)
                    }else{
                        self.businessDetail?.attachedPhoto.remove(at: indexPath.item)
                    }
                    collectionView.reloadData()
                    
                    if self.isRepeat && self.businessDetail?.attachedImagesURL?.count == 0 && (self.businessDetail?.identificationImageURL ?? "") == ""{
                        self.collectionLineView.isHidden = true
                    }else if self.isRepeat == false && self.businessDetail?.attachedPhoto.count == 0 && (self.businessDetail?.identificationImageURL ?? "") == ""{
                        self.collectionLineView.isHidden = true
                    } else{
                        self.collectionImages.delegate = self
                        self.collectionImages.dataSource = self
                        self.collectionLineView.isHidden = false
                    }
                    
                } else{
                    if self.isRepeat{
                        var imgStr = ""
                        if self.businessDetail?.attachedImagesURL?.indices.contains(indexPath.item) == true{
                            imgStr = self.businessDetail?.attachedImagesURL?[indexPath.item] ?? ""
                        }
                        photo = SKPhoto.photoWithImageURL(imgStr)
                    }else{
                        guard let img = self.businessDetail?.attachedPhoto[indexPath.item] else {return}
                        photo = SKPhoto.photoWithImage(img)
                    }
                    
                    self.photoBrowser = SKPhotoBrowser(photos: [photo])
                    super.present(self.photoBrowser, animated: true, completion: nil)
                }
            }
            rootVC?.view.addSubview(imagePop)
        }
    }
    
}

extension QueueDeliveryDetailVC{
    
    func addressChanged(){
        guard self.businessDetail?.isReversedDel == true else {
            let dropAdd = DeliveryAddressInterface.shared.selectedAddress
            self.businessDetail?.dropAddress = dropAdd
            
            let firstName = userInfo.firstName ?? ""
            let lastName = userInfo.lastName ?? ""
            let fullUserName = firstName + " " + lastName
            
            self.businessDetail?.dropAddress?.placeName = fullUserName
            
            self.getDetails()
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
        self.getDetails()
    }
    
    func swapAddresses(){
        let dropLats = self.businessDetail?.dropAddress?.latitude
        let dropLongs = self.businessDetail?.dropAddress?.longitude
        let dropAddress1 = self.businessDetail?.dropAddress?.address ?? ""
        let dropAddress2 = self.businessDetail?.dropAddress?.address2 ?? ""
        let dropFullAddress = self.businessDetail?.dropAddress?.fullAddress
        let dropDisplayAddress = [dropAddress1,dropAddress2]
        let dropNotes = self.businessDetail?.dropAddress?.notes
        let dropAptInfo = self.businessDetail?.dropAddress?.apartmentInfo
        let dropOptions = self.businessDetail?.dropAddress?.dropPickupoptions
        let dropFloor = self.businessDetail?.dropAddress?.elevatorFloor
        let dropElevatorWalkBoth = self.businessDetail?.dropAddress?.elevator_walk_both
        let dropName = self.businessDetail?.dropAddress?.placeName
        
        let pickLats = self.businessDetail?.coordinates?.latitude
        let pickLongs = self.businessDetail?.coordinates?.longitude
        let pickAddress1 = self.businessDetail?.location?.address1 ?? ""
        let pickAddress2 = self.businessDetail?.location?.address2 ?? ""
        let pickFullAddress = self.businessDetail?.location?.address3
        let pickNotes = self.businessDetail?.additionalNotes
        let pickAptInfo = self.businessDetail?.location?.aptInfo
        let pickOptions = self.businessDetail?.location?.pickOption
        let pickFloor = self.businessDetail?.location?.pickElevatorFloor
        let pickElevatorWalkBoth = self.businessDetail?.location?.pick_elevator_walk_both
        let pickName = (self.businessDetail?.name ?? "")
        
        self.businessDetail?.coordinates?.latitude = dropLats
        self.businessDetail?.coordinates?.longitude = dropLongs
        self.businessDetail?.location?.address1 = dropAddress1
        self.businessDetail?.location?.address2 = dropAddress2
        self.businessDetail?.location?.address3 = dropFullAddress
        self.businessDetail?.location?.displayAddress = dropDisplayAddress
        self.businessDetail?.additionalNotes = dropNotes
        self.businessDetail?.location?.aptInfo = dropAptInfo
        self.businessDetail?.location?.pickOption = dropOptions
        self.businessDetail?.location?.pickElevatorFloor = dropFloor
        self.businessDetail?.location?.pick_elevator_walk_both = dropElevatorWalkBoth
        self.businessDetail?.name = dropName
        
        self.businessDetail?.dropAddress?.latitude = pickLats
        self.businessDetail?.dropAddress?.longitude = pickLongs
        self.businessDetail?.dropAddress?.address = pickAddress1
        self.businessDetail?.dropAddress?.address2 = pickAddress2
        self.businessDetail?.dropAddress?.fullAddress = pickFullAddress
        self.businessDetail?.dropAddress?.notes = pickNotes
        self.businessDetail?.dropAddress?.apartmentInfo = pickAptInfo
        self.businessDetail?.dropAddress?.dropPickupoptions = pickOptions
        self.businessDetail?.dropAddress?.elevatorFloor = pickFloor
        self.businessDetail?.dropAddress?.elevator_walk_both = pickElevatorWalkBoth
        self.businessDetail?.dropAddress?.placeName = pickName
        
        self.getDetails()
    }
    
    func getDetails(){
        let originLats = self.businessDetail?.dropAddress?.latitude ?? 0.0
        let originLongs = self.businessDetail?.dropAddress?.longitude ?? 0.0
        
        let storeLats = self.businessDetail?.coordinates?.latitude ?? 0.0
        let storeLongs = self.businessDetail?.coordinates?.longitude ?? 0.0
        
        let url = URL.init(string: "https://maps.googleapis.com/maps/api/directions/json?&mode=driving&origin=\(originLats),\(originLongs)&destination=\(storeLats),\(storeLongs)&sensor=false&key=\(gooleMapKey)")!
        
        showLoader()
        
        Alamofire.request(url).responseJSON { response in
            let jsonData = JSON(response.result.value as Any)
            
            guard jsonData["routes"].count != 0 else {
                self.businessDetail?.distance = "0 mi"
                self.businessDetail?.duration = "NO TIME"
                if self.businessDetail?.isSkillService == true{
                    self.getSkillDeliveryFee()
                }else{
                    self.getDeliveryFee()
                }
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
            
            if self.businessDetail?.isSkillService == true{
                self.getSkillDeliveryFee()
            }else{
                self.getDeliveryFee()
            }
        }
    }
    
    
    func getDeliveryFee(){
        self.getTollFee()
        
        var selectedVehicleType = ""
        
        if self.businessDetail?.isSkillService == true{
            selectedVehicleType = self.skillVehicleTypes[self.businessDetail?.vehicleTypeIndex ?? 0]
        } else{
            selectedVehicleType = self.vehicleTypes[self.businessDetail?.vehicleTypeIndex ?? 0]
        }
        
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
            "transport": selectedVehicleType,
            "distance": String(format: "%.02f", distanceMiles),
            "time": formattedString,
            "dropOfOption": self.businessDetail?.dropAddress?.dropPickupoptions ?? "",
            "drop_floor": self.businessDetail?.dropAddress?.elevatorFloor ?? "0",
            "drop_elevator_walk_both": self.businessDetail?.dropAddress?.elevator_walk_both ?? "0",
            "pickupOption":self.businessDetail?.location?.pickOption ?? "",
            "pick_floor": self.businessDetail?.location?.pickElevatorFloor ?? "0",
            "pick_elevator_walk_both": self.businessDetail?.location?.pick_elevator_walk_both ?? "0",
            "itemCost" : (itemCost == "") ? "0" : itemCost
        ]
        
        ApiInterface.requestApi(params: params, api_url: API.calculation_fee , success: { (json) in
            
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
            
            hideLoader()
            self.loadData()
            
        }) { (error, json) in
            hideLoader()
            self.loadData()
        }
    }
    
    func getSkillDeliveryFee(){
        let params : Parameters = [
            "category": self.businessDetail?.category ?? "",
            "dropOfOption": self.businessDetail?.dropAddress?.dropPickupoptions ?? "",
            "drop_floor": self.businessDetail?.dropAddress?.elevatorFloor ?? "0",
            "drop_elevator_walk_both": self.businessDetail?.dropAddress?.elevator_walk_both ?? "0",
            "estimatedServiceOffer": self.businessDetail?.estimatedServiceOffer ?? ""
        ]
        
        ApiInterface.requestApi(params: params, api_url: API.special_calculation_fee , success: { (json) in
            self.businessDetail?.baseFee = String(format: "%.02f", json["data"]["basefee"].doubleValue)
            self.businessDetail?.stairsElevatorFee = String(format: "%.02f", json["data"]["stareFee"].doubleValue)
            self.businessDetail?.deliveryFee = String(format: "%.02f", json["data"]["serviceFee"].doubleValue)
            
            hideLoader()
            self.loadData()
        }) { (error, json) in
            hideLoader()
            
        }
    }
    
    func placeOrder(categoryImage: String, categoryImageColor: String){
        let cp = JSON(self.businessDetail?.courialFee ?? "0.00").doubleValue
        let cpFee = cp  * 0.05
        
        var selectedVehicleType = ""
        
        if self.businessDetail?.isSkillService == true{
            selectedVehicleType = self.skillVehicleTypes[self.businessDetail?.vehicleTypeIndex ?? 0]
        } else{
            selectedVehicleType = self.vehicleTypes[self.businessDetail?.vehicleTypeIndex ?? 0]
        }
        
        let pickUpInfo : [String : Any] = [
            "longitude" : self.businessDetail?.coordinates?.longitude ?? 0.0,
            "latitude" : self.businessDetail?.coordinates?.latitude ?? 0.0,
            "address1" : self.businessDetail?.location?.address1 ?? "",
            "address2" : self.businessDetail?.location?.address2 ?? "",
            "full_address" : self.businessDetail?.location?.address3 ?? "",
            "floors" : self.businessDetail?.location?.pickElevatorFloor ?? "",
            "options" : self.businessDetail?.location?.pickOption ?? "",
            "aptInfo" : self.businessDetail?.location?.aptInfo ?? "",
            "pick_elevator_walk_both" : self.businessDetail?.location?.pick_elevator_walk_both ?? "",
            "notes": self.businessDetail?.additionalNotes ?? "",
            "place_name": (self.businessDetail?.name ?? "")
        ]
        
        let deliveryInfo : [String : Any] = [
            "longitude" : self.businessDetail?.dropAddress?.longitude ?? 0.0,
            "latitude" : self.businessDetail?.dropAddress?.latitude ?? 0.0,
            "address1" : self.businessDetail?.dropAddress?.address ?? "",
            "address2" : (self.businessDetail?.dropAddress?.address2 ?? ""),
            "full_address" : self.businessDetail?.dropAddress?.fullAddress ?? "",
            "floors" : self.businessDetail?.dropAddress?.elevatorFloor ?? "",
            "options" : self.businessDetail?.dropAddress?.dropPickupoptions ?? "",
            "aptInfo" : self.businessDetail?.dropAddress?.apartmentInfo ?? "",
            "pick_elevator_walk_both" : self.businessDetail?.dropAddress?.elevator_walk_both ?? "",
            "notes": self.businessDetail?.dropAddress?.notes ?? "",
            "place_name": businessDetail?.dropAddress?.placeName ?? ""
        ]
        
        let data : [String : Any] = [
            "order_id" : self.businessDetail?.orderID ?? "",
            "google_distance" : self.businessDetail?.distance ?? "",
            "google_duration" : self.businessDetail?.duration ?? "",
            "pickUpTime" : self.businessDetail?.pickUpTime ?? "",
            "image": self.businessDetail?.imageUrl ?? "",
            "isWebStore" : (self.businessDetail?.isWebStore ?? false) ? "1" : "0",
            "webStoreType" : self.businessDetail?.webStoreType ?? "",
            "name" : (self.businessDetail?.isReversedDel ?? false) ? (businessDetail?.dropAddress?.placeName ?? "") : (self.businessDetail?.name ?? ""),
            "category" : self.businessDetail?.category ?? "",
            "subTotalType" : self.businessDetail?.subTotalType ?? "",
            "cost" : self.businessDetail?.courialFee ?? "",
            "trasnport_mode" : selectedVehicleType,
            "is_closed" : (self.businessDetail?.isClosed ?? false) ? "1" : "0",
            "isFav" : (self.businessDetail?.isFav ?? false) ? "1" : "0",
            "url" : (self.businessDetail?.details?.website?.absoluteString ?? self.businessDetail?.url ?? ""),
            "over45Lbs" : (self.businessDetail?.over45Lbs ?? false) ? "1" : "0",
            "Courials" : (self.businessDetail?.two_courial ?? false) ? "1" : "0",
            "googlePlaceID" : self.businessDetail?.googlePlaceID ?? "",
            "item_name" : self.businessDetail?.itemDescription ?? "",
            "pick_up_notes" : (self.businessDetail?.isReversedDel ?? false) ? (self.businessDetail?.dropAddress?.notes ?? "") : (self.businessDetail?.additionalNotes ?? ""),
            "card_id": "\(userInfo.card_default?.internalIdentifier ?? 0)",
            "pickup_info": (self.businessDetail?.isReversedDel ?? false) ? deliveryInfo : pickUpInfo ,
            "delivery_info": (self.businessDetail?.isReversedDel ?? false) ?  pickUpInfo : deliveryInfo,
            
            "deliveryFee": self.businessDetail?.deliveryFee ?? "0.00",
            "baseFee": self.businessDetail?.baseFee ?? "0.00",
            "promo_discount" : self.businessDetail?.promoPrice ?? "0.00",
            "stairsElevatorFee": self.businessDetail?.stairsElevatorFee ?? "0.00",
            "heavyFee": self.businessDetail?.heavyFee ?? "0.00",
            "itemCost": self.businessDetail?.courialFee ?? "",
            "courialPayFee" : String(format: "%.02f", cpFee),
            "courial_tip": self.businessDetail?.courialTip ?? "0.00",
            "final_price": self.businessDetail?.totalFee ?? "",
            "estimated_time": self.businessDetail?.estimatedDeliveryTime ?? "1",
            "vehicleTypeIndex" : self.businessDetail?.itemCategory ?? "",
            "storePhone" : self.businessDetail?.displayPhone ?? "",
            "special_link" : self.businessDetail?.specialLink ?? "",
            "categoryImage" : categoryImage,
            "categoryImageColor" : categoryImageColor,
            
            "isSkill": (self.businessDetail?.isSkillService ?? false) ? "1" : "0",
            "estimatedServiceTime": self.businessDetail?.estimatedServiceTime ?? "0",
            "estimatedServiceOffer": self.businessDetail?.estimatedServiceOffer ?? "0"
        ]
        
        let params : Parameters = [
            "data": JSON(data).debugDescription,
            "type": self.isRepeat ? "1" : "0",
            "Identification": self.businessDetail?.identificationImageURL ?? "",
            "images": self.businessDetail?.attachedImagesURL?.joined(separator: ",") ?? "",
            "is_reversed_del" : (self.businessDetail?.isReversedDel ?? false) ? "1" : "0",
            
            "secondsFromGMT": "\(TimeZone.current.secondsFromGMT())",
            "timezoneID": TimeZone.current.identifier,
            "timezoneDate": "\(Date().timeIntervalSince1970)"
        ]
        
        var imgParams = [String]()
        for _ in 0..<(self.businessDetail?.attachedPhoto.count ?? 0){
            imgParams.append("image")
        }
        
        ApiInterface.multipleFileApi(params: params, api_url: API.placeorder, image: self.businessDetail?.attachedPhoto ?? [], imageName: imgParams, success: { (json) in
            hideLoader()
            
            currentOrderPoints?.removeAll()
            deleteOrderFlag = false
            let responseModel = CurrentOrderModel.init(json: json["data"])
            currentOrder = responseModel
            SocketBase.sharedInstance.placeOrder(currentOrder?.orderid ?? "")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FindingCourialVC") as! FindingCourialVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.action = {
                (self.tabBarController as? TabBarVC)?.checkOrder()
                self.tabBarController?.selectedIndex = 2
            }
            self.present(vc, animated: false, completion: nil)
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }

    func getCategoryImage(upload: Bool, success: @escaping(String, String)-> Void){
        var imgStr = "imgLocal-biz"
        var imgColor = "F1F2F3"
        let cat = (self.businessDetail?.category ?? "").lowercased()
        
        if self.businessDetail?.isWebStore == true{
            if let index = appUrls.firstIndex(where: {$0.name?.lowercased() == cat}){
                imgStr = (appUrls[index].image ?? "")
                imgColor = (appUrls[index].hex ?? "")
            } else if self.businessDetail?.showIDWarning == true{
                imgStr = self.businessDetail?.imageUrl ?? ""
                imgColor = "clear"
            }else{
                imgStr = "imgLocal-biz"
                imgColor = "F1F2F3"
            }
        }else if self.businessDetail?.isSkillService == true{
            if let index = appSpecialCategories.arrayValue.firstIndex(where: {$0["category"].stringValue.lowercased() == cat}){
                imgStr = (appSpecialCategories[index]["icon"].stringValue)
                imgColor = (appSpecialCategories[index]["hex"].stringValue)
            } else{
                imgStr = "imgLocal-biz"
                imgColor = "F1F2F3"
            }
        }else if cat == "special"{
            imgStr = (specialCat["icon"].stringValue)
            imgColor = (specialCat["hex"].stringValue)
        }else{
            if let storeImage = self.businessDetail?.imageUrl{
                imgStr = storeImage
                imgColor = "clear"
            }else if let index = appCategories.arrayValue.firstIndex(where: {$0["category"].stringValue.lowercased() == cat}){
                imgStr = (appCategories[index]["icon"].stringValue)
                imgColor = (appCategories[index]["hex"].stringValue)
            } else{
                imgStr = "imgLocal-biz"
                imgColor = "F1F2F3"
            }
        }
        
        guard upload else {
            success(imgStr, imgColor)
            return
        }
        
        self.uploadSpecialImage(imgStr) { (categoryImage) in
            success(categoryImage, imgColor)
        }
    }
    
    
    func uploadSpecialImage(_ imgString: String, success: @escaping(String)-> Void){
        guard let img = UIImage(named: imgString) else{
            success(imgString)
            return
        }
        img.accessibilityHint = "png"
        ApiInterface.formDataApi(params: [:], api_url: API.upload_image, image: img, imageName: "image", success: { (json) in
            success(json["data"]["image"].stringValue)
        }) { (error, json) in
            success(imgString)
        }
    }
    
    func getTollFee(){
//        guard self.businessDetail?.isSkillService == false else {
            self.businessDetail?.tollFee = 0
            self.tollView.isHidden = true
//            return
//        }
//
//        let selectedVehicleType = self.vehicleTypes[self.businessDetail?.vehicleTypeIndex ?? 0]
//
//        MapHelper.sharedInstance.caluclateTollFee(from: (self.businessDetail?.location?.address3 ?? ""), to: (self.businessDetail?.dropAddress?.fullAddress ?? ""), vehicle: selectedVehicleType) { (tollFee) in
//            self.businessDetail?.tollFee = tollFee
//            self.tollValue.text = "$" + String(format: "%.02f", tollFee)
//            self.tollView.isHidden = (tollFee == 0) ? true : false
//        }
    }
    
}

extension QueueDeliveryDetailVC : ExpandableLabelDelegate{
    
    func setupNotes(){
        let attributedString = NSMutableAttributedString(string: "read more", attributes: [
            .font: UIFont(name: "Roboto-Medium", size: 14.0)!,
            .foregroundColor: appColor,
        ])
        
        self.pickNotes.numberOfLines = 6
        self.pickNotes.collapsedAttributedLink = attributedString
        self.pickNotes.ellipsis = NSAttributedString(string: "...")
        // update label expand or collapse state
        self.pickNotes.collapsed = true
        self.pickNotes.delegate = self
        self.pickNotes.forceTextAlignment = .left
        
        self.dropNotes.numberOfLines = 1
        self.dropNotes.collapsedAttributedLink = attributedString
        self.dropNotes.ellipsis = NSAttributedString(string: "...")
        // update label expand or collapse state
        self.dropNotes.collapsed = true
        self.dropNotes.delegate = self
        self.dropNotes.forceTextAlignment = .center
    }
    
    func willExpandLabel(_ label: ExpandableLabel) {
        let notesView = NotesView.init(frame: screenFrame(), data: (label.expandedText?.string ?? "").components(separatedBy: " • " ).last ?? "", title: (label == self.pickNotes) ? "Pickup Notes" : "Delivery Notes")
        self.view.addSubview(notesView)
        label.collapsed = true
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        label.collapsed = true
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
    }
    
}
