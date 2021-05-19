//
//  BusinessDetailsModel.swift
//
//  Created by Omeesh Sharma on 06/04/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BusinessDetailsModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kBusinessDetailsModelNameKey: String = "name"
  private let kBusinessDetailsModelIsClaimedKey: String = "is_claimed"
  private let kBusinessDetailsModelCoordinatesKey: String = "coordinates"
  private let kBusinessDetailsModelRatingKey: String = "rating"
  private let kBusinessDetailsModelPhotosKey: String = "photos"
  private let kBusinessDetailsModelPriceKey: String = "price"
  private let kBusinessDetailsModelReviewCountKey: String = "review_count"
  private let kBusinessDetailsModelAliasKey: String = "alias"
  private let kBusinessDetailsModelDisplayPhoneKey: String = "display_phone"
  private let kBusinessDetailsModelHoursKey: String = "hours"
  private let kBusinessDetailsModelInternalIdentifierKey: String = "id"
  private let kBusinessDetailsModelCategoriesKey: String = "categories"
  private let kBusinessDetailsModelLocationKey: String = "location"
  private let kBusinessDetailsModelSpecialHoursKey: String = "special_hours"
  private let kBusinessDetailsModelPhoneKey: String = "phone"
  private let kBusinessDetailsModelTransactionsKey: String = "transactions"
  private let kBusinessDetailsModelImageUrlKey: String = "image_url"
  private let kBusinessDetailsModelIsClosedKey: String = "is_closed"
  private let kBusinessDetailsModelUrlKey: String = "url"

  // MARK: Properties
  public var name: String?
  public var isClaimed: Bool = false
  public var coordinates: BusinessDetailsCoordinates?
  public var rating: Float?
  public var photos: [String]?
  public var price: String?
  public var reviewCount: Int?
  public var alias: String?
  public var displayPhone: String?
  public var hours: [BusinessDetailsHours]?
  public var internalIdentifier: String?
  public var categories: [BusinessDetailsCategories]?
  public var location: BusinessDetailsLocation?
  public var specialHours: [BusinessDetailsSpecialHours]?
  public var phone: String?
  public var transactions: [Any]?
  public var imageUrl: String?
  public var isClosed: Bool = false
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
    name = json[kBusinessDetailsModelNameKey].string
    isClaimed = json[kBusinessDetailsModelIsClaimedKey].boolValue
    coordinates = BusinessDetailsCoordinates(json: json[kBusinessDetailsModelCoordinatesKey])
    rating = json[kBusinessDetailsModelRatingKey].float
    if let items = json[kBusinessDetailsModelPhotosKey].array { photos = items.map { $0.stringValue } }
    price = json[kBusinessDetailsModelPriceKey].string
    reviewCount = json[kBusinessDetailsModelReviewCountKey].int
    alias = json[kBusinessDetailsModelAliasKey].string
    displayPhone = json[kBusinessDetailsModelDisplayPhoneKey].string
    if let items = json[kBusinessDetailsModelHoursKey].array { hours = items.map { BusinessDetailsHours(json: $0) } }
    internalIdentifier = json[kBusinessDetailsModelInternalIdentifierKey].string
    if let items = json[kBusinessDetailsModelCategoriesKey].array { categories = items.map { BusinessDetailsCategories(json: $0) } }
    location = BusinessDetailsLocation(json: json[kBusinessDetailsModelLocationKey])
    if let items = json[kBusinessDetailsModelSpecialHoursKey].array { specialHours = items.map { BusinessDetailsSpecialHours(json: $0) } }
    phone = json[kBusinessDetailsModelPhoneKey].string
    if let items = json[kBusinessDetailsModelTransactionsKey].array { transactions = items.map { $0.object} }
    imageUrl = json[kBusinessDetailsModelImageUrlKey].string
    isClosed = json[kBusinessDetailsModelIsClosedKey].boolValue
    url = json[kBusinessDetailsModelUrlKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[kBusinessDetailsModelNameKey] = value }
    dictionary[kBusinessDetailsModelIsClaimedKey] = isClaimed
    if let value = coordinates { dictionary[kBusinessDetailsModelCoordinatesKey] = value.dictionaryRepresentation() }
    if let value = rating { dictionary[kBusinessDetailsModelRatingKey] = value }
    if let value = photos { dictionary[kBusinessDetailsModelPhotosKey] = value }
    if let value = price { dictionary[kBusinessDetailsModelPriceKey] = value }
    if let value = reviewCount { dictionary[kBusinessDetailsModelReviewCountKey] = value }
    if let value = alias { dictionary[kBusinessDetailsModelAliasKey] = value }
    if let value = displayPhone { dictionary[kBusinessDetailsModelDisplayPhoneKey] = value }
    if let value = hours { dictionary[kBusinessDetailsModelHoursKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = internalIdentifier { dictionary[kBusinessDetailsModelInternalIdentifierKey] = value }
    if let value = categories { dictionary[kBusinessDetailsModelCategoriesKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = location { dictionary[kBusinessDetailsModelLocationKey] = value.dictionaryRepresentation() }
    if let value = specialHours { dictionary[kBusinessDetailsModelSpecialHoursKey] = value.map { $0.dictionaryRepresentation() } }
    if let value = phone { dictionary[kBusinessDetailsModelPhoneKey] = value }
    if let value = transactions { dictionary[kBusinessDetailsModelTransactionsKey] = value }
    if let value = imageUrl { dictionary[kBusinessDetailsModelImageUrlKey] = value }
    dictionary[kBusinessDetailsModelIsClosedKey] = isClosed
    if let value = url { dictionary[kBusinessDetailsModelUrlKey] = value }
    return dictionary
  }

}
