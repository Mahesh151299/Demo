//
//  EditAddressVC.swift
//  Courail
//
//  Created by apple on 24/01/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import LGSideMenuController

class EditAddressVC: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var editAddressView: UIView!
    
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTittle: UILabel!
    
    @IBOutlet weak var aptTF: UITextFieldCustomClass!
    
    @IBOutlet weak var dropOffTF: UITextFieldCustomClass!
    @IBOutlet weak var notesTV: IQTextView!
    
    @IBOutlet weak var placeNameTF: UITextFieldCustomClass!
    
    @IBOutlet weak var setBtnOut: UIButton!
    @IBOutlet weak var editBtnOut: UIButton!
    
    @IBOutlet weak var floorField: UITextFieldCustomClass!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var elevatorIcon: UIImageView!
    @IBOutlet weak var walkIcon: UIImageView!
    @IBOutlet weak var bothIcon: UIImageView!
    
    @IBOutlet weak var elevatorBtnOut: UIButton!
    @IBOutlet weak var walkBtnOut: UIButton!
    @IBOutlet weak var bothBtnOut: UIButton!
    
    @IBOutlet weak var aptView: UIStackView!
    @IBOutlet weak var floorView: UIView!
    @IBOutlet weak var switchView: UIStackView!
    
    @IBOutlet weak var saveUptoLbl: UILabel!
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tableWidth: NSLayoutConstraint!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var phoneView: UIView!
    
    
    //MARK:- VARIABLES
    
    var textStingTittle = ""
    
    var isEdit = false
    
    //    var isNew = false
    var index = "0"
    
    var isDelivery = true
    var isSwitched = false
    var isReversedDel = false
    var dropOffOptions = ["Meet me Curbside","Meet me at my Suite/Apt","Meet me at my front door","Leave package at my front door","Leave package in Lobby","Leave with Front Desk / Doorman"]
    
    var pickUpOptions = ["Curbside pickup","Drive thru pickup", "Pickup from contact at Suite/Apt","Package left at my front door","Package left in Lobby","See Front Desk / Doorman"]
    
    var selectedOptions = "Meet me Curbside"
    
    var marker = GMSMarker()
    
    var elevatorWalk = "" {
        didSet{
            if elevatorWalk == "0"{
                self.elevatorIcon.image = UIImage(named: "imgSwitchOn")
                self.walkIcon.image = UIImage(named: "imgSwitchOff")
                self.bothIcon.image = UIImage(named: "imgSwitchOff")
            } else if elevatorWalk == "1"{
                self.elevatorIcon.image = UIImage(named: "imgSwitchOff")
                self.walkIcon.image = UIImage(named: "imgSwitchOn")
                self.bothIcon.image = UIImage(named: "imgSwitchOff")
            }else if elevatorWalk == "2"{
                self.elevatorIcon.image = UIImage(named: "imgSwitchOff")
                self.walkIcon.image = UIImage(named: "imgSwitchOff")
                self.bothIcon.image = UIImage(named: "imgSwitchOn")
            } else{
                self.elevatorIcon.image = UIImage(named: "imgSwitchOff")
                self.walkIcon.image = UIImage(named: "imgSwitchOff")
                self.bothIcon.image = UIImage(named: "imgSwitchOff")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.floorField.delegate = self
        self.phoneTF.delegate = self
        
        if self.isDelivery{
            self.saveUptoLbl.text = "Be Covid 19 compliant and save on the effort fee\nby choosing a curbside or lobby drop-off option."
            
            self.dropOffTF.text = "Meet me Curbside"
            self.selectedOptions = "Meet me Curbside"
            if self.isEdit{
                self.headerTittle.text = "Edit Delivery Address"
                
                self.editBtnOut.setTitle("DELETE", for: .normal)
                self.aptTF.text = DeliveryAddressInterface.shared.tempAddress.apartmentInfo ?? ""
                
                self.notesTV.text = DeliveryAddressInterface.shared.tempAddress.notes ?? ""
                self.placeNameTF.text = DeliveryAddressInterface.shared.tempAddress.placeName ?? ""
                self.phoneTF.text = DeliveryAddressInterface.shared.tempAddress.addressPhone ?? ""
                
                self.selectedOptions = DeliveryAddressInterface.shared.tempAddress.dropPickupoptions ?? ""
                self.dropOffTF.text = DeliveryAddressInterface.shared.tempAddress.dropPickupoptions ?? ""
                
                self.floorField.text = DeliveryAddressInterface.shared.tempAddress.elevatorFloor ?? ""
                self.elevatorWalk = DeliveryAddressInterface.shared.tempAddress.elevator_walk_both ?? ""
            } else{
                self.headerTittle.text = "Add Delivery Address"
                self.setBtnOut.setTitle("SAVE ADDRESS", for: .normal)
                self.editBtnOut.isHidden = true
            }
            
            self.phoneView.isHidden = true
        } else{
            self.saveUptoLbl.text = "Be Covid 19 compliant and save on the effort fee\nby choosing a curbside or lobby pick up option."
            
            self.dropOffTF.text = "Curbside pickup"
            self.selectedOptions = "Curbside pickup"
            
            self.notesTV.placeholder = "Any pick up instructions? Parking notes, etc"
            
            if self.isEdit{
                self.headerTittle.text = "Edit Pick Up Address"
                self.headerView.backgroundColor = appColor
                self.topView.backgroundColor = appColor
                
                self.editBtnOut.setTitle("DELETE", for: .normal)
                self.aptTF.text = PickUpAddressInterface.shared.tempAddress.apartmentInfo ?? ""
                
                self.notesTV.text = PickUpAddressInterface.shared.tempAddress.notes ?? ""
                self.placeNameTF.text = PickUpAddressInterface.shared.tempAddress.placeName ?? ""
                self.phoneTF.text = PickUpAddressInterface.shared.tempAddress.addressPhone ?? ""
                
                self.selectedOptions = PickUpAddressInterface.shared.tempAddress.dropPickupoptions ?? ""
                self.dropOffTF.text = PickUpAddressInterface.shared.tempAddress.dropPickupoptions ?? ""
                
                self.floorField.text = PickUpAddressInterface.shared.tempAddress.elevatorFloor ?? ""
                self.elevatorWalk = PickUpAddressInterface.shared.tempAddress.elevator_walk_both ?? ""
                
            } else{
                self.headerTittle.text = "Add Pick Up Address"
                self.headerView.backgroundColor = appColor
                self.topView.backgroundColor = appColor
                
                self.setBtnOut.setTitle("SAVE ADDRESS", for: .normal)
                self.editBtnOut.isHidden = true
            }
            
            self.phoneView.isHidden = false
        }
        
        _ = self.StairsElevatorShow()
        
        if self.index == "Home" || self.index == "Work"{
            self.placeNameTF.text = self.index
            self.placeNameTF.isUserInteractionEnabled = false
        } else{
            self.placeNameTF.isUserInteractionEnabled = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        var cords = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        
        if self.isDelivery{
            let state = DeliveryAddressInterface.shared.tempAddress.fullAddress?.components(separatedBy: ", ").last ?? ""
            let filterAdd = DeliveryAddressInterface.shared.tempAddress.fullAddress?.replacingOccurrences(of: ", \(state)", with: "")
            
            self.addressLbl.text = filterAdd
            cords = CLLocationCoordinate2D(latitude: CLLocationDegrees(DeliveryAddressInterface.shared.tempAddress.latitude ?? 0.0), longitude: CLLocationDegrees(DeliveryAddressInterface.shared.tempAddress.longitude ?? 0.0))
        } else{
            let state = PickUpAddressInterface.shared.tempAddress.fullAddress?.components(separatedBy: ", ").last ?? ""
            let filterAdd = PickUpAddressInterface.shared.tempAddress.fullAddress?.replacingOccurrences(of: ", \(state)", with: "")
            
            self.addressLbl.text = filterAdd
            cords = CLLocationCoordinate2D(latitude: CLLocationDegrees(PickUpAddressInterface.shared.tempAddress.latitude ?? 0.0), longitude: CLLocationDegrees(PickUpAddressInterface.shared.tempAddress.longitude ?? 0.0))
        }
        
        self.marker.map = nil
        if cords.latitude != 0.0{
            self.marker = GMSMarker(position: cords)
            if self.isDelivery{
                self.marker.icon = UIImage(named: "imgMarkerDeliveryShadow")
            }else{
                self.marker.icon = UIImage(named: "imgMarkerPickShadow")
            }
            self.marker.map = self.mapView
            let camera = GMSCameraPosition.camera(withTarget: cords, zoom: 16)
            self.mapView.camera = camera
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    //MARK:- BUTTONS ACTIONS
    
    @IBAction func backBtnAction(_ sender: Any) {
        guard goToCurrentOrder(self, false) == false else { return }
        
        if isSwitched{
            if self.isDelivery{
                goToSpecialDelivery(self)
            } else{
                self.pop()
//                GoToHome()
            }
        } else{
            if self.isDelivery{
                self.pop()
//                GoToHome()
            } else{
                goToSpecialDelivery(self)
            }
        }
    }
    
    @IBAction func setBtnClicked(_ sender: Any) {
        if self.isDelivery{
            if self.StairsElevatorShow() && self.aptTF.text != "" && self.floorField.text == ""{
                showSwiftyAlert("", "Please enter number of floor", false)
                return
            }
            
            if self.StairsElevatorShow() && self.aptTF.text != "" && self.elevatorWalk == ""{
                showSwiftyAlert("", "Please select Elevator, Walk up or None", false)
                return
            }
            
            
            DeliveryAddressInterface.shared.tempAddress.apartmentInfo = self.checkApt(apt: self.aptTF.text!)
            DeliveryAddressInterface.shared.tempAddress.elevatorFloor = self.floorField.text!
            DeliveryAddressInterface.shared.tempAddress.elevator_walk_both = self.elevatorWalk
            DeliveryAddressInterface.shared.tempAddress.dropPickupoptions = self.selectedOptions
            DeliveryAddressInterface.shared.tempAddress.notes = self.notesTV.text!
            DeliveryAddressInterface.shared.tempAddress.placeName = self.placeNameTF.text!
            DeliveryAddressInterface.shared.tempAddress.addressType = self.placeNameTF.text!
            DeliveryAddressInterface.shared.tempAddress.addressPhone = self.phoneTF.text!
            DeliveryAddressInterface.shared.tempAddress.icon = "star-1"
            
            if self.isEdit{
                if isLoggedIn(){
                    if self.index == "Home"{
                        DeliveryAddressInterface.shared.tempAddress.internalIdentifier = DeliveryAddressInterface.shared.homeAddress.internalIdentifier
                    } else if self.index == "Work"{
                        DeliveryAddressInterface.shared.tempAddress.internalIdentifier = DeliveryAddressInterface.shared.workAddress.internalIdentifier
                    } else{
                        let indexInt = JSON(self.index).intValue
                        DeliveryAddressInterface.shared.tempAddress.internalIdentifier = DeliveryAddressInterface.shared.savedAddresses[indexInt].internalIdentifier
                    }
                    self.addAddressApi(DeliveryAddressInterface.shared.tempAddress, isEdit: true)
                } else{
                    if self.index == "Home"{
                        DeliveryAddressInterface.shared.homeAddress = DeliveryAddressInterface.shared.tempAddress
                    } else if self.index == "Work"{
                        DeliveryAddressInterface.shared.workAddress = DeliveryAddressInterface.shared.tempAddress
                    } else{
                        let indexInt = JSON(self.index).intValue
                        DeliveryAddressInterface.shared.savedAddresses[indexInt] = DeliveryAddressInterface.shared.tempAddress
                    }
                    
                    if self.isSwitched{
                        PickUpAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.tempAddress
                        if goToCurrentOrder(self, true) == false {
                            self.goToSelectedAddress(isReverse: self.isReversedDel)
                        }
                    } else{
                        if self.isReversedDel{
                            PickUpAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.tempAddress
                            if goToCurrentOrder(self, true) == false{
                                self.goToSelectedAddress(isReverse: true)
                            }
                        } else{
                            DeliveryAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.tempAddress
                            if goToCurrentOrder(self, true) == false {
                                GoToHome()
                            }
                        }
                    }
                }
            } else{
                if isLoggedIn(){
                    self.addAddressApi(DeliveryAddressInterface.shared.tempAddress, isEdit: false)
                } else{
                    DeliveryAddressInterface.shared.tempAddress.internalIdentifier = Int.random(in: 1...99999)
                    DeliveryAddressInterface.shared.savedAddresses.append(DeliveryAddressInterface.shared.tempAddress)
                    if self.isSwitched{
                        PickUpAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.tempAddress
                        if goToCurrentOrder(self, true) == false {
                            self.goToSelectedAddress(isReverse: self.isReversedDel)
                        }
                    } else{
                        if self.isReversedDel{
                            PickUpAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.tempAddress
                            if goToCurrentOrder(self, true) == false{
                                self.goToSelectedAddress(isReverse: true)
                            }
                        } else{
                            DeliveryAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.tempAddress
                            if goToCurrentOrder(self, true) == false {
                                GoToHome()
                            }
                        }
                    }
                }
            }
        } else{
            guard self.placeNameTF.text?.isEmpty == false else{
                showSwiftyAlert("", "Please enter name of this place", false)
                return
            }
            
            if self.phoneTF.text?.isEmpty == true{
                showSwiftyAlert("", "Please enter contact number", false)
                return
            }
            
            if self.phoneTF.text?.isValidateMobile() == false{
                showSwiftyAlert("", "Invalid contact number", false)
                return
            }
            
            if self.StairsElevatorShow() && self.aptTF.text != "" && self.floorField.text == ""{
                showSwiftyAlert("", "Please enter number of floor", false)
                return
            }
            
            if self.StairsElevatorShow() && self.aptTF.text != "" && self.elevatorWalk == ""{
                showSwiftyAlert("", "Please select Elevator, Walk up or None", false)
                return
            }
            
            PickUpAddressInterface.shared.tempAddress.apartmentInfo = self.checkApt(apt: self.aptTF.text!)
            PickUpAddressInterface.shared.tempAddress.elevatorFloor = self.floorField.text!
            PickUpAddressInterface.shared.tempAddress.elevator_walk_both = self.elevatorWalk
            PickUpAddressInterface.shared.tempAddress.dropPickupoptions = self.selectedOptions
            PickUpAddressInterface.shared.tempAddress.notes = self.notesTV.text!
            PickUpAddressInterface.shared.tempAddress.placeName = self.placeNameTF.text!
            PickUpAddressInterface.shared.tempAddress.addressType = self.placeNameTF.text!
            PickUpAddressInterface.shared.tempAddress.addressPhone = self.phoneTF.text!
            PickUpAddressInterface.shared.tempAddress.icon = "star-1"
            
            if self.isEdit{
                if isLoggedIn(){
                    if self.index == "Home"{
                        PickUpAddressInterface.shared.tempAddress.internalIdentifier = DeliveryAddressInterface.shared.homeAddress.internalIdentifier
                    } else if self.index == "Work"{
                        PickUpAddressInterface.shared.tempAddress.internalIdentifier = DeliveryAddressInterface.shared.workAddress.internalIdentifier
                    } else{
                        let indexInt = JSON(self.index).intValue
                        PickUpAddressInterface.shared.tempAddress.internalIdentifier = PickUpAddressInterface.shared.savedAddresses[indexInt].internalIdentifier
                    }
                    self.addAddressApi(PickUpAddressInterface.shared.tempAddress, isEdit: true)
                } else{
                    if self.index == "Home"{
                        DeliveryAddressInterface.shared.homeAddress = PickUpAddressInterface.shared.tempAddress
                    } else if self.index == "Work"{
                        DeliveryAddressInterface.shared.workAddress = PickUpAddressInterface.shared.tempAddress
                    } else{
                        let indexInt = JSON(self.index).intValue
                        PickUpAddressInterface.shared.savedAddresses[indexInt] = PickUpAddressInterface.shared.tempAddress
                    }
                    
                    if self.isSwitched{
                        if self.isReversedDel{
                            PickUpAddressInterface.shared.selectedAddress = DeliveryAddressInterface.shared.tempAddress
                            if goToCurrentOrder(self, true) == false{
                                self.goToSelectedAddress(isReverse: true)
                            }
                        } else{
                            DeliveryAddressInterface.shared.selectedAddress = PickUpAddressInterface.shared.tempAddress
                            if goToCurrentOrder(self, true) == false {
                                GoToHome()
                            }
                        }
                    } else{
                        PickUpAddressInterface.shared.selectedAddress = PickUpAddressInterface.shared.tempAddress
                        if goToCurrentOrder(self, true) == false {
                            self.goToSelectedAddress(isReverse: self.isReversedDel)
                        }
                    }
                }
            } else {
                if isLoggedIn(){
                    self.addAddressApi(PickUpAddressInterface.shared.tempAddress, isEdit: false)
                } else{
                    PickUpAddressInterface.shared.tempAddress.internalIdentifier = Int.random(in: 1...99999)
                    PickUpAddressInterface.shared.savedAddresses.append(PickUpAddressInterface.shared.tempAddress)
                    
                    if self.isSwitched{
                        if self.isReversedDel{
                            PickUpAddressInterface.shared.selectedAddress = PickUpAddressInterface.shared.tempAddress
                            if goToCurrentOrder(self, true) == false{
                                self.goToSelectedAddress(isReverse: true)
                            }
                        } else{
                            DeliveryAddressInterface.shared.selectedAddress = PickUpAddressInterface.shared.tempAddress
                            if goToCurrentOrder(self, true) == false {
                                GoToHome()
                            }
                        }
                    } else{
                        PickUpAddressInterface.shared.selectedAddress = PickUpAddressInterface.shared.tempAddress
                        if goToCurrentOrder(self, true) == false {
                            self.goToSelectedAddress(isReverse: self.isReversedDel)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        if self.editBtnOut.currentTitle == "DELETE"{
            let indexInt = JSON(self.index).intValue
            if isLoggedIn(){
                if self.index == "Home"{
                    self.deleteAddressApi(DeliveryAddressInterface.shared.homeAddress)
                } else if self.index == "Work"{
                    self.deleteAddressApi(DeliveryAddressInterface.shared.workAddress)
                } else{
                    if self.isDelivery{
                        self.deleteAddressApi(DeliveryAddressInterface.shared.savedAddresses[indexInt])
                    } else{
                        self.deleteAddressApi(PickUpAddressInterface.shared.savedAddresses[indexInt])
                    }
                }
            } else{
                if self.isDelivery{
                    if DeliveryAddressInterface.shared.savedAddresses[indexInt].internalIdentifier == DeliveryAddressInterface.shared.selectedAddress.internalIdentifier{
                        DeliveryAddressInterface.shared.selectedAddress.internalIdentifier = nil
                    }
                    DeliveryAddressInterface.shared.savedAddresses.remove(at: indexInt)
                } else{
                    if PickUpAddressInterface.shared.savedAddresses[indexInt].internalIdentifier == DeliveryAddressInterface.shared.selectedAddress.internalIdentifier{
                        DeliveryAddressInterface.shared.selectedAddress.internalIdentifier = nil
                    }
                    PickUpAddressInterface.shared.savedAddresses.remove(at: indexInt)
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func dropOffBtn(_ sender: UIButton) {
        self.tableWidth.constant = 260
        if self.isDelivery{
            self.tableHeight.constant = CGFloat(50 * self.dropOffOptions.count)
        }else{
            self.tableHeight.constant = CGFloat(50 * self.pickUpOptions.count)
        }
        self.table.delegate = self
        self.table.dataSource = self
        self.table.tableFooterView = UIView()
        self.table.layer.borderWidth = 1
        self.table.layer.borderColor = UIColor.lightGray.cgColor
        self.table.isHidden = false
    }
    
    @IBAction func elevatorBtn(_ sender: UIButton) {
        guard self.StairsElevatorShow() else {return}
        self.elevatorWalk = (self.elevatorWalk == "0") ? "" : "0"
    }
    
    @IBAction func walkBtn(_ sender: UIButton) {
        guard self.StairsElevatorShow() else {return}
        self.elevatorWalk = (self.elevatorWalk == "1") ? "" : "1"
    }
    
    @IBAction func bothBtn(_ sender: UIButton) {
        guard self.StairsElevatorShow() else {return}
        self.elevatorWalk = (self.elevatorWalk == "2") ? "" : "2"
    }
    
    @IBAction func textFieldChanged(_ textfield: UITextField) {
        _ = self.StairsElevatorShow()
    }
    
    func StairsElevatorShow()->Bool{
        let options = self.selectedOptions
        if self.isDelivery && ((options == "Meet me Curbside") || (options == "Leave package in Lobby") || (options == "Meet me at my front door") || (options == "Leave with Front Desk / Doorman") || (options == "")){
            self.resetOptions()
            self.aptView.isHidden = true
            self.switchView.isHidden = true
            return false
        }else if isDelivery == false  && ((options == "Curbside pickup") || (options == "Drive thru pickup") || (options == "Package left in Lobby") || (options == "See Front Desk / Doorman") || (options == "")){
            self.resetOptions()
            self.aptView.isHidden = true
            self.switchView.isHidden = true
            return false
        } else if self.aptTF.text?.isEmpty == true{
            self.resetOptions()
            self.aptView.isHidden = false
            self.floorView.isHidden = true
            self.switchView.isHidden = true
            return true
        }else{
            self.aptView.isHidden = false
            self.floorView.isHidden = false
            self.switchView.isHidden = false
            return true
        }
    }
    
    func resetOptions(){
        self.aptTF.text = ""
        self.floorField.text = ""
        self.elevatorWalk = ""
        
        self.elevatorBtnOut.isUserInteractionEnabled = true
        self.walkBtnOut.isUserInteractionEnabled = true
        self.bothBtnOut.isUserInteractionEnabled = true
    }
    
    
    func goToSelectedAddress(isReverse: Bool){
        self.view.endEditing(true)
        
        if (PickUpAddressInterface.shared.selectedAddress.addressPhone ?? "").isValidateMobile() && (PickUpAddressInterface.shared.selectedAddress.placeName ?? "").isEmpty == false{
            
            PickUpAddressInterface.shared.getDetails(isReversedDel: isReverse) { (model) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedStoreVC")as! SelectedStoreVC
                vc.category = "Special"
                vc.businessDetail = model
                vc.businessDetail?.name = PickUpAddressInterface.shared.selectedAddress.placeName
                vc.businessDetail?.displayPhone = PickUpAddressInterface.shared.selectedAddress.addressPhone
                vc.isFilled = true
                vc.isReversedDel = isReverse
                vc.isliveOrderChanges = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectedStoreVC")as! SelectedStoreVC
            vc.category = "Special"
            vc.isReversedDel = isReverse
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


extension EditAddressVC: UIPopoverPresentationControllerDelegate{
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension EditAddressVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isDelivery{
            return self.dropOffOptions.count
        } else{
            return self.pickUpOptions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopOverTVC")as! PopOverTVC
        
        if self.isDelivery{
        cell.lblName.text = self.dropOffOptions[indexPath.row]
        } else{
        cell.lblName.text = self.pickUpOptions[indexPath.row]
        }
        
        if self.selectedOptions == cell.lblName.text{
            cell.lblName.textColor = appColor
        } else{
            cell.lblName.textColor = .black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isDelivery{
            self.selectedOptions = self.dropOffOptions[indexPath.row]
        } else{
            self.selectedOptions = self.pickUpOptions[indexPath.row]
        }
        tableView.reloadData()
        tableView.isHidden = true
        
        self.dropOffTF.text = self.selectedOptions
        _ = self.StairsElevatorShow()
    }
    
    
}



extension EditAddressVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        if textField == self.phoneTF {
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = newString.formattedNumber()
            return false
        }else{
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = newString.floorValidation()
            if JSON(textField.text!).intValue == 1{
                self.elevatorWalk = "2"
                
                self.elevatorBtnOut.isUserInteractionEnabled = false
                self.walkBtnOut.isUserInteractionEnabled = false
                self.bothBtnOut.isUserInteractionEnabled = false
            }else if JSON(textField.text!).intValue > 1{
                if self.elevatorWalk == "2"{
                    self.elevatorWalk = ""
                }
                self.elevatorBtnOut.isUserInteractionEnabled = true
                self.walkBtnOut.isUserInteractionEnabled = true
                self.bothBtnOut.isUserInteractionEnabled = false
            }
            return false
        }
    }
    
}

extension EditAddressVC {
    
    //MARK:- API
    
    func checkApt(apt: String)->String{
        var stringArr = apt.components(separatedBy: CharacterSet.alphanumerics.inverted)
        
        for i in 0..<stringArr.count{
            if Int(stringArr[i]) != nil{
                stringArr[i] = "#" + stringArr[i]
            }
        }
        return stringArr.joined(separator: " ")
    }
    
    func addAddressApi(_ model: AddressModel?, isEdit: Bool){
        
        let addressType = (self.index == "Home") ? "1" : (self.index == "Work") ? "2" : "3"
        let delivery_pickUp = (self.index == "Home" || self.index == "Work") ? "0" : (isDelivery ? "0" : "1")
        
        
        let params: Parameters = [
            "address_id": isEdit ? "\(model?.internalIdentifier ?? 0)" : "",
            "address": model?.address ?? "",
            "address_full": model?.fullAddress ?? "",
            "place_name": model?.placeName ?? "",
            "address_phone": model?.addressPhone ?? "",
            "latitude": "\(model?.latitude ?? 0.0)",
            "longitude": "\(model?.longitude ?? 0.0)",
            "apartment_info": model?.apartmentInfo ?? "",
            "parking_info": model?.parkingInfo ?? "",
            "address_type": addressType , // Home,Work, Custom
            "delivery_pickUp": delivery_pickUp,
            "notes": model?.notes ?? "",
            "drop_pickup_options": self.selectedOptions,
            "elevator_floor": self.floorField.text ?? "",
            "elevator_walk_both": self.elevatorWalk
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: isEdit ? API.edit_address : API.add_address , method: isEdit ? .put : .post, success: { (json) in
            hideLoader()
            if isEdit{
                showSwiftyAlert("", json["msg"].stringValue, true)
            }
            
            if self.isDelivery{
                if self.isSwitched{
                    //Address is filled
                    PickUpAddressInterface.shared.selectedAddress = model!
                    PickUpAddressInterface.shared.selectedAddress.internalIdentifier = json["data"]["id"].intValue
                    if goToCurrentOrder(self, true) == false {
                        self.goToSelectedAddress(isReverse: self.isReversedDel)
                    }
                } else{
                    if self.isReversedDel{
                        PickUpAddressInterface.shared.selectedAddress = model!
                        self.goToSelectedAddress(isReverse: true)
                    } else{
                        DeliveryAddressInterface.shared.selectedAddress = model!
                        DeliveryAddressInterface.shared.selectedAddress.internalIdentifier = json["data"]["id"].intValue
                        
                        self.selectAddressApi(model: DeliveryAddressInterface.shared.selectedAddress)
//                        if goToCurrentOrder(self, true) == false {
//                            GoToHome()
//                        }
                    }
                }
            } else{
                if self.isSwitched{
                    if self.isReversedDel{
                        PickUpAddressInterface.shared.selectedAddress = model!
                        self.goToSelectedAddress(isReverse: true)
                    } else{
                        DeliveryAddressInterface.shared.selectedAddress = model!
                        DeliveryAddressInterface.shared.selectedAddress.internalIdentifier = json["data"]["id"].intValue
                        
                        self.selectAddressApi(model: DeliveryAddressInterface.shared.selectedAddress)
//                        if goToCurrentOrder(self, true) == false {
//                            GoToHome()
//                        }
                    }
                } else{
                    PickUpAddressInterface.shared.selectedAddress = model!
                    PickUpAddressInterface.shared.selectedAddress.internalIdentifier = json["data"]["id"].intValue
                    if goToCurrentOrder(self, true) == false {
                        self.goToSelectedAddress(isReverse: self.isReversedDel)
                    }
                }
            }
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    
    func deleteAddressApi(_ model: AddressModel?){
        let params: Parameters = [
            "address_id": isEdit ? "\(model?.internalIdentifier ?? 0)" : ""
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.delete_address , method:  .delete, success: { (json) in
            hideLoader()
            showSwiftyAlert("", json["msg"].stringValue, true)
            if model?.internalIdentifier == DeliveryAddressInterface.shared.selectedAddress.internalIdentifier{
                DeliveryAddressInterface.shared.selectedAddress.internalIdentifier = nil
            }
            self.pop()
        }) { (error, json) in
            hideLoader()
            showSwiftyAlert("", error, false)
        }
    }
    
    
    func selectAddressApi(model: AddressModel?){
        let params: Parameters = [
            "address_id" : "\(model?.internalIdentifier ?? 0)"
        ]
        
        showLoader()
        ApiInterface.requestApi(params: params, api_url: API.select_default_address , method: .put, success: { (json) in
            hideLoader()
            userInfo.selectedAddress = model
            if goToCurrentOrder(self, true) == false{
                GoToHome()
            }
        }) { (error, json) in
            hideLoader()
            GoToHome()
        }
    }
    
}


