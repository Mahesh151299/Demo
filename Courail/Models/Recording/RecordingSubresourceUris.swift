//
//  RecordingSubresourceUris.swift
//
//  Created by Omeesh Sharma on 01/05/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct RecordingSubresourceUris {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kRecordingSubresourceUrisTranscriptionsKey: String = "transcriptions"
  private let kRecordingSubresourceUrisAddOnResultsKey: String = "add_on_results"

  // MARK: Properties
  public var transcriptions: String?
  public var addOnResults: String?

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
    transcriptions = json[kRecordingSubresourceUrisTranscriptionsKey].string
    addOnResults = json[kRecordingSubresourceUrisAddOnResultsKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = transcriptions { dictionary[kRecordingSubresourceUrisTranscriptionsKey] = value }
    if let value = addOnResults { dictionary[kRecordingSubresourceUrisAddOnResultsKey] = value }
    return dictionary
  }

}
