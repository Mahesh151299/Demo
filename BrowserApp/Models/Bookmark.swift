//
//  Bookmark.swift
//  Browser App
//
//  Created by Gaurav Gupta on 10/3/21. on 2/6/17.
//  .
//

import Foundation
import RealmSwift

class Bookmark: Object {
	@objc dynamic var id = ""
    @objc dynamic var name = ""
	@objc dynamic var pageURL = ""
	@objc dynamic var iconURL = ""
	
	override static func indexedProperties() -> [String] {
		return ["name"]
	}
	
	override static func primaryKey() -> String? {
		return "id"
	}
}
