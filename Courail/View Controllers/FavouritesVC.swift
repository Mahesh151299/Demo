//
//  FavouritesVC.swift
//  Courail
//
//  Created by apple on 24/01/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import GooglePlaces
import DZNEmptyDataSet

class FavouritesTVC: UITableViewCell {
    
    //MARK: OUTLETS
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var imgBtn: UIButton!
    @IBOutlet weak var shortName: UILabel!
    
    @IBOutlet weak var imgGrocery: UIImageView!
    @IBOutlet weak var lblTittle: UILabel!
    @IBOutlet weak var awayTittle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var lblClosed: UILabel!
    
    @IBOutlet weak var imgGroceryHeight: NSLayoutConstraint!
    @IBOutlet weak var innerView: UIViewCustomClass!
    
    var businessDetail : YelpStoreBusinesses?{
        didSet{
            self.lblTittle.text = businessDetail?.name
            
            if businessDetail?.category?.lowercased() != "special"{
                let categories = businessDetail?.categories?.sorted(by: { (cat1, cat2) -> Bool in
                    (cat1.title ?? "") < (cat2.title ?? "")
                })
                
                if self.businessDetail?.isWebStore == true{
                    self.lblType.text = (businessDetail?.category ?? "").capitalized + " Package"
                }else if categories?.isEmpty == false{
                    self.lblType.text = (businessDetail?.category ?? "") + ", " + "\(categories?.first?.title ?? "")"
                } else{
                    self.lblType.text = (businessDetail?.category ?? "")
                }
            } else{
                self.lblType.text = "Package Delivery"
            }
            
            let address = self.businessDetail?.location
            if (address?.displayAddress?.count ?? 0) > 2{
                let line1 = self.businessDetail?.location?.displayAddress?.first ?? ""
                let line2 = self.businessDetail?.location?.displayAddress?.last ?? ""
                
                let zipCode = address?.zipCode ?? "------"
                var line2filter = line2.replacingOccurrences(of: ", \(zipCode)", with: "")
                line2filter = line2filter.replacingOccurrences(of: " \(zipCode)", with: "")
                
                if line2filter.components(separatedBy: ", ").count > 1{
                    line2filter = line2filter.components(separatedBy: ", ").first ?? ""
                }
                self.lblAddress.text = line1 + ", " + line2filter
                
            } else{
                let zipCode = address?.zipCode ?? "------"
                var filterAdd = self.businessDetail?.location?.displayAddress?.joined(separator: "\n").replacingOccurrences(of: ", \(zipCode)", with: "")
                filterAdd = filterAdd?.replacingOccurrences(of: " \(zipCode)", with: "")
                
                if (filterAdd?.components(separatedBy: ", ").count ?? 0) > 1{
                    filterAdd = filterAdd?.components(separatedBy: ", ").first ?? ""
                }
                
                self.lblAddress.text = filterAdd?.replacingOccurrences(of: "\n", with: ", ") ?? ""
            }
        }
    }
    
}

class FavouritesVC: UIViewController {
    
    //MARK:- OUTLET
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var swipeLbl: UILabel!
    
    //MARK:- VARIABLES
    
    var viewModel = FavViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        self.table.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavApi(onSuccess: {
            self.table.emptyDataSetDelegate = self
            self.table.emptyDataSetSource = self
            self.table.reloadData()
            
            if self.viewModel.favorites.count == 0{
                self.swipeLbl.isHidden = true
            }else{
                self.swipeLbl.isHidden = false
            }
        })
    }
    
}

