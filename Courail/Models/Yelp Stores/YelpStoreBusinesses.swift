//
//  YelpStoreBusinesses.swift
//
//  Created by apple on 17/03/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import GooglePlaces

public struct YelpStoreBusinesses {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kYelpStoreBusinessesIsFavKey: String = "isFav"
    private let kYelpStoreBusinessesCourialFeeKey: String = "courialFee"
    private let kYelpStoreBusinessesAdditionalNotesKey: String = "additionalNotes"
    private let kYelpStoreBusinessesOver45LbsKey: String = "over45Lbs"
    private let kYelpStoreBusinessesSubTotalTypeKey: String = "subTotalType"
    private let kYelpStoreBusinessesReviewCountKey: String = "review_count"
    private let kYelpStoreBusinessesDisplayPhoneKey: String = "display_phone"
    private let kYelpStoreBusinessesInternalIdentifierKey: String = "id"
    private let kYelpStoreBusinessesDistanceKey: String = "distance"
    private let kYelpStoreBusinessesPhoneKey: String = "phone"
    private let kYelpStoreBusinessesImageUrlKey: String = "image_url"
    private let kYelpStoreBusinessesDurationKey: String = "duration"
    private let kYelpStoreBusinessesUrlKey: String = "url"
    private let kYelpStoreBusinessesDeliveryFeeKey: String = "deliveryFee"
    private let kYelpStoreBusinessesVehicleTypeIndexKey: String = "vehicleTypeIndex"
    private let kYelpStoreBusinessesNameKey: String = "name"
    private let kYelpStoreBusinessesCoordinatesKey: String = "coordinates"
    private let kYelpStoreBusinessesRatingKey: String = "rating"
    private let kYelpStoreBusinessesPickUpTimeKey: String = "pickUpTime"
    private let kYelpStoreBusinessesPriceKey: String = "price"
    private let kYelpStoreBusinessesAliasKey: String = "alias"
    private let kYelpStoreBusinessesVehicleTypeKey: String = "vehicleType"
    private let kYelpStoreBusinessesGooglePlaceIDKey: String = "googlePlaceID"
    private let kYelpStoreBusinessesItemSizeKey: String = "itemSize"
    private let kYelpStoreBusinessesLocationKey: String = "location"
    private let kYelpStoreBusinessesCategoriesKey: String = "categories"
    private let kYelpStoreBusinessesItemTypeKey: String = "itemType"
    private let kYelpStoreBusinessesDeliveryTimeKey: String = "deliveryTime"
    private let kYelpStoreBusinessesTransactionsKey: String = "transactions"
    private let kYelpStoreBusinessesItemDescriptionKey: String = "itemDescription"
    private let kYelpStoreBusinessesIsClosedKey: String = "is_closed"
    private let kYelpStoreBusinessesPointsKey: String = "points"
    private let kYelpStoreBusinessesCategoryKey: String = "category"
    
    private let serviceFeeKey: String = "serviceFee"
    
    private let webStoreTypeKey: String = "webStoreType"
    private let estimatedDeliveryTimeKey: String = "estimatedDeliveryTime"
    
    private let isWebStoreKey: String = "isWebStore"
    
    private let courialTipKey: String = "courialTip"
    
    private let openingHoursKey: String = "open"
    
    private let stairsElevatorFeeKey: String = "stairsElevatorFee"
    private let baseFeeKey: String = "baseFee"
    private let heavyFeeKey: String = "heavyFee"
    private let waitTimeFeeKey: String = "waitTimeFee"
    
    private let isReversedDelKey: String = "isReversedDel"
    private let courialDetailsKey: String = "courialDetails"
    private let orderStatusKey: String = "orderStatusKey"
    
    // MARK: Properties
    public var isFav: Bool = false
    public var courialFee: String?
    public var additionalNotes: String?
    public var over45Lbs: Bool = false
    public var subTotalType: String?
    public var reviewCount: Int?
    public var displayPhone: String?
    public var internalIdentifier: String?
    public var distance: String?
    public var phone: String?
    public var imageUrl: String?
    public var duration: String?
    public var url: String?
    public var deliveryFee: String?
    public var vehicleTypeIndex: Int?
    public var name: String?
    public var coordinates: YelpStoreCoordinates?
    public var rating: Float?
    public var pickUpTime: String?
    public var price: String?
    public var alias: String?
    public var vehicleType: String?
    public var googlePlaceID: String?
    public var itemSize: String?
    public var location: YelpStoreLocation?
    public var categories: [YelpStoreCategories]?
    public var itemType: String?
    public var deliveryTime: String?
    public var transactions: [Any]?
    public var itemDescription: String?
    public var isClosed: Bool = false
    public var points: [String]?
    public var favId = ""
    public var category: String?
    
