//
//  ReferModel.swift
//
//  Created by Omeesh Sharma on 07/12/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct ReferModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kReferModelMiddleNameKey: String = "middleName"
  private let kReferModelLastNameKey: String = "last_name"
  private let kReferModelInternalIdentifierKey: String = "id"
  private let kReferModelImageKey: String = "image"
  private let kReferModelDeliveriesKey: String = "deliveries"
  private let kReferModelFirstNameKey: String = "first_name"
  private let kReferModelAmountKey: String = "amount"

  // MARK: Properties
  public var middleName: String?
  public var lastName: String?
  public var internalIdentifier: Int?
  public var image: String?
  public var deliveries: Int?
  public var firstName: String?
  public var amount: String?

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
    middleName = json[kReferModelMiddleNameKey].string
    lastName = json[kReferModelLastNameKey].string
    internalIdentifier = json[kReferModelInternalIdentifierKey].int
    image = json[kReferModelImageKey].string
    deliveries = json[kReferModelDeliveriesKey].int
    firstName = json[kReferModelFirstNameKey].string
    amount = json[kReferModelAmountKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = middleName { dictionary[kReferModelMiddleNameKey] = value }
    if let value = lastName { dictionary[kReferModelLastNameKey] = value }
    if let value = internalIdentifier { dictionary[kReferModelInternalIdentifierKey] = value }
    if let value = image { dictionary[kReferModelImageKey] = value }
    if let value = deliveries { dictionary[kReferModelDeliveriesKey] = value }
    if let value = firstName { dictionary[kReferModelFirstNameKey] = value }
    if let value = amount { dictionary[kReferModelAmountKey] = value }
    return dictionary
  }

}
