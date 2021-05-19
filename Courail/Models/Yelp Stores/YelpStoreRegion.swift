//
//  YelpStoreRegion.swift
//
//  Created by apple on 17/03/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct YelpStoreRegion {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kYelpStoreRegionCenterKey: String = "center"

  // MARK: Properties
  public var center: YelpStoreCenter?

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
    center = YelpStoreCenter(json: json[kYelpStoreRegionCenterKey])
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = center { dictionary[kYelpStoreRegionCenterKey] = value.dictionaryRepresentation() }
    return dictionary
  }

}
