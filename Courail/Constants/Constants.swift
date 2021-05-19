//
//  Constants.swift
//
//  Created by apple on 26/11/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import SwiftMessages
import LGSideMenuController
import MBProgressHUD
import WebKit

let appName = "Courial"

let appColor = #colorLiteral(red: 1, green: 0.3529411765, blue: 0, alpha: 1)
let appColorBlue = UIColor(red: 52/255, green: 73/255, blue:  94/255, alpha: 1.0)

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let reachability = Reachability() // To Check internet is connected or not

let appID = "1521638262"

let gooleMapKey = "AIzaSyDG3ftTHL_IMGAd8c8vU-q0Oi-oURgTeKE"
let googlePlacesKey = "AIzaSyDG3ftTHL_IMGAd8c8vU-q0Oi-oURgTeKE"

let openWeatherKey = "9746585a191ae07397e0fdbaf7bcb938"
let tollGuruKey = "p3Q7LMDNGRMGtnDgm7MDhPBqDGGB6pnF"
let googleCX = "004831390379400077845:bsbcyzw54pb"

let twilioCallingNo = "+14422694038"
let courialPartnerNo = "4154138581"

var currentCategory = ""
var currentCategoryIndex = 50021

let appStoreLinkPartner = "https://apps.apple.com/us/app/courial-partner/id1521638474"
let appStoreLinkUser = "https://apps.apple.com/us/app/courial/id1521638262"

let twilioBaseURL = "http://13.57.84.213:8099"

//MARK: Https Live Server
let socketURL = "https://gocourial.com"
let baseURL = "https://gocourial.com/userApis/"


//MARK: Test Server
//let socketURL = "http://52.52.142.145:8099"
//let baseURL = "http://52.52.142.145:8099/userApis/"

let standard = UserDefaults.standard

public var iOSplatform = "1"

var currentDeviceType = "default"

var isIpad = false

public var notificationToken = "simulator"

var splashTransistion = true

var orderInProgress = false
var deleteOrderFlag = false
var changingDeliveryAdd = true
var currentOrderDelchange = false

/*********************************************************  Structures  ************************************************************************/

enum API {
    static let clearAlldb                   =           "clearAlldb"
    
    static let check_phone                  =           "check_phone"
    static let send_otp                     =           "send_otp"
    static let mobile_send_otp              =           "mobile_send_otp"
    static let signup                       =           "signup"
    static let login                        =           "login"
    static let learnAboutUs                 =           "learnAboutUs"
    static let logout                       =           "logout"
    static let forgot_password              =           "forgot_password"
    static let get_profile                  =           "get_profile"
    static let edit_profile                 =           "edit_profile"
    static let update_phone                 =           "update_phone"
    static let update_email                 =           "update_email"
    static let change_password              =           "change_password"
    static let reset_userpassword           =           "reset_userpassword"
    
    static let increase_category_count      =           "increase_category_count"
    static let get_category_count           =           "get_category_count"
    static let get_refreluser               =           "get_refreluser"
    static let creditrefrelamount           =           "creditrefrelamount"
    
    static let sendpushtosuse               =           "sendpushtosuse"
    
    static let applyrefrelcode               =          "applyrefrelcode"
    
    
    static let updateSocialMedia            =           "edit_socialmedia"
    
    static let viewoffers                   =           "viewoffers"
    
    static let add_address                  =           "add_address"
    static let edit_address                 =           "edit_address"
    static let get_address                  =           "get_address"
    static let delete_address               =           "delete_address"
    static let select_default_address       =           "select_default_address"
    
    static let upload_image                 =           "upload_image"
    static let add_fav_businesss            =           "add_fav_businesss"
    static let remove_fav_businesss         =           "remove_fav_businesss"
    static let get_fav_businesss            =           "get_fav_businesss"
    static let Increase_fav_count           =           "Increase_fav_count"
    
    static let get_online_business          =           "get_online_business"
    static let add_edit_online_business     =           "add_edit_online_business"
    static let delete_online_business       =           "delete_online_business"
    
