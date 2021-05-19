//
//  DeliveryAddressInterface.swift
//  Courail
//
//  Created by apple on 16/03/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import GooglePlaces

class DeliveryAddressInterface: NSObject {
    
    static let shared = DeliveryAddressInterface()
    
    var currentAddress = AddressModel(json: JSON())
    var homeAddress = AddressModel(json: JSON())
    var workAddress = AddressModel(json: JSON())
    
    var searchedAddresses = [AddressModel]()
    var savedAddresses = [AddressModel]()

    var tempAddress = AddressModel.init(json: JSON())
    var selectedAddress = AddressModel.init(json: JSON())
    
    var courialHub = AddressModel.init(json: JSON([
        "latitude" : 37.781688,
        "longitude" : -122.452855,
        "addressType" : "Courial Hub",
        "placeName" : "Courial Hub",
        "is_selected" : false,
        "notes" : "",
        "address" : "3145 Geary Blvd.",
        "fullAddress" : "3145 Geary Blvd., San Francisco, CA",
        "icon": "logo_main",
        "id": Int.random(in: 1...99999)
    ]))
    
    private override init() {
        super.init()
        self.setData()
        _ = LocationInterface.shared
    }
    
    
    func setData(){
        let currentAddress = AddressModel.init(json: JSON([
            "latitude" : LocationInterface.shared.lats,
            "longitude" : LocationInterface.shared.longs,
            "addressType" : "Use Current Location",
            "placeName" : "Use Current Location",
            "is_selected" : true,
            "notes" : "",
            "address" : "",
            "fullAddress" : "",
            "icon": "loco-pointer"
        ]))
        self.currentAddress = currentAddress
          
        self.resetHomeAdd()
        self.resetWorkAdd()
        
        _ = PickUpAddressInterface.shared
        
        self.fetchCurrentAddress { (_) in
        }
    }
    
    func resetHomeAdd(){
        let otherAddress = AddressModel.init(json: JSON([
            "Longs" : 0.0,
            "longitude" : 0.0,
            "addressType" : "Home",
            "placeName" : "Home",
            "is_selected" : false,
            "notes" : "",
            "address" : "Add home address",
            "fullAddress" : "Add home address",
            "icon" : "homei"
        ]))
        
        self.homeAddress = otherAddress
    }
    
    func resetWorkAdd(){
        let otherAddress = AddressModel.init(json: JSON([
            "Longs" : 0.0,
            "longitude" : 0.0,
            "addressType" : "Work",
            "placeName" : "Work",
            "is_selected" : false,
            "notes" : "",
            "address" : "Add work address",
            "fullAddress" : "Add work address",
            "icon" : "briefcase2"
        ]))
        self.workAddress = otherAddress
    }
    
    
    func fetchCurrentAddress(result: @escaping(String)-> Void){
        guard LocationInterface.shared.lats != 0.0 else {return}
        guard let cords = LocationInterface.shared.cords else {return}

        MapHelper.sharedInstance.reverseGeoCode(location: cords, success: { (address) in
            
            let line1 = address.lines?.first ?? ""
            let city = address.locality ?? ""
            let state = address.administrativeArea ?? ""
            var fullAdd = (address.thoroughfare ?? line1) + ", " + city + ", " + state
            
            if (address.thoroughfare ?? line1) == city || city == state || city ==  ""{
                fullAdd = (address.thoroughfare ?? line1) + ", " + state
            } else{
                fullAdd = (address.thoroughfare ?? line1) + ", " + city + ", " + state
            }
            
            self.currentAddress.address = address.thoroughfare ?? line1
            self.currentAddress.fullAddress = fullAdd
            self.currentAddress.latitude = LocationInterface.shared.lats
            self.currentAddress.longitude = LocationInterface.shared.longs
            
            PickUpAddressInterface.shared.currentAddress = self.currentAddress
            result(self.currentAddress.address ?? "")
        }) { (error) in
            print(error)
            result("")
        }
        
    }
    
    

    func insertSearchAdd(model: AddressModel, prediction: GMSAutocompletePrediction?){
        self.searchedAddresses.insert(model, at: 0)
        let addressLine1 = model.address ?? ""
        let addressFull = model.fullAddress ?? ""
        
        self.searchedAddresses[0].addressType = addressLine1
        self.searchedAddresses[0].address = addressLine1
        self.searchedAddresses[0].fullAddress = addressFull
        self.filterSeaches()
    }
    
    
    func filterSeaches(){
        self.searchedAddresses = Array(self.searchedAddresses.prefix(5))
    }
    
    
    func getDeliveryCords() -> CLLocationCoordinate2D{
        let lats = self.selectedAddress.latitude ?? 0.0
        let longs = self.selectedAddress.longitude ?? 0.0
        return .init(latitude: CLLocationDegrees(lats), longitude: CLLocationDegrees(longs))
    }
    
