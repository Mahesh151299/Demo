//
//  BusinessDetailsCoordinates.swift
//
//  Created by Omeesh Sharma on 06/04/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BusinessDetailsCoordinates {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBusinessDetailsCoordinatesLongitudeKey: String = "longitude"
  private let kBusinessDetailsCoordinatesLatitudeKey: String = "latitude"

  // MARK: Properties
  public var longitude: Float?
  public var latitude: Float?

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
    longitude = json[kBusinessDetailsCoordinatesLongitudeKey].float
    latitude = json[kBusinessDetailsCoordinatesLatitudeKey].float
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = longitude { dictionary[kBusinessDetailsCoordinatesLongitudeKey] = value }
    if let value = latitude { dictionary[kBusinessDetailsCoordinatesLatitudeKey] = value }
    return dictionary
  }

}
