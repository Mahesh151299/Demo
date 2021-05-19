//
//  FinalReceiptVC.swift
//  Courail
//
//  Created by Omeesh Sharma on 24/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class FinalReceiptVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var headerTtle: UILabel!
    @IBOutlet weak var orderNo: UILabel!
    
    @IBOutlet weak var currentOrderDetailView: UIView!
    @IBOutlet weak var feeTable: UITableView!
    @IBOutlet weak var feeTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var pickUpTime: UILabel!
    
    @IBOutlet weak var dropAddress: UILabel!
    @IBOutlet weak var dropNotes: ExpandableLabel!
    @IBOutlet weak var dropAddressView: UIView!
    
    @IBOutlet weak var specialServiceView: UIView!
    
    @IBOutlet weak var pickName: UILabel!
    @IBOutlet weak var pickAddress: UILabel!
    @IBOutlet weak var pickAddress2: UILabel!
    @IBOutlet weak var pickApt: UILabel!
    @IBOutlet weak var pickNotes: ExpandableLabel!
    
    @IBOutlet weak var iconBgView: UIViewCustomClass!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryIconHeight: NSLayoutConstraint!
    
    @IBOutlet weak var transportIcon: UIImageView!
    
    @IBOutlet weak var collectionLineView: UIView!
    @IBOutlet weak var collectionImages: UICollectionView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDetails: UILabel!
    
    @IBOutlet weak var cardNo: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var paidAmount: UILabel!
    
    @IBOutlet weak var specialInstructionView: UIView!
    //MARK: VARIABLES
    var photoBrowser = SKPhotoBrowser()
    
    let vehicleTypes = ["Walker","Bicycle","E-Scooter","Moped","Motorcycle","Car","Pickup","Van","Truck","Tow Truck"]
    let transportImg =  [#imageLiteral(resourceName: "imgWalking"),#imageLiteral(resourceName: "imgBike"),#imageLiteral(resourceName: "imgE-scooter"),#imageLiteral(resourceName: "imgMoped"),#imageLiteral(resourceName: "imgMotorcycle"),#imageLiteral(resourceName: "imgCar"),#imageLiteral(resourceName: "imgPickup"),#imageLiteral(resourceName: "imgVan"),#imageLiteral(resourceName: "imgTruck") ,#imageLiteral(resourceName: "imgTowTruck")]
    
    var orderDetail = CurrentOrderModel.init(json: JSON())
    
    var fares = JSON([
        [
            "title":"Delivery Fee",
            "value" :"0.00",
            "type" : ""
        ],
        [
            "title":"Base Fee",
            "value" :"0.00",
            "type" : "sub"
        ],
        [
            "title":"Offer Price",
            "value" :"0.00",
            "type" : "sub"
        ],
        [
            "title":"Discount / Promo",
            "value" :"0.00",
            "type" : "sub"
        ],
        [
            "title":"Effort",
            "value" :"0.00",
            "type" : "sub"
        ],
        [
            "title":"Heavy",
            "value" :"0.00",
            "type" : "sub"
        ],
        [
            "title":"Wait Time",
            "value" :"0.00",
            "type" : "sub"
        ],
        [
            "title":"Item Cost",
            "value" :"0.00",
            "type" : "(Paid by Courial)"
        ],
        [
            "title":"Courial Pay Fee",
            "value" :"0.00",
            "type" : "(5%)",
        ],
        [
            "title":"Courial Tip",
            "value" :"0.00",
            "type" : ""
        ],
        [
            "title":"TOTAL COST",
            "value" :"0.00",
            "type" : "TOTAL"
        ]
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadFeeData()
        
        self.setupNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBarController?.tabBar.isHidden = true
        
        self.orderNo.text = "ORDER#" + (orderDetail.orderid ?? "")
        
        let str = isLoggedIn() ? ((userInfo.firstName ?? "") + "'s") : "Your"
        self.headerTtle.text = str + " Receipt"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func backBtn(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func specialInstructionBtn(_ sender: UIButton) {
        if let url = URL(string: orderDetail.specialLink ?? ""), !url.absoluteString.isEmpty, (UIApplication.shared.canOpenURL(url)) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            showSwiftyAlert("", "Sorry! We are not able to open this page.", false)
        }
    }
    
    
    func loadFeeData(){
        let cp = JSON(orderDetail.itemCost ?? "0.00").doubleValue
        let cpFee = cp  * 0.05
        let discount = JSON(orderDetail.promoDiscount ?? "0.00").doubleValue
        
        let pickWaitCharges = JSON(orderDetail.pickupWaitCharges ?? "0.00").doubleValue
        let DropWaitCharges = JSON(orderDetail.dropOffWaitCharges ?? "0.00").doubleValue
        let waitCharges = abs(pickWaitCharges) + abs(DropWaitCharges)
        
        //Delivery Fee
        let deliveryFee = (JSON(orderDetail.deliveryFee ?? "0.00").doubleValue - discount) + waitCharges
        self.fares[0]["value"].stringValue = String(format: "%.02f", deliveryFee)
        
        //Base Fare
        let baseFee = JSON(orderDetail.baseFee ?? "0.00").doubleValue
        self.fares[1]["value"].stringValue = String(format: "%.02f", baseFee)
        
        //Offer Price
        let offerPrice = JSON(orderDetail.estimatedServiceOffer ?? "0.00").doubleValue
        self.fares[2]["value"].stringValue = String(format: "%.02f", offerPrice)
        
        //Discount
        self.fares[3]["value"].stringValue = String(format: "%.02f", discount)
        
        //Stairs/Elevator
        self.fares[4]["value"].stringValue = orderDetail.stairsElevatorFee ?? "0.00"
        
        //Heavy
        self.fares[5]["value"].stringValue = orderDetail.heavyFee ?? "0.00"
        
        //Wait Time
        self.fares[6]["value"].stringValue = String(format: "%.02f", waitCharges)
        
        //Item Cost //Courial Pay Fee
        if orderDetail.subTotalType == "COURIAL PAYS"{
            self.fares[7]["type"].stringValue = "(Paid by Courial)"
            self.fares[7]["value"].stringValue = (orderDetail.itemCost ?? "0.00")
            
            //Courial Pay Fee
            self.fares[8]["value"].stringValue = String(format: "%.02f", cpFee)
        } else{
            self.fares[7]["type"].stringValue = "(Pre-Paid)"
            self.fares[7]["value"].stringValue = "0.00"
            
            //Courial Pay Fee
            self.fares[8]["value"].stringValue = "0.00"
        }
        
        //Tip
        let courialTip = JSON(orderDetail.courialTip ?? "0.00").doubleValue
        self.fares[9]["value"].stringValue = String(format: "%.02f", courialTip)
        
        //Total
        let totalAmount = deliveryFee  + cp + cpFee + courialTip
        self.fares[10]["value"].stringValue = String(format: "%.02f", totalAmount)
        
        if JSON(orderDetail.isSkill ?? "0").boolValue == true{
            self.fares[6]["title"].stringValue = "Additional Time"
            
            self.fares[0]["title"].stringValue = "Service Fee"
            let skillBaseFee = JSON(orderDetail.baseFee ?? "0.00").doubleValue
            self.fares[1]["value"].stringValue = String(format: "%.02f", skillBaseFee)
            
            self.fares = JSON(self.fares.arrayValue.filter({($0["value"].doubleValue != 0) || ($0["title"].stringValue.contains("Delivery Fee") == true) || ($0["title"].stringValue.contains("TOTAL COST") == true) || ($0["title"].stringValue.contains("Service Fee") == true) }))
        }else{
            self.fares = JSON(self.fares.arrayValue.filter({($0["value"].doubleValue != 0) || ($0["title"].stringValue.contains("Item Cost") == true) || ($0["title"].stringValue.contains("Delivery Fee") == true) || ($0["title"].stringValue.contains("TOTAL COST") == true) || ($0["title"].stringValue.contains("Service Fee") == true)}))
        }
        
        self.feeTable.reloadData()
        self.loadData()
    }
    
    func loadData(){
        self.setupNotes()
        
        var status = "COMPLETED "
        switch JSON(orderDetail.status ?? "0").intValue{
        case 7:
            //Cancelled
            status = "CANCELLED "
            
            let cancelAmount = String(format: "%.02f", orderDetail.cancelAmount ?? 0.0)
            self.paidAmount.text = "$" + cancelAmount
        case 8:
            //Cancelled
            status = "NO RESPONSE "
            
            let cancelAmount = String(format: "%.02f", orderDetail.cancelAmount ?? 0.0)
            self.paidAmount.text = "$" + cancelAmount
            
        default:
            status = "COMPLETED "
            if let totalAmount = self.fares.arrayValue.filter({($0["title"].stringValue == "TOTAL COST")}).first{
                self.paidAmount.text = "$" + JSON(totalAmount)["value"].stringValue
            }else{
                self.paidAmount.text = "$0.00"
            }
            
        }
        
        if (orderDetail.delivery_complete_date ?? "") != ""{
            self.pickUpTime.text = status + (orderDetail.delivery_complete_date ?? "").convertStamp(format: "dd, MMM, hh:mm a", timeZone: .current)
        }else{
            self.pickUpTime.text = status + "\(orderDetail.updatedAt ?? 0)".convertStamp(format: "dd, MMM, hh:mm a", timeZone: .current)
        }
        
        let cardType = orderDetail.card_type ?? userInfo.card_default?.cardType ?? ""
        let cardNo = orderDetail.card_number ?? userInfo.card_default?.cardNumber ?? ""
        
        self.cardImage.image = UIImage(named: cardType.lowercased()) ?? UIImage(named: "ccardbck")
        
        let cardLast = cardNo.suffix(4)
        self.cardNo.text = cardNameAbb(name: cardType) + " " + cardLast
        
        self.itemName.text = orderDetail.itemName?.uppercased()
        self.specialInstructionView.isHidden = ((orderDetail.specialLink ?? "") == "") ? true : false
        
        self.categoryImage.sd_setImage(with: URL(string: (orderDetail.categoryImage ?? "")), placeholderImage: UIImage(named: "imgNoLogo"))
        self.iconBgView.backgroundColor = hexStringToUIColor(hex: (orderDetail.categoryImageColor ?? ""))
        self.categoryImage.layer.cornerRadius = self.iconBgView.layer.cornerRadius
        self.categoryImage.clipsToBounds = true
        
        if (orderDetail.categoryImageColor ?? "") == "clear"{
            self.categoryImage.contentMode = .scaleAspectFill
            self.categoryIconHeight.constant = 0
        } else{
            self.categoryImage.contentMode = .scaleAspectFit
            self.categoryIconHeight.constant = -10
        }
        
        self.collectionImages.delegate = self
        self.collectionImages.dataSource = self
        
        let identificationImage = (orderDetail.identificationImage ?? "") == "" ? 0 : 1
        let courialReceipt = (orderDetail.actualCourialPayReceipt ?? "") == "" ? 0 : 1
        let deliveryPhoto = (orderDetail.takeDeliveryPhoto ?? "") == "" ? 0 : 1
        
        let additionalPhotos = identificationImage + courialReceipt + deliveryPhoto
        
        if ((orderDetail.orderimages?.count ?? 0) + additionalPhotos) == 0{
            self.collectionImages.isHidden = true
            self.collectionLineView.isHidden = true
        } else{
            self.collectionImages.isHidden = false
            self.collectionLineView.isHidden = false
        }
        
        let vehicleTypeIndex = self.vehicleTypes.firstIndex(where: {$0 == orderDetail.provider?.transport ?? orderDetail.trasnportMode}) ?? 0
        self.transportIcon.image = self.transportImg[vehicleTypeIndex]
        
        
        if JSON(orderDetail.isSkill ?? "0").boolValue{
            self.specialServiceView.isHidden = false
            
            self.dropAddressView.isHidden = true
            
            self.pickName.text = orderDetail.deliveryInfo?.placeName ?? ""
            
            var options = DeliveryAddressInterface.shared.addressOptions(isDelivery: true, model: orderDetail, type: 0)
            options = (options == "") ? "" : (options + " • ")
            
            var notes = (orderDetail.deliveryInfo?.notes ?? "")
            notes = (notes == "") ? "No notes" : notes
            self.pickNotes.text = options + notes
            
            let address1 = (orderDetail.deliveryInfo?.address1 ?? "")
            let address2 = (orderDetail.deliveryInfo?.address2 ?? "")
            
            var aptInfo = orderDetail.deliveryInfo?.aptInfo ?? ""
            aptInfo = (aptInfo == "") ? "" : ("• " + aptInfo)
            self.pickApt.text = aptInfo
            
            self.pickAddress.text = address1
            self.pickAddress2.text = address2
            
            let floors = DeliveryAddressInterface.shared.addressOptions(isDelivery: true, model: orderDetail, type: 1)
            self.itemDetails.text = self.getItemDetails(floors: floors)
            self.itemDetails.isHidden = ((self.itemDetails.text ?? "") == "") ? true : false
            
        }else{
            self.specialServiceView.isHidden = true
                        
            self.pickName.text = orderDetail.pickupInfo?.placeName ?? ""
            
            var options = DeliveryAddressInterface.shared.addressOptions(isDelivery: false, model: orderDetail, type: 0)
            options = (options == "") ? "" : (options + " • ")
            
            var notes = (orderDetail.pickupInfo?.notes ?? "")
            notes = (notes == "") ? "No notes" : notes
            self.pickNotes.text = options + notes
            
            let address = orderDetail.pickupInfo
            var aptInfo = address?.aptInfo ?? ""
            aptInfo = (aptInfo == "") ? "" : ("• " + aptInfo)
            self.pickApt.text = aptInfo
            self.pickAddress.text = (address?.address1 ?? "")
            self.pickAddress2.text = (address?.address2 ?? "")
            
            self.dropAddressView.isHidden = false
            
            let dropAddress1 = (orderDetail.deliveryInfo?.address1 ?? "")
            let dropAddress2 = (orderDetail.deliveryInfo?.address2 ?? "")
            
            var dropAptInfo = orderDetail.deliveryInfo?.aptInfo ?? ""
                dropAptInfo = (dropAptInfo == "") ? "" : (" • " + dropAptInfo)
            self.dropAddress.text = dropAddress1 + dropAptInfo
            
            var dropOptions = DeliveryAddressInterface.shared.addressOptions(isDelivery: true, model: orderDetail, type: 0)
            dropOptions = (dropOptions == "") ? "" : (dropOptions + " • ")
            
            var dropNotes = (orderDetail.deliveryInfo?.notes ?? "")
            dropNotes = (dropNotes == "") ? "No notes" : dropNotes
            self.dropNotes.text = dropOptions + dropNotes
            
            
            let floors = DeliveryAddressInterface.shared.addressOptions(isDelivery: false, model: orderDetail, type: 1)
            self.itemDetails.text = self.getItemDetails(floors: floors)
            self.itemDetails.isHidden = ((self.itemDetails.text ?? "") == "") ? true : false
        }
        
        
    }
    
    
    func getOrderTotalAmount()-> Double{
        let cp = JSON(orderDetail.itemCost ?? "0.00").doubleValue
        let cpFee = cp  * 0.05
        let discount = JSON(orderDetail.promoDiscount ?? "0.00").doubleValue
        
        let pickWaitCharges = JSON(orderDetail.pickupWaitCharges ?? "0.00").doubleValue
        let DropWaitCharges = JSON(orderDetail.dropOffWaitCharges ?? "0.00").doubleValue
        let waitCharges = pickWaitCharges + DropWaitCharges
        
        //Delivery Fee
        let deliveryFee = (JSON(orderDetail.deliveryFee ?? "0.00").doubleValue - discount) + waitCharges
        
        //Tip
        let courialTip = JSON(orderDetail.courialTip ?? "0.00").doubleValue
        
        //Total
        let totalAmount = deliveryFee  + cp + cpFee + courialTip
        return totalAmount
    }
}

extension FinalReceiptVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fares.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = self.fares[indexPath.row]["title"].stringValue
        let value = self.fares[indexPath.row]["value"].stringValue
        let type = self.fares[indexPath.row]["type"].stringValue
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "TotalCell", for: indexPath) as! DeliveryDetailTVC
        
        switch type{
        case "TOTAL":
            cell = tableView.dequeueReusableCell(withIdentifier: "TotalCell", for: indexPath) as! DeliveryDetailTVC
        case "sub":
            cell = tableView.dequeueReusableCell(withIdentifier: "SubCell", for: indexPath) as! DeliveryDetailTVC
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "FeeCell", for: indexPath) as! DeliveryDetailTVC
            cell.feeType.text = type
        }
        
        cell.feeTitle.text = title
        
        if (Double(value) ?? 0) != 0{
            if title == "Discount / Promo"{
                cell.feeValue.text = "-$" + value
            } else{
                cell.feeValue.text = "$" + value
            }
        }else{
            cell.feeValue.text = "$" + value
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


extension FinalReceiptVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (orderDetail.orderimages?.count ?? 0)
        case 1:
            return (orderDetail.identificationImage ?? "") == "" ? 0 : 1
        case 2:
            return (orderDetail.actualCourialPayReceipt ?? "") == "" ? 0 : 1
        case 3:
            return (orderDetail.takeDeliveryPhoto ?? "") == "" ? 0 : 1
        default:
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImagesCVC", for: indexPath) as! AddImagesCVC
        
        switch indexPath.section{
        case 0:
            if orderDetail.vehicleTypeIndex?.lowercased() == "pharmacy"{
                cell.title.text = "VIEW PRESCRIPTION"
                cell.title.textColor = .darkGray
                
                let imgStr = orderDetail.orderimages?[indexPath.row].image ?? ""
                cell.attachedImage.sd_setImage(with: URL(string: imgStr), placeholderImage: nil, options: [], context: nil)
            } else{
                cell.title.text = "VIEW IMAGE"
                cell.title.textColor = .darkGray
                
                let imgStr = orderDetail.orderimages?[indexPath.row].image ?? ""
                cell.attachedImage.sd_setImage(with: URL(string: imgStr), placeholderImage: nil, options: [], context: nil)
            }
        case 1:
            cell.title.text = "VIEW PHOTO ID"
            cell.title.textColor = appColorBlue
            cell.attachedImage.sd_setImage(with: URL(string: orderDetail.identificationImage ?? ""), placeholderImage: nil, options: [], context: nil)
            
        case 2:
            cell.title.text = "VIEW RECEIPT"
            cell.title.textColor = appColorBlue
            cell.attachedImage.sd_setImage(with: URL(string: orderDetail.actualCourialPayReceipt ?? ""), placeholderImage: nil, options: [], context: nil)
            
        case 3:
            cell.title.text = "VIEW DELIVERY\nPHOTO"
            cell.title.textColor = appColorBlue
            cell.attachedImage.sd_setImage(with: URL(string: orderDetail.takeDeliveryPhoto ?? ""), placeholderImage: nil, options: [], context: nil)
            
        default:
            cell.title.text = "VIEW IMAGE"
            cell.title.textColor = appColorBlue
            cell.attachedImage.sd_setImage(with: URL(string: ""), placeholderImage: nil, options: [], context: nil)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let attachedCount = collectionView.numberOfItems(inSection: 0) + collectionView.numberOfItems(inSection: 1) + collectionView.numberOfItems(inSection: 2) + collectionView.numberOfItems(inSection: 3)
        
        guard attachedCount != 1 else{
            return .init(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        switch section {
        case 1:
            let prevSectionCount = collectionView.numberOfItems(inSection: 0)
            if prevSectionCount == 0{
                return .init(top: 0, left: 0, bottom: 0, right: 0)
            }else{
                return .init(top: 0, left: 5, bottom: 0, right: 0)
            }
        case 2:
            let prevSectionCount = collectionView.numberOfItems(inSection: 0) + collectionView.numberOfItems(inSection: 1)
            if prevSectionCount == 0{
                return .init(top: 0, left: 0, bottom: 0, right: 0)
            }else{
                return .init(top: 0, left: 5, bottom: 0, right: 0)
            }
        case 3:
            let prevSectionCount = collectionView.numberOfItems(inSection: 0) + collectionView.numberOfItems(inSection: 1) + collectionView.numberOfItems(inSection: 2)
            if prevSectionCount == 0{
                return .init(top: 0, left: 0, bottom: 0, right: 0)
            }else{
                return .init(top: 0, left: 5, bottom: 0, right: 0)
            }
        default:
            return .init(top: 0, left: 0, bottom: 0, right: 0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let attachedCount = collectionView.numberOfItems(inSection: 0) + collectionView.numberOfItems(inSection: 1) + collectionView.numberOfItems(inSection: 2) + collectionView.numberOfItems(inSection: 3)
        
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
        
        switch indexPath.section{
        case 0:
            photo = SKPhoto.photoWithImageURL(orderDetail.orderimages?[indexPath.row].image ?? "")
        case 1:
            photo = SKPhoto.photoWithImageURL(orderDetail.identificationImage ?? "")
        case 2:
            photo = SKPhoto.photoWithImageURL(orderDetail.actualCourialPayReceipt ?? "")
        default:
            photo = SKPhoto.photoWithImageURL(orderDetail.takeDeliveryPhoto ?? "")
        }
        
        self.photoBrowser = SKPhotoBrowser(photos: [photo])
        super.present(self.photoBrowser, animated: true, completion: nil)
    }
    
    func openDeliveryPhoto(){
        guard orderDetail.takeDeliveryPhoto != "" else {return}
        let photo = SKPhoto.photoWithImageURL(orderDetail.takeDeliveryPhoto ?? "")
        self.photoBrowser = SKPhotoBrowser(photos: [photo])
        super.present(self.photoBrowser, animated: true, completion: nil)
    }
    
}

extension FinalReceiptVC {
    
    func getItemDetails(floors: String)-> String{
        guard JSON(orderDetail.isSkill ?? "0").boolValue == false else{
            var time = orderDetail.estimatedServiceTime ?? ""
            time = time + " Min Service"
            
            let value = [time,floors].filter({$0 != ""}).joined(separator: " • ")
            return value
        }
        
        let twoCourial =  JSON(orderDetail.twoCourials ?? "0").boolValue ? "Two Courials" : ""
        let over45Lbs =  JSON(orderDetail.over45Lbs ?? "0").boolValue ? "Over 45 lbs" : ""
        
        var idRequired = ""
        if orderDetail.identificationImage != ""{
            idRequired = "ID Required"
        }
        
        var value = [twoCourial,over45Lbs,idRequired,floors].filter({$0 != ""})
        if value.count > 3{
            value = [over45Lbs,idRequired,floors].filter({$0 != ""})
        }
        
        return value.joined(separator: " • ")
        
    }
    
}


extension FinalReceiptVC : ExpandableLabelDelegate{
    
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
