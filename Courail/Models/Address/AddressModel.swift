//
//  AddressModel.swift
//
//  Created by Omeesh Sharma on 14/04/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct AddressModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kAddressModelIsSelectedKey: String = "is_selected"
    private let kAddressModelIconKey: String = "icon"
    private let kAddressModelDeliveryPickupKey: String = "deliveryPickup"
    private let kAddressModelAddressKey: String = "address"
    private let kAddressModelAddress2Key: String = "address2"
    private let kAddressModelPlaceNameKey: String = "placeName"
    private let kAddressModelUserIdKey: String = "userId"
    private let kAddressModelUpdatedKey: String = "updated"
    private let kAddressModelLatitudeKey: String = "latitude"
    private let kAddressModelIsDefaultKey: String = "isDefault"
    private let kAddressModelInternalIdentifierKey: String = "id"
    private let kAddressModelCreatedKey: String = "created"
    private let kAddressModelParkingInfoKey: String = "parkingInfo"
    private let kAddressModelApartmentInfoKey: String = "apartmentInfo"
    private let kAddressModelAddressTypeKey: String = "addressType"
    private let kAddressModelFullAddressKey: String = "fullAddress"
    private let kAddressModelLongitudeKey: String = "longitude"
    private let kAddressModelNotesKey: String = "notes"
    private let addressPhoneKey: String = "address_phone"
    
    private let dropPickupoptionsKey: String = "dropPickupoptions"
    private let flightofStairsKey: String = "flightofStairs"
    private let elevatorFloorKey: String = "elevatorFloor"
    private let elevator_walk_bothKey: String = "elevatorWalkBoth"
    
    
    // MARK: Properties
    public var isSelected: Bool = false
    public var icon: String?
    public var deliveryPickup: Int?
    public var address: String?
    public var address2: String?
    public var placeName: String?
    public var addressPhone: String?
    public var userId: Int?
    public var updated: Int?
    public var latitude: Float?
    public var isDefault: Int?
    public var internalIdentifier: Int?
    public var created: Int?
    public var parkingInfo: String?
    public var apartmentInfo: String?
    public var addressType: String?
    public var fullAddress: String?
    public var longitude: Float?
    public var notes: String?
    
    public var dropPickupoptions: String?
    public var flightofStairs: String?
    public var elevatorFloor: String?
    public var elevator_walk_both: String?
    
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
        isSelected = json[kAddressModelIsSelectedKey].boolValue
        icon = json[kAddressModelIconKey].string
        deliveryPickup = json[kAddressModelDeliveryPickupKey].int
        address = json[kAddressModelAddressKey].string
        address2 = json[kAddressModelAddress2Key].string
        placeName = json[kAddressModelPlaceNameKey].string
        userId = json[kAddressModelUserIdKey].int
        updated = json[kAddressModelUpdatedKey].int
        latitude = json[kAddressModelLatitudeKey].floatValue
        isDefault = json[kAddressModelIsDefaultKey].int
        internalIdentifier = json[kAddressModelInternalIdentifierKey].int
        created = json[kAddressModelCreatedKey].int
        parkingInfo = json[kAddressModelParkingInfoKey].string
        apartmentInfo = json[kAddressModelApartmentInfoKey].string
        addressType = json[kAddressModelAddressTypeKey].string
        fullAddress = json[kAddressModelFullAddressKey].string
        longitude = json[kAddressModelLongitudeKey].floatValue
        notes = json[kAddressModelNotesKey].string
        
        dropPickupoptions = json[dropPickupoptionsKey].string
        flightofStairs = json[flightofStairsKey].string
        elevatorFloor = json[elevatorFloorKey].string
        elevator_walk_both = json[elevator_walk_bothKey].string
        
        addressPhone = json[addressPhoneKey].string
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[kAddressModelIsSelectedKey] = isSelected
        if let value = icon { dictionary[kAddressModelIconKey] = value }
        if let value = deliveryPickup { dictionary[kAddressModelDeliveryPickupKey] = value }
        if let value = address { dictionary[kAddressModelAddressKey] = value }
        if let value = address2 { dictionary[kAddressModelAddress2Key] = value }
        if let value = placeName { dictionary[kAddressModelPlaceNameKey] = value }
        if let value = userId { dictionary[kAddressModelUserIdKey] = value }
        if let value = updated { dictionary[kAddressModelUpdatedKey] = value }
        if let value = latitude { dictionary[kAddressModelLatitudeKey] = value }
        if let value = isDefault { dictionary[kAddressModelIsDefaultKey] = value }
        if let value = internalIdentifier { dictionary[kAddressModelInternalIdentifierKey] = value }
        if let value = created { dictionary[kAddressModelCreatedKey] = value }
        if let value = parkingInfo { dictionary[kAddressModelParkingInfoKey] = value }
        if let value = apartmentInfo { dictionary[kAddressModelApartmentInfoKey] = value }
        if let value = addressType { dictionary[kAddressModelAddressTypeKey] = value }
        if let value = fullAddress { dictionary[kAddressModelFullAddressKey] = value }
        if let value = longitude { dictionary[kAddressModelLongitudeKey] = value }
        if let value = notes { dictionary[kAddressModelNotesKey] = value }
        
        if let value = dropPickupoptions { dictionary[dropPickupoptionsKey] = value }
        if let value = flightofStairs { dictionary[flightofStairsKey] = value }
        if let value = elevatorFloor { dictionary[elevatorFloorKey] = value }
        if let value = elevator_walk_both { dictionary[elevator_walk_bothKey] = value }
        
        if let value = addressPhone { dictionary[addressPhoneKey] = value }
        
        return dictionary
    }
    
}