    static let get_offers                   =           "get_offers"
    static let get_ads                      =           "get_ads"
    static let updateinfo                   =           "updateinfo"
    
    static let get_call_details             =           "get_call_details"
    
    static let pricing_info                 =           "pricing_info"
    static let calculation_fee              =           "calculation_fee"
    static let special_calculation_fee      =           "special_calculation_fee"
    
    static let generate_order_id            =           "generate_order_id"
    static let apply_promo                  =           "apply_promo"
    
    static let createCard                   =           "createCard"
    static let get_card                     =           "get_card"
    static let delete_card                  =           "delete_card"
    
    static let select_default_card         =           "select_default_card"
    static let select_default_tip          =           "select_default_tip"
    
    static let placeorder                  =           "placeorder"
    static let get_current_order           =           "get_current_order"
    static let get_orders_history          =           "get_orders_history"
    static let getorderdetail              =           "getorderdetail"
    
    
    static let fav_courials_list           =           "fav_courials_list"
    static let add_fav_courial             =           "add_fav_courial"
    static let remove_fav_courial          =           "remove_fav_courial"
    static let rate_courial                =           "rate_courial"
    static let skip_rate                   =           "skip_rate"
    
    static let upload_Identification       =           "upload_Identification"
}

public enum AppKeys {
    static let authKey      =     "auth_key"
    static let userInfo     =     "userInfo"
}


public enum Twilio {
    static let accountSid          =     "AC58c577c32a0cdae3b46eee6f12331981"
    static let apiKey              =     "SK84aae07343c34d40617601e0cb717d9a"
    static let apiSecret           =     "X4cq73m1pk1F7nlFd2tSOUp4WtlIQJbj"
    static let appSid              =     "AP40d0ddf3f34146f5297317a20e0dcb05"
    static let pushSid             =     "CRea27219c8896b8484bd485b9a8f103e1"
    
    static let accessTokenEndpoint =     "cf6c7296f29645c1c34732cb3ad04042"
    static let identity            =     "corial"
    static let twimlParamTo        =     "to"
}


public enum orderStatus {
    static let pending                      =     0
    static let Accepted                     =     1
    static let confirmPickupPointArrival    =     2
    static let confirmPickup                =     3
    static let confirmDeliveryPointArrival  =     4
    static let userIdentityVerified         =     5
    static let complete                     =     6
    static let cancel                       =     7
}


public enum appSounds: String{
    case cancel = "cancel2"
    case accept = "accept2"
}


var rootVC: UIViewController?{
    get{
        return UIApplication.shared.windows.first?.rootViewController
    }
    set{
        UIApplication.shared.windows.first?.rootViewController = newValue
    }
}

func showSwiftyAlert(_ Title :String,_ body: String ,_ isSuccess : Bool, _ duration: TimeInterval = 3){
    SwiftMessages.hideAll()
    DispatchQueue.main.async {
        let warning = MessageView.viewFromNib(layout: .cardView)
        warning.configureTheme(isSuccess ? .success : .error)
        warning.backgroundView.backgroundColor = appColorBlue
        warning.configureDropShadow()
        warning.configureContent(title: Title, body: body)
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        warningConfig.duration = .seconds(seconds: duration)
        SwiftMessages.show(config: warningConfig, view: warning)
    }
}


var userInfo = UserInfoModel.init(json: JSON()){
    didSet{
        standard.set(userInfo.token, forKey: AppKeys.authKey)
        standard.set(userInfo.dictionaryRepresentation(), forKey: AppKeys.userInfo)
    }
}


var currentOrderPoints: [String]?
var currentOrder : CurrentOrderModel?{
    didSet{
        orderInProgress = false
    }
}

func saveUserInfo(){
    standard.set(userInfo.token, forKey: AppKeys.authKey)
    standard.set(userInfo.dictionaryRepresentation(), forKey: AppKeys.userInfo)
}


func isLoggedIn()->Bool{
    if  standard.value(forKey: AppKeys.userInfo) != nil{
        return true
    } else{
        return false
    }
}

