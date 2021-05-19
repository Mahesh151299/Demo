//
//  UserInfoSelectedAddress.swift
//
//  Created by Omeesh Sharma on 22/04/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct UserInfoSelectedAddress {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kUserInfoSelectedAddressDeliveryPickupKey: String = "deliveryPickup"
  private let kUserInfoSelectedAddressAddressKey: String = "address"
  private let kUserInfoSelectedAddressPlaceNameKey: String = "placeName"
  private let kUserInfoSelectedAddressUserIdKey: String = "userId"
  private let kUserInfoSelectedAddressUpdatedKey: String = "updated"
  private let kUserInfoSelectedAddressLatitudeKey: String = "latitude"
  private let kUserInfoSelectedAddressIsDefaultKey: String = "isDefault"
  private let kUserInfoSelectedAddressInternalIdentifierKey: String = "id"
  private let kUserInfoSelectedAddressCreatedKey: String = "created"
  private let kUserInfoSelectedAddressParkingInfoKey: String = "parkingInfo"
  private let kUserInfoSelectedAddressApartmentInfoKey: String = "apartmentInfo"
  private let kUserInfoSelectedAddressFullAddressKey: String = "fullAddress"
  private let kUserInfoSelectedAddressAddressTypeKey: String = "addressType"
  private let kUserInfoSelectedAddressLongitudeKey: String = "longitude"
  private let kUserInfoSelectedAddressNotesKey: String = "notes"

  // MARK: Properties
  public var deliveryPickup: Int?
  public var address: String?
  public var placeName: String?
  public var userId: Int?
  public var updated: Int?
  public var latitude: String?
  public var isDefault: Int?
  public var internalIdentifier: Int?
  public var created: Int?
  public var parkingInfo: String?
  public var apartmentInfo: String?
  public var fullAddress: String?
  public var addressType: String?
  public var longitude: String?
  public var notes: String?

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
    deliveryPickup = json[kUserInfoSelectedAddressDeliveryPickupKey].int
    address = json[kUserInfoSelectedAddressAddressKey].string
    placeName = json[kUserInfoSelectedAddressPlaceNameKey].string
    userId = json[kUserInfoSelectedAddressUserIdKey].int
    updated = json[kUserInfoSelectedAddressUpdatedKey].int
    latitude = json[kUserInfoSelectedAddressLatitudeKey].string
    isDefault = json[kUserInfoSelectedAddressIsDefaultKey].int
    internalIdentifier = json[kUserInfoSelectedAddressInternalIdentifierKey].int
    created = json[kUserInfoSelectedAddressCreatedKey].int
    parkingInfo = json[kUserInfoSelectedAddressParkingInfoKey].string
    apartmentInfo = json[kUserInfoSelectedAddressApartmentInfoKey].string
    fullAddress = json[kUserInfoSelectedAddressFullAddressKey].string
    addressType = json[kUserInfoSelectedAddressAddressTypeKey].string
    longitude = json[kUserInfoSelectedAddressLongitudeKey].string
    notes = json[kUserInfoSelectedAddressNotesKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = deliveryPickup { dictionary[kUserInfoSelectedAddressDeliveryPickupKey] = value }
    if let value = address { dictionary[kUserInfoSelectedAddressAddressKey] = value }
    if let value = placeName { dictionary[kUserInfoSelectedAddressPlaceNameKey] = value }
    if let value = userId { dictionary[kUserInfoSelectedAddressUserIdKey] = value }
    if let value = updated { dictionary[kUserInfoSelectedAddressUpdatedKey] = value }
    if let value = latitude { dictionary[kUserInfoSelectedAddressLatitudeKey] = value }
    if let value = isDefault { dictionary[kUserInfoSelectedAddressIsDefaultKey] = value }
    if let value = internalIdentifier { dictionary[kUserInfoSelectedAddressInternalIdentifierKey] = value }
    if let value = created { dictionary[kUserInfoSelectedAddressCreatedKey] = value }
    if let value = parkingInfo { dictionary[kUserInfoSelectedAddressParkingInfoKey] = value }
    if let value = apartmentInfo { dictionary[kUserInfoSelectedAddressApartmentInfoKey] = value }
    if let value = fullAddress { dictionary[kUserInfoSelectedAddressFullAddressKey] = value }
    if let value = addressType { dictionary[kUserInfoSelectedAddressAddressTypeKey] = value }
    if let value = longitude { dictionary[kUserInfoSelectedAddressLongitudeKey] = value }
    if let value = notes { dictionary[kUserInfoSelectedAddressNotesKey] = value }
    return dictionary
  }

}
