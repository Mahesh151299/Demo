//
//  DeliveryCompletedVC.swift
//  Courail
//
//  Created by mac on 12/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Cosmos
import SKPhotoBrowser

class DeliveryCompletedVC: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var dropTitle: UILabel!
    @IBOutlet weak var dropAddress1: UILabel!
    @IBOutlet weak var dropAddress2: UILabel!
    @IBOutlet weak var dropNotes: UILabel!
    
    @IBOutlet weak var pickLineView: UIView!
    @IBOutlet weak var pickTitle: UILabel!
    @IBOutlet weak var pickAddress: UILabel!
    @IBOutlet weak var pickAddress2: UILabel!
    @IBOutlet weak var pickNotes: UILabel!
    @IBOutlet weak var pickIcon: UIImageView!
    
    @IBOutlet weak var tipBtnOut: UIButton!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDesc: UILabel!
    
    @IBOutlet weak var deliveryDate: UILabel!
    
    @IBOutlet weak var partnerImage: UIImageViewCustomClass!
    @IBOutlet weak var partner2Image: UIImageViewCustomClass!
    
    @IBOutlet weak var partnerName: UILabel!
    @IBOutlet weak var partnerRating: CosmosView!
    @IBOutlet weak var deliveryPhoto: UIImageView!
    
    //MARK:- VARIABLES
    
    var photoBrowser = SKPhotoBrowser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
//        if currentOrder?.courialTip == nil || (currentOrder?.courialTip == "0.00"){
            self.tipBtnOut.isHidden = false
//        } else{
//            self.tipBtnOut.isHidden = true
//        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadData(){
        self.itemName.text = currentOrder?.itemName?.uppercased()
//        self.itemDesc.text = self.itemDetails()
        
        let courialFirstName = (currentOrder?.provider?.firstName ?? "").uppercased()
        var courialLastName = ""
        if let lastChar = (currentOrder?.provider?.lastName ?? "").uppercased().first{
            courialLastName = "\(lastChar)"
        }
        let courialName = courialFirstName + " " + courialLastName
        
        self.partnerImage.sd_setImage(with: URL(string: currentOrder?.provider?.image ?? ""), placeholderImage: nil, options: [], completed: nil)
        
        if JSON(currentOrder?.twoCourials ?? "0").boolValue == false{
            self.partner2Image.isHidden = true
            self.partnerName.text = courialName
        } else{
            let courial2FirstName = (currentOrder?.secondCourial?.firstName ?? "").uppercased()
            self.partnerName.text = courialFirstName + " & " + courial2FirstName
            
            self.partner2Image.isHidden = false
            self.partner2Image.sd_setImage(with: URL(string: currentOrder?.secondCourial?.image ?? ""), placeholderImage: nil, options: [], completed: nil)
        }
        
        if JSON(currentOrder?.provider?.rating ?? "5").doubleValue < 4.5{
            self.partnerRating.rating = 4.5
        }else{
            self.partnerRating.rating = JSON(currentOrder?.provider?.rating ?? "5").doubleValue
        }
        
        self.deliveryPhoto.sd_setImage(with: URL(string: currentOrder?.takeDeliveryPhoto ?? ""), placeholderImage: nil, options: [], completed: nil)
        
        self.deliveryDate.text = (currentOrder?.delivery_complete_date ?? "0").convertStamp(format: "MMMM dd, yyyy • hh:mm a", timeZone: .current)
        
