//
//  CurrentOrderVC.swift
//  Courail
//
//  Created by mac on 10/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import CoreLocation
import MapKit
import DZNEmptyDataSet
import SwiftGifOrigin


class CompletedDeliveryTVC: UITableViewCell {
    
    @IBOutlet weak var StoreName: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var againBtn: UIButton!
    @IBOutlet weak var receiptBtn: UIButton!
    @IBOutlet weak var status: UILabel!
    
}

class CurrentOrderVC: UIViewController, UITextFieldDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var emptyBoxIcon: UIImageView!
    @IBOutlet weak var emptyTitleTop: NSLayoutConstraint!
    
    @IBOutlet weak var headerTtle: UILabel!
    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var completedBtnOut: UIButtonCustomClass!
    @IBOutlet weak var currentBtnOut: UIButtonCustomClass!
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var helpBtnOut: UIButton!
    @IBOutlet weak var noOrderView: UIView!
    
    @IBOutlet weak var currentOrderDetailView: UIView!
    @IBOutlet weak var feeTable: UITableView!
    @IBOutlet weak var feeTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var pickUpTime: UILabel!
    @IBOutlet weak var editTimeBtnView: UIView!
    
    @IBOutlet weak var dropArrowView: UIView!
    @IBOutlet weak var dropArrowHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var dropAddress: UILabel!
    @IBOutlet weak var dropNotes: ExpandableLabel!
    @IBOutlet weak var dropAddressView: UIView!
    
    @IBOutlet weak var specialServiceView: UIView!
    
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
    
    @IBOutlet weak var collectionLineView: UIView!
    @IBOutlet weak var collectionImages: UICollectionView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDetails: UILabel!
    
    @IBOutlet weak var editAddressView: UIImageView!
    
    @IBOutlet weak var updateCourialPayView: UIView!
    @IBOutlet weak var updateCourialPayFieldView: UIView!
    @IBOutlet weak var updateCourialPayField: UITextField!
    
    @IBOutlet weak var transportBtnOut: UIButton!
    @IBOutlet weak var sendPaymentBtnOut: UIButton!
    
    @IBOutlet weak var specialInstructionView: UIView!
    //MARK: VARIABLES
    
    var photoBrowser = SKPhotoBrowser()
    var grayColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
    
    let vehicleTypes = ["Walker","Bicycle","E-Scooter","Moped","Motorcycle","Car","Pickup","Van","Truck","Tow Truck"]
    let transportImg =  [#imageLiteral(resourceName: "imgWalking"),#imageLiteral(resourceName: "imgBike"),#imageLiteral(resourceName: "imgE-scooter"),#imageLiteral(resourceName: "imgMoped"),#imageLiteral(resourceName: "imgMotorcycle"),#imageLiteral(resourceName: "imgCar"),#imageLiteral(resourceName: "imgPickup"),#imageLiteral(resourceName: "imgVan"),#imageLiteral(resourceName: "imgTruck") ,#imageLiteral(resourceName: "imgTowTruck")]
    
    var completedOrders = [CurrentOrderModel]()
    
    var currentOrderVC : CD_SeeDetailVC?
    
    var isFinalReceipt = false
    
    var isChangeAddress = false
    var isChangeTime = false
    
    var transportChange = false
    
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
    
    var type = 1{
        didSet{
            if self.type == 0{
                self.completedBtnOut.backgroundColor = appColor
                self.currentBtnOut.backgroundColor = grayColor
                self.noOrderView.isHidden = true
                self.currentOrderDetailView.isHidden = true
                self.table.isHidden = false
                self.helpBtnOut.isHidden = true
                
                
            } else{
                self.completedBtnOut.backgroundColor = grayColor
                self.currentBtnOut.backgroundColor = appColor
                if currentOrder == nil{
                    self.currentOrderDetailView.isHidden = true
                    self.noOrderView.isHidden = false
                    self.table.isHidden = true
                    self.helpBtnOut.isHidden = true
                    
                    self.emptyBoxIcon.image = UIImage.gif(name: "emptyBox")
                    
                    if UIScreen.main.bounds.height < 800{
                        self.emptyTitleTop.constant = 20
                    }
                } else{
                    self.currentOrderDetailView.isHidden = false
                    self.noOrderView.isHidden = true
                    self.table.isHidden = false
                    
                    if self.isFinalReceipt{
                        self.helpBtnOut.isHidden = true
                    } else{
                        self.helpBtnOut.isHidden = false
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.tableFooterView = UIView()
        
        self.type = 1
        self.loadFeeData()
        currentOrderDelchange = false
        
        self.updateCourialPayField.delegate = self
        self.updateCourialPayField.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .editingChanged)
        
        if self.isChangeAddress{
            self.isChangeAddress = false
            self.editDeliveryAddress(UIButton())
        }else if self.isChangeTime{
            self.isChangeTime = false
            DispatchQueue.main.async {
                self.editPickUpTime(UIButton())
            }
        }
        
        self.setupNotes()
        
        self.transportBtnOut.addTarget(self, action: #selector(self.transportBtnDoubleTap(_:event:)), for: .touchDownRepeat)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.iconBgView.addShadowsRadius()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentOrderDelchange = false
        
        if let mapVc = self.navigationController?.viewControllers.last(where: {($0 as? CD_SeeDetailVC) != nil}){
            SocketBase.sharedInstance.delegate = (mapVc as? CD_SeeDetailVC)
        }
        
        //Remove observer
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(NSNotification.Name("updateCurrentOrder"))
        
        // add notification observers
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: NSNotification.Name("updateCurrentOrder"), object: nil)
        
        if let vc = self.navigationController?.viewControllers.last(where: {($0 as? CD_SeeDetailVC) != nil}){
            self.currentOrderVC = (vc as? CD_SeeDetailVC)
            if (self.currentOrderVC?.endCallView.isHidden ?? true) == false{
                self.tabBarController?.tabBar.isHidden = true
            } else{
                self.tabBarController?.tabBar.isHidden = false
            }
        }
        
        if self.isFinalReceipt{
            self.tabBarController?.tabBar.isHidden = true
        }
        
        self.navigationController?.view.setNeedsLayout()
        self.orderNo.text = "Order #" + (currentOrder?.orderid ?? "")
        
        let str = isLoggedIn() ? ((userInfo.firstName ?? "") + "'s") : "Your"
        self.headerTtle.text = str + " Orders"
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SocketBase.sharedInstance.delegate = nil
        
        //Remove observer
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(NSNotification.Name("updateCurrentOrder"))
    }
    
    @objc func refreshData(){
        self.resetData()
        self.loadFeeData()
    }
    
    //MARK:- BUTTONS ACTIONS
    @objc func transportBtnDoubleTap(_ sender: UIButton , event: UIEvent) {
        guard currentOrder?.status == orderStatus.pending else {return}
        guard (currentOrder?.category ?? "").lowercased() != "towing" else {return}
        guard let touch: UITouch = event.allTouches?.first , (touch.tapCount == 2) else { return }
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.view.setNeedsLayout()
        
        let transportPopup = TransportView(frame: screenFrame(), vehicle: currentOrder?.trasnportMode ?? "" , isSkill: JSON(currentOrder?.isSkill ?? "0").boolValue , category : currentOrder?.category ?? "", over45: JSON(currentOrder?.over45Lbs ?? "0").boolValue, twoCourial: JSON(currentOrder?.twoCourials ?? "0").boolValue) { (vehicle, over45, twoCourial) in
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.view.setNeedsLayout()
            
            guard vehicle != "" else { return }
            guard currentOrder?.status == orderStatus.pending else {return}
            
            currentOrder?.trasnportMode = vehicle
            if JSON(currentOrder?.isSkill ?? "0").boolValue == false{
                currentOrder?.over45Lbs = over45 ? "1" : "0"
                currentOrder?.twoCourials = twoCourial ? "1" : "0"
                self.getDeliveryFee()
            }else{
                self.loadData()
                SocketBase.sharedInstance.editOrder("4")
            }
            
            
        }
        self.view.addSubview(transportPopup)

    }
    
    @IBAction func helpBtn(_ sender: UIButton) {
        guard (self.currentOrderVC?.endCallView.isHidden ?? true) == true else {
            showSwiftyAlert("", "Please End Call to continue", false)
            return
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "OrderHelpVC") as! OrderHelpVC
        vc.modalPresentationStyle = .overCurrentContext
        self.view.addSubview(vc.view)
        self.addChild(vc)
    }
    
    @IBAction func completedBtn(_ sender:UIButton){
        guard (self.currentOrderVC?.endCallView.isHidden ?? true) == true else {
            showSwiftyAlert("", "Please End Call to continue", false)
            return
        }
        
        self.type = 0
        if isLoggedIn(){
            self.getCompletedOrder()
        }
        
    }
    
    @IBAction func currentBtn(_ sender:UIButton){
        self.type = 1
    }
    
    @IBAction func scheduleBtn(_ sender: UIButton) {
        GoToHome()
    }
    
    @IBAction func updateCourialPayBtn(_ sender: UIButton) {
        self.updateCourialPayView.isHidden = true
        self.updateCourialPayFieldView.isHidden = false
    }
    
    @IBAction func sendPaymentBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        self.updateCourialPayView.isHidden = true
        self.updateCourialPayFieldView.isHidden = true
        self.sendPaymentBtnOut.isHidden = true
        
        let itemCost = JSON(self.updateCourialPayField.text ?? "0.00").doubleValue
        let newCPFee = itemCost  * 0.05
        
        SocketBase.sharedInstance.updateCpurialPay(self.updateCourialPayField.text!, newCPFee: String(format: "%.02f", newCPFee), newSubtotalType: "COURIAL PAYS")
        
        currentOrder?.updateitemcost = 1
        currentOrder?.itemCost = self.updateCourialPayField.text!
        currentOrder?.courialPayFee = String(format: "%.02f", newCPFee)
        currentOrder?.subTotalType = "COURIAL PAYS"
        
        self.refreshData()
    }
    
    @objc func textFieldChanged(_ sender: UITextField){
//        if sender.text?.isEmpty == true{
//            self.sendPaymentBtnOut.isHidden = true
//        }else{
//            self.sendPaymentBtnOut.isHidden = false
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if JSON(textField.text!).doubleValue > 200 {
            textField.text = "200.00"
            textField.placeholder = "0000.00"
            self.sendPaymentBtnOut.isHidden = false
            showSwiftyAlert("", "Enter an amount between $1.00 and $200.00", false)
        } else if textField.text?.isEmpty == true{
            textField.text = ""
            textField.placeholder = "0000.00"
            self.sendPaymentBtnOut.isHidden = true
        } else{
            textField.text = String(format: "%.02f", JSON(textField.text!).doubleValue)
            textField.placeholder = "00"
            self.sendPaymentBtnOut.isHidden = false
        }
    }
    
    
    @objc func receiptBtn(_ sender:UIButton){
        DispatchQueue.main.async {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let receiptVC = storyboard.instantiateViewController(withIdentifier: "FinalReceiptVC")as! FinalReceiptVC
            receiptVC.orderDetail = self.completedOrders[sender.tag]
            receiptVC.modalPresentationStyle = .overFullScreen
            rootVC?.present(receiptVC, animated: true, completion: nil)
        }
    }
    
    @objc func doItAgain(_ sender:UIButton){
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
        self.generateOrderID(index: sender.tag)
    }
    
    @IBAction func trackBtn(_ sender:UIButton){
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func editPickUpTime(_ sender:UIButton){
        guard (self.currentOrderVC?.endCallView.isHidden ?? true) == true else {
            showSwiftyAlert("", "Please End Call to continue", false)
            return
        }
        
        switch currentOrder?.status ?? 0{
        case orderStatus.pending,orderStatus.Accepted:
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.view.setNeedsLayout()
            
            let DTvc = storyboard?.instantiateViewController(withIdentifier: "DateAndTimeVC") as! DateAndTimeVC
            DTvc.stringKey = "4"
            var subModel = YelpStoreBusinesses.init(json: JSON())
            subModel.pickUpTime = currentOrder?.pickUpTime
            DTvc.businessDetail = subModel
            DTvc.canceled = {
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.view.setNeedsLayout()
            }
            
            DTvc.completion = { model in
//                let pickupDate = (model?.pickUpTime ?? "").convertStampToDate(.current) ?? Date()
                currentOrder?.pickUpTime = model?.pickUpTime
                self.loadData()
                SocketBase.sharedInstance.editOrder("1")
                
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.view.setNeedsLayout()
            }
            DTvc.modalPresentationStyle = .overCurrentContext
            self.view.addSubview(DTvc.view)
            self.addChild(DTvc)
        default:
            self.editTimeBtnView.isHidden = true
        }
    }
    
    @IBAction func pickNotesEditBtn(_ sender: UIButton){
        let prevNotes = JSON(currentOrder?.isSkill ?? "0").boolValue ? (currentOrder?.deliveryInfo?.notes ?? "") : (currentOrder?.pickupInfo?.notes ?? "")
        
        let editView = UpdateNotesView(frame: screenFrame(), isSkill: JSON(currentOrder?.isSkill ?? "0").boolValue, notes: prevNotes, name: currentOrder?.itemName ?? "") { (itemName, notes) in
            
            currentOrder?.itemName = itemName
            
            if JSON(currentOrder?.isSkill ?? "0").boolValue{
                currentOrder?.deliveryInfo?.notes = notes
                showSwiftyAlert("", "Additional notes updated", true)
            }else{
                currentOrder?.pickupInfo?.notes = notes
                showSwiftyAlert("", "Pickup notes updated", true)
            }
            self.loadData()
            SocketBase.sharedInstance.editOrder("6")
        }
        self.view.addSubview(editView)
    }
    
    
    @IBAction func editDeliveryAddress(_ sender:UIButton){
        guard (self.currentOrderVC?.endCallView.isHidden ?? true) == true else {
            showSwiftyAlert("", "Please End Call to continue", false)
            return
        }
        
        switch currentOrder?.status ?? 0{
        case orderStatus.pending,orderStatus.Accepted:
            //Delivery Address
            changingDeliveryAdd = true
            currentOrderDelchange = true
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetAddressVC") as! SetAddressVC
            vc.isReversedDel = false
            self.navigationController?.pushViewController(vc, animated: false)
            
        default:
            self.editTimeBtnView.isHidden = true
        }
    }
    
    
    @IBAction func editSkillDeliveryAddress(_ sender:UIButton){
        guard (self.currentOrderVC?.endCallView.isHidden ?? true) == true else {
            showSwiftyAlert("", "Please End Call to continue", false)
            return
        }

        switch currentOrder?.status ?? 0{
        case orderStatus.pending,orderStatus.Accepted:
            guard JSON(currentOrder?.isSkill ?? "0").boolValue else{
                //Pickup Address
                changingDeliveryAdd = false
                currentOrderDelchange = true
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SpecialDeliveryVC") as! SpecialDeliveryVC
//                vc.isReversedDel = false
                self.navigationController?.pushViewController(vc, animated: false)
                return
            }
            
            changingDeliveryAdd = true
            currentOrderDelchange = true
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetAddressVC") as! SetAddressVC
            vc.isReversedDel = false
            self.navigationController?.pushViewController(vc, animated: false)
            
        default:
            self.editTimeBtnView.isHidden = true
        }
    }
    
    @IBAction func specialInstructionBtn(_ sender: UIButton) {
        if let url = URL(string: currentOrder?.specialLink ?? ""), !url.absoluteString.isEmpty, (UIApplication.shared.canOpenURL(url)) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            showSwiftyAlert("", "Sorry! We are not able to open this page.", false)
        }
    }
    
    @IBAction func editInstructionsBtn(_ sender: UIButton) {
        let editView = InstructionsView(frame: screenFrame(), link: currentOrder?.specialLink ?? "") { (link) in
            currentOrder?.specialLink = link
            SocketBase.sharedInstance.editOrder("5")
            showSwiftyAlert("", "Special instructions link updated", true)
        }
        self.view.addSubview(editView)
    }
    
    func loadFeeData(){
        let cp = JSON(currentOrder?.itemCost ?? "0.00").doubleValue
        let cpFee = cp  * 0.05
        let discount = JSON(currentOrder?.promoDiscount ?? "0.00").doubleValue
        
        var pickWaitCharges = JSON(currentOrder?.pickupWaitCharges ?? "0.00").doubleValue
        if JSON(currentOrder?.isSkill ?? "0").boolValue{
            pickWaitCharges = 0
        }
        
        let DropWaitCharges = JSON(currentOrder?.dropOffWaitCharges ?? "0.00").doubleValue
        let waitCharges = abs(pickWaitCharges) + abs(DropWaitCharges)
        
        //Delivery Fee
        let deliveryFee = (JSON(currentOrder?.deliveryFee ?? "0.00").doubleValue - discount) + waitCharges
        self.fares[0]["value"].stringValue = String(format: "%.02f", deliveryFee)
        
        //Base Fare
        let baseFee = JSON(currentOrder?.baseFee ?? "0.00").doubleValue
        self.fares[1]["value"].stringValue = String(format: "%.02f", baseFee)
        
        //Offer Price
        let offerPrice = JSON(currentOrder?.estimatedServiceOffer ?? "0.00").doubleValue
        self.fares[2]["value"].stringValue = String(format: "%.02f", offerPrice)
        
        //Discount
        self.fares[3]["value"].stringValue = String(format: "%.02f", discount)
        
        //Stairs/Elevator
        self.fares[4]["value"].stringValue = currentOrder?.stairsElevatorFee ?? "0.00"
        
        //Heavy
        self.fares[5]["value"].stringValue = currentOrder?.heavyFee ?? "0.00"
        
        //Wait Time
        self.fares[6]["value"].stringValue = String(format: "%.02f", waitCharges)
        
        //Item Cost //Courial Pay Fee
        if currentOrder?.subTotalType == "COURIAL PAYS"{
            self.fares[7]["type"].stringValue = "(Paid by Courial)"
            self.fares[7]["value"].stringValue = (currentOrder?.itemCost ?? "0.00")
            
            //Courial Pay Fee
            self.fares[8]["value"].stringValue = String(format: "%.02f", cpFee)
        } else{
            self.fares[7]["type"].stringValue = "(Pre-Paid)"
            self.fares[7]["value"].stringValue = "0.00"
            
            //Courial Pay Fee
            self.fares[8]["value"].stringValue = "0.00"
        }
        
        //Tip
        let courialTip = JSON(currentOrder?.courialTip ?? "0.00").doubleValue
        self.fares[9]["value"].stringValue = String(format: "%.02f", courialTip)
        
        //Total
        let totalAmount = deliveryFee  + cp + cpFee + courialTip
        self.fares[10]["value"].stringValue = String(format: "%.02f", totalAmount)
        
        if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
            self.fares[6]["title"].stringValue = "Additional Time"
            
            self.fares[0]["title"].stringValue = "Service Fee"
            let skillBaseFee = JSON(currentOrder?.baseFee ?? "0.00").doubleValue
            self.fares[1]["value"].stringValue = String(format: "%.02f", skillBaseFee)
            
            self.fares = JSON(self.fares.arrayValue.filter({($0["value"].doubleValue != 0) || ($0["title"].stringValue.contains("Delivery Fee") == true) || ($0["title"].stringValue.contains("TOTAL COST") == true) || ($0["title"].stringValue.contains("Service Fee") == true) }))
        }else{
            self.fares = JSON(self.fares.arrayValue.filter({($0["value"].doubleValue != 0) || ($0["title"].stringValue.contains("Item Cost") == true) || ($0["title"].stringValue.contains("Delivery Fee") == true) || ($0["title"].stringValue.contains("TOTAL COST") == true) || ($0["title"].stringValue.contains("Service Fee") == true)}))
        }
        
        self.feeTable.reloadData()
        self.loadData()
    }
    
    @objc func loadData(){
        self.setupNotes()
        self.pickUpTime.text =  self.checkDate(currentOrder?.pickUpTime ?? "")
        
        self.itemName.text = currentOrder?.itemName?.uppercased()
        self.specialInstructionView.isHidden = ((currentOrder?.specialLink ?? "") == "") ? true : false
        
        self.categoryImage.sd_setImage(with: URL(string: (currentOrder?.categoryImage ?? "")), placeholderImage: UIImage(named: "imgNoLogo"))
        self.categoryImage.layer.cornerRadius = self.iconBgView.layer.cornerRadius
        self.categoryImage.clipsToBounds = true
        
        self.iconBgView.backgroundColor = hexStringToUIColor(hex: (currentOrder?.categoryImageColor ?? ""))
        
        if (currentOrder?.categoryImageColor ?? "") == "clear"{
            self.categoryImage.contentMode = .scaleAspectFill
            self.categoryIconHeight.constant = 0
        } else{
            self.categoryImage.contentMode = .scaleAspectFit
            self.categoryIconHeight.constant = -10
        }
        
        self.collectionImages.delegate = self
        self.collectionImages.dataSource = self
        
        let identificationImage = (currentOrder?.identificationImage ?? "") == "" ? 0 : 1
        
        if ((currentOrder?.orderimages?.count ?? 0) + identificationImage) == 0{
            self.collectionImages.isHidden = true
            self.collectionLineView.isHidden = true
        } else{
            self.collectionImages.isHidden = false
            self.collectionLineView.isHidden = false
        }
        
        switch currentOrder?.status ?? 0{
        case orderStatus.pending,orderStatus.Accepted:
            self.editTimeBtnView.isHidden = false
            self.editAddressView.isHidden = false
        default:
            self.editTimeBtnView.isHidden = true
            self.editAddressView.isHidden = true
        }
        
        let vehicleTypeIndex = self.vehicleTypes.firstIndex(where: {$0 == currentOrder?.provider?.transport ?? currentOrder?.trasnportMode}) ?? 0
        self.transportIcon.image = self.transportImg[vehicleTypeIndex]
        
        switch currentOrder?.status ?? 0{
        case orderStatus.pending,orderStatus.Accepted:
            self.dropArrowHeight.constant = 25
            self.dropArrowView.isHidden = false
            
        default:
            self.dropArrowHeight.constant = 0
            self.dropArrowView.isHidden = true
        }
        
        if JSON(currentOrder?.isSkill ?? "0").boolValue{
            self.specialServiceView.isHidden = false
            
            if (currentOrder?.provider?.internalIdentifier ?? 0) != 0{
                let time = currentOrder?.livePathEstimatedTime ?? 1
                
                if time == 0{
                    self.duration.text = " min"
                }else{
                    self.duration.text = "\(time) min"
                }
                self.awayLbl.text = "away"
            }else{
                self.duration.text = ""
                self.awayLbl.text = ""
            }
            
            
            self.dropAddressView.isHidden = true
            
            self.pickName.text = currentOrder?.deliveryInfo?.placeName ?? ""
            
            var options = DeliveryAddressInterface.shared.addressOptions(isDelivery: true, model: currentOrder, type: 0)
            options = (options == "") ? "" : (options + " • ")
            
            var notes = (currentOrder?.deliveryInfo?.notes ?? "")
            notes = (notes == "") ? "No notes" : notes
            self.pickNotes.text = options + notes
            
            let address1 = (currentOrder?.deliveryInfo?.address1 ?? "")
            let address2 = (currentOrder?.deliveryInfo?.address2 ?? "")
            
            var aptInfo = currentOrder?.deliveryInfo?.aptInfo ?? ""
                aptInfo = (aptInfo == "") ? "" : ("• " + aptInfo)
            self.pickApt.text = aptInfo
            
            self.pickAddress.text = address1
            self.pickAddress2.text = address2
            
            let floors = DeliveryAddressInterface.shared.addressOptions(isDelivery: true, model: currentOrder, type: 1)
            self.itemDetails.text = self.getItemDetails(floors: floors)
            self.itemDetails.isHidden = ((self.itemDetails.text ?? "") == "") ? true : false
            
        }else{
            
            self.specialServiceView.isHidden = true
            
            let time = currentOrder?.livePathEstimatedTime ?? 1
            if time == 0{
                self.duration.text = " min"
            }else{
                self.duration.text = "\(time) min"
            }
            
            self.pickName.text = currentOrder?.pickupInfo?.placeName ?? ""
            
            var options = DeliveryAddressInterface.shared.addressOptions(isDelivery: false, model: currentOrder, type: 0)
            options = (options == "") ? "" : (options + " • ")
            
            var notes = (currentOrder?.pickupInfo?.notes ?? "")
            notes = (notes == "") ? "No notes" : notes
            self.pickNotes.text = options + notes
            
            
            let address = currentOrder?.pickupInfo
            var aptInfo = address?.aptInfo ?? ""
                aptInfo = (aptInfo == "") ? "" : ("• " + aptInfo)
            self.pickApt.text = aptInfo
            self.pickAddress.text = (address?.address1 ?? "")
            self.pickAddress2.text = (address?.address2 ?? "")
            
            self.dropAddressView.isHidden = false
            self.awayLbl.text = "away"
            
            let dropAddress1 = (currentOrder?.deliveryInfo?.address1 ?? "")
//            let dropAddress2 = (currentOrder?.deliveryInfo?.address2 ?? "")
            
            
            var dropAptInfo = currentOrder?.deliveryInfo?.aptInfo ?? ""
                dropAptInfo = (dropAptInfo == "") ? "" : (" • " + dropAptInfo)
            self.dropAddress.text = dropAddress1 + dropAptInfo
            
            var dropOptions = DeliveryAddressInterface.shared.addressOptions(isDelivery: true, model: currentOrder, type: 0)
            dropOptions = (dropOptions == "") ? "" : (dropOptions + " • ")
            
            var dropNotes = (currentOrder?.deliveryInfo?.notes ?? "")
            dropNotes = (dropNotes == "") ? "No notes" : dropNotes
            self.dropNotes.text = dropOptions + dropNotes
            
            
            let floors = DeliveryAddressInterface.shared.addressOptions(isDelivery: false, model: currentOrder, type: 1)
            self.itemDetails.text = self.getItemDetails(floors: floors)
            self.itemDetails.isHidden = ((self.itemDetails.text ?? "") == "") ? true : false
        }
        
        
        if (currentOrder?.updateitemcost ?? 0) == 0 && JSON(currentOrder?.isSkill ?? "0").boolValue == false{
            if self.updateCourialPayFieldView.isHidden == false{
                self.updateCourialPayView.isHidden = true
            }else{
                self.updateCourialPayView.isHidden = false
            }
        }else{
            self.updateCourialPayView.isHidden = true
        }
        
        self.setupNotes()
    }
    
    func resetData(){
        self.fares = JSON([
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
    }
    
}

extension CurrentOrderVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView{
        case self.feeTable:
            return self.fares.count
        default:
            return self.completedOrders.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView{
        case self.table:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedDeliveryTVC")as! CompletedDeliveryTVC
            
            let order = self.completedOrders[indexPath.row]
            
            cell.StoreName.text = order.name ?? "Store"
            
            
            if (order.delivery_complete_date ?? "") != ""{
                cell.date.text = (order.delivery_complete_date ?? "0").convertStamp(format: "dd MMM, yyyy", timeZone: .current)
            }else{
                cell.date.text = "\(order.updatedAt ?? 0)".convertStamp(format: "dd MMM, yyyy", timeZone: .current)
            }
            
            let address1 = (order.deliveryInfo?.address1 ?? "")
            let address2 = (order.deliveryInfo?.address2 ?? "")
            
            cell.address.text = address1 + ", " + address2
            cell.orderId.text = "Order #" + (order.orderid ?? "")
            
            switch JSON(order.status ?? "0").intValue{
            case 7:
                //Cancelled
                cell.status.text = " (Cancelled)"
                
                let cancelAmount = String(format: "%.02f", order.cancelAmount ?? 0.0)
                cell.amount.text = "$" + cancelAmount
                
            case 8:
                //Not respond
                cell.status.text = " (No Response)"
                
                let cancelAmount = String(format: "%.02f", order.cancelAmount ?? 0.0)
                cell.amount.text = "$" + cancelAmount
            default:
                cell.status.text = " (Completed)"
                cell.amount.text = "$" + calculateOrderTotals(order: order)
            }
            
            cell.againBtn.tag = indexPath.row
            cell.againBtn.addTarget(self, action: #selector(self.doItAgain(_:)), for: .touchUpInside)
            
            cell.receiptBtn.tag = indexPath.row
            cell.receiptBtn.addTarget(self, action: #selector(self.receiptBtn(_:)), for: .touchUpInside)
            return cell
        default:
            let title = self.fares[indexPath.row]["title"].stringValue
            let value = self.fares[indexPath.row]["value"].stringValue
            let type = self.fares[indexPath.row]["type"].stringValue
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "TotalCell", for: indexPath) as! DeliveryDetailTVC
            
            switch type{
            case "TOTAL":
                cell = tableView.dequeueReusableCell(withIdentifier: "TotalCell", for: indexPath) as! DeliveryDetailTVC
                
                if (currentOrder?.updateitemcost ?? 0) == 1{
                    cell.feeValue.textColor = .red
                }else{
                    cell.feeValue.textColor = .black
                }
                
            case "sub":
                cell = tableView.dequeueReusableCell(withIdentifier: "SubCell", for: indexPath) as! DeliveryDetailTVC
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: "FeeCell", for: indexPath) as! DeliveryDetailTVC
                cell.feeType.text = type
                
                if title.lowercased() == "item cost" && (currentOrder?.updateitemcost ?? 0) == 1{
                    cell.feeTitle.textColor = .red
                    cell.feeType.textColor = .red
                    cell.feeValue.textColor = .red
                }else{
                    cell.feeTitle.textColor = .black
                    cell.feeType.textColor = .black
                    cell.feeValue.textColor = .black
                }
            }
            
            cell.feeTitle.text = title
            
            if title == "Discount / Promo"{
                cell.feeValue.text = "-$" + value
            } else{
                cell.feeValue.text = "$" + value
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


extension CurrentOrderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let identificationImage = (currentOrder?.identificationImage ?? "") == "" ? 0 : 1
        return (currentOrder?.orderimages?.count ?? 0) + identificationImage
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImagesCVC", for: indexPath) as! AddImagesCVC
        let lastCell = collectionView.numberOfItems(inSection: 0) - 1
        
        switch currentOrder?.vehicleTypeIndex?.lowercased(){
        case "pharmacy":
            if indexPath.item == lastCell {
                cell.title.text = "VIEW PHOTO ID"
                cell.title.textColor = appColorBlue
                
                cell.attachedImage.sd_setImage(with: URL(string: currentOrder?.identificationImage ?? ""), placeholderImage: nil, options: [], context: nil)
            } else{
                cell.title.text = "VIEW PRESCRIPTION"
                cell.title.textColor = .darkGray
                
                let imgStr = currentOrder?.orderimages?[indexPath.row].image ?? ""
                cell.attachedImage.sd_setImage(with: URL(string: imgStr), placeholderImage: nil, options: [], context: nil)
            }
        case "cannabis","wine","cigar","cigarette","cigarettes","tobacco":
            if indexPath.item == lastCell {
                cell.title.text = "VIEW PHOTO ID"
                cell.title.textColor = appColorBlue
                
                cell.attachedImage.sd_setImage(with: URL(string: currentOrder?.identificationImage ?? ""), placeholderImage: nil, options: [], context: nil)
                
            } else{
                cell.title.text = "VIEW IMAGE"
                cell.title.textColor = .darkGray
                
                let imgStr = currentOrder?.orderimages?[indexPath.row].image ?? ""
                cell.attachedImage.sd_setImage(with: URL(string: imgStr), placeholderImage: nil, options: [], context: nil)
                
            }
        default:
            cell.title.text = "VIEW IMAGE"
            cell.title.textColor = .darkGray
            
            let imgStr = currentOrder?.orderimages?[indexPath.row].image ?? ""
            cell.attachedImage.sd_setImage(with: URL(string: imgStr), placeholderImage: nil, options: [], context: nil)
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
        
        switch currentOrder?.vehicleTypeIndex?.lowercased(){
        case "pharmacy","cannabis","wine","cigar","cigarette","cigarettes","tobacco":
            if indexPath.item == collectionView.numberOfItems(inSection: 0) - 1{
                photo = SKPhoto.photoWithImageURL(currentOrder?.identificationImage ?? "")
            } else{
                photo = SKPhoto.photoWithImageURL(currentOrder?.orderimages?[indexPath.row].image ?? "")
            }
        default:
            photo = SKPhoto.photoWithImageURL(currentOrder?.orderimages?[indexPath.row].image ?? "")
        }
        
        self.photoBrowser = SKPhotoBrowser(photos: [photo])
        super.present(self.photoBrowser, animated: true, completion: nil)
    }
    
}


extension CurrentOrderVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource{
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = "No order found!"
        
        let font = UIFont.boldSystemFont(ofSize: 20)
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        let title = "Tap here to try again?"
        
        let font = UIFont.boldSystemFont(ofSize: 20)
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        if isLoggedIn(){
            self.getCompletedOrder()
        }
    }
    
}


extension CurrentOrderVC {
    
    func getItemDetails(floors: String)-> String{
        guard JSON(currentOrder?.isSkill ?? "0").boolValue == false else{
            var time = currentOrder?.estimatedServiceTime ?? ""
                time = time + " Min Service"
            
            let value = [time,floors].filter({$0 != ""}).joined(separator: " • ")
            return value
        }
        
        let twoCourial =  JSON(currentOrder?.twoCourials ?? "0").boolValue ? "Two Courials" : ""
        let over45Lbs =  JSON(currentOrder?.over45Lbs ?? "0").boolValue ? "Over 45 lbs" : ""
        
        var idRequired = ""
        if currentOrder?.identificationImage != ""{
            idRequired = "ID Required"
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
    
    
    func addressChanged(){
        guard changingDeliveryAdd else{
            if (PickUpAddressInterface.shared.selectedAddress.addressPhone ?? "").isValidateMobile() && (PickUpAddressInterface.shared.selectedAddress.placeName ?? "").isEmpty == false{
                PickUpAddressInterface.shared.getDetails(isReversedDel: false) { (model) in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedStoreVC")as! SelectedStoreVC
                    vc.category = "Special"
                    vc.businessDetail = model
                    vc.businessDetail?.name = PickUpAddressInterface.shared.selectedAddress.placeName
                    vc.businessDetail?.displayPhone = PickUpAddressInterface.shared.selectedAddress.addressPhone
                    vc.isFilled = true
                    vc.isliveOrderChanges = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedStoreVC")as! SelectedStoreVC
                vc.category = "Special"
                vc.isliveOrderChanges = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        self.getDetails()
    }
    
    func getDetails(){
        if changingDeliveryAdd {
            let newAdd = DeliveryAddressInterface.shared.selectedAddress
            currentOrder?.deliveryInfo?.address1 = newAdd.address
            currentOrder?.deliveryInfo?.address2 = newAdd.fullAddress?.replacingOccurrences(of: (newAdd.address ?? "") + ", ", with: "")
            currentOrder?.deliveryInfo?.fullAddress = newAdd.fullAddress
            currentOrder?.deliveryInfo?.latitude = JSON(newAdd.latitude ?? 0.0).stringValue
            currentOrder?.deliveryInfo?.longitude = JSON(newAdd.longitude ?? 0.0).stringValue
            currentOrder?.deliveryInfo?.options = newAdd.dropPickupoptions
            currentOrder?.deliveryInfo?.floors = newAdd.elevatorFloor
            currentOrder?.deliveryInfo?.pickElevatorWalkBoth = newAdd.elevator_walk_both
            currentOrder?.deliveryInfo?.notes = newAdd.notes
            currentOrder?.deliveryInfo?.aptInfo = newAdd.apartmentInfo
            
            let address1 = (newAdd.address ?? "") + ", "
            let addressFull = newAdd.fullAddress ?? ""
            var address2 = addressFull.replacingOccurrences(of: address1, with: "")
            
            if (address2.components(separatedBy: ", ").count) > 1{
                address2 = address2.components(separatedBy: ", ").first ?? ""
            }
            currentOrder?.deliveryInfo?.address2 = address2
        }else{
            let newAdd = PickUpAddressInterface.shared.selectedAddress
            currentOrder?.pickupInfo?.address1 = newAdd.address
            currentOrder?.pickupInfo?.address2 = newAdd.fullAddress?.replacingOccurrences(of: (newAdd.address ?? "") + ", ", with: "")
            currentOrder?.pickupInfo?.fullAddress = newAdd.fullAddress
            currentOrder?.pickupInfo?.latitude = JSON(newAdd.latitude ?? 0.0).stringValue
            currentOrder?.pickupInfo?.longitude = JSON(newAdd.longitude ?? 0.0).stringValue
            currentOrder?.pickupInfo?.options = newAdd.dropPickupoptions
            currentOrder?.pickupInfo?.floors = newAdd.elevatorFloor
            currentOrder?.pickupInfo?.pickElevatorWalkBoth = newAdd.elevator_walk_both
            currentOrder?.pickupInfo?.notes = newAdd.notes
            currentOrder?.pickupInfo?.aptInfo = newAdd.apartmentInfo 
            
            let address1 = (newAdd.address ?? "") + ", "
            let addressFull = newAdd.fullAddress ?? ""
            var address2 = addressFull.replacingOccurrences(of: address1, with: "")
            
            if (address2.components(separatedBy: ", ").count) > 1{
                address2 = address2.components(separatedBy: ", ").first ?? ""
            }
            currentOrder?.pickupInfo?.address2 = address2
        }
        
        currentOrderPoints?.removeAll()
        
        self.loadData()
        
        let originLats = CLLocationDegrees(JSON(currentOrder?.deliveryInfo?.latitude ?? "0.0").doubleValue)
        let originLongs = CLLocationDegrees(JSON(currentOrder?.deliveryInfo?.longitude ?? "0.0").doubleValue)
        
        var storeLats = CLLocationDegrees(JSON(currentOrder?.pickupInfo?.latitude ?? "0.0").doubleValue)
        var storeLongs = CLLocationDegrees(JSON(currentOrder?.pickupInfo?.longitude ?? "0.0").doubleValue)
        
        if JSON(currentOrder?.isSkill ?? "0").boolValue{
            storeLats = CLLocationDegrees(JSON(currentOrder?.provider?.latitude ?? "0.0").doubleValue)
            storeLongs = CLLocationDegrees(JSON(currentOrder?.provider?.longitude ?? "0.0").doubleValue)
        }
        
        guard storeLats != 0.0 else{
            if JSON(currentOrder?.isSkill ?? "0").boolValue{
                self.getSkillDeliveryFee()
            }else{
                self.getDeliveryFee()
            }
            return
        }
        
        let coordinateOrigin = CLLocationCoordinate2D(latitude: originLats, longitude: originLongs)
        let coordinateDestination = CLLocationCoordinate2D(latitude: storeLats, longitude: storeLongs)
        
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
                    
                    if JSON(formattedString).intValue != 0{
                        let time = currentOrder?.livePathEstimatedTime ?? 1
                        self.duration.text =  "\(time) min"
                        self.awayLbl.text = "away"
                    }else{
                        self.duration.text = ""
                        self.awayLbl.text = ""
                    }
                    
                    if JSON(currentOrder?.isSkill ?? "0").boolValue{
                        self.getSkillDeliveryFee()
                    }else{
                        self.getDeliveryFee()
                    }
                }
            }else{
                showSwiftyAlert("", "Unable to generate route", false)
            }
        }
    }
    
    func getDeliveryFee(){
        let distance = (currentOrder?.googleDistance ?? "")
        let distanceMiles = JSON(distance).doubleValue * 0.000621371192
        
        let durationInt = JSON(currentOrder?.googleDuration ?? "0").intValue
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute]
        formatter.unitsStyle = .positional
        var formattedString = formatter.string(from: TimeInterval(durationInt)) ?? ""
        formattedString = formattedString.replacingOccurrences(of: ",", with: "")
        
        var itemCost = "0"
        if currentOrder?.subTotalType == "COURIAL PAYS"{
            itemCost = currentOrder?.itemCost ?? ""
        }
        
        let params : Parameters = [
            "category": currentOrder?.category ?? "",
            "weight": (currentOrder?.over45Lbs ?? "0"),
            "two_courial" : (currentOrder?.twoCourials ?? "0"),
            "transport": currentOrder?.trasnportMode ?? "",
            "distance": String(format: "%.02f", distanceMiles),
            "time": formattedString,
            "dropOfOption": currentOrder?.deliveryInfo?.options ?? "",
            "drop_floor": currentOrder?.deliveryInfo?.floors ?? "0",
            "drop_elevator_walk_both": currentOrder?.deliveryInfo?.pickElevatorWalkBoth ?? "0",
            "pickupOption":currentOrder?.pickupInfo?.options ?? "",
            "pick_floor": currentOrder?.pickupInfo?.floors ?? "0",
            "pick_elevator_walk_both": currentOrder?.pickupInfo?.pickElevatorWalkBoth ?? "0",
            "itemCost" : (itemCost == "") ? "0" : itemCost
        ]
        
        ApiInterface.requestApi(params: params, api_url: API.calculation_fee , success: { (json) in
            
            var itemCost : Double = 0.00
            var cpFee : Double = 0.00
            
            if currentOrder?.subTotalType == "COURIAL PAYS"{
                itemCost = JSON(currentOrder?.itemCost ?? "0").doubleValue
                let serviceFee = itemCost * (5/100)
                cpFee = JSON(String(format: "%.02f", serviceFee)).doubleValue
            }
            currentOrder?.serviceFee = String(format: "%.02f", cpFee)
            
            let deliveryFee = json["data"]["deliveryfees"].doubleValue - cpFee - itemCost
            currentOrder?.deliveryFee = String(format: "%.02f", deliveryFee)
            
            currentOrder?.baseFee = String(format: "%.02f", json["data"]["basefee"].doubleValue)
            currentOrder?.stairsElevatorFee = String(format: "%.02f", json["data"]["stairsElevator"].doubleValue)
            currentOrder?.heavyFee = String(format: "%.02f", json["data"]["heavy"].doubleValue)
            currentOrder?.pickupWaitCharges = "0.00"
            
            hideLoader()
            self.resetData()
            self.loadFeeData()
            self.loadData()
            
            if changingDeliveryAdd{
                SocketBase.sharedInstance.editOrder("3")
            }else{
                SocketBase.sharedInstance.editOrder("2")
            }
        }) { (error, json) in
            hideLoader()
            self.loadData()
            self.feeTable.reloadData()
            if changingDeliveryAdd{
                SocketBase.sharedInstance.editOrder("3")
            }else{
                SocketBase.sharedInstance.editOrder("2")
            }
        }
    }
    
    func getSkillDeliveryFee(){
        let params : Parameters = [
            "category": currentOrder?.category ?? "",
            "dropOfOption": currentOrder?.deliveryInfo?.options ?? "",
            "drop_floor": currentOrder?.deliveryInfo?.floors ?? "0",
            "drop_elevator_walk_both": currentOrder?.deliveryInfo?.pickElevatorWalkBoth ?? "0",
            "estimatedServiceOffer": currentOrder?.estimatedServiceOffer ?? ""
        ]
        
        ApiInterface.requestApi(params: params, api_url: API.special_calculation_fee , success: { (json) in
            currentOrder?.baseFee = String(format: "%.02f", json["data"]["basefee"].doubleValue)
            currentOrder?.stairsElevatorFee = String(format: "%.02f", json["data"]["stareFee"].doubleValue)
            currentOrder?.deliveryFee = String(format: "%.02f", json["data"]["serviceFee"].doubleValue)
            
            hideLoader()
            self.resetData()
            self.loadFeeData()
            self.loadData()
            SocketBase.sharedInstance.editOrder("3")
        }) { (error, json) in
            hideLoader()
            self.loadData()
            self.feeTable.reloadData()
            SocketBase.sharedInstance.editOrder("3")
        }
    }
    
    func getCompletedOrder(){
        showLoader()
        ApiInterface.requestApi(params: [:], api_url: API.get_orders_history , success: { (json) in
            if let data = json["data"].array{
                self.completedOrders = data.map({CurrentOrderModel.init(json: $0)})
            }
            self.table.emptyDataSetDelegate = self
            self.table.emptyDataSetSource = self
            self.table.reloadData()
            hideLoader()
        }) { (error, json) in
            print(error)
            hideLoader()
            self.table.emptyDataSetDelegate = self
            self.table.emptyDataSetSource = self
            self.table.reloadData()
        }
    }
    
    func generateOrderID(index: Int){
        let params : Parameters = [
            "category": self.completedOrders[index].category ?? "",
            "isSkill" : self.completedOrders[index].isSkill ?? "0"
        ]
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.generate_order_id , success: { (json) in
            hideLoader()
            self.goToQueue(orderId: json["data"]["orderid"].stringValue, index: index)
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    func goToQueue(orderId : String, index: Int){
        let order = self.completedOrders[index]
        
        let vehicleTypeIndex = self.vehicleTypes.firstIndex(where: {$0 == order.trasnportMode}) ?? 0
        
        var model = YelpStoreBusinesses.init(json: JSON())
        
        model.orderID = orderId
        model.distance = order.googleDistance
        model.duration = order.googleDuration
        model.pickUpTime = nil
        model.imageUrl = order.image
        model.isWebStore = JSON(order.isWebStore ?? "0").boolValue
        model.webStoreType = order.webStoreType
        
        model.name = order.name
        model.category = order.category
        model.itemCategory = order.vehicleTypeIndex
        model.subTotalType = order.subTotalType
        model.courialFee = order.itemCost
        model.vehicleTypeIndex = vehicleTypeIndex
        model.isClosed = JSON(order.isClosed ?? "0").boolValue
        model.isFav = JSON(order.isFav ?? "0").boolValue
        model.url = order.url
        model.over45Lbs = JSON(order.over45Lbs ?? "0").boolValue
        model.two_courial = JSON(order.twoCourials ?? "0").boolValue
        model.googlePlaceID = order.googlePlaceID
        model.itemDescription = order.itemName
        model.additionalNotes = order.pickupInfo?.notes
        model.isReversedDel = JSON(order.isReversedDel ?? "0").boolValue
        
        model.deliveryFee = order.deliveryFee
        model.baseFee = order.baseFee
        model.displayPhone = order.storePhone
        
        model.coordinates?.latitude = JSON(order.pickupInfo?.latitude ?? "0").floatValue
        model.coordinates?.longitude = JSON(order.pickupInfo?.longitude ?? "0").floatValue
        model.location?.address1  = order.pickupInfo?.address1
        model.location?.address2  = order.pickupInfo?.address2
        model.location?.address3  = order.pickupInfo?.fullAddress
        model.location?.displayAddress  = [order.pickupInfo?.address1 ?? "" , order.pickupInfo?.address2 ?? ""]
        model.location?.pickElevatorFloor = order.pickupInfo?.floors
        model.location?.pickOption = order.pickupInfo?.options
        model.location?.aptInfo = order.pickupInfo?.aptInfo
        model.location?.pickElevatorFloor = order.pickupInfo?.pickElevatorWalkBoth
        
        model.dropAddress?.latitude = JSON(order.deliveryInfo?.latitude ?? "0").floatValue
        model.dropAddress?.longitude = JSON(order.deliveryInfo?.longitude ?? "0").floatValue
        model.dropAddress?.address  = order.deliveryInfo?.address1
        model.dropAddress?.fullAddress = order.deliveryInfo?.fullAddress
        
        model.dropAddress?.elevatorFloor = order.deliveryInfo?.floors
        model.dropAddress?.dropPickupoptions = order.deliveryInfo?.options
        model.dropAddress?.apartmentInfo = order.deliveryInfo?.aptInfo
        model.dropAddress?.elevator_walk_both = order.deliveryInfo?.pickElevatorWalkBoth
        
        model.identificationImageURL = order.identificationImage
        model.attachedImagesURL = order.orderimages?.map({$0.image ?? ""})
        
        model.isSkillService = JSON(order.isSkill ?? "0").boolValue
        model.estimatedServiceTime = order.estimatedServiceTime ?? ""
        model.estimatedServiceOffer = order.estimatedServiceOffer ?? ""
        
        model.imageCategoryURL = order.categoryImage ?? ""
        model.imageCategoryColor = order.categoryImageColor ?? ""
        model.specialLink = order.specialLink ?? ""
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QueueDeliveryDetailVC")as! QueueDeliveryDetailVC
        vc.businessDetail = model
        vc.isRepeat = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CurrentOrderVC : ExpandableLabelDelegate{
    
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

