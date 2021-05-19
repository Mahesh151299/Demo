//
//  BusinessDetailsHours.swift
//
//  Created by Omeesh Sharma on 06/04/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BusinessDetailsHours {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBusinessDetailsHoursIsOpenNowKey: String = "is_open_now"
  private let kBusinessDetailsHoursOpenKey: String = "open"
  private let kBusinessDetailsHoursHoursTypeKey: String = "hours_type"

  // MARK: Properties
  public var isOpenNow: Bool = false
  public var open: [BusinessDetailsOpen]?
  public var hoursType: String?

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
    isOpenNow = json[kBusinessDetailsHoursIsOpenNowKey].boolValue
    if let items = json[kBusinessDetailsHoursOpenKey].array { open = items.map { BusinessDetailsOpen(json: $0) } }
    hoursType = json[kBusinessDetailsHoursHoursTypeKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    dictionary[kBusinessDetailsHoursIsOpenNowKey] = isOpenNow
    if let value = open { dictionary[kBusinessDetailsHoursOpenKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = hoursType { dictionary[kBusinessDetailsHoursHoursTypeKey] = value }
    return dictionary
  }

}
