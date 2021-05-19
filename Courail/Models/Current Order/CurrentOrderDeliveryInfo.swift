//
//  CurrentOrderDeliveryInfo.swift
//
//  Created by Omeesh Sharma on 20/08/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CurrentOrderDeliveryInfo {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kCurrentOrderDeliveryInfoAddress1Key: String = "address1"
  private let kCurrentOrderDeliveryInfoFloorsKey: String = "floors"
  private let kCurrentOrderDeliveryInfoFullAddressKey: String = "full_address"
  private let kCurrentOrderDeliveryInfoPlaceNameKey: String = "place_name"
  private let kCurrentOrderDeliveryInfoOptionsKey: String = "options"
  private let kCurrentOrderDeliveryInfoLatitudeKey: String = "latitude"
  private let kCurrentOrderDeliveryInfoInternalIdentifierKey: String = "id"
  private let kCurrentOrderDeliveryInfoAddress2Key: String = "address2"
  private let kCurrentOrderDeliveryInfoOrderidKey: String = "orderid"
  private let kCurrentOrderDeliveryInfoAptInfoKey: String = "aptInfo"
  private let kCurrentOrderDeliveryInfoPickElevatorWalkBothKey: String = "pick_elevator_walk_both"
  private let kCurrentOrderDeliveryInfoLongitudeKey: String = "longitude"
  private let kCurrentOrderDeliveryInfoNotesKey: String = "notes"

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
    address1 = json[kCurrentOrderDeliveryInfoAddress1Key].string
    floors = json[kCurrentOrderDeliveryInfoFloorsKey].string
    fullAddress = json[kCurrentOrderDeliveryInfoFullAddressKey].string
    placeName = json[kCurrentOrderDeliveryInfoPlaceNameKey].string
    options = json[kCurrentOrderDeliveryInfoOptionsKey].string
    latitude = json[kCurrentOrderDeliveryInfoLatitudeKey].string
    internalIdentifier = json[kCurrentOrderDeliveryInfoInternalIdentifierKey].int
    address2 = json[kCurrentOrderDeliveryInfoAddress2Key].string
    orderid = json[kCurrentOrderDeliveryInfoOrderidKey].string
    aptInfo = json[kCurrentOrderDeliveryInfoAptInfoKey].string
    pickElevatorWalkBoth = json[kCurrentOrderDeliveryInfoPickElevatorWalkBothKey].string
    longitude = json[kCurrentOrderDeliveryInfoLongitudeKey].string
    notes = json[kCurrentOrderDeliveryInfoNotesKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = address1 { dictionary[kCurrentOrderDeliveryInfoAddress1Key] = value }
    if let value = floors { dictionary[kCurrentOrderDeliveryInfoFloorsKey] = value }
    if let value = fullAddress { dictionary[kCurrentOrderDeliveryInfoFullAddressKey] = value }
    if let value = placeName { dictionary[kCurrentOrderDeliveryInfoPlaceNameKey] = value }
    if let value = options { dictionary[kCurrentOrderDeliveryInfoOptionsKey] = value }
    if let value = latitude { dictionary[kCurrentOrderDeliveryInfoLatitudeKey] = value }
    if let value = internalIdentifier { dictionary[kCurrentOrderDeliveryInfoInternalIdentifierKey] = value }
    if let value = address2 { dictionary[kCurrentOrderDeliveryInfoAddress2Key] = value }
    if let value = orderid { dictionary[kCurrentOrderDeliveryInfoOrderidKey] = value }
    if let value = aptInfo { dictionary[kCurrentOrderDeliveryInfoAptInfoKey] = value }
    if let value = pickElevatorWalkBoth { dictionary[kCurrentOrderDeliveryInfoPickElevatorWalkBothKey] = value }
    if let value = longitude { dictionary[kCurrentOrderDeliveryInfoLongitudeKey] = value }
    if let value = notes { dictionary[kCurrentOrderDeliveryInfoNotesKey] = value }
    return dictionary
  }

}
