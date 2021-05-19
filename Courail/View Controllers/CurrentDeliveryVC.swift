//
//  CurrentDeliveryVC.swift
//  Courail
//
//  Created by mac on 10/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SKPhotoBrowser


class CurrentDeliveryVC: UIViewController {
    
    //MARK:- BUTTONS ACTIONS
    
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var pickUpTime: UILabel!
    
    
    //MARK:- VARIABLES ACTIONS
    var photoBrowser = SKPhotoBrowser()
    
    var businessDetail : YelpStoreBusinesses?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.orderNo.text = "Order #" + (self.businessDetail?.orderID ?? "")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        orderInProgress = false
        let str = isLoggedIn() ? ((userInfo.firstName ?? "") + "'s") : "Your"
        self.navTitle.text = str + " Order"
        self.pickUpTime.text = "PICK UP " +  self.checkDate(self.businessDetail?.pickUpTime ?? "")
        
        self.tabBarController?.tabBar.isHidden = true
        self.table.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func MenuOrGoBack(_ sender:UIButton){
        self.pop()
    }
    
    @IBAction func completedDelivery(_ sender:UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompletedDeliveryVC")as! CompletedDeliveryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func receiptBtn(_ sender:UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReceiptViewController") as! ReceiptViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.businessDetail = self.businessDetail
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func trackBtn(_ sender:UIButton){
        self.pop()
    }
  
}

