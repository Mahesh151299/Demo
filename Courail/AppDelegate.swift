//
//  AppDelegate.swift
//  Courail
//
//  Created by apple on 23/01/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import GoogleMaps
import GooglePlaces
import LGSideMenuController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let userData = standard.value(forKey: AppKeys.userInfo){
            userInfo = UserInfoModel.init(json: JSON(userData))
            ApiInterface.getCatCount()
        }
        
        //Request for push notifications
        self.setupPushNotifications()
        
        _ = LocationInterface.shared
        LocationInterface.shared.checkStatus()
        _ = DeliveryAddressInterface.shared
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardAppearance = .dark
        GMSServices.provideAPIKey(gooleMapKey)
        GMSPlacesClient.provideAPIKey(googlePlacesKey)
        sleep(3)
        
        self.autoLogin()
        UpdateAvailable.isUpdateAvailable()
                
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0
        SocketBase.sharedInstance.establishConnection()
        ApiInterface.updateVersion()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        SocketBase.sharedInstance.establishConnection()
        UpdateAvailable.isUpdateAvailable()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        if url.absoluteString.contains("com.live.courialuser://search"){
            DispatchQueue.main.async {
                var tabBarVC = ((rootVC as? LGSideMenuController)?.rootViewController as? UINavigationController)?.viewControllers.first as? TabBarVC
                if tabBarVC == nil{
                    GoToHome()
                    tabBarVC = ((rootVC as? LGSideMenuController)?.rootViewController as? UINavigationController)?.viewControllers.first as? TabBarVC
                }
                tabBarVC?.selectedIndex = 1
            }
        }else if url.absoluteString.contains("com.live.courialuser://details?user_id="){
            let userID = JSON(url.valueOf("user_id") ?? "0").stringValue
            DispatchQueue.main.async {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let resetPass = storyboard.instantiateViewController(withIdentifier: "ResetPasswordVC")as! ResetPasswordVC
                resetPass.userID = userID
                resetPass.modalPresentationStyle = .overFullScreen
                resetPass.showTabBar = rootVC?.tabBarController?.tabBar.isHidden ?? false
                rootVC?.tabBarController?.tabBar.isHidden = true
                rootVC?.present(resetPass, animated: true, completion: nil)
            }
        }else if url.absoluteString.contains("com.live.courialuser://details?orderid"){
            let orderID = JSON(url.valueOf("orderid") ?? "0").stringValue
            if isLoggedIn(){
                if currentOrder?.orderid == orderID{
                    if (currentOrder?.status == orderStatus.complete){
                        DispatchQueue.main.async {
                            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                            let receiptVC = storyboard.instantiateViewController(withIdentifier: "FinalReceiptVC")as! FinalReceiptVC
                            receiptVC.orderDetail = currentOrder ?? CurrentOrderModel.init(json: JSON())
                            receiptVC.modalPresentationStyle = .overFullScreen
                            rootVC?.present(receiptVC, animated: true, completion: nil)
                        }
                    }else{
                        SocketBase.sharedInstance.establishConnection()
                        DispatchQueue.main.async {
                            var tabBarVC = ((rootVC as? LGSideMenuController)?.rootViewController as? UINavigationController)?.viewControllers.first as? TabBarVC
                            if tabBarVC == nil{
                                GoToHome()
                                tabBarVC = ((rootVC as? LGSideMenuController)?.rootViewController as? UINavigationController)?.viewControllers.first as? TabBarVC
                            }
                            tabBarVC?.selectedIndex = 2
                        }
                    }
                }else{
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
                            }
                        }
                    }
                }
            }
        }
        return true
    }
    
    //MARK:- AutoLogin
    func autoLogin() {
        if let userData = standard.value(forKey: AppKeys.userInfo){
            userInfo = UserInfoModel.init(json: JSON(userData))
            ApiInterface.getCatCount()
            if let addModel = userInfo.selectedAddress{
                DeliveryAddressInterface.shared.selectedAddress = addModel
                GoToHome()
            } else{
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SetAddressVC") as! SetAddressVC
                let nav = UINavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                rootVC = vc
            }
        }
    }
}


extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}

