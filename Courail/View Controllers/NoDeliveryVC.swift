//
//  NoDeliveryVC.swift
//  Courail
//
//  Created by mac on 28/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class NoDeliveryVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var backBtnOut: UIButton!
    
    @IBOutlet weak var headerTitle: UILabel!
    //MARK:- VARIABLES
    
    var fromMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.fromMenu{
            self.backBtnOut.setImage(UIImage(named: "newBar"), for: .normal)
        } else{
            self.backBtnOut.setImage(UIImage(named: "arrow_3Temp"), for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let str = isLoggedIn() ? ((userInfo.firstName ?? "") + "'s") : "Your"
        self.headerTitle.text = str + " Order"
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func MenuOrGoBack(_ sender:UIButton){
        if fromMenu{
            toggleMenu(self)
        }else{
            self.pop()
        }
    }
    
    @IBAction func seduleBack(_ sender:UIButton){
        GoToHome()
    }
    

    
}
