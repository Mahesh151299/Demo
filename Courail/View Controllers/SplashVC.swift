//
//  SplashVC.swift
//  Courail
//
//  Created by apple on 25/02/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var heightLogo: NSLayoutConstraint!
    @IBOutlet weak var imgLogo: UIImageView!
    
    //MARK:- View lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.animateLogo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK:- Common Functions
    private func animateLogo(){
        UIView.animate(withDuration: 10 , delay: 0, options: [] ,animations: {
            self.heightLogo.constant = 50
            self.imgLogo.layoutIfNeeded()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now()+4) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "boardingVC") as! boardingVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
