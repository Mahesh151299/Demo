//
//  NotificationInterface.swift
//  InstaDate
//
//  Created by apple on 12/02/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import LGSideMenuController

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    //MARK:- NOTIFICATION setup
    func setupPushNotifications(){
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in
            if granted == true{
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            }
        }
    }
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("device Token = ",deviceTokenString)
        notificationToken = deviceTokenString
        standard.setValue(notificationToken, forKey: "notifictionToken")
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Device token will not be generated in Simulator \(error)")
        notificationToken = "Simulator"
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? [String:Any]{
            let json = JSON(userInfo)
            
            let notiType = json["data"]["notitype"].intValue
            guard notiType != 88 else{
                if let appStoreUrl = URL(string: appStoreLinkUser) {
                    UIApplication.shared.open(appStoreUrl, options: [:], completionHandler: nil)
                }
                return
            }
            
            guard isLoggedIn() else {return}
            self.handelNoti(data: json)
        }
    }
    
    //Handel Notification when opened
    func handelNoti(data: JSON){
        //Open Notification
        let notiType =  data["data"]["notitype"].intValue
        let orderID = data["data"]["receiver_data"]["orderid"].stringValue
                
        var tabBarVC = ((rootVC as? LGSideMenuController)?.rootViewController as? UINavigationController)?.viewControllers.first as? TabBarVC

        if (rootVC as? LGSideMenuController)?.isLeftViewHidden == false{
            (rootVC as? LGSideMenuController)?.toggleLeftView()
        }
        
        guard orderID != "" else{return}
        
        guard notiType != 1 else {
            showLoader()
            ApiInterface.getOrderWithID(id: orderID) { (order) in
                hideLoader()
                if order != nil{
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                        let receiptVC = storyboard.instantiateViewController(withIdentifier: "FinalReceiptVC")as! FinalReceiptVC
                        receiptVC.orderDetail = order ?? CurrentOrderModel.init(json: JSON())
                        receiptVC.modalPresentationStyle = .overFullScreen
                        rootVC?.present(receiptVC, animated: true, completion: nil)
                        receiptVC.openDeliveryPhoto()
                    }
                }
            }
            return
        }
        
        
        guard currentOrder?.orderid != orderID else{
            if tabBarVC == nil{
                GoToHome()
                tabBarVC = ((rootVC as? LGSideMenuController)?.rootViewController as? UINavigationController)?.viewControllers.first as? TabBarVC
            }
            tabBarVC?.selectedIndex = 2
            return
        }
        
        if currentOrder == nil{
            ApiInterface.getCurrentOrder { (result) in
                guard currentOrder?.orderid != orderID else{
                    if tabBarVC == nil{
                        GoToHome()
                        tabBarVC = ((rootVC as? LGSideMenuController)?.rootViewController as? UINavigationController)?.viewControllers.first as? TabBarVC
                    }
                    tabBarVC?.selectedIndex = 2
                    return
                }
            }
        }
    }
    
}

