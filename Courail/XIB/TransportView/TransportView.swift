//
//  TransportView.swift
//  Courail
//
//  Created by apple on 02/03/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class TransportView: UIView {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var transportIcon: UIImageView!
    @IBOutlet weak var transportDetails: UILabel!
    
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var over45Switch: UIButton!
    @IBOutlet weak var twoCourialSwitch: UIButton!
    
    
    //MARK: VARIABLES
    
    var currentVehicle = "Car"
    var isSkill = false
    var category = ""
    var completion : ((_ vehicle: String?, _ over45: Bool, _ twoCourial: Bool)->Void)?
    var selectedIndex = 0
    
    var isOver45 =  false
    var isTwoCourial = false
    
    
    var transportImg =                [#imageLiteral(resourceName: "imgWalking"),#imageLiteral(resourceName: "imgBike"),#imageLiteral(resourceName: "imgE-scooter"),#imageLiteral(resourceName: "imgMoped"),#imageLiteral(resourceName: "imgMotorcycle"),#imageLiteral(resourceName: "imgCar"),#imageLiteral(resourceName: "imgPickup"),#imageLiteral(resourceName: "imgVan"),#imageLiteral(resourceName: "imgTruck") ]
    var transportSize  : [CGFloat] =  [35,50,40,50,50,65,65,60,55]
    let vehicleTypes = ["Walker","Bicycle","E-Scooter","Moped","Motorcycle","Car","Pickup","Van","Truck"]
    var transportDescArr =  [
        "Ideal for light weight items on trips under 1 mile\nBest for rush hour.",
        "Ideal for light weight items on trips under five miles.",
        "Ideal for light weight items on trips under five miles.",
        "Ideal for medium sized-light weight items on trips under a five miles.",
        "Ideal for medium sized items.",
        "Ideal for anything that can easily fit in a sedan.",
        "Ideal for large items that can easily fit in bed usually\n4 x 6 feet (If you do not select two Courials,\nyou agree to help move this item)",
        "Ideal for large items that fit in a van usually\n5 x 8 feet requiring two Courials.",
        "Ideal for several large items requiring two Courials."
    ]
    
    var transportImgSkill =                [#imageLiteral(resourceName: "imgWalking"),#imageLiteral(resourceName: "imgBike"),#imageLiteral(resourceName: "imgE-scooter"),#imageLiteral(resourceName: "imgMoped"),#imageLiteral(resourceName: "imgMotorcycle"),#imageLiteral(resourceName: "imgCar"),#imageLiteral(resourceName: "imgPickup"),#imageLiteral(resourceName: "imgVan"),#imageLiteral(resourceName: "imgTruck") ,#imageLiteral(resourceName: "imgTowTruck")]
    var transportSizeSkill  : [CGFloat] =  [35,50,40,50,50,65,65,60,55,55]
    var skillVehicleTypesSkill = ["Walker","Bicycle","E-Scooter","Moped","Motorcycle","Car","Pickup","Van","Truck","Tow Truck"]

    var transportDescArrSkill =  [
        "Best for nearby services during rush hour.",
        "Best for services under 2 miles away.",
        "Best for light weight items on trips under five miles.",
        "Best for medium sized-light weight items on trips under a five miles.",
        "Best for services during rush hour.",
        "Best for services where lots of equipment is needed.",
        "Best for large items that can easily fit in bed usually\n4 x 6 feet (If you do not select two Courials,\nyou agree to help move this item)",
        "Best for large items that fit in a van usually\n5 x 8 feet requiring two Courials.",
        "Best for several large items requiring two Courials.",
        "Use this option only for towing services."
    ]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect,vehicle: String, isSkill: Bool, category: String, over45: Bool, twoCourial: Bool, completion: @escaping ((_ vehicle: String?,_ over45: Bool,_ twoCourial: Bool)-> ())) {
        super.init(frame: frame)
        self.completion = completion
        self.setup(vehicle: vehicle, isSkill: isSkill, category: category, over45: over45 , twoCourial: twoCourial)
    }
    
    
    func setup(vehicle: String, isSkill: Bool, category: String, over45: Bool , twoCourial: Bool){
        self.bgView = Bundle.main.loadNibNamed("TransportView", owner: self, options: nil)?.first as? UIView
        self.bgView.frame = self.bounds
        self.addSubview(self.bgView)
        
        self.collectionView.register(UINib.init(nibName: "TransportCVC", bundle: nil), forCellWithReuseIdentifier: "SpecialDeliveryCVC")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.currentVehicle = vehicle
        self.isSkill = isSkill
        self.category = category
        
        self.selectedIndex = self.vehicleTypes.firstIndex(where: {$0 == self.currentVehicle}) ?? 0
        if self.isSkill{
            self.selectedIndex = self.skillVehicleTypesSkill.firstIndex(where: {$0 == self.currentVehicle}) ?? 0
            self.weightView.isHidden = true
        }
        self.collectionView.reloadData()
        self.collectionView(self.collectionView, didSelectItemAt: IndexPath.init(item: self.selectedIndex, section: 0))
        
        self.isOver45 = over45
        self.isTwoCourial = twoCourial
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath.init(item: self.selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
        
        guard self.isSkill == false else {
            self.weightView.isHidden = true
            return
        }
        
        if self.isOver45{
            self.over45Switch.setImage(UIImage(named: "toggle_on"), for: .normal)
        } else{
            self.over45Switch.setImage(UIImage(named: "toggleNew"), for: .normal)
        }
        
        if self.isTwoCourial{
            self.twoCourialSwitch.setImage(UIImage(named: "toggle_on"), for: .normal)
        } else{
            self.twoCourialSwitch.setImage(UIImage(named: "toggleNew"), for: .normal)
        }
    }
    
    
    
    //MARK: BUTTONS ACTIONS
    
    @IBAction func continueBtn(_ sender: UIButton) {
        guard let completion = self.completion else{
            self.removeFromSuperview()
            return
        }
        completion(self.currentVehicle, self.isOver45 , self.isTwoCourial)
        self.removeFromSuperview()
    }
    
    @IBAction func closeBtn(_ sender: UIButton){
        guard let completion = self.completion else{
            self.removeFromSuperview()
            return
        }
        completion("",false,false)
        self.removeFromSuperview()
    }
    
    @IBAction func over45Btn(_ sender: UIButton) {
        guard !(0...4 ~= self.selectedIndex) else{
            return
        }
        
        if self.selectedIndex != 6 && self.selectedIndex != 7 && self.selectedIndex != 8{
            if self.isOver45{
                self.over45Switch.setImage(UIImage(named: "toggleNew"), for: .normal)
                self.isOver45 = false
            } else{
                self.over45Switch.setImage(UIImage(named: "toggle_on"), for: .normal)
                self.isOver45 = true
            }
            
            let indexPath = IndexPath(item: self.selectedIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func twoCourialBtn(_ sender: UIButton) {
        guard 6...8 ~= self.selectedIndex else{
            return
        }
        
        if self.isTwoCourial{
            self.isTwoCourial = false
            self.twoCourialSwitch.setImage(UIImage(named: "toggleNew"), for: .normal)
        } else{
            self.isTwoCourial = true
            self.twoCourialSwitch.setImage(UIImage(named: "toggle_on"), for: .normal)
        }
    }
    
}

extension TransportView : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isSkill{
            return transportImgSkill.count
        }else{
            return transportImg.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialDeliveryCVC", for: indexPath) as! SpecialDeliveryCVC
        
        if self.isSkill{
            cell.TypeImgView.image = transportImgSkill[indexPath.item].withRenderingMode(.alwaysOriginal)
        }else{
            cell.TypeImgView.image = transportImg[indexPath.item].withRenderingMode(.alwaysOriginal)
        }

        cell.TypeImgView.alpha = (self.selectedIndex == indexPath.item) ? 1 : 0.3
        
        switch indexPath.row{
        case 0:
            cell.centerConstraint.constant = 0.2
        case 1:
            cell.centerConstraint.constant = 2
        case 2:
            cell.centerConstraint.constant = -0.3
        case 3:
            cell.centerConstraint.constant = 2.2
        case 4:
            cell.centerConstraint.constant = 2.8
        case 5:
            cell.centerConstraint.constant = 4.5
        case 6:
            cell.centerConstraint.constant = 3.5
        case 7:
            cell.centerConstraint.constant = 4.5
        case 8,9:
            cell.centerConstraint.constant = 2.5
        default:
            cell.centerConstraint.constant = 0
        }
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.category.lowercased() == "take out" && 6...8 ~= indexPath.item {
            return CGSize(width: 0 , height: 0)
        } else{
            if self.isSkill{
                let width = self.transportSizeSkill[indexPath.item]
                return CGSize(width: width , height: 50)
            }else{
                let width = self.transportSize[indexPath.item]
                return CGSize(width: width , height: 50)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.item
        
        if self.isSkill{
            self.currentVehicle = self.skillVehicleTypesSkill[indexPath.item]
            self.transportIcon.image = transportImgSkill[indexPath.item]
            self.transportDetails.text = transportDescArrSkill[indexPath.item]
        }else{
            self.currentVehicle = self.vehicleTypes[indexPath.item]
            self.transportIcon.image = transportImg[indexPath.item]
            self.transportDetails.text = transportDescArr[indexPath.item]
        }
        
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        guard self.isSkill == false else {return}
        if indexPath.item < 5{
            self.weightView.isHidden = true
        }else{
            self.weightView.isHidden = false
        }
        
        if  indexPath.item == 5 && (self.category != "Take Out"){
            self.isTwoCourial = false
            self.twoCourialSwitch.setImage(UIImage(named: "toggleNew"), for: .normal)
            
            self.isOver45 = false
            self.over45Switch.setImage(UIImage(named: "toggleNew"), for: .normal)
        } else if  6...8 ~= indexPath.item && (self.category != "Take Out"){
            self.isTwoCourial = true
            self.twoCourialSwitch.setImage(UIImage(named: "toggle_on"), for: .normal)
            
            self.isOver45 = true
            self.over45Switch.setImage(UIImage(named: "toggle_on"), for: .normal)
        } else{
            self.isTwoCourial = false
            self.twoCourialSwitch.setImage(UIImage(named: "toggleNew"), for: .normal)
            
            self.isOver45 = false
            self.over45Switch.setImage(UIImage(named: "toggleNew"), for: .normal)
        }
    }
    
    
}
