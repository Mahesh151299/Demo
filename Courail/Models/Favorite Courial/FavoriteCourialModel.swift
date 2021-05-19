//
//  FavoriteCourialModel.swift
//
//  Created by Omeesh Sharma on 27/08/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct FavoriteCourialModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kFavoriteCourialModelMiddleNameKey: String = "middleName"
  private let kFavoriteCourialModelLastNameKey: String = "last_name"
  private let kFavoriteCourialModelInternalIdentifierKey: String = "id"
  private let kFavoriteCourialModelImageKey: String = "image"
  private let kFavoriteCourialModelFirstNameKey: String = "first_name"
  private let kFavoriteCourialModelMyratingKey: String = "myrating"
  private let kFavoriteCourialModelRatingKey: String = "rating"
  private let kFavoriteCourialModelMyreviewKey: String = "myreview"
  private let kFavoriteCourialModelTotalDeliveriesKey: String = "total_deliveries"

  // MARK: Properties
  public var middleName: String?
  public var lastName: String?
  public var internalIdentifier: Int?
  public var image: String?
  public var firstName: String?
  public var myrating: String?
  public var rating: String?
  public var myreview: String?
  public var totalDeliveries: Int?

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
    middleName = json[kFavoriteCourialModelMiddleNameKey].string
    lastName = json[kFavoriteCourialModelLastNameKey].string
    internalIdentifier = json[kFavoriteCourialModelInternalIdentifierKey].int
    image = json[kFavoriteCourialModelImageKey].string
    firstName = json[kFavoriteCourialModelFirstNameKey].string
    myrating = json[kFavoriteCourialModelMyratingKey].string
    rating = json[kFavoriteCourialModelRatingKey].string
    myreview = json[kFavoriteCourialModelMyreviewKey].string
    totalDeliveries = json[kFavoriteCourialModelTotalDeliveriesKey].int
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = middleName { dictionary[kFavoriteCourialModelMiddleNameKey] = value }
    if let value = lastName { dictionary[kFavoriteCourialModelLastNameKey] = value }
    if let value = internalIdentifier { dictionary[kFavoriteCourialModelInternalIdentifierKey] = value }
    if let value = image { dictionary[kFavoriteCourialModelImageKey] = value }
    if let value = firstName { dictionary[kFavoriteCourialModelFirstNameKey] = value }
    if let value = myrating { dictionary[kFavoriteCourialModelMyratingKey] = value }
    if let value = rating { dictionary[kFavoriteCourialModelRatingKey] = value }
    if let value = myreview { dictionary[kFavoriteCourialModelMyreviewKey] = value }
    if let value = totalDeliveries { dictionary[kFavoriteCourialModelTotalDeliveriesKey] = value }
    return dictionary
  }

}
