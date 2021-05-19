//
//  CancelDeliveryVC.swift
//  Courail
//
//  Created by Omeesh Sharma on 06/08/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import CoreLocation

class CancelDeliveryVC: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var cardNoLbl: UILabel!
    @IBOutlet weak var confirmLbl: UILabel!
    
    @IBOutlet weak var cancelDelBtnOut: UIButtonCustomClass!
    @IBOutlet weak var dontCancelBtnOut: UIButtonCustomClass!
    
    @IBOutlet weak var dontCancel2View: UIView!
    @IBOutlet weak var cancel2View: UIView!
    
    //MARK: VARIABLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.cardNoLbl.isHidden = true
        self.confirmLbl.isHidden = true
        self.dontCancel2View.isHidden = true
        self.cancel2View.isHidden = true
        

        let str =  NSMutableAttributedString(string: "Pending: No charge\nCourial Assigned: $5.00 Fee\nCourial in Route to Pickup: $7.00 Fee\nItem Picked Up: Greater of $7.00 or total delivery fee\n")
        let range1 = str.mutableString.range(of: "Pending:")
        let range2 = str.mutableString.range(of: "Courial Assigned:")
        let range3 = str.mutableString.range(of: "Courial in Route to Pickup:")
        let range4 = str.mutableString.range(of: "Item Picked Up:")
        
        str.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], range: range1)
        str.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], range: range2)
        str.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], range: range3)
        str.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], range: range4)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        str.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, str.length))
        
        self.infoLbl.attributedText = str
        
        let cardLast = userInfo.card_default?.cardNumber?.suffix(4) ?? ""
        let card = cardNameAbb(name: userInfo.card_default?.cardType ?? "") + " •••• " + cardLast
        
        var amountToDeduct = "00.00"
        switch currentOrder?.status ?? 0{
        case orderStatus.pending:
            //Full Refund
            amountToDeduct = "0.00"
        case orderStatus.Accepted:
            //Full Refund - $5
            amountToDeduct = "5.00"
            
            let orderAcceptTime = JSON(currentOrder?.confirmOrdertime ?? 0).stringValue.convertStampToDate(TimeZone.init(identifier: "UTC") ?? .current) ?? Date()
            
            //Courial Partner Marker position update
            let courialLats = JSON(currentOrder?.provider?.latitude ?? "0").doubleValue
            let courialLongs = JSON(currentOrder?.provider?.longitude ?? "0").doubleValue
            let courialLocation = CLLocation(latitude: courialLats, longitude: courialLongs)
            
            var pickLats = JSON(currentOrder?.pickupInfo?.latitude ?? "0").doubleValue
            var pickLongs = JSON(currentOrder?.pickupInfo?.longitude ?? "0").doubleValue
            var pickLocation = CLLocation(latitude: pickLats, longitude: pickLongs)
            
            if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
                pickLats = JSON(currentOrder?.deliveryInfo?.latitude ?? "0").doubleValue
                pickLongs = JSON(currentOrder?.deliveryInfo?.longitude ?? "0").doubleValue
                pickLocation = CLLocation(latitude: pickLats, longitude: pickLongs)
            }
            
            let distanceMeters = courialLocation.distance(from: pickLocation)
            
            if abs(Date().minutesBetweenDate(toDate: orderAcceptTime)) < 5 && distanceMeters > 1609{
                amountToDeduct = "0.00"
            }else{
                amountToDeduct = "5.00"
            }
            
        case orderStatus.confirmPickupPointArrival:
            //Full Refund - $7
            amountToDeduct = "7.00"
            
        default:
            if JSON(currentOrder?.isSkill ?? "0").boolValue == true && (currentOrder?.status ?? 0) < 4{
                //Full Refund - $5
                amountToDeduct = "5.00"
            }else if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
                let deliveryPointArrivalTime = JSON(currentOrder?.DeliveryPointArrivalTime ?? 0).stringValue.convertStampToDate(TimeZone.init(identifier: "UTC") ?? .current) ?? Date()
                
                if abs(Date().minutesBetweenDate(toDate: deliveryPointArrivalTime)) < 5{
                    amountToDeduct = String(format: "%.02f", (self.getTotalAmount() / 2))
                }else{
                    //No Refund
                    amountToDeduct = String(format: "%.02f", self.getTotalAmount())
                }
            }else{
                //No Refund
                if (self.getTotalAmount()) < 7{
                    amountToDeduct = "7.00"
                } else{
                    amountToDeduct = String(format: "%.02f", self.getTotalAmount())
                }
            }
        }
        
        self.cardNoLbl.text = "$\(amountToDeduct) has been billed to \(card)"
    }
    
    func getTotalAmount()-> Double{
        let cp = JSON(currentOrder?.itemCost ?? "0.00").doubleValue
        let cpFee = cp  * 0.05
        let discount = JSON(currentOrder?.promoDiscount ?? "0.00").doubleValue
        
        let pickWaitCharges = JSON(currentOrder?.pickupWaitCharges ?? "0.00").doubleValue
        let DropWaitCharges = JSON(currentOrder?.dropOffWaitCharges ?? "0.00").doubleValue
        let waitCharges = pickWaitCharges + DropWaitCharges
        
        //Delivery Fee
        let deliveryFee = (JSON(currentOrder?.deliveryFee ?? "0.00").doubleValue - discount) + waitCharges
        
        //Tip
        let courialTip = JSON(currentOrder?.courialTip ?? "0.00").doubleValue
        
        //Total
        let totalAmount = deliveryFee  + cp + cpFee + courialTip
        return totalAmount
    }
    
    //MARK: BUTTONS ACTIONS
    
    @IBAction func backAct(_ sender: Any) {
        self.removeView()
    }
    
    @IBAction func cancelDelBtn(_ sender: UIButton) {
        self.infoLbl.isHidden = true
        self.cancelDelBtnOut.isHidden = true
        self.dontCancelBtnOut.isHidden = true
        
        self.cardNoLbl.isHidden = false
        self.confirmLbl.isHidden = false
        self.dontCancel2View.isHidden = false
        self.cancel2View.isHidden = false
    }
    
    @IBAction func dontCancelBtn(_ sender: UIButton) {
        self.removeView()
    }
    
    @IBAction func cancel2Btn(_ sender: UIButton) {
        SocketBase.sharedInstance.cancelOrder(currentOrder?.orderid ?? "")
        currentOrder = nil
        GoToHome()
        self.removeView()
        MediaShareInterface.shared.playSound(.cancel)
    }
    
    @IBAction func dontCancel2Btn(_ sender: UIButton) {
        self.removeView()
    }
    
    func removeView(){
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
}
