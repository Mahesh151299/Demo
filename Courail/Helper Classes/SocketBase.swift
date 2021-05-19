//
//  SocketBase.swift
//  CleanyDriver
//
//  Created by Apple on 3/22/18.
//  Copyright © 2018 Relinns. All rights reserved.
//

import UIKit
import SocketIO
import CoreLocation

protocol SocketDelegate: class {
    func socketResponse(data: JSON, method: String)
}

public struct socketMethods {
    public static let connect_user              =           "connect_user"
    public static let connect_listener          =           "connect_listener"
    
    public static let disconnect                =           "disconnect"
    
    public static let placeorder                =           "placeorder"
    public static let placeorder_listener       =           "placeorder_listener"
    public static let error_listener            =           "error_listener"
    
    public static let confirmOrder_listener     =           "confirmOrder_listener"
    public static let AcceptOrder_listener      =           "AcceptOrder_listener"
    
    public static let update_location_listener  =           "update_location_listener"
    
    public static let confirmPickupPointArrival_listener     = "confirmPickupPointArrival_listener"
    public static let confirmPickup_listener                 = "confirmPickup_listener"
    
    public static let courialpayrecipt_listener              = "courialpayrecipt_listener"
    
    public static let confirmDeliveryPointArrival_listener   = "confirmDeliveryPointArrival_listener"
    public static let confirmDelivery_listener               = "confirmDelivery_listener"
    
    public static let userCancelOrder                        = "userCancelOrder" //User Cancels order
    public static let userCancelOrder_listener               = "userCancelOrder_listener"
    
    public static let CancelOrder_listener                   = "CancelOrder_listener" //Partner Cancels order
    public static let decline_listener                       = "decline_listener" //Partner decline order
    public static let assignotherpartner_listener                  = "assignotherpartner_listener"
    
    public static let editorder                              = "editorder"
    public static let editorder_listener                     = "editorder_listener"
    
    public static let pausePlayTimer_listener                = "pausePlayTimer_listener"
    
    public static let tip_courial                            = "tip_courial"
    public static let tip_courial_listener                   = "tip_courial_listener"
    
    public static let nearbypartner                          = "nearbypartner"
    public static let nearbypartner_listener                 = "nearbypartner_listener"
    
    public static let nearbypartnerlist                      = "nearbypartnerlist"
    public static let nearbypartnerlist_listener             = "nearbypartnerlist_listener"
    
    public static let updateitemcost                         = "updateitemcost"
    public static let updateitemcost_listener                = "updateitemcost_listener"
    
    public static let approvalRequestListener                = "SendVerificationRequest_listener"
    
    public static let takeDeliveryVerify                     = "takeDeliveryVerify"
    public static let pausePlayTimer                         = "pausePlayTimer"
}

class SocketBase: NSObject {
    
    static let sharedInstance = SocketBase()
    
    var listnersArr  = [
        socketMethods.connect_listener,
        socketMethods.placeorder_listener,
        socketMethods.error_listener,
        socketMethods.AcceptOrder_listener,
        socketMethods.update_location_listener,
        socketMethods.confirmPickupPointArrival_listener,
        socketMethods.confirmPickup_listener,
        socketMethods.confirmDeliveryPointArrival_listener,
        socketMethods.confirmDelivery_listener,
        socketMethods.userCancelOrder_listener,
        socketMethods.CancelOrder_listener,
        socketMethods.decline_listener,
        socketMethods.editorder_listener,
        socketMethods.pausePlayTimer_listener,
        socketMethods.tip_courial_listener,
        socketMethods.nearbypartner_listener,
        socketMethods.nearbypartnerlist_listener,
        socketMethods.courialpayrecipt_listener,
        socketMethods.updateitemcost_listener,
        socketMethods.approvalRequestListener,
        socketMethods.assignotherpartner_listener
    ]
    
    
    var currentState = SocketIOStatus.notConnected
    private let manager = SocketManager(socketURL: URL(string: socketURL)!, config: [.log(true)])
    private var socket : SocketIOClient?
    weak var delegate: SocketDelegate?
    