    public var webStoreType: String?
    public var isWebStore : Bool = false
    
    public var serviceFee : String?
    
    public var orderID : String?
    public var promoApplied : Bool = false
    public var promoPrice : String?
    public var promoCode : String?
    public var hidePromo : Bool = false
    public var validPromo : Bool = true
    public var expiredPromo : Bool = false
    
    public var isSkillService : Bool = false
    
    public var courialTip : String?
    
    public var stairsElevatorFee: String?
    public var baseFee: String?
    public var heavyFee: String?
    public var waitTimeFee: String?
    
    public var openingHours: [OpenHoursModel]?
    
    var details : GMSPlace?
    var attachedPhoto = [UIImage]()
    
    var two_courial : Bool = false
    var estimatedDeliveryTime : String?
    
    var idReqYesNoSelected: Bool = false
    var itemCategorySelected: Bool = false
    var itemCategory: String?
    var totalFee : String?
    
    var dropAddress : AddressModel?
    var isReversedDel: Bool = false
    
    var courialDetails : CourialModel?
    public var orderStatus: String?
    
    var identificationImageURL : String?
    var attachedImagesURL : [String]?
    
    var estimatedServiceTime : String?
    var estimatedServiceOffer : String?
    
    var specialLink : String?
    
    var showIDWarning = false
    
    
    var imageCategoryURL = ""
    var imageCategoryColor = ""
    
    var isCannabis = false
    
    var tollFee = 0.0
    
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
        isFav = json[kYelpStoreBusinessesIsFavKey].boolValue
        isWebStore = json[isWebStoreKey].boolValue
        courialFee = json[kYelpStoreBusinessesCourialFeeKey].string
        additionalNotes = json[kYelpStoreBusinessesAdditionalNotesKey].string
        over45Lbs = json[kYelpStoreBusinessesOver45LbsKey].boolValue
        subTotalType = json[kYelpStoreBusinessesSubTotalTypeKey].string ?? "NONE"
        reviewCount = json[kYelpStoreBusinessesReviewCountKey].int
        displayPhone = json[kYelpStoreBusinessesDisplayPhoneKey].string
        internalIdentifier = json[kYelpStoreBusinessesInternalIdentifierKey].string
        distance = json[kYelpStoreBusinessesDistanceKey].stringValue
        phone = json[kYelpStoreBusinessesPhoneKey].string
        imageUrl = json[kYelpStoreBusinessesImageUrlKey].string
        duration = json[kYelpStoreBusinessesDurationKey].string
        url = json[kYelpStoreBusinessesUrlKey].string
        deliveryFee = json[kYelpStoreBusinessesDeliveryFeeKey].string
        vehicleTypeIndex = json[kYelpStoreBusinessesVehicleTypeIndexKey].int ?? 0
        name = json[kYelpStoreBusinessesNameKey].string
        coordinates = YelpStoreCoordinates(json: json[kYelpStoreBusinessesCoordinatesKey])
        rating = json[kYelpStoreBusinessesRatingKey].float
        pickUpTime = json[kYelpStoreBusinessesPickUpTimeKey].string ?? "Choose"
        price = json[kYelpStoreBusinessesPriceKey].string
        alias = json[kYelpStoreBusinessesAliasKey].string
        vehicleType = json[kYelpStoreBusinessesVehicleTypeKey].string
        googlePlaceID = json[kYelpStoreBusinessesGooglePlaceIDKey].string
        itemSize = json[kYelpStoreBusinessesItemSizeKey].string
        location = YelpStoreLocation(json: json[kYelpStoreBusinessesLocationKey])
        if let items = json[kYelpStoreBusinessesCategoriesKey].array { categories = items.map { YelpStoreCategories(json: $0) } }
        itemType = json[kYelpStoreBusinessesItemTypeKey].string
        deliveryTime = json[kYelpStoreBusinessesDeliveryTimeKey].string ?? "Choose"
        if let items = json[kYelpStoreBusinessesTransactionsKey].array { transactions = items.map { $0.object} }
        itemDescription = json[kYelpStoreBusinessesItemDescriptionKey].string
        isClosed = json[kYelpStoreBusinessesIsClosedKey].boolValue
        category = json[kYelpStoreBusinessesCategoryKey].string
        if let items = json[kYelpStoreBusinessesPointsKey].array { points = items.map { $0.stringValue } }
        
        serviceFee = json[serviceFeeKey].string
        courialTip = json[courialTipKey].string
        webStoreType = json[webStoreTypeKey].string
        estimatedDeliveryTime = json[estimatedDeliveryTimeKey].string
        
