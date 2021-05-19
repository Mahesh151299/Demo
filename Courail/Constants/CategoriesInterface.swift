//
//  CategoriesInterface.swift
//  Courail
//
//  Created by Omeesh Sharma on 01/06/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

var specialCat = JSON([
    "category":"Special",
    "icon":"imgSpecial",
    "hex":"F1F2F3",
    "info":""
])

var appCategories = JSON([
    [
        "category":"Convenience",
        "icon":"imgConveniencestore",
        "hex":"F1F2F3",
        "info":"Loading Convenience Stores",
        "count":0,
        "terms":"Convenience Stores",
        "keywords": "Convenience Stores, 7-Eleven"
        //"Convenience stores, beer, wine & spirits, drugstores, cosmetics & beauty, delis, grocery, 7-Eleven, sandwiches, gas stations, markets"
    ],
    [
        "category":"Grocery",
        "icon":"imgGrocery",
        "hex":"F1F2F3",
        "info":"Loading Grocery Stores",
        "count":0,
        "terms":"Grocery, Supermarkets",
        "keywords": ""
        
        //"grocery, meat shops, delis, seafood market, Stew Leonard's, New Seasons Market, Fairway Market, The Fresh Market, Hannaford, WinCo Foods, Hy-Vee, Safeway, Meijer, Albertsons, Kroger, Target, Costco, Harris Teeter, Whole Foods Market, Lidl, Trader Joe's, Aldi, Wegmans, Publix, Walmart, Sam's Club, Ahold Delhaize, H.E. But Grocery, Meijer, Wakefern Food, Harris Tweeter, Smith's, Vons, Food Lion, Stop & Shop, Hannaford banners, ShopRite, Price Rite, The Fresh Grocer, Dearborn Market, Gourmet Garage"
    ],
    [
        "category":"Pharmacy",
        "icon":"imgPharmacy",
        "hex":"F1F2F3",
        "info":"Loading Pharmacies",
        "count":0,
        "terms":"Pharmacy",
        "keywords":"Pharmacy, CVS, Walgreens, drugstores"
    ],
    [
        "category":"Coffee & Tea",
        "icon":"imgCoffee",
        "hex":"F1F2F3",
        "info":"Loading Coffee & Tea Shops",
        "count":0,
        "terms":"Coffee & Tea",
        "keywords": ""
        
//            "Starbucks,Coffee Bean and Tea Leaf,Tim Hortons, Biggby Coffee, Dutch Bros, Dunkin', Peet's Coffee, Caribou Coffee, La Colombe, Blue Bottle Coffee Company, bubble tea, juice bars & smoothies, tea rooms, delis, cafes, bakeries, desserts"
    ],
    [
        "category":"Take Out",
        "icon":"imgTakeout",
        "hex":"F1F2F3",
        "info":"Loading Take Out Options",
        "count":0,
        "terms":"Restaurants",
        "keywords":""
        //fast food
    ],
    [
        "category":"Alcohol",
        "icon":"imgSpirits",
        "hex":"F1F2F3",
        "info":"Loading Alcoholic Beverages",
        "count":0,
        "terms":"Spirits",
        "keywords":"Spirits, bevmo, bear, wines, 7-Eleven, drug stores"
    ],
    [
        "category":"Office",
        "icon":"imgOffice",
        "hex":"F1F2F3",
        "info":"Loading Office Supplies",
        "count":0,
        "terms":"Office Equipment",
        "keywords":"Office, IT, staples, office supplies, office equipments"
    ],
    [
        "category":"Mail & Ship",
        "icon":"imgMail",
        "hex":"F1F2F3",
        "info":"Loading MAIL & SHIPPING OPTIONS",
        "count":0,
        "terms":"Shipping",
        "keywords":"Shipping, post office, shipping centers, mailbox, fedex office print & ship, UPS Store, DHL"
    ],
    [
        "category":"Dry Clean",
        "icon":"imgLaundry",
        "hex":"F1F2F3",
        "info":"Loading Dry Cleaners",
        "count":0,
        "terms":"Dry Clean",
        "keywords": "Dry Clean, Laundry"
        //"dry cleaning & Laundry, laundromats"
    ],
    [
        "category":"Fashion",
        "icon":"imgFashion",
        "hex":"F1F2F3",
        "info":"Loading Fashion Stores",
        "count":0,
        "terms":"Department Stores",
        "keywords":"Fashion, department stores, men’s clothing, women’s clothing, accessories"
    ],
    [
        "category":"Beauty",
        "icon":"imgSalon",
        "hex":"F1F2F3",
        "info":"Loading Beauty Stores",
        "count":0,
        "terms":"Beauty",
        "keywords":"Beauty, Cosmetics, Beauty Supply, makeup artist, mac cosmetics"
    ],
    [
        "category":"Home Decor",
        "icon":"imgHomeDecor",
        "hex":"F1F2F3",
        "info":"Loading Home Décor Stores",
        "count":0,
        "terms":"Home Decor, Furniture",
        "keywords":""
    ],
    [
        "category":"Computers",
        "icon":"imgComputer",
        "hex":"F1F2F3",
        "info":"Loading Computer Stores",
        "count":0,
        "terms":"Computers",
        "keywords":""
    ],
    [
        "category":"Phones",
        "icon":"imgPhones",
        "hex":"F1F2F3",
        "info":"Loading Mobile Phone Stores",
        "count":0,
        "terms":"Mobile Phones",
        "keywords":"Mobile Phones, mobile phone repiar, mobile phone accessories, apple store, T-Mobile, Verizon, AT&T , sprint"
    ],
    [
        "category":"Electronics",
        "icon":"imgElectronics",
        "hex":"F1F2F3",
        "info":"Loading Electronic Stores",
        "count":0,
        "terms":"Electronics",
        "keywords":"Electronics, best buy, apple store, Costco, target"
    ],
    [
        "category":"Hardware",
        "icon":"imgHardware",
        "hex":"F1F2F3",
        "info":"Loading Hardware Stores",
        "count":0,
        "terms":"Hardware, the home depot",
        "keywords": "Hardware, appliances"
    ],
    [
        "category":"Toys",
        "icon":"imgToys",
        "hex":"F1F2F3",
        "info":"Loading Toy Stores",
        "count":0,
        "terms":"Toys",
        "keywords":""
    ],
    [
        "category":"Games",
        "icon":"imgVidGames",
        "hex":"F1F2F3",
        "info":"Loading Video Games Stores",
        "count":0,
        "terms":"Video Games",
        "keywords":"Video Games, video game rental, cards, toys"
    ],
    [
        "category":"Baby",
        "icon":"imgBaby",
        "hex":"F1F2F3",
        "info":"Loading Baby Supply Stores",
        "count":0,
        "terms":"Baby Stores",
        "keywords":"baby stores, baby gear & furniture, grocery stores"
    ],
    [
        "category":"Pets",
        "icon":"imgPetStuff",
        "hex":"F1F2F3",
        "info":"Loading Pet Stuff Shops",
        "count":0,
        "terms":"Pets",
        "keywords":"Pet Stuff, Petco, PetSmart, pet supplies, pet stores"
    ],
    [
        "category":"Gas Stations",
        "icon":"imgGasStation",
        "hex":"F1F2F3",
        "info":"Loading Gas Stations",
        "count":0,
        "terms":"Gas Stations",
        "keywords":""
    ],
    [
        "category":"Florists",
        "icon":"imgFlourists",
        "hex":"F1F2F3",
        "info":"Loading Florists Shops",
        "count":0,
        "terms":"Florists",
        "keywords":"Florists, floral designers"
    ],
    [
        "category":"Sporting",
        "icon":"imgSporting",
        "hex":"F1F2F3",
        "info":"Loading Sporting Goods",
        "count":0,
        "terms":"Sporting goods",
        "keywords":"sporting goods, outdoor sporting goods, Bikes, hunting & fishing"
    ],
    [
        "category":"Luggage",
        "icon":"imgLuggage",
        "hex":"F1F2F3",
        "info":"Loading Luggage",
        "count":0,
        "terms":"Luggage",
        "keywords":"luggage, samsonite, department stores"
    ],
    [
        "category":"Adult",
        "icon":"imgAdult",
        "hex":"F1F2F3",
        "info":"Loading Adult Stores",
        "count":0,
        "terms":"Adult",
        "keywords":"adult, adult stores, lingerie"
    ],
    [
        "category":"Eyewear",
        "icon":"imgCannabis",
        "hex":"F1F2F3",
        "info":"Loading Eyewear",
        "count":0,
        "terms":"Eyewear",
        "keywords":"eyewear, opticians, LensCrafters"
//        cannabis dispensary, cannabis company, cannabis
    ],
    [
        "category":"Cigarette",
        "icon":"imgCigarettes",
        "hex":"F1F2F3",
        "info":"Loading Cigarettes",
        "count":0,
        "terms":"Cigarette",
        "keywords": "Cigarette, Convenience Stores"
//            "7-Eleven, tobacco shops, head shops, drugstores, vape shops, grocery, liquor store, convenience stores"
    ],
    [
        "category":"Last Mile",
        "icon":"imgLocal-biz",
        "hex":"F1F2F3",
        "info":"",
        "count":0,
        "terms":"",
        "keywords": ""
    ],
//    [
//        "category":"Books",
//        "icon":"imgBooks",
//        "hex":"DC6D3D",
//        "info":"Loading Book Stores",
//        "count":0,
//        "terms":"Books",
//        "keywords":"Books, newspapers, magazines"
//    ],
//    [
//        "category":"Art Supply",
//        "icon":"imgArtsupply",
//        "hex":"73B97A",
//        "info":"Loading Art Supplies",
//        "count":0,
//        "terms":"Art Supply",
//        "keywords":"art supplies, art galleries, pawn shops, antiques"
//    ],
//    [
//        "category":"Gift Wrap",
//        "icon":"imgGift",
//        "hex":"F5EC99",
//        "info":"Loading Gift Shops",
//        "count":0,
//        "terms":"Gift Wrap",
//        "keywords":"Gift wrap, gift shops, cards & stationery"
//    ],
//    [
//        "category":"Auto",
//        "icon":"imgAutomotive",
//        "hex":"FACE33",
//        "info":"Loading Auto Stores",
//        "count":0,
//        "terms":"Auto parts",
//        "keywords":"auto, autp repair, Tires, Auto Parts & Supplies, Pep Boys Parts & Service, oil changes"
//    ]
])