    //MARK: constructor
    private override init() {
        super.init()
        socket = manager.defaultSocket
        socket?.connect()
        addHandlers()
    }
    
    private func addHandlers() {
        for method in listnersArr{
            socket?.on(method, callback: { (Data, emitter) in
                guard let dict = Data.first else{return}
                
                switch method{
                case socketMethods.nearbypartner_listener:
                    currentOrder?.nearbyPartnersCount = JSON(dict).intValue
                    
                case socketMethods.AcceptOrder_listener:
                    if (currentOrder?.provider?.firstName ?? "") == ""{
                        currentOrder?.provider = .init(json: JSON(dict)["Provider"])
                    } else{
                        currentOrder?.secondCourial = .init(json: JSON(dict)["secondCourial"])
                    }
                    
                    currentOrder?.confirmOrdertime = JSON(dict)["confirmOrdertime"].intValue
                    currentOrder?.status = orderStatus.Accepted
                    MediaShareInterface.shared.playSound(.accept)
                    
                case socketMethods.confirmPickupPointArrival_listener:
                    currentOrder?.status = orderStatus.confirmPickupPointArrival
                    currentOrder?.PickupPointArrivalTime = JSON(dict)["PickupPointArrivalTime"].stringValue
                    
                case socketMethods.courialpayrecipt_listener:
                    currentOrder?.pickupWaitCharges =  JSON(dict)["pickup_wait_charges"].stringValue
                    
                    currentOrder?.itemCost = JSON(dict)["itemCost"].stringValue
                    currentOrder?.actualCourialPayAmount = JSON(dict)["courialpayamount"].doubleValue
                    currentOrder?.actualCourialPayReceipt = JSON(dict)["courialpayreciptImage"].stringValue
                    
                case socketMethods.confirmPickup_listener:
                    currentOrder?.status = orderStatus.confirmPickup
                    currentOrder?.pickupWaitCharges =  JSON(dict)["pickup_wait_charges"].stringValue
                    
                    currentOrder?.itemCost = JSON(dict)["itemCost"].stringValue
                    currentOrder?.actualCourialPayAmount = JSON(dict)["courialpayamount"].doubleValue
                    currentOrder?.actualCourialPayReceipt = JSON(dict)["courialpayreciptImage"].stringValue
                    
                case socketMethods.update_location_listener:
                    currentOrder?.provider?.latitude = JSON(dict)["latitude"].stringValue
                    currentOrder?.provider?.longitude = JSON(dict)["longitude"].stringValue
                    currentOrder?.provider?.course = JSON(dict)["course"].doubleValue
                    
                case socketMethods.confirmDeliveryPointArrival_listener:
                    currentOrder?.status = orderStatus.confirmDeliveryPointArrival
                    currentOrder?.DeliveryPointArrivalTime = JSON(dict)["DeliveryPointArrivalTime"].stringValue
                    currentOrder?.isPlayed = JSON(dict)["isPlayed"].stringValue
                    currentOrder?.pausePlayDate = JSON(dict)["pausePlayDate"].stringValue
                    currentOrder?.totalPauseTime = JSON(dict)["totalPauseTime"].stringValue
                    
                    currentOrder?.itemCost = JSON(dict)["itemCost"].stringValue
                    currentOrder?.actualCourialPayAmount = JSON(dict)["courialpayamount"].doubleValue
                    currentOrder?.actualCourialPayReceipt = JSON(dict)["courialpayreciptImage"].stringValue
                    
                case socketMethods.confirmDelivery_listener:
                    currentOrder?.status = orderStatus.complete
                    currentOrder?.DeliveryPointArrivalTime = JSON(dict)["DeliveryPointArrivalTime"].stringValue
                    currentOrder?.delivery_complete_date = JSON(dict)["delivery_complete_date"].stringValue
                    currentOrder?.dropOffWaitCharges =  JSON(dict)["drop_off_wait_charges"].stringValue
                    currentOrder?.takeDeliveryPhoto =  JSON(dict)["takeDeliveryPhoto"].stringValue
                    
                    currentOrder?.itemCost = JSON(dict)["itemCost"].stringValue
                    currentOrder?.actualCourialPayAmount = JSON(dict)["courialpayamount"].doubleValue
                    currentOrder?.actualCourialPayReceipt = JSON(dict)["courialpayreciptImage"].stringValue
                    
                case socketMethods.userCancelOrder:
                    currentOrder?.status = orderStatus.cancel
                    
                case socketMethods.userCancelOrder_listener:
                    currentOrder?.status = orderStatus.cancel
                    currentOrder = nil
                    
                case socketMethods.CancelOrder_listener:
                    currentOrder?.status = orderStatus.pending
                    
                case socketMethods.assignotherpartner_listener:
                    currentOrder?.status = orderStatus.pending
                    
                case socketMethods.pausePlayTimer_listener:
                    currentOrder?.isPlayed = JSON(dict)["isPlayed"].stringValue
                    currentOrder?.pausePlayDate = JSON(dict)["pausePlayDate"].stringValue
                    currentOrder?.totalPauseTime = JSON(dict)["totalPauseTime"].stringValue
                  
                case socketMethods.approvalRequestListener:
                    if JSON(dict)["isSkill"].intValue == 1{
                        DispatchQueue.main.async {
                            if let window = UIApplication.shared.keyWindow{
                                window.rootViewController!.showAlertTwoActions(msg: "\(JSON.init(JSON(dict)["Provider"])["first_name"].stringValue) has marked this offer as complete. Do you approve?", doneBtnTitle: "YES", cancelBtnTitle: "NO") {
                                    self.verifyDeliveryPhoto(orderId: JSON(dict)["orderid"].stringValue, status: "1")
                                    self.pauseTimer()
                                    currentOrder?.DeliveryPhotoverify = 1
                                } cancelActions: {
                                    self.verifyDeliveryPhoto(orderId: JSON(dict)["orderid"].stringValue, status: "2")
                                }
                                //Play Sound
                                MediaShareInterface.shared.playSound(.accept)
                            }
                        }
                    }
                    
                case socketMethods.tip_courial_listener:
                    break;
                    
                default:
                    break;
                }
                self.delegate?.socketResponse(data: JSON(dict), method: method)
            })
        }
        
        socket?.on("error") {data, ack in
            print("This block can be used to capture different errors and not only the error to connect, you can always see the error description 'data' ")
        }
        
        socket?.onAny({ (event) in
            self.currentState = self.socket!.status
        })
        
        socket?.on(clientEvent: .disconnect, callback: { (dataArr, Ack) in
            self.socket?.connect(timeoutAfter: 1, withHandler: {
            })
        })
    }
    
