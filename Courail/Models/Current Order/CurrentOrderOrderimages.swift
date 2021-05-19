//
//  CurrentOrderOrderimages.swift
//
//  Created by Omeesh Sharma on 20/08/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CurrentOrderOrderimages {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kCurrentOrderOrderimagesInternalIdentifierKey: String = "id"
  private let kCurrentOrderOrderimagesOrderidKey: String = "orderid"
  private let kCurrentOrderOrderimagesImageKey: String = "image"

  // MARK: Properties
  public var internalIdentifier: Int?
  public var orderid: String?
  public var image: String?

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
    internalIdentifier = json[kCurrentOrderOrderimagesInternalIdentifierKey].int
    orderid = json[kCurrentOrderOrderimagesOrderidKey].string
    image = json[kCurrentOrderOrderimagesImageKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = internalIdentifier { dictionary[kCurrentOrderOrderimagesInternalIdentifierKey] = value }
    if let value = orderid { dictionary[kCurrentOrderOrderimagesOrderidKey] = value }
    if let value = image { dictionary[kCurrentOrderOrderimagesImageKey] = value }
    return dictionary
  }

}