var restrictedKeywords = [
    "Dispensary",
    "Marijuana",
    "Pot",
    "Weed",
    "Grass",
    "420",
    "Ganga",
    "Ganja",
    "Dope",
    "Herb",
    "Joint",
    "Blunt",
    "Cannabis",
    "Reefer",
    "Mary Jane",
    "Maryjane",
    "Mary-jane",
    "Buds",
    "Stinkweed",
    "Nuggets",
    "Chronic",
    "Hay",
    "Rope",
    "Gangster",
    "Skunk",
    "Boom",
    "Blaze",
    "Ashes",
    "Block",
    "Boo",
    "Burnie",
    "Charge",
    "sensimilla",
    "cannabis dispensary",
    "cheeba",
    "Hash",
    "Aunt Mary",
    "Ashes",
    "Atshitshi",
    "Baby Bhang",
    "Bammy",
    "Blanket",
    "Bo-Bo",
    "Bobo Bush",
    "Bomber",
    "Boom",
    "Cripple",
    "Dagga",
    "Dinkie Dow",
    "Ding",
    "Dona Juana",
    "Juanita",
    "Gasper",
    "Giggle Smoke",
    "Good Giggles",
    "Good Butt",
    "Hot Stick",
    "Jay",
    "Jolly Green",
    "Joy Smoke"
]

