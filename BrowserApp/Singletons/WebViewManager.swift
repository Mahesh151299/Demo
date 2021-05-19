//
//  WebViewManager.swift
//  Browser App
//
//  Created by Gaurav Gupta.
//  .
//

import UIKit
import RealmSwift
import WebKit

typealias ScriptHandler = (WKUserContentController, WKScriptMessage) -> ()

class WebViewManager: NSObject {
	@objc static let shared = WebViewManager()
	@objc static let sharedProcessPool = WKProcessPool()
    var isPrivteEnable=false
	
	@objc func logPageVisit(url: String?, pageTitle: String?) {
        if let urlString = url, let urlObj = URL(string: urlString), urlObj.host == "localhost" {
            // We don't want to log any pages we serve ourselves
            return
        }
        
        // Check if we should be logging page visits
        if !UserDefaults.standard.bool(forKey: SettingsKeys.trackHistory) {
            return
        }
        if url == defaultWebPage
        {
            return
        }
      
        
		let entry = HistoryEntry()
		entry.id = UUID().uuidString
		entry.pageURL = url ?? ""
		entry.pageTitle = pageTitle ?? ""
		entry.visitDate = Date()
        if let pageUrl = URL(string: url ?? "")
        {
        guard let url = url else { return }
        guard let scheme = pageUrl.scheme else { return }
        guard let host = pageUrl.host else { return }

        let faviconURL = scheme + "://" + host + "/favicon.ico"
            entry.iconURL = faviconURL
        }
        else
        {
            entry.iconURL = ""
        }
		
		do {
			let realm = try Realm()
			try realm.write {
				realm.add(entry)
			}
		} catch let error {
			logRealmError(error: error)
		}
	}
	
    @objc func getColoredURL(url: URL?) -> NSAttributedString {
		guard let url = url else { return NSAttributedString(string: "") }
        guard let _ = url.host else { return NSAttributedString(string: "") }
		let urlString = url.absoluteString as NSString
		
		let mutableAttributedString = NSMutableAttributedString(string: urlString as String,
                                                                attributes: [.foregroundColor: UIColor.gray])
		if url.scheme == "https" {
			let range = urlString.range(of: url.scheme!)
            mutableAttributedString.addAttribute(.foregroundColor, value: isPrivteEnable ? .white : Colors.urlGreen, range: range)
		}
        
		let domainRange = urlString.range(of: url.host!)
        mutableAttributedString.addAttribute(.foregroundColor, value: isPrivteEnable ? .white : UIColor.black, range: domainRange)
		
		return mutableAttributedString
	}
    
    @objc func loadBuiltinExtensions(webContainer: WebContainer) -> [BuiltinExtension] {
        let faviconGetter = FaviconGetter(container: webContainer)

        return [faviconGetter]
        //return []
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKey(_ input: String) -> NSAttributedString.Key {
	return NSAttributedString.Key(rawValue: input)
}
