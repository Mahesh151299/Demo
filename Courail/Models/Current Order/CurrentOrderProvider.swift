//
//  CurrentOrderProvider.swift
//
//  Created by Omeesh Sharma on 20/08/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CurrentOrderProvider {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kCurrentOrderProviderLatitudeKey: String = "latitude"
  private let kCurrentOrderProviderMiddleNameKey: String = "middleName"
  private let kCurrentOrderProviderLocationKey: String = "location"
  private let kCurrentOrderProviderEmailKey: String = "email"
  private let kCurrentOrderProviderInternalIdentifierKey: String = "id"
  private let kCurrentOrderProviderImageKey: String = "image"
  private let kCurrentOrderProviderCountryCodeKey: String = "country_code"
  private let kCurrentOrderProviderLastNameKey: String = "last_name"
  private let kCurrentOrderProviderPhoneKey: String = "phone"
  private let kCurrentOrderProviderFirstNameKey: String = "first_name"
  private let kCurrentOrderProviderLongitudeKey: String = "longitude"
  private let ratingKey: String = "rating"
  
  private let courseKey: String = "course"
  private let transportKey: String = "transport"
  
    private let credentials_WebsiteKey: String = "credentials_Website"
    private let credentials_license_numberKey: String = "credentials_license_number"
    private let credentials_experienceKey: String = "credentials_experience"
    private let credentials_notesKey: String = "credentials_notes"
    
    
    
    
    
    

  // MARK: Properties
  public var latitude: String?
  public var middleName: String?
  public var location: String?
  public var email: String?
  public var internalIdentifier: Int?
  public var image: String?
  public var countryCode: String?
  public var lastName: String?
  public var phone: String?
  public var firstName: String?
  public var longitude: String?
  public var rating: String?
    
  public var course: Double?
    
    public var transport: String?
    
    public var credentials_Website: String?
    public var credentials_license_number: String?
    public var credentials_experience: String?
    public var credentials_notes: String?

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
    latitude = json[kCurrentOrderProviderLatitudeKey].string
    middleName = json[kCurrentOrderProviderMiddleNameKey].string
    location = json[kCurrentOrderProviderLocationKey].string
    email = json[kCurrentOrderProviderEmailKey].string
    internalIdentifier = json[kCurrentOrderProviderInternalIdentifierKey].int
    image = json[kCurrentOrderProviderImageKey].string
    countryCode = json[kCurrentOrderProviderCountryCodeKey].string
    lastName = json[kCurrentOrderProviderLastNameKey].string
    phone = json[kCurrentOrderProviderPhoneKey].string
    firstName = json[kCurrentOrderProviderFirstNameKey].string
    longitude = json[kCurrentOrderProviderLongitudeKey].string
    rating = json[ratingKey].string
    course = json[ratingKey].doubleValue
    
    transport = json[transportKey].string
    
    credentials_Website = json[credentials_WebsiteKey].stringValue
    credentials_license_number = json[credentials_license_numberKey].stringValue
    credentials_experience = json[credentials_experienceKey].stringValue
    credentials_notes = json[credentials_notesKey].stringValue
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = latitude { dictionary[kCurrentOrderProviderLatitudeKey] = value }
    if let value = middleName { dictionary[kCurrentOrderProviderMiddleNameKey] = value }
    if let value = location { dictionary[kCurrentOrderProviderLocationKey] = value }
    if let value = email { dictionary[kCurrentOrderProviderEmailKey] = value }
    if let value = internalIdentifier { dictionary[kCurrentOrderProviderInternalIdentifierKey] = value }
    if let value = image { dictionary[kCurrentOrderProviderImageKey] = value }
    if let value = countryCode { dictionary[kCurrentOrderProviderCountryCodeKey] = value }
    if let value = lastName { dictionary[kCurrentOrderProviderLastNameKey] = value }
    if let value = phone { dictionary[kCurrentOrderProviderPhoneKey] = value }
    if let value = firstName { dictionary[kCurrentOrderProviderFirstNameKey] = value }
    if let value = longitude { dictionary[kCurrentOrderProviderLongitudeKey] = value }
    if let value = rating { dictionary[ratingKey] = value }
    if let value = course { dictionary[courseKey] = value }
    if let value = transport { dictionary[transportKey] = value }
    
    if let value = credentials_Website { dictionary[credentials_WebsiteKey] = value }
    if let value = credentials_license_number { dictionary[credentials_license_numberKey] = value }
    if let value = credentials_experience { dictionary[credentials_experienceKey] = value }
    if let value = credentials_notes { dictionary[credentials_notesKey] = value }
    
    return dictionary
  }

}
