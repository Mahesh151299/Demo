//
//  DateExtensions.swift
//  InstaDate
//
//  Created by apple on 13/03/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

extension Date {
    
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
    
    func minutesBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.minute], from: self, to: toDate)
        return components.minute ?? 0
    }
    
    func secondsBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.second], from: self, to: toDate)
        return components.second ?? 0
    }
    
    func dayNumberOfWeek() -> Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday ?? 0
    }
    
    func timeBetweenDates() -> String{
        let timeinterval = self.timeIntervalSinceNow
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour,.minute]
        return formatter.string(from: timeinterval) ?? ""
    }
    
    
    func convertToFormat(_ format: String,  timeZone: TimeZone) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    
    func convertToDate(_ timeZone: TimeZone)-> Date?{
        let dateFormatter = DateFormatter()
        let dateStr = dateFormatter.string(from: self)
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: dateStr)
    }
    
    func convertTimeZone(inputTimeZone: TimeZone , outputTimeZone: TimeZone )-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = inputTimeZone
        let dateStr = dateFormatter.string(from: self)
        dateFormatter.timeZone = outputTimeZone
        return dateFormatter.date(from: dateStr)
    }
    
}
