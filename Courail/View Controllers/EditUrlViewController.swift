//
//  EditUrlViewController.swift
//  Courail
//
//  Created by Omeesh Sharma on 24/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class EditUrlViewController: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var storeName: UITextField!
    @IBOutlet weak var storeURL: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionURLHeight: NSLayoutConstraint!
    
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var addView: UIView!
    
    @IBOutlet weak var cameraIcon: UIImageView!
    @IBOutlet weak var shortName: UILabel!
    @IBOutlet weak var heartIcon: UIImageView!
    @IBOutlet weak var storeView: UIViewCustomClass!
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeImageHeight: NSLayoutConstraint!
    
    //MARK:- VARIABLES
    var detailModel : OnlineBusinessModel?
    var completion: ((OnlineBusinessModel?)->())?
    var selectedIndex = 0
    var isEdit = false
    
    var imageChanged = false
    
    var data = appUrls
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let model = self.detailModel, self.isEdit == false{
            self.data.insert(model, at: 0)
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionURLHeight.constant = ((self.collectionView.frame.width - 15) / 4) * 1.2
    }
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.removeView()
    }
    
    @IBAction func storeImage(_ sender: UIButton) {
        guard self.selectedIndex == 0 else {return}
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "OpenCameraAlertVC") as! OpenCameraAlertVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.isClearBG = true
        vc.delegate = self
        self.view.addSubview(vc.view)
        self.addChild(vc)
    }
    
    @IBAction func shopBtn(_ sender: UIButton) {
        self.detailModel?.name = self.storeName.text
        self.detailModel?.url = self.storeURL.text
        
        guard let callBack = self.completion else{
            self.removeView()
            return
        }
        callBack(self.detailModel)
        self.removeView()
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        self.editApi()
    }
    
    @IBAction func favBtn(_ sender: UIButton) {
        guard checkLogin() else {return}
        guard self.selectedIndex == 0 else {return}
        
        if self.heartIcon.image == UIImage(named: "heart2_2"){
            //remove
            self.deleteApi()
        } else{
            //Add
            guard self.storeImage.image != nil else {
                showLoader()
                self.addApi()
                return
            }
            
            self.uploadImage(self.storeImage.image)
            
        }
    }
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        self.deleteApi()
    }
    
    @IBAction func searchLogoBtn(_ sender: UIButton) {
        guard self.selectedIndex == 0 else {return}
        
        let urlStr = "https://www.google.com/search?tbm=isch&q=\(self.storeName.text ?? "")+logo".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: urlStr) else{return}
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        UIApplication.shared.open(url, options: [:]) { (_) in
            self.storeImage(sender)
        }
    }
    
    func removeView(){
        DispatchQueue.main.async {
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    
}


extension EditUrlViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCVC", for: indexPath) as! CategoryCVC
        
        cell.title.text = data[indexPath.item].name ?? ""
        cell.iconHeight.constant = 0
        cell.icon.contentMode = .scaleAspectFill
        cell.icon.layer.cornerRadius = cell.iconBGView.layer.cornerRadius
        cell.icon.clipsToBounds = true
        
        let img = (data[indexPath.item].image ?? "")
        if img == "", let char = cell.title.text?.first{
            cell.shortName.text = "\(char)".uppercased()
            
            cell.icon.image = nil
            cell.iconBGView.backgroundColor = .white
            cell.iconBGView.layer.borderWidth = 0.5
        } else{
            cell.shortName.text = ""
            if let imgLocal =  UIImage(named: img){
                cell.icon.image = imgLocal
                cell.iconBGView.backgroundColor = hexStringToUIColor(hex: data[indexPath.item].hex ?? "")
                cell.iconBGView.layer.borderWidth = 0
            } else{
                cell.icon.sd_setImage(with: URL(string: img), placeholderImage: nil, options: [], completed: nil)
                cell.iconBGView.backgroundColor = .white
                cell.iconBGView.layer.borderWidth = 0.5
            }
        }
        
        if self.selectedIndex == indexPath.item{
            cell.lineView.isHidden = false
        }else{
            cell.lineView.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 15 ) / 4
        let height = width * 1.2
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.item
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        self.imageChanged = false
        
        self.storeName.text = data[self.selectedIndex].name ?? ""
        self.storeURL.text = data[self.selectedIndex].url ?? ""
        self.storeView.borderWidth = 0.5
        let img = (data[indexPath.item].image ?? "")
        if img == "", let char = self.storeName.text?.first{
            self.shortName.text = "\(char)".uppercased()
            self.storeImage.image = nil
            self.storeView.backgroundColor = .white
        } else{
            self.shortName.text = ""
            
            if let imgLocal = UIImage(named: img){
                self.storeImage.image = imgLocal
                self.storeView.backgroundColor = hexStringToUIColor(hex: data[self.selectedIndex].hex ?? "")
                self.storeImage.contentMode = .scaleAspectFit
                self.storeImageHeight.constant = -20
            } else{
                self.storeImage.sd_setImage(with: URL(string: img), placeholderImage: nil, options: [], completed: nil)
                self.storeView.backgroundColor = .white
                self.storeImage.contentMode = .scaleAspectFill
                self.storeImageHeight.constant = 0
            }
        }
        
        self.showHideFav()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.collectionURLHeight.constant = ((self.collectionView.frame.width - 15) / 4) * 1.2
    }
    
    
    func loadData(){
        if self.isEdit{
            self.editView.isHidden = false
            self.addView.isHidden = true
            
            if data.indices.contains(self.selectedIndex){
                self.storeName.text = data[self.selectedIndex].name ?? ""
                self.storeURL.text = data[self.selectedIndex].url ?? ""
            }
        } else{
            self.editView.isHidden = true
            self.addView.isHidden = false
            
            self.storeName.text = self.detailModel?.name
            if let char = self.storeName.text?.first{
                self.shortName.text = "\(char)".uppercased()
            }
            
            self.storeURL.text = self.detailModel?.url
            self.storeImage.image = nil
            self.storeView.backgroundColor = .white
            self.storeView.borderWidth = 0.5
        }
        
        self.showHideFav()
    }
    
    
    func showHideFav(){
        if self.selectedIndex == 0 && self.isEdit == false{
            self.heartIcon.isHidden = false
            self.cameraIcon.isHidden = false
        } else{
            self.heartIcon.isHidden = true
            self.cameraIcon.isHidden = true
        }
    }
}

