//
//  BusinessDetailsLocation.swift
//
//  Created by Omeesh Sharma on 06/04/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BusinessDetailsLocation {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBusinessDetailsLocationStateKey: String = "state"
  private let kBusinessDetailsLocationCityKey: String = "city"
  private let kBusinessDetailsLocationAddress1Key: String = "address1"
  private let kBusinessDetailsLocationAddress3Key: String = "address3"
  private let kBusinessDetailsLocationAddress2Key: String = "address2"
  private let kBusinessDetailsLocationDisplayAddressKey: String = "display_address"
  private let kBusinessDetailsLocationZipCodeKey: String = "zip_code"
  private let kBusinessDetailsLocationCrossStreetsKey: String = "cross_streets"
  private let kBusinessDetailsLocationCountryKey: String = "country"

  // MARK: Properties
  public var state: String?
  public var city: String?
  public var address1: String?
  public var address3: String?
  public var address2: String?
  public var displayAddress: [String]?
  public var zipCode: String?
  public var crossStreets: String?
  public var country: String?

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
    state = json[kBusinessDetailsLocationStateKey].string
    city = json[kBusinessDetailsLocationCityKey].string
    address1 = json[kBusinessDetailsLocationAddress1Key].string
    address3 = json[kBusinessDetailsLocationAddress3Key].string
    address2 = json[kBusinessDetailsLocationAddress2Key].string
    if let items = json[kBusinessDetailsLocationDisplayAddressKey].array { displayAddress = items.map { $0.stringValue } }
    zipCode = json[kBusinessDetailsLocationZipCodeKey].string
    crossStreets = json[kBusinessDetailsLocationCrossStreetsKey].string
    country = json[kBusinessDetailsLocationCountryKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = state { dictionary[kBusinessDetailsLocationStateKey] = value }
    if let value = city { dictionary[kBusinessDetailsLocationCityKey] = value }
    if let value = address1 { dictionary[kBusinessDetailsLocationAddress1Key] = value }
    if let value = address3 { dictionary[kBusinessDetailsLocationAddress3Key] = value }
    if let value = address2 { dictionary[kBusinessDetailsLocationAddress2Key] = value }
    if let value = displayAddress { dictionary[kBusinessDetailsLocationDisplayAddressKey] = value }
    if let value = zipCode { dictionary[kBusinessDetailsLocationZipCodeKey] = value }
    if let value = crossStreets { dictionary[kBusinessDetailsLocationCrossStreetsKey] = value }
    if let value = country { dictionary[kBusinessDetailsLocationCountryKey] = value }
    return dictionary
  }

}
