//
//  RecordingModel.swift
//
//  Created by Omeesh Sharma on 01/05/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct RecordingModel {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kRecordingModelSourceKey: String = "source"
  private let kRecordingModelUriKey: String = "uri"
  private let kRecordingModelAccountSidKey: String = "accountSid"
  private let kRecordingModelPriceKey: String = "price"
  private let kRecordingModelStatusKey: String = "status"
  private let kRecordingModelErrorCodeKey: String = "errorCode"
  private let kRecordingModelApiVersionKey: String = "apiVersion"
  private let kRecordingModelDateUpdatedKey: String = "dateUpdated"
  private let kRecordingModelChannelsKey: String = "channels"
  private let kRecordingModelSubresourceUrisKey: String = "subresourceUris"
  private let kRecordingModelCallSidKey: String = "callSid"
  private let kRecordingModelPriceUnitKey: String = "priceUnit"
  private let kRecordingModelDateCreatedKey: String = "dateCreated"
  private let kRecordingModelConferenceSidKey: String = "conferenceSid"
  private let kRecordingModelSidKey: String = "sid"
  private let kRecordingModelDurationKey: String = "duration"
  private let kRecordingModelStartTimeKey: String = "startTime"

  // MARK: Properties
  public var source: String?
  public var uri: String?
  public var accountSid: String?
  public var price: String?
  public var status: String?
  public var errorCode: Int?
  public var apiVersion: String?
  public var dateUpdated: String?
  public var channels: Int?
  public var subresourceUris: RecordingSubresourceUris?
  public var callSid: String?
  public var priceUnit: String?
  public var dateCreated: String?
  public var conferenceSid: String?
  public var sid: String?
  public var duration: String?
  public var startTime: String?

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
    source = json[kRecordingModelSourceKey].string
    uri = json[kRecordingModelUriKey].string
    accountSid = json[kRecordingModelAccountSidKey].string
    price = json[kRecordingModelPriceKey].string
    status = json[kRecordingModelStatusKey].string
    errorCode = json[kRecordingModelErrorCodeKey].int
    apiVersion = json[kRecordingModelApiVersionKey].string
    dateUpdated = json[kRecordingModelDateUpdatedKey].string
    channels = json[kRecordingModelChannelsKey].int
    subresourceUris = RecordingSubresourceUris(json: json[kRecordingModelSubresourceUrisKey])
    callSid = json[kRecordingModelCallSidKey].string
    priceUnit = json[kRecordingModelPriceUnitKey].string
    dateCreated = json[kRecordingModelDateCreatedKey].string
    conferenceSid = json[kRecordingModelConferenceSidKey].string
    sid = json[kRecordingModelSidKey].string
    duration = json[kRecordingModelDurationKey].string
    startTime = json[kRecordingModelStartTimeKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = source { dictionary[kRecordingModelSourceKey] = value }
    if let value = uri { dictionary[kRecordingModelUriKey] = value }
    if let value = accountSid { dictionary[kRecordingModelAccountSidKey] = value }
    if let value = price { dictionary[kRecordingModelPriceKey] = value }
    if let value = status { dictionary[kRecordingModelStatusKey] = value }
    if let value = errorCode { dictionary[kRecordingModelErrorCodeKey] = value }
    if let value = apiVersion { dictionary[kRecordingModelApiVersionKey] = value }
    if let value = dateUpdated { dictionary[kRecordingModelDateUpdatedKey] = value }
    if let value = channels { dictionary[kRecordingModelChannelsKey] = value }
    if let value = subresourceUris { dictionary[kRecordingModelSubresourceUrisKey] = value.dictionaryRepresentation() }
    if let value = callSid { dictionary[kRecordingModelCallSidKey] = value }
    if let value = priceUnit { dictionary[kRecordingModelPriceUnitKey] = value }
    if let value = dateCreated { dictionary[kRecordingModelDateCreatedKey] = value }
    if let value = conferenceSid { dictionary[kRecordingModelConferenceSidKey] = value }
    if let value = sid { dictionary[kRecordingModelSidKey] = value }
    if let value = duration { dictionary[kRecordingModelDurationKey] = value }
    if let value = startTime { dictionary[kRecordingModelStartTimeKey] = value }
    return dictionary
  }

}
