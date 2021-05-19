//
//  SearchPlaceVC.swift
//  Courail
//
//  Created by apple on 24/01/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit


class CategoryCVC: UICollectionViewCell {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var shortName: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconHeight: NSLayoutConstraint!
    @IBOutlet weak var iconBGView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard iconBGView != nil else{ return }
        self.iconBGView.addShadowsRadius()
    }
}

class SearchPlaceVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var stackView : UIStackView!
    @IBOutlet weak var searchBusinessView: UIViewCustomClass!
    @IBOutlet weak var searchURLView: UIViewCustomClass!
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var urlView: UIView!
    @IBOutlet weak var urlFieldBtn: UIButton!
    @IBOutlet weak var collectionURL: UICollectionView!
    
    @IBOutlet weak var sepcialServicesView: UIView!
    @IBOutlet weak var specialTableView: UITableView!
    
    
    //MARK:- VARIABLES
    
    var searchType = 1
    
    var categoryList = appCategories
    
    var editURLView: EditUrlViewController?
    
    let learnMore = "http://www.example.com/learnmore"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchField.addTarget(self, action: #selector(self.searchBusinessChanged(_:)), for: .editingChanged)
        
        self.specialTableView.tableFooterView = UIView()
        
        self.resetCategories()
        
        self.collectionView.register(UINib(nibName: "TextViewCVC", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier:"TextViewCVC")
        self.collectionURL.register(UINib(nibName: "TextViewCVC", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier:"TextViewCVC")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.arrangeViews()
                
        if let editURLpopup = self.editURLView{
            editURLpopup.removeView()
        }
    }
  
    func resetCategories(){
        self.categoryList = JSON(appCategories.arrayValue.sorted(by: { (cat1, cat2) -> Bool in
            cat1["count"].intValue > cat2["count"].intValue
        }))
        
        self.collectionView.reloadData()
    }
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func searchBtn(_ sender: UITextField) {
        guard sender.text?.isEmpty == false else {return}
        self.view.endEditing(true)
        
        sender.text = (sender.text ?? "").trimmingCharacters(in: .whitespaces)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoresVC") as! StoresVC
        vc.category = sender.text ?? ""
        vc.isSearch = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func searchBusinessChanged(_ sender: UITextField){
        guard sender.text?.isEmpty == false else {
            self.resetCategories()
            return
        }
        
        let text = (sender.text ?? "").lowercased()
        self.categoryList = JSON(appCategories.arrayValue.filter({$0["category"].stringValue.lowercased().contains(text) || $0["keywords"].stringValue.lowercased().contains(text)}))
        self.collectionView.reloadData()
    }
    
    @IBAction func urlBtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchURLViewController") as! SearchURLViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    func arrangeViews(){
        
        switch self.searchType {
        case 2:
            self.categoryView.isHidden = true
            self.sepcialServicesView.isHidden = true
            self.urlView.isHidden = false
            
            self.collectionURL.reloadData()
        case 3:
            self.categoryView.isHidden = true
            self.urlView.isHidden = true
            self.sepcialServicesView.isHidden = false
            
            self.specialTableView.reloadData()
        default:
            self.searchField.text = ""
            
            self.urlView.isHidden = true
            self.sepcialServicesView.isHidden = true
            self.categoryView.isHidden = false
            
            self.view.layoutIfNeeded()
            self.resetCategories()
        }
    }
    
}

extension SearchPlaceVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case self.collectionURL:
            return appUrls.count + 1
        default:
            return self.categoryList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCVC", for: indexPath) as! CategoryCVC
        
        switch collectionView{
        case self.collectionURL:
            guard indexPath.item != collectionView.numberOfItems(inSection: 0) - 1 else{
                cell.shortName.text = ""
                cell.title.text = "Edit List"
                cell.icon.image = UIImage(named: "imgEditList")
                cell.icon.contentMode = .scaleAspectFit
                cell.iconHeight.constant = -10
                cell.iconBGView.layer.borderWidth = 0
                cell.iconBGView.backgroundColor = appColorBlue
                
                return cell
            }
            
            cell.title.text = appUrls[indexPath.item].name ?? ""
            cell.iconHeight.constant = 0
            cell.icon.contentMode = .scaleAspectFill
            cell.iconBGView.layer.borderWidth = 0
            cell.icon.layer.cornerRadius = cell.iconBGView.layer.cornerRadius
            cell.icon.clipsToBounds = true
            
            let img = appUrls[indexPath.item].image ?? ""
            if img == "" , let char = cell.title.text?.first{
                cell.shortName.text = "\(char)"
                
                cell.icon.image = UIImage(named: img)
                cell.iconBGView.backgroundColor = .white
            } else{
                cell.shortName.text = ""
                
                if let imgLocal =  UIImage(named: img){
                    cell.icon.image = imgLocal
                    cell.iconBGView.backgroundColor = hexStringToUIColor(hex: appUrls[indexPath.item].hex ?? "")
                } else{
                    cell.icon.sd_setImage(with: URL(string: img), placeholderImage: nil, options: [], completed: nil)
                    cell.iconBGView.backgroundColor = .white
                }
            }
            
            
            
        default:
            let category = self.categoryList[indexPath.item]["category"].stringValue
            cell.title.text = category
            
            
            cell.icon.image = UIImage(named: self.categoryList[indexPath.item]["icon"].stringValue)
            cell.iconBGView.backgroundColor = hexStringToUIColor(hex: self.categoryList[indexPath.item]["hex"].stringValue)
            
//            switch self.categoryList[indexPath.item]["icon"].stringValue {
//            case "imgLocal-biz","imgConveniencestore","imgLaundry":
//                cell.icon.contentMode = .scaleAspectFill
//                cell.iconHeight.constant = 0
//            default:
                cell.icon.contentMode = .scaleAspectFit
                cell.iconHeight.constant = -10
//            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TextViewCVC", for: indexPath) as! TextViewCVC
        
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            guard collectionView == self.collectionURL else{
                return footerView
            }
            
            self.setupTextView(footerView.textView)
            return footerView
        default:
            return footerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard collectionView == self.collectionURL else {
            return CGSize.init(width: 0.01, height: 0.01)
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 0) / 4
        return .init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView{
        case self.collectionURL:
            guard indexPath.item != collectionView.numberOfItems(inSection: 0) - 1 else{
                if checkLogin(){
                    let popup = self.storyboard?.instantiateViewController(withIdentifier: "EditUrlViewController") as! EditUrlViewController
                    popup.modalPresentationStyle = .overCurrentContext
                    popup.isEdit = true
                    popup.completion = { (store) in
                        self.collectionURL.reloadData()
                    }
                    self.view.addSubview(popup.view)
                    self.addChild(popup)
                    self.editURLView = popup
                }
                return
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleGroceryDeliveryVC") as! ScheduleGroceryDeliveryVC
            var model = YelpStoreBusinesses.init(json: JSON())
            model.url =  appUrls[indexPath.item].url ?? ""
            model.name = appUrls[indexPath.item].name ?? ""
            model.isWebStore = true
            vc.businessDetail = model
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            guard self.categoryList[indexPath.item]["category"].stringValue.lowercased() != "last mile" else{
                self.searchType = 2
                self.arrangeViews()
                return
            }
            
            if isLoggedIn(){
                self.incCatCount(self.categoryList[indexPath.item]["category"].stringValue)
            }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoresVC") as! StoresVC
            vc.category = self.categoryList[indexPath.item]["category"].stringValue
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension SearchPlaceVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appSpecialCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesTVC")as! FavouritesTVC
        
        let category = appSpecialCategories[indexPath.row]
        
        cell.imgGrocery.image = UIImage(named: category["icon"].stringValue)
        cell.innerView.backgroundColor = hexStringToUIColor(hex: category["hex"].stringValue)
        
        cell.imgGrocery.contentMode = .scaleAspectFit
        cell.imgGroceryHeight.constant = -10
        
        cell.lblTittle.text = category["category"].stringValue
        cell.lblAddress.text = category["info"].stringValue
        cell.lblType.text = category["rate"].stringValue
        
        cell.innerView.addShadowsRadius()
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SpecialSkillOrderVC") as! SpecialSkillOrderVC
        var model = YelpStoreBusinesses.init(json: JSON())
        model.category = appSpecialCategories[indexPath.row]["category"].stringValue
        vc.businessDetail = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension SearchPlaceVC : UITextViewDelegate {
    
    func setupTextView(_ textView: UITextView){
        let myParagraphStyle = NSMutableParagraphStyle()
        myParagraphStyle.alignment = .center // center the text
        myParagraphStyle.lineSpacing = 2 //Change spacing between lines
        myParagraphStyle.paragraphSpacing = 2 //Change space between paragraphs
        
        let originalText = "Learn more about how Courial can help your online\ndeliveries arrive sooner with real-time tracking."
        
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        
        let linkColor = UIColor.init(red: 21/255, green: 93/255, blue: 155/255, alpha: 1.0)
        
        let linkRange = attributedOriginalText.mutableString.range(of: originalText)
        let myAttribute = [ NSAttributedString.Key.font: UIFont.init(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.paragraphStyle: myParagraphStyle]
        
        attributedOriginalText.addAttributes(myAttribute, range: linkRange)
        
        let linkTermsRange = attributedOriginalText.mutableString.range(of: "Learn more")
        attributedOriginalText.addAttribute(.link, value: learnMore, range: linkTermsRange)
        attributedOriginalText.addAttributes([NSAttributedString.Key.font : UIFont.init(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)], range: linkTermsRange)
        
        textView.linkTextAttributes = [ NSAttributedString.Key.foregroundColor : linkColor]
        textView.delegate = self
        textView.attributedText = attributedOriginalText
    }
    
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyViewController") as! PrivacyViewController
        vc.screen = "Learn More"
        self.navigationController?.pushViewController(vc, animated: true)
        return false
    }
    
}



extension SearchPlaceVC{
    
    //MARK: API
    
    func incCatCount(_ cat: String){
        let params: Parameters = [
            "categoryname" : cat
        ]
        ApiInterface.requestApi(params: params, api_url: API.increase_category_count , success: { (json) in
            if let index = appCategories.arrayValue.firstIndex(where: {$0["category"].stringValue.lowercased() == cat.lowercased()}){
                appCategories[index]["count"].intValue += 1
            }
        }) { (error, json) in
            print(error)
        }
    }
    
    
}
