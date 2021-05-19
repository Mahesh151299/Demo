//
//  RatingInterface.swift//
//  Created by Codeyeti iOS on 10/01/18.
//  Copyright © 2018 Relinns. All rights reserved.
//

import UIKit
import StoreKit


class RatingInterface: NSObject {
    
    init(appID: String) {
        super.init()
        self.rateApp(appId: appID)
    }
    
    fileprivate func rateApp(appId: String) {
        let url = "itms-apps://itunes.apple.com/app/id" + appId
        openUrl(url)
    }
    
    fileprivate func openUrl(_ urlString:String) {
        if #available( iOS 10.3,*){
            SKStoreReviewController.requestReview()
        }else{
            guard let url = URL(string: urlString) else{
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
}
