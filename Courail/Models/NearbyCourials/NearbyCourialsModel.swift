//
//  NearbyCourialsModel.swift
//
//  Created by Omeesh Sharma on 28/01/21
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct NearbyCourialsModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kNearbyCourialsModelMiddleNameKey: String = "middleName"
  private let kNearbyCourialsModelEmailKey: String = "email"
  private let kNearbyCourialsModelTransportKey: String = "transport"
  private let kNearbyCourialsModelLatitudeKey: String = "latitude"
  private let kNearbyCourialsModelLocationKey: String = "location"
  private let kNearbyCourialsModelLastNameKey: String = "last_name"
  private let kNearbyCourialsModelInternalIdentifierKey: String = "id"
  private let kNearbyCourialsModelImageKey: String = "image"
  private let kNearbyCourialsModelFirstNameKey: String = "first_name"
  private let kNearbyCourialsModelDistanceKey: String = "distance"
  private let kNearbyCourialsModelPhoneKey: String = "phone"
  private let kNearbyCourialsModelCountryCodeKey: String = "country_code"
  private let kNearbyCourialsModelLongitudeKey: String = "longitude"

  // MARK: Properties
  public var middleName: String?
  public var email: String?
  public var transport: String?
  public var latitude: String?
  public var location: String?
  public var lastName: String?
  public var internalIdentifier: Int?
  public var image: String?
  public var firstName: String?
  public var distance: Int?
  public var phone: String?
  public var countryCode: String?
  public var longitude: String?

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
    middleName = json[kNearbyCourialsModelMiddleNameKey].string
    email = json[kNearbyCourialsModelEmailKey].string
    transport = json[kNearbyCourialsModelTransportKey].string
    latitude = json[kNearbyCourialsModelLatitudeKey].string
    location = json[kNearbyCourialsModelLocationKey].string
    lastName = json[kNearbyCourialsModelLastNameKey].string
    internalIdentifier = json[kNearbyCourialsModelInternalIdentifierKey].int
    image = json[kNearbyCourialsModelImageKey].string
    firstName = json[kNearbyCourialsModelFirstNameKey].string
    distance = json[kNearbyCourialsModelDistanceKey].int
    phone = json[kNearbyCourialsModelPhoneKey].string
    countryCode = json[kNearbyCourialsModelCountryCodeKey].string
    longitude = json[kNearbyCourialsModelLongitudeKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = middleName { dictionary[kNearbyCourialsModelMiddleNameKey] = value }
    if let value = email { dictionary[kNearbyCourialsModelEmailKey] = value }
    if let value = transport { dictionary[kNearbyCourialsModelTransportKey] = value }
    if let value = latitude { dictionary[kNearbyCourialsModelLatitudeKey] = value }
    if let value = location { dictionary[kNearbyCourialsModelLocationKey] = value }
    if let value = lastName { dictionary[kNearbyCourialsModelLastNameKey] = value }
    if let value = internalIdentifier { dictionary[kNearbyCourialsModelInternalIdentifierKey] = value }
    if let value = image { dictionary[kNearbyCourialsModelImageKey] = value }
    if let value = firstName { dictionary[kNearbyCourialsModelFirstNameKey] = value }
    if let value = distance { dictionary[kNearbyCourialsModelDistanceKey] = value }
    if let value = phone { dictionary[kNearbyCourialsModelPhoneKey] = value }
    if let value = countryCode { dictionary[kNearbyCourialsModelCountryCodeKey] = value }
    if let value = longitude { dictionary[kNearbyCourialsModelLongitudeKey] = value }
    return dictionary
  }

}