var buildDate: Date {
    if let infoPath = Bundle.main.path(forResource: "Info", ofType: "plist"),
       let infoAttr = try? FileManager.default.attributesOfItem(atPath: infoPath),
       let infoDate = infoAttr[.modificationDate] as? Date {
        return infoDate
    }
    return Date()
}

//Headers
func createHeaders()-> [String: String]{
    let headers = [
        "Authorization": "Bearer \(standard.string(forKey: AppKeys.authKey) ?? "")",
        "security_key": "curial@0#-129"
    ]
    return headers
}



func GoToHome(){
    if isLoggedIn(){
        SocketBase.sharedInstance.establishConnection()
        SocketBase.sharedInstance.connectUser()
    }
    
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
    let nav = UINavigationController(rootViewController: vc)
    nav.isNavigationBarHidden = true
    let sideMenu = storyboard.instantiateViewController(withIdentifier: "LGSideMenuController") as! LGSideMenuController
    sideMenu.rootViewController = nav
    sideMenu.leftViewPresentationStyle = .slideAbove
    sideMenu.leftViewWidth = 270
    sideMenu.isLeftViewSwipeGestureEnabled = false
    
    if DeliveryAddressInterface.shared.selectedAddress.internalIdentifier == nil{
        let vcSetAddress = storyboard.instantiateViewController(withIdentifier: "SetAddressVC") as! SetAddressVC
        
        if let vc = (rootVC?.tabBarController?.viewControllers?[0] as? UINavigationController){
            rootVC?.tabBarController?.selectedIndex = 0
            rootVC?.tabBarController?.tabBar.isHidden = true
            (vc.viewControllers.first as? HomeVC)?.navigationController?.pushViewController(vcSetAddress, animated: false)
        } else if let vc = ((rootVC as? LGSideMenuController)?.rootViewController as? UINavigationController){
            vc.pushViewController(vcSetAddress, animated: false)
        } else{
            (rootVC as? UINavigationController)?.pushViewController(vcSetAddress, animated: false)
        }
    } else{
        rootVC = sideMenu
    }
}


func goToSpecialDelivery(_ from: UIViewController){
    if DeliveryAddressInterface.shared.selectedAddress.internalIdentifier == nil{
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vcSetAddress = storyboard.instantiateViewController(withIdentifier: "SetAddressVC") as! SetAddressVC
        if let vc = (rootVC?.tabBarController?.viewControllers?[0] as? UINavigationController){
            rootVC?.tabBarController?.selectedIndex = 0
            rootVC?.tabBarController?.tabBar.isHidden = true
            (vc.viewControllers.first as? HomeVC)?.navigationController?.pushViewController(vcSetAddress, animated: false)
        } else if let vc = ((rootVC as? LGSideMenuController)?.rootViewController as? UINavigationController){
            vc.pushViewController(vcSetAddress, animated: false)
        } else{
            (rootVC as? UINavigationController)?.pushViewController(vcSetAddress, animated: false)
        }
    }  else{
        if let vc = from.navigationController?.viewControllers.last(where: {($0 as? SpecialDeliveryVC) != nil}){
            from.navigationController?.popToViewController(vc, animated: true)
        } else{
            GoToHome()
        }
    }
}

func deleteOrder(completion: @escaping(Bool)->Void){
    let deletePopup = DeleteView.init(frame: screenFrame(), msg: "Delete this Order?") { (result) in
        guard result == true else{return}
        deleteOrderFlag = false
        completion(result)
    }
    rootVC?.view.addSubview(deletePopup)
}

