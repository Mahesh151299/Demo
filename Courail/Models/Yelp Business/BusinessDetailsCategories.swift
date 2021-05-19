//
//  BusinessDetailsCategories.swift
//
//  Created by Omeesh Sharma on 06/04/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BusinessDetailsCategories {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBusinessDetailsCategoriesTitleKey: String = "title"
  private let kBusinessDetailsCategoriesAliasKey: String = "alias"

  // MARK: Properties
  public var title: String?
  public var alias: String?

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
    title = json[kBusinessDetailsCategoriesTitleKey].string
    alias = json[kBusinessDetailsCategoriesAliasKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = title { dictionary[kBusinessDetailsCategoriesTitleKey] = value }
    if let value = alias { dictionary[kBusinessDetailsCategoriesAliasKey] = value }
    return dictionary
  }

}
