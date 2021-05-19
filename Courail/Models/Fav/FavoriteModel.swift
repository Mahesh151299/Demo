//
//  FavoriteModel.swift
//
//  Created by Omeesh Sharma on 28/04/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct FavoriteModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kFavoriteModelUpdatedKey: String = "updated"
  private let kFavoriteModelUserIdKey: String = "userId"
  private let kFavoriteModelCreatedKey: String = "created"
  private let kFavoriteModelInternalIdentifierKey: String = "id"
  private let kFavoriteModelJsdsonKey: String = "json"
  private let favcountKey: String = "favcount"
    

  // MARK: Properties
  public var updated: Int?
  public var userId: Int?
  public var created: Int?
  public var internalIdentifier: Int?
  public var data: YelpStoreBusinesses?
  public var favcount: Int?

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
    updated = json[kFavoriteModelUpdatedKey].int
    userId = json[kFavoriteModelUserIdKey].int
    created = json[kFavoriteModelCreatedKey].int
    internalIdentifier = json[kFavoriteModelInternalIdentifierKey].int
    data = YelpStoreBusinesses(json: json[kFavoriteModelJsdsonKey])
    favcount = json[favcountKey].intValue
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = updated { dictionary[kFavoriteModelUpdatedKey] = value }
    if let value = userId { dictionary[kFavoriteModelUserIdKey] = value }
    if let value = created { dictionary[kFavoriteModelCreatedKey] = value }
    if let value = internalIdentifier { dictionary[kFavoriteModelInternalIdentifierKey] = value }
    if let value = data { dictionary[kFavoriteModelJsdsonKey] = value.dictionaryRepresentation() }
    if let value = favcount { dictionary[favcountKey] = value }
    return dictionary
  }

}