func goToCurrentOrder(_ vc: UIViewController, _ addressChanged: Bool)->Bool{
    if currentOrderDelchange == true || deleteOrderFlag == true{
        if let vc = vc.navigationController?.viewControllers.last(where: {($0 as? QueueDeliveryDetailVC) != nil}){
            if addressChanged{
                (vc as? QueueDeliveryDetailVC)?.addressChanged()
            }
            vc.navigationController?.popToViewController(vc, animated: false)
        }else if let vc = vc.navigationController?.viewControllers.last(where: {($0 as? SpecialDeliveryAddToQueueVC) != nil}){
            if addressChanged{
                (vc as? SpecialDeliveryAddToQueueVC)?.addressChanged()
            }
            vc.navigationController?.popToViewController(vc, animated: false)
        }else if let vc = vc.navigationController?.viewControllers.last(where: {($0 as? SpecialSkillOrderVC) != nil}){
            if addressChanged{
                (vc as? SpecialSkillOrderVC)?.addressChanged()
            }
            vc.navigationController?.popToViewController(vc, animated: false)
        }else if let vc = vc.navigationController?.viewControllers.last(where: {($0 as? CurrentOrderVC) != nil}){
            currentOrderDelchange = false
            vc.navigationController?.popToViewController(vc, animated: false)
            if addressChanged{
                (vc as? CurrentOrderVC)?.addressChanged()
            }
        }
        return true
    } else{
        return false
    }
}


func logout(){
    currentOrder = nil
    SocketBase.sharedInstance.disConnectUser()
    
    userInfo = UserInfoModel.init(json: JSON())
    standard.setValue(nil, forKey: AppKeys.authKey)
    standard.setValue(nil, forKey: AppKeys.userInfo)
    
    DeliveryAddressInterface.shared.resetHomeAdd()
    DeliveryAddressInterface.shared.resetWorkAdd()
    DeliveryAddressInterface.shared.savedAddresses.removeAll()
    DeliveryAddressInterface.shared.searchedAddresses.removeAll()
    
    PickUpAddressInterface.shared.setData()
    PickUpAddressInterface.shared.savedAddresses.removeAll()
    
    for i in 0..<appCategories.count{
        appCategories[i]["count"].intValue = 0
    }
    
    appUrls = appDefaultUrls
    
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    let onboardVC = storyboard.instantiateViewController(withIdentifier: "boardingVC")as! boardingVC
    
    let singInvc = storyboard.instantiateViewController(withIdentifier: "SignInVC")as! SignInVC
    let phoneVC = storyboard.instantiateViewController(withIdentifier: "SignUpAVC")as! SignUpAVC
    let nav = UINavigationController()
    nav.isNavigationBarHidden = true
    nav.viewControllers = [onboardVC,phoneVC,singInvc]
    rootVC = nav
}

func presentWelcome(){
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    let phoneVC = storyboard.instantiateViewController(withIdentifier: "SignUpAVC")as! SignUpAVC
    phoneVC.ongoingProcess = true
    
    if let nav = (rootVC as? UINavigationController) ?? ((rootVC as! LGSideMenuController).rootViewController as? UINavigationController){
        nav.pushViewController(phoneVC, animated: true)
    }
    
    let tabBarHidden = rootVC?.tabBarController?.tabBar.isHidden ?? true
    rootVC?.tabBarController?.tabBar.isHidden = true
    phoneVC.closed = {
        rootVC?.tabBarController?.tabBar.isHidden = tabBarHidden
    }
}

func screenFrame()-> CGRect{
    if let rootView = rootVC?.view{
        if #available(iOS 11.0, *) {
            let height = rootView.frame.height + rootView.safeAreaInsets.top + rootView.safeAreaInsets.bottom
            return CGRect(x: 0, y: -rootView.safeAreaInsets.top, width: rootView.frame.width, height: height)
        } else {
            // Fallback on earlier versions
            return UIScreen.main.bounds
        }
    } else{
        return UIScreen.main.bounds
    }
}

func showLoader() {
    guard let root = rootVC?.view else{
        return
    }
    MBProgressHUD.showAdded(to: root, animated: true)
}

func hideLoader() {
    guard let root = rootVC?.view else{
        return
    }
    MBProgressHUD.hide(for: root, animated: true)
}


func checkLogin()-> Bool{
    guard isLoggedIn() else {
        presentWelcome()
        return false
    }
    return true
}
