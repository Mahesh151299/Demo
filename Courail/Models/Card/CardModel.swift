//
//  CardModel.swift
//
//  Created by Omeesh Sharma on 30/06/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CardModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kCardModelCardNumberKey: String = "cardNumber"
  private let kCardModelCardTypeKey: String = "cardType"
  private let kCardModelInternalIdentifierKey: String = "id"
  private let kCardModelZipKey: String = "zip"
  private let kCardModelCreatedAtKey: String = "createdAt"
  private let kCardModelUpdatedAtKey: String = "updatedAt"
  private let kCardModelCardIdKey: String = "cardId"
  private let kCardModelUserIdKey: String = "userId"
  private let kCardModelExpMonthKey: String = "expMonth"
  private let kCardModelExpYearKey: String = "expYear"

  // MARK: Properties
  public var cardNumber: String?
  public var cardType: String?
  public var internalIdentifier: Int?
  public var zip: String?
  public var createdAt: String?
  public var updatedAt: String?
  public var cardId: String?
  public var userId: Int?
  public var expMonth: String?
  public var expYear: String?

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
    cardNumber = json[kCardModelCardNumberKey].string
    cardType = json[kCardModelCardTypeKey].string
    internalIdentifier = json[kCardModelInternalIdentifierKey].int
    zip = json[kCardModelZipKey].string
    createdAt = json[kCardModelCreatedAtKey].string
    updatedAt = json[kCardModelUpdatedAtKey].string
    cardId = json[kCardModelCardIdKey].string
    userId = json[kCardModelUserIdKey].int
    expMonth = json[kCardModelExpMonthKey].stringValue
    expYear = json[kCardModelExpYearKey].stringValue
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = cardNumber { dictionary[kCardModelCardNumberKey] = value }
    if let value = cardType { dictionary[kCardModelCardTypeKey] = value }
    if let value = internalIdentifier { dictionary[kCardModelInternalIdentifierKey] = value }
    if let value = zip { dictionary[kCardModelZipKey] = value }
    if let value = createdAt { dictionary[kCardModelCreatedAtKey] = value }
    if let value = updatedAt { dictionary[kCardModelUpdatedAtKey] = value }
    if let value = cardId { dictionary[kCardModelCardIdKey] = value }
    if let value = userId { dictionary[kCardModelUserIdKey] = value }
    if let value = expMonth { dictionary[kCardModelExpMonthKey] = value }
    if let value = expYear { dictionary[kCardModelExpYearKey] = value }
    return dictionary
  }

}
