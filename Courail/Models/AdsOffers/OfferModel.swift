//
//  OfferModel.swift
//
//  Created by Omeesh Sharma on 28/10/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct OfferModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kOfferModelStatusKey: String = "status"
  private let kOfferModelUpdatedAtKey: String = "updated_at"
  private let kOfferModelInternalIdentifierKey: String = "id"
  private let kOfferModelImageKey: String = "image"
  private let kOfferModelCreatedAtKey: String = "created_at"
  private let kOfferModelDescriptionValueKey: String = "description"
  private let kOfferModelTitleKey: String = "title"
  private let kOfferModelUrlKey: String = "url"
  private let viewcountsKey: String = "viewcounts"
    
  private let SetAdsTimeintervelKey: String = "SetAdsTimeintervel"
    

  // MARK: Properties
  public var status: Int?
  public var updatedAt: String?
  public var internalIdentifier: Int?
  public var image: String?
  public var createdAt: String?
  public var descriptionValue: String?
  public var title: String?
  public var url: String?
  public var viewcounts: Int?
    
  public var SetAdsTimeintervel: Int?

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
    status = json[kOfferModelStatusKey].int
    updatedAt = json[kOfferModelUpdatedAtKey].string
    internalIdentifier = json[kOfferModelInternalIdentifierKey].int
    image = json[kOfferModelImageKey].string
    createdAt = json[kOfferModelCreatedAtKey].string
    descriptionValue = json[kOfferModelDescriptionValueKey].string
    title = json[kOfferModelTitleKey].string
    url = json[kOfferModelUrlKey].string
    viewcounts = json[viewcountsKey].intValue
    
    SetAdsTimeintervel = json[SetAdsTimeintervelKey].intValue
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[kOfferModelStatusKey] = value }
    if let value = updatedAt { dictionary[kOfferModelUpdatedAtKey] = value }
    if let value = internalIdentifier { dictionary[kOfferModelInternalIdentifierKey] = value }
    if let value = image { dictionary[kOfferModelImageKey] = value }
    if let value = createdAt { dictionary[kOfferModelCreatedAtKey] = value }
    if let value = descriptionValue { dictionary[kOfferModelDescriptionValueKey] = value }
    if let value = title { dictionary[kOfferModelTitleKey] = value }
    if let value = url { dictionary[kOfferModelUrlKey] = value }
    if let value = viewcounts { dictionary[viewcountsKey] = value }
    
    if let value = SetAdsTimeintervel { dictionary[SetAdsTimeintervelKey] = value }
    return dictionary
  }

}
