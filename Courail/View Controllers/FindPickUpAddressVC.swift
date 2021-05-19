//
//  FindPickUpAddressVC.swift
//  Courail
//
//  Created by mac on 03/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import GoogleMaps

class FindPickUpAddressVC: UIViewController {
    
    @IBOutlet var mapVw: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapVw.delegate = self
        
        tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUseThisPickUpAddress(_ sender: Any) {
        backBtnAction(self)
        
    }
    
}

extension FindPickUpAddressVC: GMSMapViewDelegate {
    
}
