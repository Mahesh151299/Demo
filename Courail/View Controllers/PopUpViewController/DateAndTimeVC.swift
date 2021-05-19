//
//  DateAndTimeVC.swift
//  Courail
//
//  Created by mac on 13/02/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class DateAndTimeVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var myDatePicker: UIDatePicker!
    
    //MARK: VARIABLES
    
    var stringKey = ""
    var businessDetail : YelpStoreBusinesses?
        
    var completion : ((YelpStoreBusinesses?)->Void)?
    var canceled : (()->Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.4, *) {
            myDatePicker.preferredDatePickerStyle = .wheels
            myDatePicker.setValue(false, forKey: "highlightsToday")
        }
        
        myDatePicker.setValue(appColorBlue, forKeyPath: "textColor")
        if stringKey == "4" {
            myDatePicker.datePickerMode = .dateAndTime
            let minDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date()) ?? Date()
            let bufferDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
            myDatePicker.minimumDate = minDate
            
            if let prevDate = self.businessDetail?.pickUpTime?.convertToDate(), prevDate >= minDate{
                self.myDatePicker.setDate(prevDate, animated: false)
            } else{
                self.myDatePicker.setDate(bufferDate, animated: false)
            }
        } else {
            myDatePicker.datePickerMode = .dateAndTime
            let deliveryTime = JSON(self.businessDetail?.estimatedDeliveryTime ?? "0").intValue + 10
            let selectedPickUpDate = self.businessDetail?.pickUpTime?.convertToDate() ?? Date()
            let minDate = Calendar.current.date(byAdding: .minute, value: deliveryTime, to: selectedPickUpDate) ?? Date()
            myDatePicker.minimumDate = minDate
            
            if let prevDate = self.businessDetail?.deliveryTime?.convertToDate(){
                self.myDatePicker.setDate(prevDate, animated: false)
            } else{
                self.myDatePicker.setDate(minDate, animated: false)
            }
        }
    }
    
    @IBAction func continueBtnAction(_ sender: Any) {
        let finalDate = self.myDatePicker.date.convertToFormat("dd/MM/yyyy hh:mm':00' a", timeZone: .current).convertToDate(format: "dd/MM/yyyy hh:mm:ss a", timeZone: .current) ?? self.myDatePicker.date
        
        if stringKey == "4" {
            self.businessDetail?.pickUpTime = "\(finalDate.timeIntervalSince1970)"
            self.businessDetail?.deliveryTime = nil
        } else{
            self.businessDetail?.deliveryTime = "\(finalDate.timeIntervalSince1970)"
        }
        
        guard let result = self.completion else{
            self.removeFromParent()
            self.view.removeFromSuperview()
            return
        }
        
        result(self.businessDetail)
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
    @IBAction func shutDownPicker(_ sender: Any) {
        guard let result = self.canceled else{
            self.removeFromParent()
            self.view.removeFromSuperview()
            return
        }
        result()
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
    @objc func dateChanged(_ sender: UIDatePicker){
//        self.dateLbl.text = sender.date.convertToFormat("EEE, MMM dd", timeZone: .current)
//        self.timeLbl.text = sender.date.convertToFormat("hh:mm a", timeZone: .current)
    }
    
}

