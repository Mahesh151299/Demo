//
//  BusinessDetailsSpecialHours.swift
//
//  Created by Omeesh Sharma on 06/04/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BusinessDetailsSpecialHours {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBusinessDetailsSpecialHoursDateKey: String = "date"
  private let kBusinessDetailsSpecialHoursEndKey: String = "end"
  private let kBusinessDetailsSpecialHoursIsOvernightKey: String = "is_overnight"
  private let kBusinessDetailsSpecialHoursStartKey: String = "start"

  // MARK: Properties
  public var date: String?
  public var end: String?
  public var isOvernight: Bool = false
  public var start: String?

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    date = json[kBusinessDetailsSpecialHoursDateKey].string
    end = json[kBusinessDetailsSpecialHoursEndKey].string
    isOvernight = json[kBusinessDetailsSpecialHoursIsOvernightKey].boolValue
    start = json[kBusinessDetailsSpecialHoursStartKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = date { dictionary[kBusinessDetailsSpecialHoursDateKey] = value }
    if let value = end { dictionary[kBusinessDetailsSpecialHoursEndKey] = value }
    dictionary[kBusinessDetailsSpecialHoursIsOvernightKey] = isOvernight
    if let value = start { dictionary[kBusinessDetailsSpecialHoursStartKey] = value }
    return dictionary
  }

}