    func getStatus() -> SocketIOStatus? {
        return self.socket?.status
    }
    
    func establishConnection() {
        socket?.connect()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.connectUser()
        }
    }
    
    func closeConnection() {
        socket?.disconnect()
    }
    
}

extension SocketBase{
    
    //MARK: Emitters
    
    func connectUser(){
        let dict = [
            "userId": "\(userInfo.internalIdentifier ?? 0)"
        ]
        SocketBase.sharedInstance.socketEmit(emitString: socketMethods.connect_user, data: dict)
    }
    
    
    func disConnectUser(){
        let dict = [
            "userId": "\(userInfo.internalIdentifier ?? 0)"
        ]
        SocketBase.sharedInstance.socketEmit(emitString: socketMethods.disconnect, data: dict)
    }
    
    func nearbyCourialsLocation(cords: CLLocationCoordinate2D, type: String){
        let dict = [
            "latitude" : "\(cords.latitude)",
            "longitude" : "\(cords.longitude)",
            "type": type
        ]
        SocketBase.sharedInstance.socketEmit(emitString: socketMethods.nearbypartnerlist, data: dict)
    }
    
    func placeOrder(_ orderID: String){
        let dict = [
            "orderId": orderID,
            "secondsFromGMT": "\(TimeZone.current.secondsFromGMT())",
            "timezoneID": TimeZone.current.identifier,
            "timezoneDate": "\(Date().timeIntervalSince1970)"
        ]
        SocketBase.sharedInstance.socketEmit(emitString: socketMethods.placeorder, data: dict)
    }
    
