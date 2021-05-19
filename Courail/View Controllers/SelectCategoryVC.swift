//
//  SelectCategoryVC.swift
//  Courail
//
//  Created by mac on 28/01/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SelectCategoryTVC: UITableViewCell {
    @IBOutlet weak var imgCheckmark: UIImageView!
    @IBOutlet weak var lblCategoryData: UILabel!
    
}

struct selectCategoryData {
    var textData: [String]?
}

class SelectCategoryVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var tableViewSelectCategory: UITableView!
    
    //MARK:- VARIABLES
    var referenceVc = HomeVC()
    var selectedIndex = 0
    var selectCategorydataObj = selectCategoryData(textData: ["Special","Grocery","Pharmacy","Book","Electronics","Kitchen","Clothing, Shoes","Take Out-Web","Take Out-Phone","Furniture","Toys","Shoes","Office","Automotive","Jewelry","Dry Cleaning","Health & Beauty","Games","Misc Errands"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func cancelBtn(_ sender: Any) {
        referenceVc.tabBarController?.tabBar.isHidden = false
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
}

extension SelectCategoryVC: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectCategorydataObj.textData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SelectCategoryTVC()
        cell = tableViewSelectCategory.dequeueReusableCell(withIdentifier: "SelectCategoryTVC") as! SelectCategoryTVC
        if selectedIndex == indexPath.row
        {
            cell.imgCheckmark.image = #imageLiteral(resourceName: "imgCheckmark")
        }else{
            cell.imgCheckmark.image = nil
        }
        cell.lblCategoryData.text = selectCategorydataObj.textData?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
        if selectedIndex == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "SpecialDeliveryVC") as! SpecialDeliveryVC
            navigationController?.pushViewController(vc, animated: true)
            
        } else if selectedIndex == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "StoresVC") as! StoresVC
            navigationController?.pushViewController(vc, animated: true)
        } else {
            print("Nothing")
            
        }        
        cancelBtn(self)
    }
    
}
