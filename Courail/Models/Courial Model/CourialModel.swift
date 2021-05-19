//
//  CourialModel.swift
//
//  Created by Omeesh Sharma on 18/08/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CourialModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kCourialModelMiddleNameKey: String = "middleName"
  private let kCourialModelEmailKey: String = "email"
  private let kCourialModelLatitudeKey: String = "latitude"
  private let kCourialModelLocationKey: String = "location"
  private let kCourialModelLastNameKey: String = "last_name"
  private let kCourialModelInternalIdentifierKey: String = "id"
  private let kCourialModelFirstNameKey: String = "first_name"
  private let kCourialModelImageKey: String = "image"
  private let kCourialModelDistanceKey: String = "distance"
  private let kCourialModelPhoneKey: String = "phone"
  private let kCourialModelCountryCodeKey: String = "country_code"
  private let kCourialModelLongitudeKey: String = "longitude"
  private let kCourialModelSocketIdKey: String = "socketId"

  // MARK: Properties
  public var middleName: String?
  public var email: String?
  public var latitude: String?
  public var location: String?
  public var lastName: String?
  public var internalIdentifier: Int?
  public var firstName: String?
  public var image: String?
  public var distance: Int?
  public var phone: String?
  public var countryCode: String?
  public var longitude: String?
  public var socketId: String?

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
    middleName = json[kCourialModelMiddleNameKey].string
    email = json[kCourialModelEmailKey].string
    latitude = json[kCourialModelLatitudeKey].string
    location = json[kCourialModelLocationKey].string
    lastName = json[kCourialModelLastNameKey].string
    internalIdentifier = json[kCourialModelInternalIdentifierKey].int
    firstName = json[kCourialModelFirstNameKey].string
    image = json[kCourialModelImageKey].string
    distance = json[kCourialModelDistanceKey].int
    phone = json[kCourialModelPhoneKey].string
    countryCode = json[kCourialModelCountryCodeKey].string
    longitude = json[kCourialModelLongitudeKey].string
    socketId = json[kCourialModelSocketIdKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = middleName { dictionary[kCourialModelMiddleNameKey] = value }
    if let value = email { dictionary[kCourialModelEmailKey] = value }
    if let value = latitude { dictionary[kCourialModelLatitudeKey] = value }
    if let value = location { dictionary[kCourialModelLocationKey] = value }
    if let value = lastName { dictionary[kCourialModelLastNameKey] = value }
    if let value = internalIdentifier { dictionary[kCourialModelInternalIdentifierKey] = value }
    if let value = firstName { dictionary[kCourialModelFirstNameKey] = value }
    if let value = image { dictionary[kCourialModelImageKey] = value }
    if let value = distance { dictionary[kCourialModelDistanceKey] = value }
    if let value = phone { dictionary[kCourialModelPhoneKey] = value }
    if let value = countryCode { dictionary[kCourialModelCountryCodeKey] = value }
    if let value = longitude { dictionary[kCourialModelLongitudeKey] = value }
    if let value = socketId { dictionary[kCourialModelSocketIdKey] = value }
    return dictionary
  }

}
