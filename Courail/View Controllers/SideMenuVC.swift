//
//  SideMenuVC.swift
//  Courail
//
//  Created by apple on 24/01/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import LGSideMenuController

func toggleMenu(_ vc: UIViewController){
    (vc.sideMenuController?.leftViewController as? SideMenuVC)?.viewWillAppear(false)
    vc.sideMenuController?.toggleLeftView(animated: true, completionHandler: {
    })
}


class SideMenuTFV: UITableViewHeaderFooterView {
    
}

class SideMenuTVC: UITableViewCell {
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgViewIcon: UIImageView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblSepratorLine: UILabel!
    @IBOutlet weak var creditValue: UILabel!
}

struct SideMenuData {
    var imgArr: [UIImage]?,
    nameArr: [String]?
}

class SideMenuVC: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var viewProfileBtnOut: UIButton!
    @IBOutlet var tblViewMenuList: UITableView!
    @IBOutlet weak var imgSideMenu: UIImageViewCustomClass!
    
    //MARK:- VARIABLES
    
//    var sideMenuDataObj = SideMenuData(imgArr: [UIImage(named: "Newhome-clr2_2")!, UIImage(named: "pin_new")!,  UIImage(named: "friends")!, UIImage(named: "payment-1")!, UIImage(named: "email")!, UIImage(named: "helpppp")!, UIImage(named: "rate")!, UIImage(named: "setting")!,UIImage(named: "imgCredits")!], nameArr: ["Home","Saved Addresses","Refer Friends, Get $55","Payment","Contact Us","Get Help","Rate Our App","Settings","Credits"])
    var sideMenuDataObj = SideMenuData(imgArr: [UIImage(named: "Newhome-clr2_2")!, UIImage(named: "pin_new")!,  UIImage(named: "friends")!, UIImage(named: "payment-1")!, UIImage(named: "email")!, UIImage(named: "helpppp")!, UIImage(named: "setting")!,UIImage(named: "imgCredits")!], nameArr: ["Home","Saved Addresses","Refer Friends, Get $55","Payment","Contact Us","Get Help","Settings","Credits"])

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialUpdates()
        // Do any additional setup after loading the view.
        imgSideMenu.layer.cornerRadius = imgSideMenu.frame.height/2
        imgSideMenu.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let firstName = userInfo.firstName ?? ""
        let lastName = userInfo.lastName ?? ""
        if lastName != ""{
            self.nameLbl.text = firstName + "\n" + lastName
        }else{
            self.nameLbl.text = firstName
        }
        
        self.imgSideMenu.sd_setImage(with: URL(string: userInfo.image ?? ""), placeholderImage: UIImage(named: "imgPlaceholder"), options: [], completed: nil)
        
        if isLoggedIn(){
            self.viewProfileBtnOut.isHidden = false
        } else{
            self.viewProfileBtnOut.isHidden = true
        }
    }
    
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func BtnViewProfile(_ sender: Any) {
        guard checkLogin() else{
            toggleMenu(self)
            return
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        
        let sideMenu = storyboard?.instantiateViewController(withIdentifier: "LGSideMenuController") as! LGSideMenuController
        sideMenu.rootViewController = navController
        sideMenu.leftViewPresentationStyle = .slideAbove
        sideMenu.leftViewWidth = 270
        
        appDelegate.window?.rootViewController = sideMenu
    }
    
    
    @IBAction func actionEditProfile(_ sender: Any) {
        guard checkLogin() else{
            toggleMenu(self)
            return
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        vc.openPopUp = "open"
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        
        let sideMenu = storyboard?.instantiateViewController(withIdentifier: "LGSideMenuController") as! LGSideMenuController
        sideMenu.rootViewController = navController
        sideMenu.leftViewPresentationStyle = .slideAbove
        sideMenu.leftViewWidth = 270
        
        appDelegate.window?.rootViewController = sideMenu
    }
    
}

extension SideMenuVC : LGSideMenuDelegate{
    
    func initialUpdates(){
        let footerNib = UINib.init(nibName: "SideMenuFooter", bundle: Bundle.main)
        tblViewMenuList.register(footerNib, forHeaderFooterViewReuseIdentifier: "SideMenuTFV")
    }
    
}

extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return sideMenuDataObj.nameArr?.count ?? 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SideMenuTVC()
        
        switch indexPath.section{
        case 0:
            if indexPath.row == 2{
                cell = tblViewMenuList.dequeueReusableCell(withIdentifier: "ReferTVC", for: indexPath) as! SideMenuTVC
                cell.lblName.text = sideMenuDataObj.nameArr?[indexPath.row]
                cell.bottomConstraint.constant = 0
                cell.lblSepratorLine.isHidden = false
            }else if indexPath.row == ((sideMenuDataObj.nameArr?.count ?? 0) - 1) {
                cell = tblViewMenuList.dequeueReusableCell(withIdentifier: "SideMenuCreditsTVC", for: indexPath) as! SideMenuTVC
                cell.bottomConstraint.constant = 0
                cell.lblSepratorLine.isHidden = true
                
                cell.creditValue.text = "$" + String(format: "%.02f", userInfo.referralamount ?? 0.0)
            }else{
                cell = tblViewMenuList.dequeueReusableCell(withIdentifier: "SideMenuTVC", for: indexPath) as! SideMenuTVC
                cell.lblName.text = sideMenuDataObj.nameArr?[indexPath.row]
                cell.imgViewIcon.image = sideMenuDataObj.imgArr?[indexPath.row]
                
                cell.bottomConstraint.constant = 0
                cell.lblSepratorLine.isHidden = false
            }
        case 1:
            cell = tblViewMenuList.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as! SideMenuTVC
            
        default:
            cell = tblViewMenuList.dequeueReusableCell(withIdentifier: "BottomCell", for: indexPath) as! SideMenuTVC
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 1 else {
            guard checkLogin() else{
                toggleMenu(self)
                return
            }
            
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "NearbyCourialsVC") as! NearbyCourialsVC
                detailVC.type = 1
            
            let navController = UINavigationController(rootViewController: detailVC)
            navController.isNavigationBarHidden = true
            
            let sideMenu = storyboard?.instantiateViewController(withIdentifier: "LGSideMenuController") as! LGSideMenuController
            sideMenu.rootViewController = navController
            sideMenu.leftViewPresentationStyle = .slideAbove
            sideMenu.leftViewWidth = 280
            
            appDelegate.window?.rootViewController = sideMenu
            
            return
        }
        
        guard indexPath.section != 2 else {
            if let url = URL(string: "com.live.courialPartner://") {
                guard UIApplication.shared.canOpenURL(url) else{
                    if let appStoreUrl = URL(string: appStoreLinkPartner) {
                        UIApplication.shared.open(appStoreUrl, options: [:], completionHandler: nil)
                    }
                    return
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            return
        }
        
        switch indexPath.row {
        case 0:
            GoToHome()
            
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: "SavedDeliveryAddressVC") as! SavedDeliveryAddressVC
            vc.fromMenu = true
            let navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            
            let sideMenu = storyboard?.instantiateViewController(withIdentifier: "LGSideMenuController") as! LGSideMenuController
            sideMenu.rootViewController = navController
            sideMenu.leftViewPresentationStyle = .slideAbove
            sideMenu.leftViewWidth = 280
            
            appDelegate.window?.rootViewController = sideMenu
            
        case 2:
            guard checkLogin() else{
                toggleMenu(self)
                return
            }
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "ReferFriendVC") as! ReferFriendVC
            let navController = UINavigationController(rootViewController: detailVC)
            navController.isNavigationBarHidden = true
            
            let sideMenu = storyboard?.instantiateViewController(withIdentifier: "LGSideMenuController") as! LGSideMenuController
            sideMenu.rootViewController = navController
            sideMenu.leftViewPresentationStyle = .slideAbove
            sideMenu.leftViewWidth = 280
            
            appDelegate.window?.rootViewController = sideMenu
            
            
        case 3:
            
            guard checkLogin() else{
                toggleMenu(self)
                return
            }
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "PaymentMethodVC") as! PaymentMethodVC
            detailVC.fromMenu = true
            
            let navController = UINavigationController(rootViewController: detailVC)
            navController.isNavigationBarHidden = true
            
            let sideMenu = storyboard?.instantiateViewController(withIdentifier: "LGSideMenuController") as! LGSideMenuController
            sideMenu.rootViewController = navController
            sideMenu.leftViewPresentationStyle = .slideAbove
            sideMenu.leftViewWidth = 280
            
            appDelegate.window?.rootViewController = sideMenu
            
        case 4:
            
            MediaShareInterface.shared.supportEmail(self)
           
            
        case 5:
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "PrivacyViewController") as! PrivacyViewController
            detailVC.fromMenu = true
            detailVC.screen = "Get Help"
            
            let navController = UINavigationController(rootViewController: detailVC)
            navController.isNavigationBarHidden = true
            
            let sideMenu = storyboard?.instantiateViewController(withIdentifier: "LGSideMenuController") as! LGSideMenuController
            sideMenu.rootViewController = navController
            sideMenu.leftViewPresentationStyle = .slideAbove
            sideMenu.leftViewWidth = 280
            
            appDelegate.window?.rootViewController = sideMenu
            
            
