//
//  SearchCourialsStoreVC.swift
//  Courail
//
//  Created by apple on 26/02/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SearchCourialsStoreTVC: UITableViewCell {
    
    @IBOutlet weak var lblHeaderTxt: UILabel!
    @IBOutlet weak var lblRowTittle: UILabel!
    @IBOutlet weak var checkMarkBtn: UIImageView!
    @IBOutlet weak var filterBtn: UIButton!
}

class SearchCourialsStoreVC: UIViewController {
    
    @IBOutlet weak var tableViewSearchCorialStore: UITableView!
    
    
    var HeaderData = ["“Hammer” in Favorites","“Hammer” in Nearby Stores","“Hammer” in Other Places"]
    var rowTittleData = ["Safeway","Target"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tittleHeaderBtn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SetAddressVC") as! SetAddressVC
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension SearchCourialsStoreVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return HeaderData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerCell = tableView.dequeueReusableCell(withIdentifier: "sectionHeaderCell") as! SearchCourialsStoreTVC
        headerCell.lblHeaderTxt.text = HeaderData[section]
        headerCell.filterBtn.addTarget(self, action: #selector(FilterBtnAction), for: .touchUpInside)
        
        if section == 0 {
            headerCell.filterBtn.isHidden = false
        } else {
             headerCell.filterBtn.isHidden = true
        }
   
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SearchCourialsStoreTVC()
        cell = tableViewSearchCorialStore.dequeueReusableCell(withIdentifier: "SearchCourialsStoreTVC", for: indexPath) as! SearchCourialsStoreTVC
        cell.lblRowTittle.text = rowTittleData[indexPath.row]
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.checkMarkBtn.isHidden = false
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedStoreVC") as! SelectedStoreVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    // Filter Button Act
    
    @objc func FilterBtnAction(sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "FilterPopUpVC") as! FilterPopUpVC
//        vc.modalPresentationStyle = .overCurrentContext
//        self.view.addSubview(vc.view)
//        self.addChild(vc)
    }
    
}

