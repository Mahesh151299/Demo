//
//  UpdateAvailable.swift
//  Courail
//
//  Created by Omeesh Sharma on 22/01/21.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class UpdateAvailable: NSObject {
    
    class func isUpdateAvailable() {
        let info = Bundle.main.infoDictionary
        
        let appName = info?["CFBundleName"] as? String ?? "App"
        let currentVersion = info?["CFBundleShortVersionString"] as? String ?? "0"
        
        guard let identifier = info?["CFBundleIdentifier"] as? String else {return}
        guard let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {return}
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            
            
            guard ((response.result.value) != nil) else{
                print(response.result.error?.localizedDescription ?? "Error")
                return
            }
            
            let json = JSON(response.result.value!)
            
            guard (json["resultCount"].intValue) != 0 else {
                //self.showalertview(json["msg"].stringValue)
                print("No data available")
                return
            }
            
            let newVersion = json["results"].arrayValue.map({$0["version"] .stringValue})[0]
            
            if currentVersion < newVersion{
                // creating the alert
                let alert = UIAlertController(title: "Update Available", message: "A new version of \(appName) is available. Please update to version \(newVersion) now.", preferredStyle: .alert)
                
                //adding action
                alert.addAction(UIAlertAction(title: "Update", style: .default, handler: {
                    action in
                    
                    guard let appURL = URL(string: appStoreLinkUser) else {return}
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appURL)
                    } else {
                        UIApplication.shared.openURL(appURL)
                    }
                    
                }))
                
                //showing alert
                UIApplication.shared.keyWindow?.makeKeyAndVisible()
                UIApplication.shared.keyWindow?.rootViewController?.present(alert,animated: true, completion: nil)
            }
            
        }
        
    }
    
}
