//
//  WKWebViewExtensions.swift
//  Browser App
//
//  Created by Gaurav Gupta on 10/3/21. on 11/7/17.
//  .
//

import Foundation
import WebKit

extension UIView {
    func screenshot() -> UIImage? {
        let rect = bounds

            UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)

            guard let context = UIGraphicsGetCurrentContext() else {
             // assertionFailure()
              return nil
            }

            layer.render(in: context)

            guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
             // assertionFailure()
              return nil
            }

            UIGraphicsEndImageContext()

            return image
        
//        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
//        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
//        let img = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return img
    }
}
extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
extension WKWebView {
    class func clean() {
        guard #available(iOS 9.0, *) else {return}

        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                #if DEBUG
                    print("WKWebsiteDataStore record deleted:", record)
                #endif
            }
        }
    }
}
