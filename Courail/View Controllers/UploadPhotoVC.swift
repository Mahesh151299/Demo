//
//  UploadPhotoVC.swift
//  Courail
//
//  Created by mac on 02/03/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class UploadPhotoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnAct(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func uploadPhotoBtn(_ sender: Any) {
        backBtnAct(self)
        
    }
    
}