extension FavouritesVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesTVC")as! FavouritesTVC
        
        let store = viewModel.favorites[indexPath.row].data
        cell.businessDetail = store
        cell.tag = indexPath.row
        
        DispatchQueue.main.async {
            if(cell.tag == indexPath.row) {
                if store?.category?.lowercased() == "special"{
                    let data = specialCat
                    cell.imgGrocery.image = UIImage(named: data["icon"].stringValue)
                    cell.imgGrocery.contentMode = .scaleAspectFit
                    cell.imgGrocery.backgroundColor = .clear
                    cell.imgGroceryHeight.constant = -10
                    cell.innerView.backgroundColor = hexStringToUIColor(hex: data["hex"].stringValue)
                    cell.innerView.borderColor = hexStringToUIColor(hex: data["hex"].stringValue)
                }else if (store?.isWebStore == true) && store?.webStoreType != "custom"{
                    let category = store?.webStoreType ?? ""
                    let data = appCourialServices.arrayValue.first(where: {$0["category"].stringValue == category}) ?? JSON()
                    cell.imgGrocery.image = UIImage(named: data["icon"].stringValue)
                    cell.imgGrocery.contentMode = .scaleAspectFit
                    cell.imgGrocery.backgroundColor = hexStringToUIColor(hex: data["hex"].stringValue)
                    cell.imgGroceryHeight.constant = 0
                    cell.innerView.borderColor = .lightGray
                    cell.innerView.backgroundColor = .white
                }else if let img = URL(string: (store?.imageUrl ?? "")){
                    cell.imgGrocery.sd_setImage(with: img , placeholderImage: UIImage(named: "logo_main"), options: [], completed: nil)
                    cell.shortName.text = ""
                    cell.innerView.borderColor = .lightGray
                    cell.imgGrocery.backgroundColor = .clear
                    cell.imgGroceryHeight.constant = 0
                    cell.imgGrocery.contentMode = .scaleAspectFill
                    cell.innerView.backgroundColor = .white
                } else{
                    cell.imgGrocery.image = nil
                    cell.innerView.borderColor = appColor
                    cell.imgGrocery.backgroundColor = .clear
                    cell.imgGroceryHeight.constant = 0
                    cell.innerView.backgroundColor = .white
                    let nameArr = store?.name?.components(separatedBy: " ")
                    var firstChar = ""
                    var lastChar = ""
                    if let first = (nameArr?.first?.uppercased() ?? "").first{
                        firstChar = "\(first)"
                        if (nameArr?.count ?? 0 > 1) , let last = (nameArr?[1].uppercased() ?? "").first{
                            lastChar = "\(last)"
                        }
                    }
                    cell.shortName.text = firstChar + lastChar
                }
            }
        }
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnAction(_:)), for: .touchUpInside)
        
        cell.imgBtn.tag = indexPath.row
        cell.imgBtn.addTarget(self, action: #selector(imgBtnAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let storeName = self.viewModel.favorites[indexPath.row].data?.name ?? "Store"
            let deletePopup = DeleteView.init(frame: screenFrame(), msg: "Delete \(storeName)?") { (result) in
                guard result == true else {return}
                let id = self.viewModel.favorites[indexPath.row].internalIdentifier ?? 0
                self.viewModel.removeFavApi(id, indexPath.row, onSuccess: {
                    self.table.reloadData()
                })
            }
            rootVC?.view.addSubview(deletePopup)
        }
    }
    
    @objc func imgBtnAction(_ sender: UIButton){
        showLoader()
        self.viewModel.FavOpenedApi(self.viewModel.favorites[sender.tag].internalIdentifier ?? 0)
        
        viewModel.getPlaceDetails(sender.tag) {
            hideLoader()
            
            var model = self.viewModel.favorites[sender.tag].data
            if model?.details?.website == nil || model?.category?.lowercased() == "special" || model?.isWebStore == true{
                if model?.isWebStore == false{
                    model?.itemDescription = ""
                }
                model?.courialFee = ""
                model?.subTotalType = ""
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SpecialDeliveryAddToQueueVC") as! SpecialDeliveryAddToQueueVC
                vc.businessDetail = model
                self.navigationController?.pushViewController(vc, animated: true)
            } else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleGroceryDeliveryVC") as! ScheduleGroceryDeliveryVC
                vc.businessDetail = model
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // Delete button Action
    
    @objc func deleteBtnAction(_ sender: UIButton){
        let storeName = self.viewModel.favorites[sender.tag].data?.name ?? "Store"
        let deletePopup = DeleteView.init(frame: screenFrame(), msg: "Delete \(storeName)?") { (result) in
            guard result == true else {return}
            let id = self.viewModel.favorites[sender.tag].internalIdentifier ?? 0
            self.viewModel.removeFavApi(id, sender.tag, onSuccess: {
                self.table.reloadData()
            })
        }
        rootVC?.view.addSubview(deletePopup)
    }
    
}



extension FavouritesVC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.filterArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCatCell", for: indexPath) as! SubCatCell
        
        cell.catName.text = self.viewModel.filterArr[indexPath.item]
        
        cell.catName.textColor = (indexPath.row == self.viewModel.sortingType) ? .white : .black
        cell.innerView.backgroundColor = (indexPath.row == self.viewModel.sortingType) ? appColorBlue : UIColor.lightGray.withAlphaComponent(0.2)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (collectionView.frame.width - 30) / 4, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel.sortingType{
            self.viewModel.sortingType = 0
        } else{
            self.viewModel.sortingType = indexPath.row
        }
        collectionView.reloadData()
        
        self.viewModel.sortData {
            self.table.reloadData()
            if self.table.numberOfRows(inSection: 0) > 0 {
                self.table.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
            }
        }
    }
    
}

extension FavouritesVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource{
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = "No favorite place found!"
        
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
        viewModel.getFavApi {
            self.table.emptyDataSetDelegate = self
            self.table.emptyDataSetSource = self
            self.table.reloadData()
        }
    }
    
}


