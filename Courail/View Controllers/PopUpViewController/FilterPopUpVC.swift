//
//  FilterPopUpVC.swift
//  Courail
//
//  Created by mac on 02/03/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class FilterPopUpTVC: UITableViewCell {
    //MARK: OUTLETS
    @IBOutlet weak var lblFilterTxt: UILabel!
    @IBOutlet weak var checkmarkImg: UIImageView!
    
}

class FilterPopUpVC: UIViewController {
    
    //MARK:- OUTLETS

    @IBOutlet weak var tableViewFilter: UITableView!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableBottom: NSLayoutConstraint!
    //MARK:- VARIABLES
    
    var filterArr = ["Cost","Distance","Time","Number of Reviews","Name","Rating"]
    
    var viewModel = BussinessViewModel()
    var completion : (()->())?
    
    var sortingType = 1 //Distance
    
    var isFav = false
    var favModels = [FavoriteModel]()
    
    var favCompletion : (([FavoriteModel] , _ sortingType : Int)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewFilter.tableFooterView = UIView()
        
        if self.isFav == false{
            self.sortingType = viewModel.sortingType
            self.tableViewFilter.reloadData()
        }
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom ?? 0
            self.tableBottom.constant = bottomPadding
        } else{
            self.tableBottom.constant = 0
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnAct(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableHeight.constant = self.tableViewFilter.contentSize.height
    }

}

extension FilterPopUpVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = FilterPopUpTVC()
        cell = tableViewFilter.dequeueReusableCell(withIdentifier: "FilterPopUpTVC", for: indexPath) as! FilterPopUpTVC
        cell.lblFilterTxt.text = filterArr[indexPath.row]
        
        if self.sortingType == indexPath.row {
            cell.checkmarkImg.image = #imageLiteral(resourceName: "imgCheckmark")
        } else {
            cell.checkmarkImg.image = nil
        }
        
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1{
            cell.separatorInset = .init(top: 0, left: tableView.frame.width, bottom: 0, right: 0)
        } else{
            cell.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isFav == false{
            self.sortData(indexPath.row)
        } else{
            self.sortFavData(indexPath.row)
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}

extension FilterPopUpVC{
    
    func sortData(_ index: Int){
        self.viewModel.businessData.businesses = self.viewModel.businessData.businesses?.sorted(by: { (store1, store2) -> Bool in
            switch self.filterArr[index]{
            case "Cost":
                let cost1 = (store1.price ?? "$$")
                let cost2 = (store2.price ?? "$$")
                return cost1 < cost2
            case "Distance":
                let distance1 = (store1.distance ?? "0")
                let distance2 = (store2.distance ?? "0")
                return JSON(distance1).doubleValue < JSON(distance2).doubleValue
            case "Time":
                let time1 = (store1.duration ?? "")
                let time2 = (store2.duration ?? "")
                return JSON(time1).doubleValue < JSON(time2).doubleValue
            case "Number of Reviews":
                let reviews1 = store1.reviewCount ?? 0
                let reviews2 = store2.reviewCount ?? 0
                return reviews1 > reviews2
            case "Rating":
                return (store1.rating ?? 0) > (store2.rating ?? 0)
            default :
                //"Name"
                return (store1.name ?? "").lowercased() < (store2.name ?? "").lowercased()
            }
        })
        self.tabBarController?.tabBar.isHidden = false
        viewModel.sortingType = index
        tableViewFilter.reloadData()
        self.removeFromParent()
        self.view.removeFromSuperview()
        
        guard let result = self.completion else{return}
        result()
    }

    func sortFavData(_ index: Int){
        self.favModels = favModels.sorted(by: { (store1, store2) -> Bool in
            switch self.filterArr[index]{
            case "Cost":
                let cost1 = (store1.data?.price ?? "$$")
                let cost2 = (store2.data?.price ?? "$$")
                return cost1 < cost2
            case "Distance":
                let distance1 = (store1.data?.distance ?? "0")
                let distance2 = (store2.data?.distance ?? "0")
                return JSON(distance1).doubleValue < JSON(distance2).doubleValue
            case "Time":
                let time1 = (store1.data?.duration ?? "")
                let time2 = (store2.data?.duration ?? "")
                
                return JSON(time1).doubleValue < JSON(time2).doubleValue
            case "Number of Reviews":
                let reviews1 = store1.data?.reviewCount ?? 0
                let reviews2 = store2.data?.reviewCount ?? 0
                return reviews1 > reviews2
            case "Rating":
                return (store1.data?.rating ?? 0) > (store2.data?.rating ?? 0)
            default :
                //"Name"
                return (store1.data?.name ?? "").lowercased() < (store2.data?.name ?? "").lowercased()
            }
        })
        self.tabBarController?.tabBar.isHidden = false
        self.sortingType = index
        tableViewFilter.reloadData()
        self.removeFromParent()
        self.view.removeFromSuperview()
        
        guard let result = self.favCompletion else{return}
        result(self.favModels , self.sortingType)
    }

    
    
}
