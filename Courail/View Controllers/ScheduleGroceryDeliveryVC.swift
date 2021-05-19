//
//  ScheduleGroceryDeliveryVC.swift
//  Courail
//
//  Created by mac on 05/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import WebKit
import SwiftGifOrigin

class WebMenuCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var centerConst: NSLayoutConstraint!
    
}


class ScheduleGroceryDeliveryVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var webViewBGView: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var endCallView: UIViewCustomClass!
    @IBOutlet weak var gifImage: UIImageView!
    @IBOutlet weak var backBtnOut: UIButton!
    
    @IBOutlet weak var storeInfoView: UIViewCustomClass!
    @IBOutlet weak var storeInfoTblView: UITableView!
    @IBOutlet weak var storeInfoTblViewHeigh: NSLayoutConstraint!
    
    @IBOutlet weak var heartIcon: UIImageView!
    @IBOutlet weak var driveThruIcon: UIImageView!
    @IBOutlet weak var driveThruText: UILabel!
    
    //MARK:- VARIABLES
    var businessDetail : YelpStoreBusinesses?
    
    var webView: WKWebView!
    
    var screenshot : UIImage?
    
    var businessName = ""
    
    var hideMenu = true {
        didSet{
            self.table.isHidden = hideMenu
        }
    }
    
    let menuData = [["arrowWhite","Previous Page"],["call","Call Store"],["mailTemp","Open Email"],["HomeWhite","Home"]]
    
    var isStoreInfo = false
    
    private var observation: NSKeyValueObservation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLoadingView()
        
        if self.isStoreInfo{
            self.backBtnOut.isHidden = false
            self.storeInfoView.isHidden = false
            self.storeInfoTblView.delegate = self
            self.storeInfoTblView.dataSource = self
            self.tabBarController?.tabBar.isHidden = false
        }else{
            self.storeInfoView.isHidden = true
        }
        
        self.table.delegate = self
        self.table.dataSource = self
        self.tableHeight.constant = CGFloat(40 * self.menuData.count)
        self.table.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 10, borderColor: nil, borderWidth: nil)
        
        self.lblTitle.text = self.businessDetail?.name ?? " "
        
        self.webView = WKWebView.init(frame: self.webViewBGView.bounds)
        self.webView.backgroundColor = .clear
        self.webView.scrollView.backgroundColor = .clear
        self.webViewBGView.addSubview(self.webView)
        
        self.webView.navigationDelegate = self
        
        guard let url = URL(string: self.businessDetail?.details?.website?.absoluteString ?? self.businessDetail?.url ?? "") else {return}
        let request = URLRequest(url: url)
        self.webView.load(request)
        
        //add observer to get estimated progress value
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);
        
        //        showLoader()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        self.webView.navigationDelegate = nil
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.businessName != ""{
            self.businessDetail?.name = self.businessName
        } else{
            self.businessName = (self.businessDetail?.name?.uppercased() ?? " ")
        }
        
        if self.isStoreInfo == false{
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.webView.frame = self.webViewBGView.bounds
        if self.storeInfoView.isHidden == false{
            self.storeInfoTblViewHeigh.constant = self.storeInfoTblView.contentSize.height
        }
    }
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func backBtnAction(_ sender: Any) {
        guard self.endCallView.isHidden else {
            showSwiftyAlert("", "Please End Call to continue", false)
            return
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuBtnAction(_ sender: UIButton) {
        self.hideMenu = !self.hideMenu
    }
    
    func btnCallAction() {
        MediaShareInterface.shared.endCallView = self.endCallView
        MediaShareInterface.shared.tabBarShowAtEnd = false
        MediaShareInterface.shared.twilioCall(vc: self,no: (self.businessDetail?.displayPhone ?? "") , name: (self.businessDetail?.name ?? "Store").uppercased())
    }
    
    @IBAction func cameraBtn(_ sender: UIButton) {
        self.hideMenu = true
        
        showLoader()
        self.webView.takeSnapshot(with: nil, completionHandler: { (img, error) in
            guard let image = img else {
                hideLoader()
                showSwiftyAlert("", "Unable to save screenshot", false)
                return
            }
            self.screenshot = image
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        })
    }
    @IBAction func showCallBtn(_ sender: UIButton) {
        MediaShareInterface.shared.voipView?.view.isHidden = false
        MediaShareInterface.shared.endCallView?.isHidden = true
    }
    
    @IBAction func endCallBtn(_ sender: UIButton) {
        MediaShareInterface.shared.endCallView?.isHidden = true
        guard MediaShareInterface.shared.voipView != nil else{
            return
        }
        MediaShareInterface.shared.voipView?.crossPressed = false
        MediaShareInterface.shared.voipView?.endCall()
    }
    
    @IBAction func scheduleBtn(_ sender: Any) {
        guard self.endCallView.isHidden else {
            showSwiftyAlert("", "Please End Call to continue", false)
            return
        }
        
        guard self.businessDetail?.isWebStore == false else {
            self.pickUpPopup()
            return
        }
        
        self.businessDetail?.itemDescription = ""
        self.businessDetail?.additionalNotes = ""
        self.businessDetail?.courialFee = ""
        self.businessDetail?.subTotalType = "PRE-PAID"
        if let image = self.screenshot{
            self.businessDetail?.attachedPhoto = [image]
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SpecialDeliveryAddToQueueVC") as! SpecialDeliveryAddToQueueVC
        vc.businessDetail = self.businessDetail
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pickUpPopup(){
        let popup = self.storyboard?.instantiateViewController(withIdentifier: "PickUpInfoPopupVC") as! PickUpInfoPopupVC
        popup.modalPresentationStyle = .overCurrentContext
        let businessName = (self.businessDetail?.name ?? "").uppercased()
        popup.businessName = businessName
        popup.businessDetail = self.businessDetail
        popup.completion = { (store) in
            self.businessDetail = store
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SpecialDeliveryAddToQueueVC") as! SpecialDeliveryAddToQueueVC
            vc.businessDetail = self.businessDetail
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(popup.view)
        self.addChild(popup)
    }
    
    
    
    func ShowPopUp(){
        let popView = CaptureView.init(frame: screenFrame())
        rootVC?.view.addSubview(popView)
        
        DispatchQueue.main.asyncAfter(wallDeadline:.now() + 2)
        {
            self.businessDetail?.itemDescription = ""
            self.businessDetail?.additionalNotes = ""
            self.businessDetail?.courialFee = ""
            self.businessDetail?.subTotalType = "PRE-PAID"
            if let image = self.screenshot{
                self.businessDetail?.attachedPhoto = [image]
            }
            popView.removeFromSuperview()
        }
    }
    
    @IBAction func browseBtn(_ sender: UIButton){
        self.storeInfoView.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.view.setNeedsLayout()
        guard let url = URL(string: self.businessDetail?.details?.website?.absoluteString ?? self.businessDetail?.url ?? "") else {return}
        UIApplication.shared.open(url, options: [:]) { (_) in
        }
    }
    
    @IBAction func heartBtnAction(sender: UIButton) {
        if checkLogin(){
            if self.businessDetail?.isFav == true{
                self.removeFavApi()
            } else{
                self.addFavApi()
            }
        }
    }
    
    @IBAction func driveThruBtnAction(sender: UIButton) {
        if self.businessDetail?.location?.pickOption == "Drive thru pickup"{
            self.businessDetail?.location?.pickOption = ""
            self.driveThruIcon.alpha = 0.5
            
            self.driveThruText.text = "Drive\nThru\nPickup?"
            self.driveThruText.alpha = 0.5
        }else{
            self.businessDetail?.location?.pickOption = "Drive thru pickup"
            self.driveThruIcon.alpha = 1
            
            self.driveThruText.text = "Drive\nThru\nPickup"
            self.driveThruText.alpha = 1
        }
    }
    
    
    @IBAction func btnScheduleDeliveryAction(sender: UIButton){
        self.businessDetail?.itemDescription = ""
        self.businessDetail?.courialFee = "00.00"
        self.businessDetail?.subTotalType = "PRE-PAID"
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SpecialDeliveryAddToQueueVC") as! SpecialDeliveryAddToQueueVC
        vc.businessDetail = self.businessDetail
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


extension ScheduleGroceryDeliveryVC :  WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    // Observe value
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if self.webView.estimatedProgress > 0.5{
                self.removeLoadingView()
                hideLoader()
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.removeLoadingView()
        hideLoader()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse {
            if response.statusCode == 401 {
                // ...
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.removeLoadingView()
        hideLoader()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        self.removeLoadingView()
        hideLoader()
        if let error = error {
            // we got back an error!
            showSwiftyAlert("", error.localizedDescription, false)
        } else {
            self.ShowPopUp()
        }
    }
    
    func addLoadingView(){
        let gifType = "weburl"
        
        self.gifImage.isHidden = false
        self.gifImage.image = UIImage.gif(name: gifType)
    }
    
    func removeLoadingView(){
        self.gifImage.alpha = 1
        UIView.animate(withDuration: 0.5, animations: {
            self.gifImage.alpha = 0
        }) { (_) in
            self.gifImage.image = nil
            self.gifImage.isHidden = true
        }
    }
    
}

extension ScheduleGroceryDeliveryVC :  UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableView != self.storeInfoTblView else{
            return 1
        }
        return self.menuData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard tableView != self.storeInfoTblView else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedStoreCell", for: indexPath) as! SelectedStoreCell
            cell.businessDetail = self.businessDetail
            cell.imgGrocery.sd_setImage(with: URL(string: self.businessDetail?.imageUrl ?? ""), placeholderImage: UIImage(named: "imgNoLogo"), options: [], completed: nil)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebMenuCell")as! WebMenuCell
        let data = self.menuData[indexPath.row]
        
        cell.icon.image = UIImage(named: data[0])
        cell.icon.tintColor = .white
        cell.title.text = data[1]
        
        if indexPath.row == 3{
            cell.centerConst.constant = -1.5
        } else{
            cell.centerConst.constant = 0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard tableView != self.storeInfoTblView else{
            return 200
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard tableView != self.storeInfoTblView else{
            return UITableView.automaticDimension
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView != self.storeInfoTblView else{
            return
        }
        
        self.hideMenu = true
        
        switch indexPath.row{
        case 0:
            self.webView.goBack()
        case 1:
            guard self.endCallView.isHidden else {
                showSwiftyAlert("", "Please End Call to continue", false)
                return
            }
            
            if self.isStoreInfo{
                self.storeInfoView.isHidden = true
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.view.setNeedsLayout()
            }
            
            self.btnCallAction()
        case 2:
            let mailURL = URL(string: "message://")!
            if UIApplication.shared.canOpenURL(mailURL) {
                UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
            }
        default:
            guard self.endCallView.isHidden else {
                showSwiftyAlert("", "Please End Call to continue", false)
                return
            }
            deleteOrder { (_) in
                GoToHome()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard tableView != self.storeInfoTblView else{
            self.storeInfoTblViewHeigh.constant = tableView.contentSize.height
            return
        }
        
    }
    
}


extension ScheduleGroceryDeliveryVC {
    
    //MARK: API
    
    func addFavApi(){
        let params: Parameters = [
            "json" : JSON(self.businessDetail?.dictionaryRepresentation() ?? [:]).debugDescription
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.add_fav_businesss , success: { (json) in
            hideLoader()
            
            self.businessDetail?.isFav = true
            self.businessDetail?.favId = json["data"]["id"].stringValue
            
            self.heartIcon.image = UIImage(named: "heart2_2")
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    func removeFavApi(){
        let params: Parameters = [
            "fav_id" : self.businessDetail?.favId ?? ""
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.remove_fav_businesss, method: .delete , success: { (json) in
            hideLoader()
            self.businessDetail?.isFav = false
            self.heartIcon.image = UIImage(named: "heart3_2-1")
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
}
