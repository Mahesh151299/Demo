//
//  UserInfoModel.swift
//
//  Created by Omeesh Sharma on 22/04/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct UserInfoModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kUserInfoModelIdKey: String = "id"
    private let kUserInfoModelEmailKey: String = "email"
    private let kUserInfoModelEmailVerifyKey: String = "emailVerify"
    private let kUserInfoModelDeviceTypeKey: String = "deviceType"
    private let kUserInfoModelTokenKey: String = "token"
    private let kUserInfoModelLastNameKey: String = "lastName"
    private let kUserInfoModelSelectedAddressKey: String = "selected_address"
    private let kUserInfoModelIsVerifiedKey: String = "isVerified"
    private let kUserInfoModelLatitudeKey: String = "latitude"
    private let kUserInfoModelDeviceTokenKey: String = "deviceToken"
    private let kUserInfoModelLocationKey: String = "location"
    private let kUserInfoModelInternalIdentifierKey: String = "id"
    private let kUserInfoModelImageKey: String = "image"
    private let kUserInfoModelCountryCodeKey: String = "countryCode"
    private let kUserInfoModelPhoneKey: String = "phone"
    private let kUserInfoModelFirstNameKey: String = "firstName"
    private let kUserInfoModelLongitudeKey: String = "longitude"
    private let kUserInfoModelCategoryNameKey: String = "categoryName"
    
    private let new_passwordKey: String = "new_password"
    private let card_defaultKey: String = "card_default"
    
    private let tiptypeKey: String = "tiptype"
    private let tipevalueKey: String = "tipevalue"
    private let isOtherTipKey: String = "isOther"
    private let refrelKey: String = "refrel"
    private let Identification_imageKey: String = "Identification_image"
    private let referralamountKey: String = "referralamount"
    
    private let instagramKey: String = "instagram"
    private let facebookKey: String = "facebook"
    private let twitterKey: String = "twitter"
    
    
    // MARK: Properties
    public var id: Int?
    public var email: String?
    public var emailVerify: Int?
    public var deviceType: Int?
    public var token: String?
    public var lastName: String?
    public var selectedAddress: AddressModel?
    public var isVerified: Int?
    public var latitude: String?
    public var deviceToken: String?
    public var location: String?
    public var internalIdentifier: Int?
    public var image: String?
    public var countryCode: String?
    public var phone: String?
    public var firstName: String?
    
    public var longitude: String?
    public var categoryName: String?
    
    public var new_password: String?
    public var card_default: CardModel?
    public var tiptype: String?
    public var tipevalue: String?
    public var isOtherTip: String?
    public var Identification_image: String?
    
    public var refrel: String?
    public var referralamount: Double?
    
    public var instagram: String?
    public var facebook: String?
    public var twitter: String?
    
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
        id = json[kUserInfoModelIdKey].int
        email = json[kUserInfoModelEmailKey].string
        emailVerify = json[kUserInfoModelEmailVerifyKey].int
        deviceType = json[kUserInfoModelDeviceTypeKey].int
        token = json[kUserInfoModelTokenKey].string
        lastName = json[kUserInfoModelLastNameKey].string
        selectedAddress = AddressModel(json: json[kUserInfoModelSelectedAddressKey])
        isVerified = json[kUserInfoModelIsVerifiedKey].int
        latitude = json[kUserInfoModelLatitudeKey].string
        deviceToken = json[kUserInfoModelDeviceTokenKey].string
        location = json[kUserInfoModelLocationKey].string
        internalIdentifier = json[kUserInfoModelInternalIdentifierKey].int
        image = json[kUserInfoModelImageKey].string
        countryCode = json[kUserInfoModelCountryCodeKey].string
        phone = json[kUserInfoModelPhoneKey].string
        firstName = json[kUserInfoModelFirstNameKey].string
        longitude = json[kUserInfoModelLongitudeKey].string
        categoryName = json[kUserInfoModelCategoryNameKey].string
        
        refrel = json[refrelKey].stringValue
        
        new_password = json[new_passwordKey].string
        card_default = CardModel(json: json[card_defaultKey])
        tiptype = json[tiptypeKey].stringValue
        tipevalue = json[tipevalueKey].stringValue
        isOtherTip = json[isOtherTipKey].stringValue
        
        referralamount = json[referralamountKey].doubleValue
        
        Identification_image = json[Identification_imageKey].stringValue
        
        instagram = json[instagramKey].stringValue
        facebook = json[facebookKey].stringValue
        twitter = json[twitterKey].stringValue
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = id { dictionary[kUserInfoModelIdKey] = value }
        if let value = email { dictionary[kUserInfoModelEmailKey] = value }
        if let value = emailVerify { dictionary[kUserInfoModelEmailVerifyKey] = value }
        if let value = deviceType { dictionary[kUserInfoModelDeviceTypeKey] = value }
        if let value = token { dictionary[kUserInfoModelTokenKey] = value }
        if let value = lastName { dictionary[kUserInfoModelLastNameKey] = value }
        if let value = selectedAddress { dictionary[kUserInfoModelSelectedAddressKey] = value.dictionaryRepresentation() }
        if let value = isVerified { dictionary[kUserInfoModelIsVerifiedKey] = value }
        if let value = latitude { dictionary[kUserInfoModelLatitudeKey] = value }
        if let value = deviceToken { dictionary[kUserInfoModelDeviceTokenKey] = value }
        if let value = location { dictionary[kUserInfoModelLocationKey] = value }
        if let value = internalIdentifier { dictionary[kUserInfoModelInternalIdentifierKey] = value }
        if let value = image { dictionary[kUserInfoModelImageKey] = value }
        if let value = countryCode { dictionary[kUserInfoModelCountryCodeKey] = value }
        if let value = phone { dictionary[kUserInfoModelPhoneKey] = value }
        if let value = firstName { dictionary[kUserInfoModelFirstNameKey] = value }
        if let value = longitude { dictionary[kUserInfoModelLongitudeKey] = value }
        if let value = categoryName { dictionary[kUserInfoModelCategoryNameKey] = value }
        
        if let value = new_password { dictionary[new_passwordKey] = value }
        if let value = card_default { dictionary[card_defaultKey] = value.dictionaryRepresentation() }
        
        if let value = refrel { dictionary[refrelKey] = value }
        
        if let value = tiptype { dictionary[tiptypeKey] = value }
        if let value = tipevalue { dictionary[tipevalueKey] = value }
        if let value = isOtherTip { dictionary[isOtherTipKey] = value }
        if let value = referralamount { dictionary[referralamountKey] = value }
        
        if let value = Identification_image { dictionary[Identification_imageKey] = value }
        
        if let value = instagram { dictionary[instagramKey] = value }
        if let value = facebook { dictionary[facebookKey] = value }
        if let value = twitter { dictionary[twitterKey] = value }
        return dictionary
    }
    
}