var appUrls : [OnlineBusinessModel] = [
    .init(json: JSON(
        [
            "name":"Rakuten",
            "image":"imgRakuten",
            "hex":"C1322A",
            "url":"https://www.rakuten.com",
            "id": 1
    ])),
    .init(json: JSON(
        [
            "name":"Wayfair",
            "image":"imgWayfair",
            "hex":"FFFFFF",
            "url":"https://www.wayfair.com",
            "id": 2
    ])),
    .init(json: JSON(
        [
            "name":"Amazon",
            "image":"imgAmazon",
            "hex":"FFFFFF",
            "url":"https://www.amazon.com",
            "id": 3
    ])),
    .init(json: JSON(
        [
            "name":"Craigslist",
            "image":"imgCraigslist",
            "hex":"774A77",
            "url":"https://www.cragislist.com",
            "id": 4
    ])),
    .init(json: JSON(
        [
            "name":"Etsy",
            "image":"imgEtsy",
            "hex":"FFFFFF",
            "url":"https://www.etsy.com",
            "id": 5
    ])),
    .init(json: JSON(
        [
            "name":"Walmart",
            "image":"imgWalmart",
            "hex":"FFFFFF",
            "url":"https://www.walmart.com",
            "id": 6
    ])),
    .init(json: JSON(
        [
            "name":"Shopify",
            "image":"imgShopify",
            "hex":"FFFFFF",
            "url":"https://www.shopify.com",
            "id": 7
    ])),
    .init(json: JSON(
        [
            "name":"Ebay",
            "image":"imgEbay",
            "hex":"FFFFFF",
            "url":"https://www.ebay.com",
            "id": 8
    ]))
]

