//
//  CurrentOrderPickupInfo.swift
//
//  Created by Omeesh Sharma on 20/08/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CurrentOrderPickupInfo {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kCurrentOrderPickupInfoAddress1Key: String = "address1"
  private let kCurrentOrderPickupInfoFloorsKey: String = "floors"
  private let kCurrentOrderPickupInfoFullAddressKey: String = "full_address"
  private let kCurrentOrderPickupInfoPlaceNameKey: String = "place_name"
  private let kCurrentOrderPickupInfoOptionsKey: String = "options"
  private let kCurrentOrderPickupInfoLatitudeKey: String = "latitude"
  private let kCurrentOrderPickupInfoInternalIdentifierKey: String = "id"
  private let kCurrentOrderPickupInfoAddress2Key: String = "address2"
  private let kCurrentOrderPickupInfoOrderidKey: String = "orderid"
  private let kCurrentOrderPickupInfoAptInfoKey: String = "aptInfo"
  private let kCurrentOrderPickupInfoPickElevatorWalkBothKey: String = "pick_elevator_walk_both"
  private let kCurrentOrderPickupInfoLongitudeKey: String = "longitude"
  private let kCurrentOrderPickupInfoNotesKey: String = "notes"

  // MARK: Properties
  public var address1: String?
  public var floors: String?
  public var fullAddress: String?
  public var placeName: String?
  public var options: String?
  public var latitude: String?
  public var internalIdentifier: Int?
  public var address2: String?
  public var orderid: String?
  public var aptInfo: String?
  public var pickElevatorWalkBoth: String?
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
    address1 = json[kCurrentOrderPickupInfoAddress1Key].string
    floors = json[kCurrentOrderPickupInfoFloorsKey].string
    fullAddress = json[kCurrentOrderPickupInfoFullAddressKey].string
    placeName = json[kCurrentOrderPickupInfoPlaceNameKey].string
    options = json[kCurrentOrderPickupInfoOptionsKey].string
    latitude = json[kCurrentOrderPickupInfoLatitudeKey].string
    internalIdentifier = json[kCurrentOrderPickupInfoInternalIdentifierKey].int
    address2 = json[kCurrentOrderPickupInfoAddress2Key].string
    orderid = json[kCurrentOrderPickupInfoOrderidKey].string
    aptInfo = json[kCurrentOrderPickupInfoAptInfoKey].string
    pickElevatorWalkBoth = json[kCurrentOrderPickupInfoPickElevatorWalkBothKey].string
    longitude = json[kCurrentOrderPickupInfoLongitudeKey].string
    notes = json[kCurrentOrderPickupInfoNotesKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = address1 { dictionary[kCurrentOrderPickupInfoAddress1Key] = value }
    if let value = floors { dictionary[kCurrentOrderPickupInfoFloorsKey] = value }
    if let value = fullAddress { dictionary[kCurrentOrderPickupInfoFullAddressKey] = value }
    if let value = placeName { dictionary[kCurrentOrderPickupInfoPlaceNameKey] = value }
    if let value = options { dictionary[kCurrentOrderPickupInfoOptionsKey] = value }
    if let value = latitude { dictionary[kCurrentOrderPickupInfoLatitudeKey] = value }
    if let value = internalIdentifier { dictionary[kCurrentOrderPickupInfoInternalIdentifierKey] = value }
    if let value = address2 { dictionary[kCurrentOrderPickupInfoAddress2Key] = value }
    if let value = orderid { dictionary[kCurrentOrderPickupInfoOrderidKey] = value }
    if let value = aptInfo { dictionary[kCurrentOrderPickupInfoAptInfoKey] = value }
    if let value = pickElevatorWalkBoth { dictionary[kCurrentOrderPickupInfoPickElevatorWalkBothKey] = value }
    if let value = longitude { dictionary[kCurrentOrderPickupInfoLongitudeKey] = value }
    if let value = notes { dictionary[kCurrentOrderPickupInfoNotesKey] = value }
    return dictionary
  }

}
