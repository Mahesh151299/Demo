//
//  SignUpInfoViewController.swift
//  Courail
//
//  Created by Omeesh Sharma on 06/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class RadioTVC: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var field: UITextField!
}

class SignUpInfoViewController: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var table: UITableView!
    
    //MARK:- VARIABLES
    
    var selectedIndex = -1
    var otherField : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        self.table.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LocationInterface.shared.setupCoreLocation()
    }
    
    //MARK:- ACTIONS
    @IBAction func backBtn(_ sender: UIButton) {
        if orderInProgress{
            if let vc = self.navigationController?.viewControllers.last(where: {$0 as? TabBarVC != nil}){
                self.navigationController?.popToViewController(vc, animated: true)
            }
        } else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsPrivacyVC") as! TermsPrivacyVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func continueBtn(_ sender: UIButton) {
        guard self.selectedIndex != -1 else {
            showSwiftyAlert("", "Please select an option", false)
            return
        }
        
//        if self.selectedIndex == learnAboutUs.count{
//            if self.otherField?.text?.isEmpty == true {
//                showSwiftyAlert("", "Please enter How did you hear about us?", false)
//            } else{
//                self.appInfoApi(self.otherField?.text ?? "")
//            }
//        } else{
            self.appInfoApi(learnAboutUs[self.selectedIndex])
//        }
    }
    
}

extension SignUpInfoViewController: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return learnAboutUs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard indexPath.row != learnAboutUs.count else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherTVC" )as! RadioTVC
//
//            self.otherField = cell.field
//
//            if self.selectedIndex == indexPath.row{
//                cell.icon.image = UIImage(named: "radio_1")
//            } else{
//                cell.icon.image = UIImage(named: "radio_2")
//            }
//
//            cell.separatorInset = .init(top: 0, left: cell.frame.width, bottom: 0, right: 0)
//
//            return cell
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadioTVC" )as! RadioTVC
        cell.title.text = learnAboutUs[indexPath.row]
        
        if self.selectedIndex == indexPath.row{
            cell.icon.image = UIImage(named: "radio_1")
            cell.title.textColor = appColorBlue
        } else{
            cell.icon.image = UIImage(named: "radio_2")
            cell.title.textColor = .black
        }
        
        cell.separatorInset = .init(top: 0, left: 25, bottom: 0, right: 25)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        tableView.reloadData()
    }
    
    
}



extension SignUpInfoViewController {
    
    //MARK:- API
    
    func appInfoApi(_ value: String){
        let params: Parameters = [
            "about": value
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.learnAboutUs , success: { (json) in
            hideLoader()
            if orderInProgress{
                if let vc = self.navigationController?.viewControllers.last(where: {$0 as? TabBarVC != nil}){
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            } else{
                GoToHome()
            }
            
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
}