var appSpecialCategories = JSON([
    [
        "category":"Multiple Deliveries",
        "icon":"imgMultiDel",
        "hex":"F1F2F3",
        "info":"Multiple deliveries and / or drops on the same offer",
        "rate":"$25 / hour average fee"
    ],
    [
        "category":"Personal Assistant",
        "icon":"imgPersAsst",
        "hex":"F1F2F3",
        "info":"DMV waiting, line concierges, misc errands and PA Services",
        "rate":"$25 / hour average fee"
    ],
    [
        "category":"Fixer / Handyperson",
        "icon":"imgHandyperson",
        "hex":"F1F2F3",
        "info":"Skills or repair work that can be completed in less than an hour",
        "rate":"$30 / hour average fee"
    ],
    [
        "category":"Locksmith",
        "icon":"imgLocksmith",
        "hex":"F1F2F3",
        "info":"Licensed locksmiths to replace keys or provide lockout service",
        "rate":"$50 / hour average fee"
    ],
    [
        "category":"Barber",
        "icon":"imgBarber",
        "hex":"F1F2F3",
        "info":"Licensed barbers come to your home or place of work",
        "rate":"$25 / hour average fee"
    ],
    [
        "category":"Manicurist",
        "icon":"imgManicurist",
        "hex":"F1F2F3",
        "info":"Mani or pedi by licensed manicurist in your home or place of work",
        "rate":"$30 / hour average fee"
    ],
    [
        "category":"Notary",
        "icon":"imgNotary",
        "hex":"F1F2F3",
        "info":"Licensed notary public will come to your home or place of work",
        "rate":"$50 / hour average fee"
    ],
    [
        "category":"Photographer",
        "icon":"imgPhotographer",
        "hex":"F1F2F3",
        "info":"Get a mini session with a photographer",
        "rate":"$100 / hour average fee"
    ],
    [
        "category":"Gas / Battery / Flat",
        "icon":"imgGas",
        "hex":"F1F2F3",
        "info":"A gallon of gas, battery jump or flat fixed in under 30 minutes",
        "rate":"$20 / hour average fee"
    ],
    [
        "category":"Towing",
        "icon":"imgTowingCat",
        "hex":"F1F2F3",
        "info":"Have a vehicle towed in under 30 minutes",
        "rate":"$75 / hour average fee"
    ]
])

var appDefaultUrls : [OnlineBusinessModel] = [
    .init(json: JSON(
        [
            "name":"Rakuten",
            "image":"imgRakuten",
            "hex":"C1322A",
            "url":"https://www.rakuten.com",
            "id": 1
    ])),
    .init(json: JSON(
        [
            "name":"Wayfair",
            "image":"imgWayfair",
            "hex":"FFFFFF",
            "url":"https://www.wayfair.com",
            "id": 2
    ])),
    .init(json: JSON(
        [
            "name":"Amazon",
            "image":"imgAmazon",
            "hex":"FFFFFF",
            "url":"https://www.amazon.com",
            "id": 3
    ])),
    .init(json: JSON(
        [
            "name":"Craigslist",
            "image":"imgCraigslist",
            "hex":"774A77",
            "url":"https://www.cragislist.com",
            "id": 4
    ])),
    .init(json: JSON(
        [
            "name":"Etsy",
            "image":"imgEtsy",
            "hex":"FFFFFF",
            "url":"https://www.etsy.com",
            "id": 5
    ])),
    .init(json: JSON(
        [
            "name":"Walmart",
            "image":"imgWalmart",
            "hex":"FFFFFF",
            "url":"https://www.walmart.com",
            "id": 6
    ])),
    .init(json: JSON(
        [
            "name":"Shopify",
            "image":"imgShopify",
            "hex":"FFFFFF",
            "url":"https://www.shopify.com",
            "id": 7
    ])),
    .init(json: JSON(
        [
            "name":"Ebay",
            "image":"imgEbay",
            "hex":"FFFFFF",
            "url":"https://www.ebay.com",
            "id": 8
    ]))
]


