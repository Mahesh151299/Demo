//
//  BusinessDetailsOpen.swift
//
//  Created by Omeesh Sharma on 06/04/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BusinessDetailsOpen {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBusinessDetailsOpenEndKey: String = "end"
  private let kBusinessDetailsOpenIsOvernightKey: String = "is_overnight"
  private let kBusinessDetailsOpenStartKey: String = "start"
  private let kBusinessDetailsOpenDayKey: String = "day"

  // MARK: Properties
  public var end: String?
  public var isOvernight: Bool = false
  public var start: String?
  public var day: Int?

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
    end = json[kBusinessDetailsOpenEndKey].string
    isOvernight = json[kBusinessDetailsOpenIsOvernightKey].boolValue
    start = json[kBusinessDetailsOpenStartKey].string
    day = json[kBusinessDetailsOpenDayKey].int
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = end { dictionary[kBusinessDetailsOpenEndKey] = value }
    dictionary[kBusinessDetailsOpenIsOvernightKey] = isOvernight
    if let value = start { dictionary[kBusinessDetailsOpenStartKey] = value }
    if let value = day { dictionary[kBusinessDetailsOpenDayKey] = value }
    return dictionary
  }

}