    func filterHomeWork(){
        if let homeModel = self.savedAddresses.filter({$0.addressType == "1"}).first{
            self.homeAddress = homeModel
        } else{
            self.resetHomeAdd()
        }
        if let workModel = self.savedAddresses.filter({$0.addressType == "2"}).first{
            self.workAddress = workModel
        } else{
            self.resetWorkAdd()
        }
        
        self.searchedAddresses = self.removeDuplicates(self.savedAddresses.filter({$0.addressType == "4"}))
        self.searchedAddresses.reverse()
        self.filterSeaches()
        
        self.savedAddresses = self.removeDuplicates(self.savedAddresses.filter({($0.addressType != "1") && ($0.addressType != "2") && ($0.addressType != "4")}))
    }
    
    func removeDuplicates(_ modelArr: [AddressModel]) -> [AddressModel] {
        var noDuplicates = [AddressModel]()
        var usedAddresses = [String]()
        for model in modelArr {
            if let address = model.fullAddress, !usedAddresses.contains(address) {
                noDuplicates.append(model)
                usedAddresses.append(address)
            }
        }
        return noDuplicates
    }
    
    func addressOptions(isDelivery: Bool, model : YelpStoreBusinesses?, type: Int)-> String{
        if isDelivery{
            var options = model?.dropAddress?.dropPickupoptions ?? ""
            if (model?.isSkillService) == true{
                options = self.convertOptions(value: options, toDel: false, isSkill: true)
            }else if model?.isReversedDel == true{
                options = self.convertOptions(value: options, toDel: false, isSkill: false)
            }else{
                options = self.convertOptions(value: options, toDel: true, isSkill: false)
            }
            
            switch options{
            case "Meet me Curbside","Leave package in Lobby","Meet me at my front door","Leave with Front Desk / Doorman","Curbside pickup","Drive thru pickup","Package left in Lobby","See Front Desk / Doorman","Meet me in Lobby","Meet me at Front Desk / Doorman","":
                
                if type != 1 {
                    return options
                }else{
                    return ""
                }
            default:
                var floors = model?.dropAddress?.elevatorFloor ?? ""
                
//                if JSON(floors).intValue == 0{
//                    floors = ""
//                }else if JSON(floors).intValue == 1{
//                    floors = floors + "st Fl "
//                }else if JSON(floors).intValue == 2{
//                    floors = floors + "nd Fl "
//                }else if JSON(floors).intValue == 3{
//                    floors = floors + "rd Fl "
//                } else{
//                    floors = floors + "th Fl "
//                }
                
                var floorType = model?.dropAddress?.elevator_walk_both ?? ""
                if floorType == "0"{
                    floorType = " Elevator"
                }else if floorType == "1"{
                    floorType = " Stairs"
                } else{
                    floors = ""
                    floorType = "1st Floor"
                }
                
                if type == 0{
                    return options
                }else if type == 1{
                    return (floors + floorType)
                } else{
                    return (floors + floorType) +  " • " + options
                }
                
            }
        } else{
            var options = model?.location?.pickOption ?? ""
            
            if (model?.isSkillService) == true{
                options = self.convertOptions(value: options, toDel: false, isSkill: true)
            }else if model?.isReversedDel == true{
                options = self.convertOptions(value: options, toDel: true, isSkill: false)
            }else{
                options = self.convertOptions(value: options, toDel: false, isSkill: false)
            }
            
            switch options{
            case "Meet me Curbside","Leave package in Lobby","Meet me at my front door","Leave with Front Desk / Doorman","Curbside pickup","Drive thru pickup","Package left in Lobby","See Front Desk / Doorman","Meet me in Lobby","Meet me at Front Desk / Doorman","":
                if type != 1 {
                    return options
                }else{
                    return ""
                }
            default:
                var floors = model?.location?.pickElevatorFloor ?? ""
                
//                if JSON(floors).intValue == 0{
//                    floors = ""
//                }else if JSON(floors).intValue == 1{
//                    floors = floors + "st Fl "
//                }else if JSON(floors).intValue == 2{
//                    floors = floors + "nd Fl "
//                }else if JSON(floors).intValue == 3{
//                    floors = floors + "rd Fl "
//                } else{
//                    floors = floors + "th Fl "
//                }
                
                var floorType = model?.location?.pick_elevator_walk_both ?? ""
                if floorType == "0"{
                    floorType = " Elevator"
                }else if floorType == "1"{
                    floorType = " Stairs"
                } else{
                    floors = ""
                    floorType = "1st Floor"
                }
                
//                let twoCourial =  (model?.two_courial ?? false) ? " • 2 Courial's" : ""
                if type == 0{
                    return options
                }else if type == 1{
                    return (floors + floorType)
                } else{
                    return (floors + floorType) +  " • " + options
                }
            }
        }
    }
    
