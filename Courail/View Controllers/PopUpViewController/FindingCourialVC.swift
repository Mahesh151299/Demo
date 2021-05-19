//
//  FindingCourialVC.swift
//  Courail
//
//  Created by mac on 14/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class FindingCourialVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var pickUpTitle: UILabel!
    @IBOutlet weak var pickUpAddress1: UILabel!
    @IBOutlet weak var pickUpAddress2: UILabel!
    @IBOutlet weak var pickUpOptions: UILabel!
    @IBOutlet weak var pickUpNotes: UILabel!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var dropTitle: UILabel!
    @IBOutlet weak var dropAddress1: UILabel!
    @IBOutlet weak var dropAddress2: UILabel!
    @IBOutlet weak var dropOptions: UILabel!
    @IBOutlet weak var dropNotes: UILabel!
    
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var pickStack: UIStackView!
    @IBOutlet weak var itemNameView: UIView!
    @IBOutlet weak var delStack: UIStackView!
    
    //MARK:- VARIABLES
    
    var isSpinning: Bool = false
    
    var action : (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isSpinning = true
        self.spin(options: UIView.AnimationOptions.curveEaseIn)
        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- BUTTONS ACTIONS
    
    //    @IBAction func dismissView(_ sender: UIButton) {
    //        self.dismiss(animated: false, completion: nil)
    //    }
    
    func loadData(){
        self.itemName.text = currentOrder?.itemName?.uppercased()
        
        self.pickUpTitle.text = currentOrder?.pickupInfo?.placeName ?? ""
        self.pickUpNotes.text = currentOrder?.pickupInfo?.notes ?? ""
        
        let options1 = DeliveryAddressInterface.shared.addressOptions(isDelivery: false, model: currentOrder, type: 2)
        self.pickUpOptions.text = options1
        
        let address = currentOrder?.pickupInfo
        let pickaAptInfo = address?.aptInfo ?? ""
        if pickaAptInfo != ""{
            self.pickUpAddress1.text = (address?.address1 ?? "") + " • " + pickaAptInfo
        } else{
            self.pickUpAddress1.text = (address?.address1 ?? "")
        }
        self.pickUpAddress2.text = (address?.address2 ?? "")        
        
//        let firstName = userInfo.firstName ?? "You"
//        let lastName = userInfo.lastName ?? ""
//        self.dropTitle.text = (firstName + " " + lastName)
        self.dropTitle.text = currentOrder?.deliveryInfo?.placeName ?? ""
        
        self.dropNotes.text = currentOrder?.deliveryInfo?.notes ?? ""
        let options2 = DeliveryAddressInterface.shared.addressOptions(isDelivery: true, model: currentOrder, type: 2)
        self.dropOptions.text = options2
        
        let dropAptInfo = currentOrder?.deliveryInfo?.aptInfo ?? ""
        if dropAptInfo != ""{
            self.dropAddress1.text = (currentOrder?.deliveryInfo?.address1 ?? "") + " • " + dropAptInfo
        } else{
            self.dropAddress1.text = (currentOrder?.deliveryInfo?.address1 ?? "")
        }
        self.dropAddress2.text = (currentOrder?.deliveryInfo?.address2 ?? "")
        
        if JSON(currentOrder?.isSkill ?? "0").boolValue == true{
            self.pickUpOptions.isHidden = true
            self.pickUpTitle.isHidden = true
            self.pickUpOptions.isHidden = true
            self.pickUpAddress2.isHidden = true
            self.pickUpNotes.isHidden = true
            
            let time = currentOrder?.estimatedServiceTime ?? ""
            let vehicle = "By " + (currentOrder?.trasnportMode ?? "")
            self.pickUpAddress1.text = (time + " min Service • " + vehicle)
            
            mainStack.insertArrangedSubview(self.delStack, at: 0)
            mainStack.insertArrangedSubview(self.itemNameView, at: 1)
            mainStack.insertArrangedSubview(self.pickStack, at: 2)
            
            mainStack.setNeedsLayout()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.dismiss(animated: false) {
                guard let completion = self.action else{return}
                completion()
            }
        }
    }
        
    func spin(options: UIView.AnimationOptions) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: options, animations: { [weak logo] in
            if let iconView = logo {
                iconView.transform = iconView.transform.rotated(by: CGFloat(Double.pi/2))
            }
        }) { [weak self] finished in
            guard let strongSelf = self else { return }
            
            if finished {
                if strongSelf.isSpinning {
                    strongSelf.spin(options: UIView.AnimationOptions.curveLinear)
                } else if options != UIView.AnimationOptions.curveEaseOut {
                    strongSelf.spin(options: UIView.AnimationOptions.curveEaseOut)
                }
            }
        }
    }
    
}