extension CurrentDeliveryVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = DeliveryDetailTVC()
        
        switch indexPath.section{
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryDetailCell", for: indexPath) as! DeliveryDetailTVC
            
            if indexPath.row == 0{
                cell.arrowIcon.isHidden = true
                cell.line0.isHidden = true
                cell.line1.isHidden = false
                cell.bottomLine.isHidden = false
                
                cell.imgIcon.image = UIImage(named: "imgMarkerPick")
                cell.lblTittle.text = self.businessDetail?.name ?? ""
                cell.notes.text = self.businessDetail?.additionalNotes ?? ""
                
                cell.adressOptions.text = self.addressOptions(isDelivery: false)
                let aptInfo = self.businessDetail?.location?.aptInfo ?? ""
                
                let address = self.businessDetail?.location
                if aptInfo != ""{
                    cell.lblAddress1.text = (address?.address1 ?? "") + " • " + aptInfo
                } else{
                    cell.lblAddress1.text = (address?.address1 ?? "")
                }
                cell.lblAddress2.text = (address?.address2 ?? "")
                
            } else{
                cell.arrowIcon.isHidden = true
                cell.line0.isHidden = false
                cell.line1.isHidden = true
                
                cell.imgIcon.image = UIImage(named: "imgMarkerDelivery")
                cell.lblTittle.text = userInfo.firstName ?? "You"
                cell.notes.text = DeliveryAddressInterface.shared.selectedAddress.notes ?? ""
                
                let address1 = (DeliveryAddressInterface.shared.selectedAddress.address ?? "") + ", "
                let addressFull = DeliveryAddressInterface.shared.selectedAddress.fullAddress ?? ""
                let address2 = addressFull.replacingOccurrences(of: address1, with: "")
                
                let aptInfo = DeliveryAddressInterface.shared.selectedAddress.apartmentInfo ?? ""
                if aptInfo != ""{
                    cell.lblAddress1.text = (DeliveryAddressInterface.shared.selectedAddress.address ?? "") + " • " + aptInfo
                } else{
                    cell.lblAddress1.text = DeliveryAddressInterface.shared.selectedAddress.address ?? ""
                }
                
                cell.lblAddress2.text = address2
                
                cell.adressOptions.text = self.addressOptions(isDelivery: true)
                
                cell.bottomLine.isHidden = true
                
            }
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "PackageDetailCell", for: indexPath) as! DeliveryDetailTVC
            cell.itemName.text = self.businessDetail?.itemDescription?.uppercased()
            cell.itemDetails.text = self.itemDetails()
            
            cell.collectionImages.delegate = self
            cell.collectionImages.dataSource = self
            
            if self.businessDetail?.attachedPhoto.count == 0{
                cell.collectionImages.isHidden = true
            } else{
                cell.collectionImages.isHidden = false
            }
            
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "SubTotalCell", for: indexPath) as! DeliveryDetailTVC
            
            if self.businessDetail?.subTotalType == "COURIAL PAYS"{
                cell.prePaidBtn.isHidden = true
                cell.courialPayBtn.isHidden = false
            }else{
                cell.prePaidBtn.isHidden = false
                cell.courialPayBtn.isHidden = true
            }
            
            cell.field.text = self.businessDetail?.courialFee ?? "0000.00"
            
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "TotalCell", for: indexPath) as! DeliveryDetailTVC
            cell.totalAmount.text = "$" + (self.businessDetail?.totalFee ?? "0.0")
            
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell", for: indexPath) as! DeliveryDetailTVC
            
            cell.receiptBtn.addTarget(self, action: #selector(self.receiptBtn(_:)), for: .touchUpInside)
            cell.trackBtn.addTarget(self, action: #selector(self.trackBtn(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    
    func itemDetails()-> String{
        let twoCourial =  (self.businessDetail?.two_courial ?? false) ? "Two Courials • " : ""
        let over45Lbs =  (self.businessDetail?.over45Lbs ?? false) ? "Over 45 lbs • " : ""
        
        let vehicleTypes = ["Walker","Bicycle","E-Scooter","Scooter Large","Motorcycle","Car","Pickup","Van","Truck"]
        let vehicle = "By " + vehicleTypes[self.businessDetail?.vehicleTypeIndex ?? 0]
        
        return twoCourial + over45Lbs + vehicle
        
    }
    
    func addressOptions(isDelivery: Bool)-> String{
        if isDelivery{
            let options = DeliveryAddressInterface.shared.selectedAddress.dropPickupoptions ?? ""
            
            if (options == "Meet me Curbside") || (options == "Meet me in Lobby") || (options == "Leave at Front Desk") || (options == ""){
                return options
            } else{
                var floors = DeliveryAddressInterface.shared.selectedAddress.elevatorFloor ?? ""
                
                if JSON(floors).intValue == 0{
                    floors = ""
                }else if JSON(floors).intValue == 1{
                    floors = floors + "st Fl "
                }else if JSON(floors).intValue == 2{
                    floors = floors + "nd Fl "
                }else if JSON(floors).intValue == 3{
                    floors = floors + "rd Fl "
                } else{
                    floors = floors + "th Fl "
                }
                
                var floorType = DeliveryAddressInterface.shared.selectedAddress.elevator_walk_both ?? ""
                if floorType == "0"{
                    floorType = "Elevator"
                }else if floorType == "1"{
                    floorType = "Stairs"
                } else{
                    floorType = "Elevators and Stairs"
                }
                
                return (floors + floorType) +  " • " + options
            }
        } else{
            let options = self.businessDetail?.location?.pickOption ?? ""
            
            if (options == "Meet me Curbside") || (options == "Meet me in Lobby") || (options == "Leave at Front Desk") || (options == ""){
                return options
            } else{
                var floors = self.businessDetail?.location?.pickElevatorFloor ?? ""
                
                if JSON(floors).intValue == 0{
                    floors = ""
                }else if JSON(floors).intValue == 1{
                    floors = floors + "st Fl "
                }else if JSON(floors).intValue == 2{
                    floors = floors + "nd Fl "
                }else if JSON(floors).intValue == 3{
                    floors = floors + "rd Fl "
                } else{
                    floors = floors + "th Fl "
                }
                
                var floorType = self.businessDetail?.location?.pick_elevator_walk_both ?? ""
                if floorType == "0"{
                    floorType = "Elevator"
                }else if floorType == "1"{
                    floorType = "Stairs"
                } else{
                    floorType = "Elevators and Stairs"
                }
                
                let twoCourial =  (self.businessDetail?.two_courial ?? false) ? " • 2 Courial's" : ""
                
                return (floors + floorType) +  " • " + options + twoCourial
            }
        }
    }
    
    func checkDate(_ stamp: String)-> String{
        guard let date = stamp.convertToDate() else{
            return "Select Time"
        }
        
        if Calendar.current.isDateInToday(date){
            return date.convertToFormat("'TODAY, ' hh:mm a", timeZone: .current)
        } else if Calendar.current.isDateInTomorrow(date){
            return date.convertToFormat("'TOMORROW, ' hh:mm a", timeZone: .current)
        } else{
            return date.convertToFormat("dd MMM hh:mm a", timeZone: .current)
        }
    }
    
}

extension CurrentDeliveryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.businessDetail?.attachedPhoto.count ?? 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImagesCVC", for: indexPath) as! AddImagesCVC
        cell.attachedImage.image = self.businessDetail?.attachedPhoto[indexPath.item]
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
        
        let attachedCount = (self.businessDetail?.attachedPhoto.count ?? 0)
        if attachedCount == 1{
            return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
        }else if attachedCount == 2{
            let width = (collectionView.frame.width - 10) / 2
            return CGSize(width: width , height: collectionView.frame.height)
        }else{
            let width = (collectionView.frame.width - 15) / 3
            return CGSize(width: width , height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let img = self.businessDetail?.attachedPhoto[indexPath.item] else {return}
        let photo = SKPhoto.photoWithImage(img)
        self.photoBrowser = SKPhotoBrowser(photos: [photo])
        super.present(self.photoBrowser, animated: true, completion: nil)
    }
    
}
