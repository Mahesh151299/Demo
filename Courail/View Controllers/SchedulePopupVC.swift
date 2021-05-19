//
//  SchedulePopupVC.swift
//  Courail
//
//  Created by Omeesh Sharma on 03/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SchedulePopupVC: UIViewController {
    
    //MARK: VARIABLES
    
    var completion: ((Int)->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func crossBtn(_ sender: UIButton) {
            self.removeView()
    }
    
    @IBAction func saveOrderBtn(_ sender: UIButton) {
        guard let result = self.completion else {
            self.removeView()
            return
        }
        result(1)
        self.removeView()
    }
    
    @IBAction func directScheduleBtn(_ sender: UIButton) {
        guard let result = self.completion else {
            self.removeView()
            return
        }
        result(2)
        self.removeView()
    }
    
    
    func removeView(){
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
}
