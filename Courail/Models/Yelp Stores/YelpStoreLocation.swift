//
//  YelpStoreLocation.swift
//
//  Created by apple on 17/03/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct YelpStoreLocation {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kYelpStoreLocationStateKey: String = "state"
    private let kYelpStoreLocationCityKey: String = "city"
    private let kYelpStoreLocationAddress1Key: String = "address1"
    private let kYelpStoreLocationAddress3Key: String = "address3"
    private let kYelpStoreLocationAddress2Key: String = "address2"
    private let kYelpStoreLocationDisplayAddressKey: String = "display_address"
    private let kYelpStoreLocationZipCodeKey: String = "zip_code"
    private let kYelpStoreLocationCountryKey: String = "country"
    private let aptInfoKey: String = "aptInfo"
    
    private let dropOptionKey: String = "dropOption"
    private let deliveryFlightStairsKey: String = "deliveryFlightStairs"
    private let deliveryElevatorFloorKey: String = "deliveryElevatorFloor"
    private let drop_elevator_walk_both_Key: String = "drop_elevator_walk_both"
    
    private let pickOptionKey: String = "pickOption"
    private let pickFlightStairsKey: String = "pickFlightStairs"
    private let pickElevatorFloorKey: String = "pickElevatorFloor"
    private let pick_elevator_walk_both_Key: String = "pick_elevator_walk_both"
    
    // MARK: Properties
    public var state: String?
    public var city: String?
    public var address1: String?
    public var address2: String?
    public var address3: String?
    
    public var displayAddress: [String]?
    public var zipCode: String?
    public var country: String?
    public var aptInfo: String?
    
    public var dropOption: String?
    public var deliveryFlightStairs: String?
    public var deliveryElevatorFloor: String?
    public var drop_elevator_walk_both: String?
    
    public var pickOption: String?
    public var pickFlightStairs: String?
    public var pickElevatorFloor: String?
    public var pick_elevator_walk_both: String?
    
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
        state = json[kYelpStoreLocationStateKey].string
        city = json[kYelpStoreLocationCityKey].string
        address1 = json[kYelpStoreLocationAddress1Key].string
        address3 = json[kYelpStoreLocationAddress3Key].string
        address2 = json[kYelpStoreLocationAddress2Key].string
        if let items = json[kYelpStoreLocationDisplayAddressKey].array { displayAddress = items.map { $0.stringValue } }
        zipCode = json[kYelpStoreLocationZipCodeKey].string
        country = json[kYelpStoreLocationCountryKey].string
        aptInfo = json[aptInfoKey].string
        
        dropOption = json[dropOptionKey].string
        deliveryFlightStairs = json[deliveryFlightStairsKey].string
        deliveryElevatorFloor = json[deliveryElevatorFloorKey].string
        drop_elevator_walk_both = json[drop_elevator_walk_both_Key].string
        
        pickOption = json[pickOptionKey].string
        pickFlightStairs = json[pickFlightStairsKey].string
        pickElevatorFloor = json[pickElevatorFloorKey].string
        pick_elevator_walk_both = json[pick_elevator_walk_both_Key].string
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = state { dictionary[kYelpStoreLocationStateKey] = value }
        if let value = city { dictionary[kYelpStoreLocationCityKey] = value }
        if let value = address1 { dictionary[kYelpStoreLocationAddress1Key] = value }
        if let value = address3 { dictionary[kYelpStoreLocationAddress3Key] = value }
        if let value = address2 { dictionary[kYelpStoreLocationAddress2Key] = value }
        if let value = displayAddress { dictionary[kYelpStoreLocationDisplayAddressKey] = value }
        if let value = zipCode { dictionary[kYelpStoreLocationZipCodeKey] = value }
        if let value = country { dictionary[kYelpStoreLocationCountryKey] = value }
        if let value = aptInfo { dictionary[aptInfoKey] = value }
        
        if let value = dropOption { dictionary[dropOptionKey] = value }
        if let value = deliveryFlightStairs { dictionary[deliveryFlightStairsKey] = value }
        if let value = deliveryElevatorFloor { dictionary[deliveryElevatorFloorKey] = value }
        if let value = drop_elevator_walk_both { dictionary[drop_elevator_walk_both_Key] = value }
        
        if let value = pickOption { dictionary[pickOptionKey] = value }
        if let value = pickFlightStairs { dictionary[pickFlightStairsKey] = value }
        if let value = pickElevatorFloor { dictionary[pickElevatorFloorKey] = value }
        if let value = pick_elevator_walk_both { dictionary[pick_elevator_walk_both_Key] = value }
        
        return dictionary
    }
    
}