    func verifyDeliveryPhoto(orderId: String, status: String){
        let dict = [
            "orderId": orderId,
            "status": status
        ]
        SocketBase.sharedInstance.socketEmit(emitString: socketMethods.takeDeliveryVerify, data: dict)
    }
    
    //MARK:- Pause timer
    func pauseTimer(){
        let orderId = currentOrder?.orderid ?? ""
        if currentOrder?.isPlayed != "0"{
            SocketBase.sharedInstance.socketEmit(emitString: socketMethods.pausePlayTimer, data: ["orderId": orderId,
                                                                         "type": "0",
                                                                         "pausePlayDate": "\(Date().timeIntervalSince1970)",
                                                                         "totalPauseTime": currentOrder?.totalPauseTime ?? "",
                                                                         "latitude": Double(currentOrder?.provider?.latitude ?? "") ?? 0.0,
                                                                         "longitude": Double(currentOrder?.provider?.longitude ?? "") ?? 0.0, "userid": userInfo.id ?? 0])
        }
    }
    
    //MARK:- Time differnec from current time
    func getTimeDifference(_ time: String)->Int{
        let currentTimeStamp = Date().timeIntervalSince1970
        let arrivalTimeStamp = Double(time) ?? Date().timeIntervalSince1970
        let timeDiff = Int(currentTimeStamp - arrivalTimeStamp)
        return timeDiff
    }
    
    func cancelOrder(_ orderID: String){
        var cancelAmount = "0.00"
        
        switch currentOrder?.status ?? 0{
        case orderStatus.pending:
            //Full Refund
            cancelAmount = "0.00"
            
        case orderStatus.Accepted:
            //Full Refund - $5
            cancelAmount = "5.00"
            
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
            
            //USER CAN CANCEL WITH NO FEE UP TO FIVE MINUTES AFTER PARTNER ACCEPTS UNLESS PARTNER IS 1 MILE AWAY FROM PICKUP
            if abs(Date().minutesBetweenDate(toDate: orderAcceptTime)) < 5 && distanceMeters > 1609{
                cancelAmount = "0.00"
            }else{
                cancelAmount = "5.00"
            }
                        
        case orderStatus.confirmPickupPointArrival:
            //Full Refund - $7
            cancelAmount = "7.00"
            
        default:
            if JSON(currentOrder?.isSkill ?? "0").boolValue == true && (currentOrder?.status ?? 0) < 4{
                //Full Refund - $5
                cancelAmount = "5.00"
            } else if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
                let deliveryPointArrivalTime = JSON(currentOrder?.DeliveryPointArrivalTime ?? 0).stringValue.convertStampToDate(TimeZone.init(identifier: "UTC") ?? .current) ?? Date()
                
                if abs(Date().minutesBetweenDate(toDate: deliveryPointArrivalTime)) < 5{
                    cancelAmount = String(format: "%.02f", (self.getCurrentOrderTotalAmount() / 2))
                }else{
                    //No Refund
                    cancelAmount = String(format: "%.02f", self.getCurrentOrderTotalAmount())
                }
            }else{
                //No Refund
                if (self.getCurrentOrderTotalAmount()) < 7{
                    cancelAmount = "7.00"
                } else{
                    cancelAmount = String(format: "%.02f", self.getCurrentOrderTotalAmount())
                }
            }
        }
        
