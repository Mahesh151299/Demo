//
//  SharedConfig.swift
//  Browser App
//
//  Created by Gaurav Gupta on 1/31/17.
//  .
//

import Foundation
import UIKit
import BSColorUtils

struct Colors {
    static let whiteBg = UIColor.white//UIColor.with(hex: "#EFEFEF")
    static let unselected = UIColor.with(hex: "#C8C8C8")
    static let urlGreen = UIColor.with(hex: "#046D23")
    static let darkBg = UIColor.darkGray//UIColor.with(hex: "#EFEFEF")
}

struct SettingsKeys {
    static let firstRun = "firstRun"
    static let trackHistory = "trackHistory"
    static let searchEngineUrl = "searchEngineUrl"
    static let defaultPageUrl = "defaultPageUrl"
    static let blockCookies = "blockCookies"
}



let isiPadUI = UI_USER_INTERFACE_IDIOM() == .pad
let isiPhone5 = UIScreen.main.bounds.height == 568

func logRealmError(error: Error) {
	print("## Realm Error: \(error.localizedDescription)")
}

func delay(_ delay: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