        stairsElevatorFee = json[stairsElevatorFeeKey].string
        baseFee = json[baseFeeKey].string
        heavyFee = json[heavyFeeKey].string
        waitTimeFee = json[waitTimeFeeKey].string
        
        isReversedDel = json[isReversedDelKey].bool ?? false
        
        courialDetails = CourialModel(json: json[courialDetailsKey])
        orderStatus = json[orderStatusKey].stringValue
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[kYelpStoreBusinessesIsFavKey] = isFav
        dictionary[isWebStoreKey] = isWebStore
        dictionary[isReversedDelKey] = isReversedDel
        
        if let value = courialFee { dictionary[kYelpStoreBusinessesCourialFeeKey] = value }
        if let value = additionalNotes { dictionary[kYelpStoreBusinessesAdditionalNotesKey] = value }
        dictionary[kYelpStoreBusinessesOver45LbsKey] = over45Lbs
        if let value = subTotalType { dictionary[kYelpStoreBusinessesSubTotalTypeKey] = value }
        if let value = reviewCount { dictionary[kYelpStoreBusinessesReviewCountKey] = value }
        if let value = displayPhone { dictionary[kYelpStoreBusinessesDisplayPhoneKey] = value }
        if let value = internalIdentifier { dictionary[kYelpStoreBusinessesInternalIdentifierKey] = value }
        if let value = distance { dictionary[kYelpStoreBusinessesDistanceKey] = value }
        if let value = phone { dictionary[kYelpStoreBusinessesPhoneKey] = value }
        if let value = imageUrl { dictionary[kYelpStoreBusinessesImageUrlKey] = value }
        if let value = duration { dictionary[kYelpStoreBusinessesDurationKey] = value }
        if let value = url { dictionary[kYelpStoreBusinessesUrlKey] = value }
        if let value = deliveryFee { dictionary[kYelpStoreBusinessesDeliveryFeeKey] = value }
        if let value = vehicleTypeIndex { dictionary[kYelpStoreBusinessesVehicleTypeIndexKey] = value }
        if let value = name { dictionary[kYelpStoreBusinessesNameKey] = value }
        if let value = coordinates { dictionary[kYelpStoreBusinessesCoordinatesKey] = value.dictionaryRepresentation() }
        if let value = rating { dictionary[kYelpStoreBusinessesRatingKey] = value }
        if let value = pickUpTime { dictionary[kYelpStoreBusinessesPickUpTimeKey] = value }
        if let value = price { dictionary[kYelpStoreBusinessesPriceKey] = value }
        if let value = alias { dictionary[kYelpStoreBusinessesAliasKey] = value }
        if let value = vehicleType { dictionary[kYelpStoreBusinessesVehicleTypeKey] = value }
        if let value = googlePlaceID { dictionary[kYelpStoreBusinessesGooglePlaceIDKey] = value }
        if let value = itemSize { dictionary[kYelpStoreBusinessesItemSizeKey] = value }
        if let value = location { dictionary[kYelpStoreBusinessesLocationKey] = value.dictionaryRepresentation() }
        if let value = categories { dictionary[kYelpStoreBusinessesCategoriesKey] = value.map { $0.dictionaryRepresentation() } }
        if let value = itemType { dictionary[kYelpStoreBusinessesItemTypeKey] = value }
        if let value = deliveryTime { dictionary[kYelpStoreBusinessesDeliveryTimeKey] = value }
        if let value = transactions { dictionary[kYelpStoreBusinessesTransactionsKey] = value }
        if let value = itemDescription { dictionary[kYelpStoreBusinessesItemDescriptionKey] = value }
        if let value = category { dictionary[kYelpStoreBusinessesCategoryKey] = value }
        dictionary[kYelpStoreBusinessesIsClosedKey] = isClosed
        if let value = points { dictionary[kYelpStoreBusinessesPointsKey] = value }
        
        if let value = webStoreType { dictionary[webStoreTypeKey] = value }
        if let value = estimatedDeliveryTime { dictionary[estimatedDeliveryTimeKey] = value }
        
        if let value = serviceFee { dictionary[serviceFeeKey] = value }
        if let value = courialTip { dictionary[courialTipKey] = value }
        
        if let value = stairsElevatorFee { dictionary[stairsElevatorFeeKey] = value }
        if let value = baseFee { dictionary[baseFeeKey] = value }
        if let value = heavyFee { dictionary[heavyFeeKey] = value }
        if let value = waitTimeFee { dictionary[waitTimeFeeKey] = value }
        
        if let value = courialDetails { dictionary[courialDetailsKey] = value.dictionaryRepresentation() }
        if let value = orderStatus { dictionary[orderStatusKey] = value }
        
        return dictionary
    }
}
