//
//  OnlineBusinessModel.swift
//
//  Created by Omeesh Sharma on 28/07/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct OnlineBusinessModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kOnlineBusinessModelNameKey: String = "name"
  private let kOnlineBusinessModelHexKey: String = "hex"
  private let kOnlineBusinessModelInternalIdentifierKey: String = "id"
  private let kOnlineBusinessModelImageKey: String = "image"
  private let kOnlineBusinessModelUrlKey: String = "url"

  // MARK: Properties
  public var name: String?
  public var hex: String?
  public var internalIdentifier: Int?
  public var image: String?
  public var url: String?

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
    name = json[kOnlineBusinessModelNameKey].string
    hex = json[kOnlineBusinessModelHexKey].string
    internalIdentifier = json[kOnlineBusinessModelInternalIdentifierKey].int
    image = json[kOnlineBusinessModelImageKey].string
    url = json[kOnlineBusinessModelUrlKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[kOnlineBusinessModelNameKey] = value }
    if let value = hex { dictionary[kOnlineBusinessModelHexKey] = value }
    if let value = internalIdentifier { dictionary[kOnlineBusinessModelInternalIdentifierKey] = value }
    if let value = image { dictionary[kOnlineBusinessModelImageKey] = value }
    if let value = url { dictionary[kOnlineBusinessModelUrlKey] = value }
    return dictionary
  }

}