extension EditUrlViewController : CameraAlertDelegate{
    
    func imageSelected(_ img: UIImage) {
        img.accessibilityHint = "image"
        self.shortName.text = ""
        
        self.storeImage.image = img
        self.storeImage.contentMode = .scaleAspectFill
        self.storeView.backgroundColor = .white
        self.imageChanged = true
        self.storeImageHeight.constant = 0
    }
    
}

extension EditUrlViewController{
    //MARK: API
    
    func addApi(){
        let params: Parameters = [
            "name": self.storeName.text ?? "",
            "url": self.storeURL.text ?? "",
            "image": self.detailModel?.image ?? ""
        ]
        
        ApiInterface.requestApi(params: params, api_url: API.add_edit_online_business , success: { (json) in
            hideLoader()
            self.heartIcon.image = UIImage(named: "heart2_2")
            self.data[0] = OnlineBusinessModel.init(json: json["data"])
            appUrls.insert(self.data[0] , at: 0)
            self.collectionView.reloadData()
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    func editApi(){
        let params: Parameters = [
            "name": self.storeName.text ?? "",
            "url": self.storeURL.text ?? "",
            "image": self.data[self.selectedIndex].image ?? "",
            "id": "\(self.data[self.selectedIndex].internalIdentifier ?? 0)"
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.add_edit_online_business , success: { (json) in
            hideLoader()
            appUrls[self.selectedIndex].name = self.storeName.text ?? ""
            appUrls[self.selectedIndex].url = self.storeURL.text ?? ""
            
            guard let callBack = self.completion else{
                self.removeView()
                return
            }
            callBack(appUrls[self.selectedIndex])
            self.removeView()
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    func deleteApi(){
        let params: Parameters = [
            "id" : "\(self.data[self.selectedIndex].internalIdentifier ?? 0)"
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.delete_online_business, method: .delete , success: { (json) in
            hideLoader()
            if self.isEdit{
                self.data.remove(at: self.selectedIndex)
                appUrls.remove(at: self.selectedIndex)
                
                guard let callBack = self.completion else{
                    self.removeView()
                    return
                }
                callBack(self.detailModel)
                self.removeView()
            } else{
                self.heartIcon.image = UIImage(named: "heart3_2-1")
                appUrls.remove(at: self.selectedIndex)
                self.collectionView.reloadData()
                self.loadData()
            }
            
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    func uploadImage(_ img: UIImage?){
        showLoader()
        ApiInterface.formDataApi(params: [:], api_url: API.upload_image, image: img, imageName: "image", success: { (json) in
            self.detailModel?.image = json["data"]["image"].stringValue
            self.addApi()
        }) { (error, json) in
            hideLoader()
        }
    }
    
}
