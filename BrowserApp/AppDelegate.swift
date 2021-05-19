//
//  AppDelegate.swift
//  BrowserApp
//
//  Created by Gaurav on 13/03/21.
//

import UIKit
import Then
import SnapKit
import RealmSwift
import SwiftKeychainWrapper
import SDWebImage
import WebKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //WKWebView.clean()
        // Override point for customization after application launch.
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: SettingsKeys.firstRun) {
            defaults.set(true, forKey: SettingsKeys.firstRun)
            defaults.set(true, forKey: SettingsKeys.blockCookies)
            performFirstRunTasks()
        }
        if defaults.string(forKey: SettingsKeys.searchEngineUrl) == nil {
            defaults.set("https://bing.com/search?q=", forKey: SettingsKeys.searchEngineUrl)
        }
        if let defaultWeb =  defaults.string(forKey: SettingsKeys.defaultPageUrl){
           defaultWebPage  = defaultWeb
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func performFirstRunTasks() {
        UserDefaults.standard.set(true, forKey: SettingsKeys.trackHistory)
    }

}