//        case 6:
//            let rateView = RatingView.init(frame: screenFrame()) { (result) in
//                if result < 4{
//                    MediaShareInterface.shared.ratingEmail(self)
//                }else{
//                    _ = RatingInterface(appID : appID)
//                }
//            }
//            rootVC?.view.addSubview(rateView)
            
            
        case 6:
            
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
            
            let navController = UINavigationController(rootViewController: detailVC)
            navController.isNavigationBarHidden = true
            
            let sideMenu = storyboard?.instantiateViewController(withIdentifier: "LGSideMenuController") as! LGSideMenuController
            sideMenu.rootViewController = navController
            sideMenu.leftViewPresentationStyle = .slideAbove
            sideMenu.leftViewWidth = 280
            
            appDelegate.window?.rootViewController = sideMenu
        case 7:
            guard checkLogin() else{
                toggleMenu(self)
                return
            }
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "ReferStatusVC") as! ReferStatusVC
            
            let navController = UINavigationController(rootViewController: detailVC)
            navController.isNavigationBarHidden = true
            
            let sideMenu = storyboard?.instantiateViewController(withIdentifier: "LGSideMenuController") as! LGSideMenuController
            sideMenu.rootViewController = navController
            sideMenu.leftViewPresentationStyle = .slideAbove
            sideMenu.leftViewWidth = 280
            
            appDelegate.window?.rootViewController = sideMenu
            
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            // return 65
            if 0...1 ~= indexPath.row{
                return 55
            } else {
                return 45
            }
        case 1:
            return 55
        default:
            return 65
        }
    }
    
    
    func clearDBApi(){
        ApiInterface.requestApi(params: [:], api_url: API.clearAlldb , success: { (json) in
            showSwiftyAlert("", json["msg"].stringValue, true)
            toggleMenu(self)
            presentWelcome()
        }) { (error, json) in
            showSwiftyAlert("", error, false)
        }
    }
    
}

