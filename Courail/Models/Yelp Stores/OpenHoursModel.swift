//
//  OpenHoursModel.swift
//
//  Created by Omeesh Sharma on 21/07/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct OpenHoursModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kOpenHoursModelEndKey: String = "end"
  private let kOpenHoursModelIsOvernightKey: String = "is_overnight"
  private let kOpenHoursModelStartKey: String = "start"
  private let kOpenHoursModelDayKey: String = "day"

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
    end = json[kOpenHoursModelEndKey].string
    isOvernight = json[kOpenHoursModelIsOvernightKey].boolValue
    start = json[kOpenHoursModelStartKey].string
    day = json[kOpenHoursModelDayKey].int
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = end { dictionary[kOpenHoursModelEndKey] = value }
    dictionary[kOpenHoursModelIsOvernightKey] = isOvernight
    if let value = start { dictionary[kOpenHoursModelStartKey] = value }
    if let value = day { dictionary[kOpenHoursModelDayKey] = value }
    return dictionary
  }

}