    func addressOptions(isDelivery: Bool, model : CurrentOrderModel?, type: Int)-> String{
        if isDelivery{
            var options = model?.deliveryInfo?.options ?? ""
            if JSON(model?.isSkill ?? "0").boolValue == true{
                options = self.convertOptions(value: options, toDel: true, isSkill: true)
            }else{
                options = self.convertOptions(value: options, toDel: true, isSkill: false)
            }
            
            
            switch options{
            case "Meet me Curbside","Leave package in Lobby","Meet me at my front door","Leave with Front Desk / Doorman","Curbside pickup","Drive thru pickup","Package left in Lobby","See Front Desk / Doorman","Meet me in Lobby","Meet me at Front Desk / Doorman","":
                if type != 1 {
                    return options
                }else{
                    return ""
                }
            default:
                var floors = model?.deliveryInfo?.floors ?? ""
                
//                if JSON(floors).intValue == 0{
//                    floors = ""
//                }else if JSON(floors).intValue == 1{
//                    floors = floors + "st Fl "
//                }else if JSON(floors).intValue == 2{
//                    floors = floors + "nd Fl "
//                }else if JSON(floors).intValue == 3{
//                    floors = floors + "rd Fl "
//                } else{
//                    floors = floors + "th Fl "
//                }
                
                var floorType = model?.deliveryInfo?.pickElevatorWalkBoth ?? ""
                if floorType == "0"{
                    floorType = " Elevator"
                }else if floorType == "1"{
                    floorType = " Stairs"
                } else{
                    floors = ""
                    floorType = "1st Floor"
                }
                
                if type == 0{
                    return options
                }else if type == 1{
                    return (floors + floorType)
                } else{
                    return (floors + floorType) +  " • " + options
                }
            }
        } else{
            var options = model?.pickupInfo?.options ?? ""
            if JSON(model?.isSkill ?? "0").boolValue == true{
                options = self.convertOptions(value: options, toDel: false, isSkill: true)
            }else{
                options = self.convertOptions(value: options, toDel: false, isSkill: false)
            }
            
            
            switch options{
            case "Meet me Curbside","Leave package in Lobby","Meet me at my front door","Leave with Front Desk / Doorman","Curbside pickup","Drive thru pickup","Package left in Lobby","See Front Desk / Doorman","Meet me in Lobby","Meet me at Front Desk / Doorman","":
                if type != 1 {
                    return options
                }else{
                    return ""
                }
            default:
                var floors = model?.pickupInfo?.floors ?? ""
                
//                if JSON(floors).intValue == 0{
//                    floors = ""
//                }else if JSON(floors).intValue == 1{
//                    floors = floors + "st Fl "
//                }else if JSON(floors).intValue == 2{
//                    floors = floors + "nd Fl "
//                }else if JSON(floors).intValue == 3{
//                    floors = floors + "rd Fl "
//                } else{
//                    floors = floors + "th Fl "
//                }
                
                var floorType = model?.pickupInfo?.pickElevatorWalkBoth ?? ""
                if floorType == "0"{
                    floorType = " Elevator"
                }else if floorType == "1"{
                    floorType = " Stairs"
                } else{
                    floors = ""
                    floorType = "1st Floor"
                }
                
//                let twoCourial =  JSON(model?.twoCourials ?? "0").boolValue ? " • 2 Courial's" : ""
                if type == 0{
                    return options
                }else if type == 1{
                    return (floors + floorType)
                } else{
                    return (floors + floorType) +  " • " + options
                }
            }
        }
    }
    
    func convertOptions(value: String, toDel: Bool, isSkill: Bool)->String{
        if isSkill{
            switch value{
            case "Leave package at my front door":
                return "Meet me at my front door"
                
            case "Leave package in Lobby","Package left in Lobby":
                return "Meet me in Lobby"
                
            case "Leave with Front Desk / Doorman","See Front Desk / Doorman":
                return "Meet me at Front Desk / Doorman"
                
            case "Curbside pickup", "Drive thru pickup":
                return "Meet me Curbside"
        
                
            case "Pickup from contact at Suite/Apt":
                return "Meet me at my Suite/Apt"
            
            case "Package left at my front door":
                return "Meet me outside Suite/Apt"
                
            default:
                return value
            }
        }else if toDel{
            switch value{
            case "Curbside pickup", "Drive thru pickup":
                return "Meet me Curbside"
            case "Package left in Lobby":
                return "Leave package in Lobby"
            case "See Front Desk / Doorman":
                return "Leave with Front Desk / Doorman"
            default:
                return value
            }
        }else{
            switch value{
            case "Meet me Curbside":
                return "Curbside pickup"
            case "Leave package in Lobby":
                return "Package left in Lobby"
            case "Leave with Front Desk / Doorman":
                return "See Front Desk / Doorman"
            default:
                return value
            }
        }
    }
    
}
