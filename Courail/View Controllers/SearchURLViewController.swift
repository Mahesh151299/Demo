//
//  SeachURLViewController.swift
//  Courail
//
//  Created by Omeesh Sharma on 29/05/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class SearchTVC: UITableViewCell {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var title: UILabel!
    
}


class SearchURLViewController: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var table: UITableView!
    
    
    //MARK: VARIABLES
    
    var suggestions = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        self.table.tableFooterView = UIView()
        self.searchField.becomeFirstResponder()
        self.searchField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- BUTTONS ACTIONS
        
    @IBAction func searchChanged(_ sender: UITextField) {
        guard sender.text?.isEmpty == false else {
            self.suggestions = JSON()
            return
        }
        
        MapHelper.sharedInstance.googleCustomSearch(search: sender.text!, success: { (json) in
            self.suggestions = json
            self.table.emptyDataSetDelegate = self
            self.table.emptyDataSetSource = self
            self.table.reloadData()
        }) { (error) in
            self.table.emptyDataSetDelegate = self
            self.table.emptyDataSetSource = self
            self.table.reloadData()
        }
    }
    
    @IBAction func searchBtn(_ sender: UITextField) {
        guard sender.text?.isEmpty == false else {
            self.suggestions = JSON()
            return
        }
        self.view.endEditing(true)
    }
    
    
}

extension SearchURLViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.text?.isEmpty == true else {return}
        self.navigationController?.popViewController(animated: false)
    }
    
}


extension SearchURLViewController: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suggestions["items"].arrayValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTVC") as! SearchTVC
        let data = self.suggestions["items"].arrayValue[indexPath.row]
        
        cell.title.text = data["link"].stringValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTVC") as! SearchTVC
            cell.title.text = "Google Search"
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let data = self.suggestions["items"].arrayValue[indexPath.row]
        var model = YelpStoreBusinesses.init(json: JSON())
        model.url =  data["link"].stringValue
        model.name = self.searchField.text?.capitalized ?? self.getTitle(data["title"].stringValue)
        model.isWebStore = true
        
        let popup = self.storyboard?.instantiateViewController(withIdentifier: "EditUrlViewController") as! EditUrlViewController
        popup.modalPresentationStyle = .overCurrentContext
        let store = OnlineBusinessModel.init(json: JSON([
            "name": model.name ?? "",
            "url": model.url ?? ""
            ]))
        popup.detailModel = store
        popup.completion = { (store) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleGroceryDeliveryVC") as! ScheduleGroceryDeliveryVC
            model.name = store?.name
            model.url = store?.url
            model.imageUrl = store?.image
            vc.businessDetail = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(popup.view)
        self.addChild(popup)
    }
    
    func getTitle(_ value: String)-> String{
        var title = value
        if title.contains(":"){
            title = title.components(separatedBy: ":").first ?? ""
        }
        
        if title.contains(" | "){
            title = title.components(separatedBy: " | ").last ?? ""
        }
        
        if title.contains(" |"){
            title = title.components(separatedBy: " | ").first ?? ""
        }
        
        if title.contains(".com"){
            title = title.replacingOccurrences(of: "www.", with: "").replacingOccurrences(of: "https://", with: "").components(separatedBy: ".com").first ?? ""
        }
   
        if title.contains(" -"){
            title = title.components(separatedBy: " -").first ?? ""
        }
        
        if title.components(separatedBy: " ").count > 5{
            return title.components(separatedBy: " ").first ?? ""
        } else{
            return title
        }
        
        
//        return title.components(separatedBy: " ").first ?? ""
      }
    
}


extension SearchURLViewController : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource{
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = "No results found!"
        
        let font =  UIFont.boldSystemFont(ofSize: 20)
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
}
