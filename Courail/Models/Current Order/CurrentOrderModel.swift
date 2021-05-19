//
//  CurrentOrderModel.swift
//
//  Created by Omeesh Sharma on 20/08/20
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CurrentOrderModel {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private let kCurrentOrderModelIsFavKey: String = "isFav"
    private let kCurrentOrderModelIsRequestedKey: String = "isRequested"
    private let kCurrentOrderModel2CourialsKey: String = "2Courials"
    private let kCurrentOrderModelCourialPayFeeKey: String = "courialPayFee"
    private let kCurrentOrderModelTakeDeliveryPhotoKey: String = "takeDeliveryPhoto"
    private let kCurrentOrderModelServiceFeeKey: String = "service_fee"
    private let kCurrentOrderModelCardIdKey: String = "card_id"
    private let kCurrentOrderModelSubTotalTypeKey: String = "subTotalType"
    private let kCurrentOrderModelCostKey: String = "cost"
    private let kCurrentOrderModelPickupInfoKey: String = "pickupInfo"
    private let kCurrentOrderModelWebStoreTypeKey: String = "webStoreType"
    private let kCurrentOrderModelInternalIdentifierKey: String = "id"
    private let kCurrentOrderModelImageKey: String = "image"
    private let kCurrentOrderModelEstimatedTimeKey: String = "estimated_time"
    private let kCurrentOrderModelItemCostKey: String = "itemCost"
    private let kCurrentOrderModelPromoDiscountKey: String = "promo_discount"
    private let kCurrentOrderModelUrlKey: String = "url"
    private let kCurrentOrderModelBaseFeeKey: String = "baseFee"
    private let kCurrentOrderModelTrasnportModeKey: String = "trasnport_mode"
    private let kCurrentOrderModelEstimatedTotalPriceKey: String = "estimated_total_price"
    private let kCurrentOrderModelOver45LbsKey: String = "over45Lbs"
    private let kCurrentOrderModelGoogleDurationKey: String = "google_duration"
    private let kCurrentOrderModelCreatedAtKey: String = "created_at"
    private let kCurrentOrderModelFinalPriceKey: String = "final_price"
    private let kCurrentOrderModelDropOffWaitChargesKey: String = "drop_off_wait_charges"
    private let kCurrentOrderModelProviderKey: String = "Provider"
    private let kCurrentOrderModelPickUpNotesKey: String = "pick_up_notes"
    private let kCurrentOrderModelIsWebStoreKey: String = "isWebStore"
    private let kCurrentOrderModelPickupWaitKey: String = "pickup_wait"
    private let kCurrentOrderModelGoogleDistanceKey: String = "google_distance"
    private let kCurrentOrderModelCategoryKey: String = "category"
    private let kCurrentOrderModelDropOffWaitKey: String = "drop_off_wait"
    private let kCurrentOrderModelDeliveryInfoKey: String = "deliveryInfo"
    private let kCurrentOrderModelOrderidKey: String = "orderid"
    private let kCurrentOrderModelStorePhoneKey: String = "storePhone"
    private let kCurrentOrderModelCourialTipKey: String = "courial_tip"
    private let kCurrentOrderModelPromocodeidKey: String = "promocodeid"
    private let kCurrentOrderModelUseridKey: String = "userid"
    private let kCurrentOrderModelDeliveryFeeKey: String = "deliveryFee"
    private let kCurrentOrderModelEstimatedArrivalKey: String = "estimated_arrival"
    private let kCurrentOrderModelNameKey: String = "name"
    private let kCurrentOrderModelItemNameKey: String = "item_name"
    private let kCurrentOrderModelUpdatedAtKey: String = "updated_at"
    private let kCurrentOrderModelIdentificationImageKey: String = "Identification_image"
    private let kCurrentOrderModelIsReversedDelKey: String = "is_reversed_del"
    private let kCurrentOrderModelPickUpTimeKey: String = "pickUpTime"
    private let kCurrentOrderModelPickupWaitChargesKey: String = "pickup_wait_charges"
    private let kCurrentOrderModelGooglePlaceIDKey: String = "googlePlaceID"
    private let kCurrentOrderModelStatusKey: String = "status"
    private let kCurrentOrderModelPromocodeKey: String = "promocode"
    private let kCurrentOrderModelHeavyFeeKey: String = "heavyFee"
    private let kCurrentOrderModelOrderimagesKey: String = "orderimages"
    private let kCurrentOrderModelProviderIdKey: String = "providerId"
    private let kCurrentOrderModelStairsElevatorFeeKey: String = "stairsElevatorFee"
    private let kCurrentOrderModelIsClosedKey: String = "is_closed"
    private let PickupPointArrivalTimeKey: String = "PickupPointArrivalTime"
    private let DeliveryPointArrivalTimeKey: String = "DeliveryPointArrivalTime"
    private let vehicleTypeIndexKey: String = "vehicleTypeIndex"
    
    private let totalPauseTimeKey: String = "totalPauseTime"
    private let pausePlayDateKey: String = "pausePlayDate"
    private let isPlayedKey: String = "isPlayed"
    
    private let delivery_complete_dateKey: String = "delivery_complete_date"
    private let is_rateKey: String = "is_rate"
    
    private let estimatedServiceOfferKey: String = "estimatedServiceOffer"
    private let estimatedServiceTimeKey: String = "estimatedServiceTime"
    private let isSkillKey: String = "isSkill"
    
    private let secondCourialKey: String = "secondCourial"
    
    private let categoryImageKey: String = "categoryImage"
    private let categoryImageColorKey: String = "categoryImageColor"
    
    private let card_numberKey: String = "card_number"
    private let card_typeKey: String = "card_type"
    
    private let cancelAmountKey: String = "cancelamount"
    
    private let actualCourialPayAmountKey: String = "courialpayamount"
    private let actualCourialPayReceiptKey: String = "courialpayreciptImage"
    
    private let confirmOrdertimeKey: String = "confirmOrdertime"
    
    private let updateitemcostKey: String = "updateitemcost"
    
    private let specialLinkKey: String = "special_link"
    
    private let kDeliveryPhotoverifyKey: String = "DeliveryPhotoverify"
    
    
    
    // MARK: Properties
    public var isFav: String?
    public var twoCourials: String?
    public var courialPayFee: String?
    public var takeDeliveryPhoto: String?
    public var serviceFee: String?
    public var cardId: String?
    public var subTotalType: String?
    public var cost: String?
    public var pickupInfo: CurrentOrderPickupInfo?
    public var webStoreType: String?
    public var internalIdentifier: Int?
    public var image: String?
    public var estimatedTime: String?
    public var itemCost: String?
    public var specialLink: String?
    public var promoDiscount: String?
    public var url: String?
    public var baseFee: String?
    public var trasnportMode: String?
    public var estimatedTotalPrice: String?
    public var over45Lbs: String?
    public var googleDuration: String?
    public var createdAt: Int?
    public var finalPrice: String?
    public var dropOffWaitCharges: String?
    public var provider: CurrentOrderProvider?
    public var secondCourial: CurrentOrderProvider?
    public var pickUpNotes: String?
    public var isWebStore: String?
    public var pickupWait: String?
    public var googleDistance: String?
    public var category: String?
    public var dropOffWait: String?
    public var deliveryInfo: CurrentOrderDeliveryInfo?
    public var orderid: String?
    public var storePhone: String?
    public var courialTip: String?
    public var promocodeid: Int?
    public var userid: Int?
    public var deliveryFee: String?
    public var estimatedArrival: String?
    public var name: String?
    public var itemName: String?
    public var updatedAt: Int?
    public var identificationImage: String?
    public var isReversedDel: Int?
    public var isRequested: Int?
    public var pickUpTime: String?
    public var pickupWaitCharges: String?
    public var googlePlaceID: String?
    public var status: Int?
    public var promocode: String?
    public var heavyFee: String?
    public var orderimages: [CurrentOrderOrderimages]?
    public var providerId: String?
    public var stairsElevatorFee: String?
    public var isClosed: String?
    public var vehicleTypeIndex: String?
    
    public var PickupPointArrivalTime: String?
    public var DeliveryPointArrivalTime: String?
    
    public var totalPauseTime: String?
    public var pausePlayDate: String?
    public var isPlayed: String?
    
    public var confirmOrdertime: Int?
    
    public var card_number: String?
    public var card_type: String?
    
    public var cancelAmount: Double?
    
    public var updateitemcost, DeliveryPhotoverify: Int?
    
    public var delivery_complete_date: String?
    
    public var isRate: String?
    public var isSkill: String?
    public var estimatedServiceOffer: String?
    public var estimatedServiceTime: String?
    
    public var actualCourialPayAmount: Double?
    public var actualCourialPayReceipt: String?
    
    public var categoryImage, categoryImageColor: String?
    
    public var nearbyPartnersCount = 1
    
    
    var livePathDuration = 0
    var livePathDistance = 0
    var livePathEstimatedTime = 0
    
    var points : [String]?
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
        DeliveryPhotoverify = json[kDeliveryPhotoverifyKey].int
        isFav = json[kCurrentOrderModelIsFavKey].string
        twoCourials = json[kCurrentOrderModel2CourialsKey].string
        courialPayFee = json[kCurrentOrderModelCourialPayFeeKey].string
        takeDeliveryPhoto = json[kCurrentOrderModelTakeDeliveryPhotoKey].string
        serviceFee = json[kCurrentOrderModelServiceFeeKey].string
        cardId = json[kCurrentOrderModelCardIdKey].string
        subTotalType = json[kCurrentOrderModelSubTotalTypeKey].string
        cost = json[kCurrentOrderModelCostKey].string
        pickupInfo = CurrentOrderPickupInfo(json: json[kCurrentOrderModelPickupInfoKey])
        webStoreType = json[kCurrentOrderModelWebStoreTypeKey].string
        internalIdentifier = json[kCurrentOrderModelInternalIdentifierKey].int
        image = json[kCurrentOrderModelImageKey].string
        estimatedTime = json[kCurrentOrderModelEstimatedTimeKey].string
        itemCost = json[kCurrentOrderModelItemCostKey].string
        promoDiscount = json[kCurrentOrderModelPromoDiscountKey].string
        url = json[kCurrentOrderModelUrlKey].string
        baseFee = json[kCurrentOrderModelBaseFeeKey].string
        trasnportMode = json[kCurrentOrderModelTrasnportModeKey].string
        estimatedTotalPrice = json[kCurrentOrderModelEstimatedTotalPriceKey].string
        over45Lbs = json[kCurrentOrderModelOver45LbsKey].string
        googleDuration = json[kCurrentOrderModelGoogleDurationKey].string
        createdAt = json[kCurrentOrderModelCreatedAtKey].int
        finalPrice = json[kCurrentOrderModelFinalPriceKey].string
        dropOffWaitCharges = json[kCurrentOrderModelDropOffWaitChargesKey].string
        
        specialLink = json[specialLinkKey].string
        
        provider = CurrentOrderProvider(json: json[kCurrentOrderModelProviderKey])
        secondCourial = CurrentOrderProvider(json: json[secondCourialKey])
        
        pickUpNotes = json[kCurrentOrderModelPickUpNotesKey].string
        isWebStore = json[kCurrentOrderModelIsWebStoreKey].string
        pickupWait = json[kCurrentOrderModelPickupWaitKey].string
        googleDistance = json[kCurrentOrderModelGoogleDistanceKey].string
        category = json[kCurrentOrderModelCategoryKey].string
        dropOffWait = json[kCurrentOrderModelDropOffWaitKey].string
        deliveryInfo = CurrentOrderDeliveryInfo(json: json[kCurrentOrderModelDeliveryInfoKey])
        orderid = json[kCurrentOrderModelOrderidKey].string
        storePhone = json[kCurrentOrderModelStorePhoneKey].string
        courialTip = json[kCurrentOrderModelCourialTipKey].string
        promocodeid = json[kCurrentOrderModelPromocodeidKey].int
        userid = json[kCurrentOrderModelUseridKey].int
        deliveryFee = json[kCurrentOrderModelDeliveryFeeKey].string
        estimatedArrival = json[kCurrentOrderModelEstimatedArrivalKey].string
        name = json[kCurrentOrderModelNameKey].string
        itemName = json[kCurrentOrderModelItemNameKey].string
        updatedAt = json[kCurrentOrderModelUpdatedAtKey].int
        identificationImage = json[kCurrentOrderModelIdentificationImageKey].string
        isReversedDel = json[kCurrentOrderModelIsReversedDelKey].int
        isRequested = json[kCurrentOrderModelIsRequestedKey].int
        pickUpTime = json[kCurrentOrderModelPickUpTimeKey].string
        pickupWaitCharges = json[kCurrentOrderModelPickupWaitChargesKey].string
        googlePlaceID = json[kCurrentOrderModelGooglePlaceIDKey].string
        status = json[kCurrentOrderModelStatusKey].int
        promocode = json[kCurrentOrderModelPromocodeKey].string
        heavyFee = json[kCurrentOrderModelHeavyFeeKey].string
        if let items = json[kCurrentOrderModelOrderimagesKey].array { orderimages = items.map { CurrentOrderOrderimages(json: $0) } }
        providerId = json[kCurrentOrderModelProviderIdKey].string
        stairsElevatorFee = json[kCurrentOrderModelStairsElevatorFeeKey].string
        isClosed = json[kCurrentOrderModelIsClosedKey].string
        PickupPointArrivalTime = json[PickupPointArrivalTimeKey].string
        DeliveryPointArrivalTime = json[DeliveryPointArrivalTimeKey].string
        vehicleTypeIndex = json[vehicleTypeIndexKey].string
        
        totalPauseTime = json[totalPauseTimeKey].string
        pausePlayDate = json[pausePlayDateKey].string
        isPlayed = json[isPlayedKey].string
        delivery_complete_date = json[delivery_complete_dateKey].string
        isRate = json[is_rateKey].string
        
        isSkill = json[isSkillKey].stringValue
        estimatedServiceTime = json[estimatedServiceTimeKey].stringValue
        estimatedServiceOffer = json[estimatedServiceOfferKey].stringValue
        
        categoryImage = json[categoryImageKey].stringValue
        categoryImageColor = json[categoryImageColorKey].stringValue
        
        card_number = json[card_numberKey].stringValue
        card_type = json[card_typeKey].stringValue
        
        cancelAmount = json[cancelAmountKey].doubleValue
        
        actualCourialPayAmount = json[actualCourialPayAmountKey].doubleValue
        actualCourialPayReceipt = json[actualCourialPayReceiptKey].stringValue
        
        confirmOrdertime = json[confirmOrdertimeKey].intValue
        
        updateitemcost = json[updateitemcostKey].intValue
        
    }
    
    /**
     Generates description of the object in the form of a NSDictionary.
     - returns: A Key value pair containing all valid values in the object.
     */
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = DeliveryPhotoverify {dictionary[kDeliveryPhotoverifyKey] = value}
        if let value = isFav { dictionary[kCurrentOrderModelIsFavKey] = value }
        if let value = twoCourials { dictionary[kCurrentOrderModel2CourialsKey] = value }
        if let value = courialPayFee { dictionary[kCurrentOrderModelCourialPayFeeKey] = value }
        if let value = takeDeliveryPhoto { dictionary[kCurrentOrderModelTakeDeliveryPhotoKey] = value }
        if let value = serviceFee { dictionary[kCurrentOrderModelServiceFeeKey] = value }
        if let value = cardId { dictionary[kCurrentOrderModelCardIdKey] = value }
        if let value = subTotalType { dictionary[kCurrentOrderModelSubTotalTypeKey] = value }
        if let value = cost { dictionary[kCurrentOrderModelCostKey] = value }
        if let value = pickupInfo { dictionary[kCurrentOrderModelPickupInfoKey] = value.dictionaryRepresentation() }
        if let value = webStoreType { dictionary[kCurrentOrderModelWebStoreTypeKey] = value }
        if let value = internalIdentifier { dictionary[kCurrentOrderModelInternalIdentifierKey] = value }
        if let value = image { dictionary[kCurrentOrderModelImageKey] = value }
        if let value = estimatedTime { dictionary[kCurrentOrderModelEstimatedTimeKey] = value }
        if let value = itemCost { dictionary[kCurrentOrderModelItemCostKey] = value }
        if let value = promoDiscount { dictionary[kCurrentOrderModelPromoDiscountKey] = value }
        if let value = url { dictionary[kCurrentOrderModelUrlKey] = value }
        if let value = baseFee { dictionary[kCurrentOrderModelBaseFeeKey] = value }
        if let value = trasnportMode { dictionary[kCurrentOrderModelTrasnportModeKey] = value }
        if let value = estimatedTotalPrice { dictionary[kCurrentOrderModelEstimatedTotalPriceKey] = value }
        if let value = over45Lbs { dictionary[kCurrentOrderModelOver45LbsKey] = value }
        if let value = googleDuration { dictionary[kCurrentOrderModelGoogleDurationKey] = value }
        if let value = createdAt { dictionary[kCurrentOrderModelCreatedAtKey] = value }
        if let value = finalPrice { dictionary[kCurrentOrderModelFinalPriceKey] = value }
        if let value = dropOffWaitCharges { dictionary[kCurrentOrderModelDropOffWaitChargesKey] = value }
        
        if let value = specialLink { dictionary[specialLinkKey] = value }
        
        if let value = provider { dictionary[kCurrentOrderModelProviderKey] = value.dictionaryRepresentation() }
        if let value = secondCourial { dictionary[secondCourialKey] = value.dictionaryRepresentation() }
        
        if let value = pickUpNotes { dictionary[kCurrentOrderModelPickUpNotesKey] = value }
        if let value = isWebStore { dictionary[kCurrentOrderModelIsWebStoreKey] = value }
        if let value = pickupWait { dictionary[kCurrentOrderModelPickupWaitKey] = value }
        if let value = googleDistance { dictionary[kCurrentOrderModelGoogleDistanceKey] = value }
        if let value = category { dictionary[kCurrentOrderModelCategoryKey] = value }
        if let value = dropOffWait { dictionary[kCurrentOrderModelDropOffWaitKey] = value }
        if let value = deliveryInfo { dictionary[kCurrentOrderModelDeliveryInfoKey] = value.dictionaryRepresentation() }
        if let value = orderid { dictionary[kCurrentOrderModelOrderidKey] = value }
        if let value = storePhone { dictionary[kCurrentOrderModelStorePhoneKey] = value }
        if let value = courialTip { dictionary[kCurrentOrderModelCourialTipKey] = value }
        if let value = promocodeid { dictionary[kCurrentOrderModelPromocodeidKey] = value }
        if let value = userid { dictionary[kCurrentOrderModelUseridKey] = value }
        if let value = deliveryFee { dictionary[kCurrentOrderModelDeliveryFeeKey] = value }
        if let value = estimatedArrival { dictionary[kCurrentOrderModelEstimatedArrivalKey] = value }
        if let value = name { dictionary[kCurrentOrderModelNameKey] = value }
        if let value = itemName { dictionary[kCurrentOrderModelItemNameKey] = value }
        if let value = updatedAt { dictionary[kCurrentOrderModelUpdatedAtKey] = value }
        if let value = identificationImage { dictionary[kCurrentOrderModelIdentificationImageKey] = value }
        if let value = isReversedDel { dictionary[kCurrentOrderModelIsReversedDelKey] = value }
        if let value = isRequested { dictionary[kCurrentOrderModelIsRequestedKey] = value }
        if let value = pickUpTime { dictionary[kCurrentOrderModelPickUpTimeKey] = value }
        if let value = pickupWaitCharges { dictionary[kCurrentOrderModelPickupWaitChargesKey] = value }
        if let value = googlePlaceID { dictionary[kCurrentOrderModelGooglePlaceIDKey] = value }
        if let value = status { dictionary[kCurrentOrderModelStatusKey] = value }
        if let value = promocode { dictionary[kCurrentOrderModelPromocodeKey] = value }
        if let value = heavyFee { dictionary[kCurrentOrderModelHeavyFeeKey] = value }
        if let value = orderimages { dictionary[kCurrentOrderModelOrderimagesKey] = value.map { $0.dictionaryRepresentation() } }
        if let value = providerId { dictionary[kCurrentOrderModelProviderIdKey] = value }
        if let value = stairsElevatorFee { dictionary[kCurrentOrderModelStairsElevatorFeeKey] = value }
        if let value = isClosed { dictionary[kCurrentOrderModelIsClosedKey] = value }
        if let value = PickupPointArrivalTime { dictionary[PickupPointArrivalTimeKey] = value }
        if let value = DeliveryPointArrivalTime { dictionary[DeliveryPointArrivalTimeKey] = value }
        if let value = vehicleTypeIndex { dictionary[vehicleTypeIndexKey] = value }
        
        if let value = totalPauseTime { dictionary[totalPauseTimeKey] = value }
        if let value = pausePlayDate { dictionary[pausePlayDateKey] = value }
        if let value = isPlayed { dictionary[isPlayedKey] = value }
        if let value = delivery_complete_date { dictionary[delivery_complete_dateKey] = value }
        
        if let value = isRate { dictionary[is_rateKey] = value }
        
        if let value = isSkill { dictionary[isSkillKey] = value }
        if let value = estimatedServiceTime { dictionary[estimatedServiceTimeKey] = value }
        if let value = estimatedServiceOffer { dictionary[estimatedServiceOfferKey] = value }
        
        if let value = categoryImage { dictionary[categoryImageKey] = value }
        if let value = categoryImageColor { dictionary[categoryImageColorKey] = value }
        
        if let value = card_number { dictionary[card_numberKey] = value }
        if let value = card_type { dictionary[card_typeKey] = value }
        
        if let value = cancelAmount { dictionary[cancelAmountKey] = value }
        
        if let value = confirmOrdertime { dictionary[confirmOrdertimeKey] = value }
        
        if let value = actualCourialPayAmount { dictionary[actualCourialPayAmountKey] = value }
        if let value = actualCourialPayReceipt { dictionary[actualCourialPayReceiptKey] = value }
        
        if let value = updateitemcost { dictionary[updateitemcostKey] = value }
        
        return dictionary
    }
    
}
