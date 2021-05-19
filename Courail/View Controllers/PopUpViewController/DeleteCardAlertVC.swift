//
//  DeleteCardAlertVC.swift
//  Courail
//
//  Created by mac on 27/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class DeleteCardAlertVC: UIViewController {

    @IBOutlet weak var deleteView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackBtnClicked(_ sender: Any) {
        CancelBtn(self)
    }
    
    @IBAction func DeleteCardBtn(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.deleteView.isHidden = false
        }
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.deleteView.isHidden = true
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func CancelBtn(_ sender: Any) {
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
}
