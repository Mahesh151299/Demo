//
//  FavoriteCourialVC.swift
//  Courail
//
//  Created by mac on 20/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class FavoriteCourialTVC: UITableViewCell {
    
    @IBOutlet weak var courialImage: UIImageView!
    @IBOutlet weak var courialName: UILabel!
    @IBOutlet weak var courialReview: UILabel!
    
    @IBOutlet weak var courialRating: UILabel!
    @IBOutlet weak var courialDeliveries: UILabel!
    
}

class FavoriteCourialVC: UIViewController {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var tableViewFavoriteCourial: UITableView!
    
    //MARK: VARIABLES
    
    var courials = [FavoriteCourialModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCourials()
        // Do any additional setup after loading the view.
    }
    @IBAction func backBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension FavoriteCourialVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courials.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCourialTVC", for: indexPath) as! FavoriteCourialTVC
        
        let data = self.courials[indexPath.row]
        cell.courialImage.sd_setImage(with: URL(string: data.image ?? ""), placeholderImage: nil, options: [], completed: nil)
        
        let courialFirstName = (data.firstName ?? "")
        let courialLastName = (data.lastName ?? "")
        let courialName = courialFirstName + " " + courialLastName
        
        cell.courialName.text = courialName
        cell.courialReview.text = data.myreview ?? ""
        
        if JSON(data.myrating ?? "0").doubleValue < 4.5{
            cell.courialRating.text = "4.5"
        }else{
            cell.courialRating.text = (data.myrating ?? "")
        }
        
//        cell.courialDeliveries.text = "\(data.totalDeliveries ?? 0)"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemoveCardTVC")as! PaymentMethodTVC
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard self.courials.isEmpty == false else{
            return 0
        }
        
        return 130
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            self.removeFavCourial(index: indexPath.row)
        }
    }
}


extension FavoriteCourialVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource{
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = "No Courial found!"
        
        let font = UIFont.boldSystemFont(ofSize: 20)
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        let title = "Tap here to try again?"
        
        let font = UIFont.boldSystemFont(ofSize: 20)
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.getCourials()
    }
    
}

extension FavoriteCourialVC {
    
    //MARK: API
    
    func getCourials(){
        showLoader()
        ApiInterface.requestApi(params: [:], api_url: API.fav_courials_list, method : .get , encoding: URLEncoding.httpBody , success: { (json) in
            if let data = json["data"].array{
                self.courials = data.map({FavoriteCourialModel.init(json: $0)})
            }
            self.tableViewFavoriteCourial.emptyDataSetDelegate = self
            self.tableViewFavoriteCourial.emptyDataSetSource = self
            self.tableViewFavoriteCourial.reloadData()
            hideLoader()
        }) { (error, json) in
            print(error)
            hideLoader()
            self.tableViewFavoriteCourial.emptyDataSetDelegate = self
            self.tableViewFavoriteCourial.emptyDataSetSource = self
            self.tableViewFavoriteCourial.reloadData()
        }
    }
    
    func removeFavCourial(index: Int){
        let params : Parameters = [
            "providerid": "\(self.courials[index].internalIdentifier ?? 0)"
        ]
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.remove_fav_courial , method: .delete , success: { (json) in
            hideLoader()
            self.courials.remove(at: index)
            self.tableViewFavoriteCourial.reloadData()
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
}