func modifyURLs(){
    if let index = appUrls.firstIndex(where: {$0.image == "imgRakuten"}){
        appUrls[index].hex = "C1322A"
    }
    
    if let index = appUrls.firstIndex(where: {$0.image == "imgWayfair"}){
        appUrls[index].hex = "FFFFFF"
    }
    
    if let index = appUrls.firstIndex(where: {$0.image == "imgAmazon"}){
        appUrls[index].hex = "FFFFFF"
    }
    
    if let index = appUrls.firstIndex(where: {$0.image == "imgCraigslist"}){
        appUrls[index].hex = "774A77"
    }
}

var appCourialServices = JSON([
    [
        "category":"custom",
        "icon":"customService",
        "hex":"34495E",
    ],
    [
        "category":"FedEx",
        "icon":"fedex",
        "hex":"4E298B",
    ],
    [
        "category":"UPS",
        "icon":"ups",
        "hex":"1E0302",
    ],
    [
        "category":"USPS",
        "icon":"usps",
        "hex":"FFFFFF",
    ],
    [
        "category":"DHL",
        "icon":"dhl",
        "hex":"F9CB33",
    ]
])

var learnAboutUs = [
    "Courial Email or Text Message",
    "The Rideshare Guy",
    "Facebook",
    "Instagram",
    "Rideshare Professor",
    "GridWise",
    "Twitter",
    "Google",
    "YouTube",
    "Apple App Store",
    "Google Play Store",
    "Yelp",
    "Flyer, Post Card, Business Card",
    "WOM, a friend or colleague",
    "Craigslist"
]


func cardNameAbb(name: String)->String{
    switch name.lowercased() {
    case "visa":
        return "VISA"
    case "mastercard","master card","mc":
        return "MC"
    case "amex","american express":
        return "AMEX"
    case "maestro":
        return "MS"
    case "disc","discover":
        return "DISC"
    case "diner's club","diners club","diners","diner's":
        return "DLCB"
    case "unionpay","union pay":
        return "UP"
    default:
        return name.uppercased()
    }
}


func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
    
    
}

func dayOfWeek(_ date: Date)->Int{
    switch date.convertToFormat("EEEE", timeZone: .current).lowercased() {
    case "monday":
        return 0
    case "tuesday":
        return 1
    case "wednesday":
        return 2
    case "thursday":
        return 3
    case "friday":
        return 4
    case "saturday":
        return 5
    case "sunday":
        return 6
    default:
        return 0
    }
}

func calculateOrderTotals(order: CurrentOrderModel?)->String{
    let cp = JSON(order?.itemCost ?? "0.00").doubleValue
    let cpFee = cp  * 0.05
    let discount = JSON(order?.promoDiscount ?? "0.00").doubleValue
    
    let pickWaitCharges = JSON(order?.pickupWaitCharges ?? "0.00").doubleValue
    let DropWaitCharges = JSON(order?.dropOffWaitCharges ?? "0.00").doubleValue
    let waitCharges = abs(pickWaitCharges) + abs(DropWaitCharges)
    
    //Delivery Fee
    let deliveryFee = (JSON(order?.deliveryFee ?? "0.00").doubleValue - discount) + waitCharges
    
    //Tip
    let courialTip = JSON(order?.courialTip ?? "0.00").doubleValue
    
    //Total
    let totalAmount = deliveryFee  + cp + cpFee + courialTip
    return  String(format: "%.02f", totalAmount)
}