//        let firstName = userInfo.firstName ?? "You"
//        let lastName = userInfo.lastName ?? ""
//        self.dropTitle.text = (firstName + " " + lastName)
        
        self.dropTitle.text = currentOrder?.deliveryInfo?.placeName ?? ""
        
        let address1 = (currentOrder?.deliveryInfo?.address1 ?? "")
        let address2 = currentOrder?.deliveryInfo?.address2 ?? ""
        
        let dropAptInfo = currentOrder?.deliveryInfo?.aptInfo ?? ""
        if dropAptInfo != ""{
            self.dropAddress1.text = address1 + " • " + dropAptInfo
        } else{
            self.dropAddress1.text = address1
        }
        
        self.dropAddress2.text = address2
        
        var dropOptions = DeliveryAddressInterface.shared.addressOptions(isDelivery: true, model: currentOrder, type: 0)
        dropOptions = (dropOptions == "") ? "" : (dropOptions + " • ")
        
        var dropNotes = (currentOrder?.deliveryInfo?.notes ?? "")
        dropNotes = (dropNotes == "") ? "No notes" : dropNotes
        self.dropNotes.text = dropOptions + dropNotes
        
        
        if JSON(currentOrder?.isSkill ?? 0).boolValue == false{
            self.pickIcon.isHidden = false
            
            self.pickTitle.text = currentOrder?.pickupInfo?.placeName ?? ""
            self.pickAddress.text = (currentOrder?.pickupInfo?.fullAddress ?? "")
            
            let pickAddress = currentOrder?.pickupInfo
            var pickAptInfo = pickAddress?.aptInfo ?? ""
                pickAptInfo = (pickAptInfo == "") ? "" : ("• " + pickAptInfo)
            self.pickAddress.text = (pickAddress?.address1 ?? "") + pickAptInfo
            self.pickAddress2.text = (pickAddress?.address2 ?? "")
            
            
            var pickOptions = DeliveryAddressInterface.shared.addressOptions(isDelivery: false, model: currentOrder, type: 0)
            pickOptions = (pickOptions == "") ? "" : (pickOptions + " • ")
            
            var pickNotes = (currentOrder?.pickupInfo?.notes ?? "")
            pickNotes = (pickNotes == "") ? "No notes" : pickNotes
            self.pickNotes.text = pickOptions + pickNotes
            
        }else{
            self.pickLineView.isHidden = true
            self.pickTitle.isHidden = true
            self.pickAddress.isHidden = true
            self.pickAddress2.isHidden = true
            self.pickNotes.isHidden = true
            self.pickIcon.isHidden = true
        }
        
    }
    
    
    func itemDetails()-> String{
        guard JSON(currentOrder?.isSkill ?? "0").boolValue == false else{
            let time = currentOrder?.estimatedServiceTime ?? ""
            let vehicle = "By " + (currentOrder?.trasnportMode ?? "")
            return (time + " min Service • " + vehicle)
        }
        
        let twoCourial =  JSON(currentOrder?.twoCourials ?? 0).boolValue ? "Two Courials • " : ""
        let over45Lbs =  JSON(currentOrder?.over45Lbs ?? "0").boolValue ? "Over 45 lbs • " : ""
        
        var idRequired = ""
        switch currentOrder?.category?.lowercased(){
        case "cannabis","alcohol","wine","pharmacy","cigar","cigarette","cigarettes","tobacco":
            idRequired = " • ID Required"
        default:
            idRequired = ""
        }
        
        let vehicle = (currentOrder?.trasnportMode ?? "")
        
        return twoCourial + over45Lbs + vehicle + idRequired
        
    }
    
    func showCustomAlert(title: String, msg:String, doneBtnTitle: String, cancelBtnTitle: String, handler:@escaping () -> Void ){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
            let messageAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.black]
              let messageString = NSAttributedString(string: msg, attributes: messageAttributes)
              alert.setValue(messageString, forKey: "attributedMessage")
            alert.addAction(UIAlertAction(title: doneBtnTitle, style: .default, handler: { action  in
                DispatchQueue.main.async {
                    handler()
                }
            }))
            alert.addAction(UIAlertAction(title: cancelBtnTitle, style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
           }
       }
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func RateUsBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RateUsVC") as! RateUsVC
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func receiptBtn(_ sender: UIButton){
        DispatchQueue.main.async {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let receiptVC = storyboard.instantiateViewController(withIdentifier: "FinalReceiptVC")as! FinalReceiptVC
            receiptVC.orderDetail = currentOrder ?? CurrentOrderModel.init(json: JSON())
            receiptVC.modalPresentationStyle = .overFullScreen
            rootVC?.present(receiptVC, animated: true, completion: nil)
        }
//        let vc = storyboard?.instantiateViewController(withIdentifier: "CurrentOrderVC") as! CurrentOrderVC
//            vc.isFinalReceipt = true
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.showCustomAlert(title: "Did you tip your Courial?", msg: "Say thanks with a nice tip!\nYou won’t be able to tip or leave a rating once you\nclose this screen.", doneBtnTitle: "Continue", cancelBtnTitle: "Cancel") {
            self.skipRating()
        }
    }
    
    @IBAction func tipBtn(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RateUsVC") as! RateUsVC
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func helpBtn(_ sender: UIButton) {
    }
    
    @IBAction func deliveryPhotoBtn(_ sender: UIButton) {
        let photo = SKPhoto.photoWithImageURL(currentOrder?.takeDeliveryPhoto ?? "")
        self.photoBrowser = SKPhotoBrowser(photos: [photo])
        super.present(self.photoBrowser, animated: true, completion: nil)
    }
    
}

extension DeliveryCompletedVC {
    
    //MARK: API
    func skipRating(){
        let params : Parameters = [
            "orderId": currentOrder?.orderid ?? "",
            
            "secondsFromGMT": "\(TimeZone.current.secondsFromGMT())",
            "timezoneID": TimeZone.current.identifier,
            "timezoneDate": "\(Date().timeIntervalSince1970)"
        ]
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.skip_rate , success: { (json) in
            hideLoader()
            currentOrder = nil
            GoToHome()
        }) { (error, json) in
            hideLoader()
            currentOrder = nil
            GoToHome()
        }
    }
    
}
