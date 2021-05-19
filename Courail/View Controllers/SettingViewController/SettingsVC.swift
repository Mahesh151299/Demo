//
//  SettingsVC.swift
//  Courail
//
//  Created by mac on 19/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

struct SettingData {
    var imgArr: [UIImage]?,
        nameArr: [String]?
}


class SettingsTVC: UITableViewCell {
    
    @IBOutlet weak var imgSetting: UIImageView!
    @IBOutlet weak var lblSetting: UILabel!
    @IBOutlet weak var bottomLine: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var iconRating: UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    
}

class SettingsVC: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var tableViewSettings: UITableView!
    @IBOutlet weak var logOutAlertView: UIView!
    
    @IBOutlet weak var buildVersion: UILabel!
    //MARK:- VARIABLES
    
    var showSettingData = SettingData(imgArr: [UIImage(named: "coin")!, UIImage(named: "magic")!, UIImage(named: "favourite")!, UIImage(named: "legal")!], nameArr: ["Default Tip Setting","Promotions","Favorite Courials","Legal"])
    
    var courials = [FavoriteCourialModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        Bundle.main.releaseVersionNumber
        
        self.buildVersion.text = "Version \(Bundle.main.releaseVersionNumber ?? "0.0") - Build \(Bundle.main.buildVersionNumber ?? "0") - \(buildDate.convertToFormat("MM/dd/yyyy", timeZone: .current))"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLoggedIn(){
            self.getCourials()
        }
    }
    
    @IBAction func menuBtn(_ sender: UIButton) {
        toggleMenu(self)
    }
    
    
}

extension SettingsVC: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return showSettingData.nameArr?.count ?? 0
        } else {
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SettingsTVC()
        if indexPath.section == 0 {
            cell = tableViewSettings.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingsTVC
            cell.imgSetting.image = showSettingData.imgArr![indexPath.row]
            cell.lblSetting.text = showSettingData.nameArr![indexPath.row]
            if indexPath.row == 3 {
                cell.bottomLine.isHidden = true
            }
            
            if indexPath.row == 2{
                if self.courials.count > 0{
                    let data = self.courials.first
                    let courialFirstName = (data?.firstName ?? "")
                    //                let courialLastName = (data.lastName ?? "")
                    //                let courialName = courialFirstName + " " + courialLastName
                    
                    cell.lblInfo.text = courialFirstName + " "
                   
                    let rating = data?.myrating ?? ""
                    cell.lblRating.text = rating
                    cell.lblInfo.isHidden = false
                    cell.lblRating.isHidden = false
                    cell.iconRating.isHidden = false
                }else{
                    cell.lblInfo.isHidden = true
                    cell.lblRating.isHidden = true
                    cell.iconRating.isHidden = true
                }
            }else{
                cell.lblInfo.isHidden = true
                cell.lblRating.isHidden = true
                cell.iconRating.isHidden = true
            }
            
            
        } else {
            cell = tableViewSettings.dequeueReusableCell(withIdentifier: "LogOutCell", for: indexPath) as! SettingsTVC
            if isLoggedIn(){
                cell.lblSetting.text = "Log Out"
            } else{
                cell.lblSetting.text = "Sign In"
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                guard checkLogin() else{return}
                let vc = storyboard?.instantiateViewController(withIdentifier: "DefaultTipVC") as! DefaultTipVC
                self.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyViewController") as! PrivacyViewController
                vc.screen = "Promotions"
                self.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 2 {
                guard checkLogin() else{return}
                let vc = storyboard?.instantiateViewController(withIdentifier: "FavoriteCourialVC") as! FavoriteCourialVC
                
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = storyboard?.instantiateViewController(withIdentifier: "LegalSettingVC") as! LegalSettingVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else  {
            guard checkLogin() else{return}
            let vc = storyboard?.instantiateViewController(withIdentifier: "AlertVC") as! AlertVC
            vc.modalPresentationStyle = .overCurrentContext
            self.view.addSubview(vc.view)
            self.addChild(vc)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row != 1 else{
            return 0
        }
        
        return UITableView.automaticDimension
    }
    
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}


extension SettingsVC {
    
    //MARK: API
    
    func getCourials(){
        showLoader()
        ApiInterface.requestApi(params: [:], api_url: API.fav_courials_list, method : .get , encoding: URLEncoding.httpBody , success: { (json) in
            
            if let data = json["data"].array{
                self.courials = data.map({FavoriteCourialModel.init(json: $0)})
            }
            self.tableViewSettings.reloadData()
            
            hideLoader()
        }) { (error, json) in
            print(error)
            hideLoader()
        }
    }
    
}
