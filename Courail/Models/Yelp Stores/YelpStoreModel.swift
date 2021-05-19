//
//  YelpStoreModel.swift
//
//  Created by apple on 17/03/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct YelpStoreModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kYelpStoreModelTotalKey: String = "total"
  private let kYelpStoreModelRegionKey: String = "region"
  private let kYelpStoreModelBusinessesKey: String = "businesses"

  // MARK: Properties
  public var total: Int?
  public var region: YelpStoreRegion?
  public var businesses: [YelpStoreBusinesses]?

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
    total = json[kYelpStoreModelTotalKey].int
    region = YelpStoreRegion(json: json[kYelpStoreModelRegionKey])
    if let items = json[kYelpStoreModelBusinessesKey].array { businesses = items.map { YelpStoreBusinesses(json: $0) } }
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = total { dictionary[kYelpStoreModelTotalKey] = value }
    if let value = region { dictionary[kYelpStoreModelRegionKey] = value.dictionaryRepresentation() }
    if let value = businesses { dictionary[kYelpStoreModelBusinessesKey] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