        let dict = [
            "orderId": orderID,
            "amount" : cancelAmount,
            "secondsFromGMT": "\(TimeZone.current.secondsFromGMT())",
            "timezoneID": TimeZone.current.identifier,
            "timezoneDate": "\(Date().timeIntervalSince1970)"
        ]
        
        SocketBase.sharedInstance.socketEmit(emitString: socketMethods.userCancelOrder, data: dict)
    }
    
    func getCurrentOrderTotalAmount()-> Double{
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
    
    
    func editOrder(_ editOrderValue: String){
        let dict : [String:Any] = [
            "orderId": currentOrder?.orderid ?? "",
            "pickUpTime" : currentOrder?.pickUpTime ?? "",
            "pickup_info" : currentOrder?.pickupInfo?.dictionaryRepresentation() ?? ["":""],
            "delivery_info": currentOrder?.deliveryInfo?.dictionaryRepresentation() ?? ["":""],
            "deliveryFee": currentOrder?.deliveryFee ?? "",
            "baseFee": currentOrder?.baseFee ?? "",
            "finalPrice": currentOrder?.finalPrice ?? "",
            "stairsElevatorFee": currentOrder?.stairsElevatorFee ?? "",
            "heavyFee": currentOrder?.heavyFee ?? "",
            "googleDistance": currentOrder?.googleDistance ?? "",
            "googleDuration": currentOrder?.googleDuration ?? "",
            "editOrderValue": editOrderValue,
            "trasnport_mode": currentOrder?.trasnportMode ?? "",
            "secondsFromGMT": "\(TimeZone.current.secondsFromGMT())",
            "timezoneID": TimeZone.current.identifier,
            "timezoneDate": "\(Date().timeIntervalSince1970)",
            "name": currentOrder?.name ?? "",
            "item_name": currentOrder?.itemName ?? "",
            "storePhone": currentOrder?.storePhone ?? "",
            "categoryImage" : currentOrder?.categoryImage ?? "",
            "categoryImageColor" : currentOrder?.categoryImageColor ?? "",
            "special_link": currentOrder?.specialLink ?? "",
            "courial_tip": currentOrder?.courialTip ?? "0.00"
        ]
        SocketBase.sharedInstance.socketEmit(emitString: socketMethods.editorder, data: dict)
        
        //Play Sound
        MediaShareInterface.shared.playSound(.accept)
    }
    
    func updateCpurialPay(_ newItemCost: String, newCPFee: String, newSubtotalType: String){
        let dict : [String:Any] = [
            "orderId": currentOrder?.orderid ?? "",
            "subTotalType": newSubtotalType,
            "itemCost": newItemCost,
            "courialPayFee": newCPFee,
            "secondsFromGMT": "\(TimeZone.current.secondsFromGMT())",
            "timezoneID": TimeZone.current.identifier,
            "timezoneDate": "\(Date().timeIntervalSince1970)"
        ]
        SocketBase.sharedInstance.socketEmit(emitString: socketMethods.updateitemcost, data: dict)
        
        //Play Sound
        MediaShareInterface.shared.playSound(.accept)
    }
    
    func tipCourial(_ orderID: String , tip: String){
        let dict = [
            "orderId": orderID,
            "courial_tip": tip
        ]
        SocketBase.sharedInstance.socketEmit(emitString: socketMethods.tip_courial, data: dict)
    }
    
    func socketEmit(emitString: String, data:[String:Any]) {
        socket?.emit(emitString, data)
    }
    
    func nearbyPartnersCount(){
        let dict = [
            "latitude": currentOrder?.deliveryInfo?.latitude ?? "0.0",
            "longitude": currentOrder?.deliveryInfo?.longitude ?? "0.0"
        ]
        SocketBase.sharedInstance.socketEmit(emitString: socketMethods.nearbypartner, data: dict)
    }
    
}
