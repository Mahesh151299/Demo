//
//  BrowsingSession.swift
//  Browser App
//
//  Created by Gaurav Gupta on 10/3/21. on 2/5/17.
//  .
//

import Foundation
import RealmSwift

class URLModel: Object {
	@objc dynamic var urlString = ""
	@objc dynamic var pageTitle = ""
}

class BrowsingSession: Object {
	let tabs = List<URLModel>()
	@objc dynamic var selectedTabIndex = 0
}
