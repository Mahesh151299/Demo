//
//  PopOverVC.swift
//  CourialPartner
//
//  Created by apple on 23/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class PopOverVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var table: UITableView!
    
    //MARK:- Variables
    var data = [String]()
    var selectedOption = ""
    
    var completion : ((String) -> (Void))?
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        self.table.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

extension PopOverVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopOverTVC")as! PopOverTVC
        cell.lblName.text = self.data[indexPath.row]
        cell.imgSelection.isHidden = true
        
        if self.selectedOption == cell.lblName.text{
            cell.lblName.textColor = appColor
        } else{
            cell.lblName.textColor = .black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedOption = self.data[indexPath.row]
        tableView.reloadData()
        self.dismiss(animated: true) {
            guard let closure = self.completion else {
                return
            }
            closure(self.selectedOption)
        }
        
    }
    
    
}
