//
//  BuiltinExtension.swift
//  Browser App
//
//  Created by Gaurav Gupta on 2/8/17.
//  .
//

import UIKit
import WebKit

protocol UserScriptHandler {
    var scriptMessageHandler: ScriptHandler { get }
}

class BuiltinExtension: NSObject {
    @objc var extensionName: String {
        return "UNNAMED"
    }
    
    @objc var scriptHandlerName: String?
    
    @objc var webContainer: WebContainer?
    @objc var webScript: WKUserScript?
    
    @objc init(container: WebContainer) {
        super.init()
        
        webContainer = container
    }
}
