//
//  AlertVC.swift
//  Courail
//
//  Created by mac on 20/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AlertVC: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var alertHeader: UIButton!
    @IBOutlet weak var coloredBtnText: UIButtonCustomClass!
    @IBOutlet weak var blackBtnText: UIButtonCustomClass!
    @IBOutlet weak var lblAppVersion: UILabel!
    
    //MARK:- VARIABLES
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
    @IBAction func logMeOutBtn(_ sender: Any) {
        self.logoutApi()
    }
}


extension AlertVC {
    
    //MARK:- API
    
    func logoutApi(){
        showLoader()
        ApiInterface.requestApi(params: [:], api_url: API.logout, method: .get, encoding: URLEncoding.httpBody , success: { (json) in
            hideLoader()
            logout()
        }) { (error, json) in
            hideLoader()
            logout()
        }
    }
    
}



