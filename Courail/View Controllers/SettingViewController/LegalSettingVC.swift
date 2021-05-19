//
//  LegalSettingVC.swift
//  Courail
//
//  Created by mac on 20/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class LegalSettingTVC: UITableViewCell {
    
    @IBOutlet weak var lblLegalTxt: UILabel!
}

class LegalSettingVC: UIViewController {

    @IBOutlet weak var tableViewLegal: UITableView!
    
    var legalArr = ["Terms of Service","Privacy Policy","Licenses"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension LegalSettingVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = LegalSettingTVC()
        cell = tableViewLegal.dequeueReusableCell(withIdentifier: "LegalSettingTVC", for: indexPath) as! LegalSettingTVC
        cell.lblLegalTxt.text = legalArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyViewController") as! PrivacyViewController
        if indexPath.row == 0 {
            vc.screen = "Terms of Service"
        }else if indexPath.row == 1 {
            vc.screen = "Privacy Policy"
        } else{
            vc.screen = "Licenses"
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row != 2 else{
            return 0
        }
        return UITableView.automaticDimension
    }
    
}
