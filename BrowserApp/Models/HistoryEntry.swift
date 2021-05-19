//
//  HistoryEntry.swift
//  Browser App
//
//  Created by Gaurav Gupta on 10/3/21. on 2/5/17.
//  .
//

import Foundation
import RealmSwift

class HistoryEntry: Object {
	@objc dynamic var id = ""
	@objc dynamic var pageURL = ""
	@objc dynamic var pageTitle = ""
	@objc dynamic var visitDate = Date(timeIntervalSince1970: 1)
    @objc dynamic var iconURL = ""
	
	override class func primaryKey() -> String? {
		return "id"
	}
}
