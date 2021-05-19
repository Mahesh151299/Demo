
import UIKit
import Alamofire
import LGSideMenuController

class ApiInterface: NSObject {
    
    class func requestApi(params: Parameters, api_url: String, headers : [String: String]? = createHeaders(),method: HTTPMethod = .post, encoding: ParameterEncoding = JSONEncoding.default, success: @escaping(JSON)-> Void,failure: @escaping(String , JSON)-> Void){
        print(params)
        var finalParams : Parameters? = params
        var finalApiURL = baseURL + api_url
        
        if method == .get && params.isEmpty == false{
            let urlParams = params.compactMap({ (key, value) -> String in
                return "\(key)=\(value)"
            }).joined(separator: "&")
            finalApiURL = finalApiURL + "?" + urlParams
            if let urlQuery = finalApiURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                finalApiURL = urlQuery
            }
            finalParams = nil
        }
        
        ApiManager.sharedInstance.requestApiURL(finalApiURL , params: finalParams as [String : AnyObject]?, headers: headers, encoding: encoding, method: method , success: { (result, statusCode) in
            print(result)
            //Success
            success(result)
        }) { (error, statusCode) in
            //Failure
            guard api_url.contains("logout") == false else {
                failure(error,JSON(JSON.self))
                return
            }
            
            switch statusCode{
            case 401: // Status Code For Session Expire
                logout()
                DispatchQueue.main.async {
                    showSwiftyAlert("", "Session Expired", false)
                }
                
            default:
                failure(error,JSON(JSON.self))
            }
        }
    }
    
    class func formDataApi(params: Parameters, api_url: String, image: UIImage?, imageName: String,headers : [String: String]? = createHeaders(), method: HTTPMethod = .post, success: @escaping(JSON)-> Void,failure: @escaping(String , JSON)-> Void){
        print(params)
        ApiManager.sharedInstance.requestMultiPartURL(baseURL + api_url, params: params as [String : AnyObject], headers: headers, imagesArray: [image], imageName: [imageName], method: method, success: { (result, statusCode) in
            //Success
            success(result)
        }) { (error, statusCode) in
            //Failure
            switch statusCode{
            case 401: // Status Code For Session Expire
            logout()
            DispatchQueue.main.async {
                showSwiftyAlert("", "Session Expired", false)
            }
            default:
                failure(error,JSON(JSON.self))
            }
            
        }
    }
    
    class func multipleFileApi(params: Parameters, api_url: String, image: [UIImage?], imageName: [String], headers : [String: String]? = createHeaders(), method: HTTPMethod = .post,  success: @escaping(JSON)-> Void,failure: @escaping(String , JSON)-> Void){
        print(params)
        ApiManager.sharedInstance.requestMultiPartURL(baseURL + api_url, params: params as [String : AnyObject], headers: headers, imagesArray: image, imageName: imageName, method: method, success: { (result, statusCode) in
            //Success
            success(result)
        }) { (error, statusCode) in
            //Failure
            switch statusCode{
            case 401: // Status Code For Session Expire
            logout()
            DispatchQueue.main.async {
                showSwiftyAlert("", "Session Expired", false)
            }
            default:
                failure(error,JSON(JSON.self))
            }
            
        }
    }
    
    class func multipleDocApi(params: Parameters, api_url: String, docArray: [DocumentModel?], headers : [String: String]? = createHeaders(), method: HTTPMethod = .post,  success: @escaping(JSON)-> Void,failure: @escaping(String , JSON)-> Void){
        print(params)
        ApiManager.sharedInstance.requestDocUploadURL(baseURL + api_url, params: params as [String : AnyObject], headers: headers, docArray: docArray, method: method, success: { (result, statusCode) in
            //Success
            success(result)
        }) { (error, statusCode) in
            //Failure
            switch statusCode{
            case 401: // Status Code For Session Expire
            logout()
            DispatchQueue.main.async {
                showSwiftyAlert("", "Session Expired", false)
            }
            default:
                failure(error,JSON(JSON.self))
            }
        }
    }
    

    class func getCurrentOrder(completion: @escaping((Bool) -> Void)){
        guard isLoggedIn() else {return}
        
        ApiInterface.requestApi(params: [:], api_url: API.get_current_order, success: { (json) in
            guard json["data"].isEmpty == false else {
                currentOrder = nil
                (((rootVC as! LGSideMenuController).rootViewController as? UINavigationController)?.viewControllers.first as? TabBarVC)?.setTabBarItems()
                completion(false)
                return
            }
            currentOrder = .init(json: json["data"])
            if JSON(currentOrder?.isSkill ?? "0").boolValue{
                if currentOrder?.status == orderStatus.confirmPickupPointArrival || currentOrder?.status == orderStatus.confirmPickup{
                    currentOrder?.status = orderStatus.Accepted
                }
            }
            
            if let orderDetails = currentOrder, let window = UIApplication.shared.keyWindow, (orderDetails.isRequested ?? 0) == 1{
                window.rootViewController!.showAlertTwoActions(msg: "\(currentOrder?.provider?.firstName ?? "") has marked this offer as complete. Do you approve?", doneBtnTitle: "YES", cancelBtnTitle: "NO") {
                    SocketBase.sharedInstance.pauseTimer()
                    SocketBase.sharedInstance.verifyDeliveryPhoto(orderId: currentOrder?.orderid ?? "", status: "1")
                    currentOrder?.DeliveryPhotoverify = 1
                } cancelActions: {
                    SocketBase.sharedInstance.verifyDeliveryPhoto(orderId: currentOrder?.orderid ?? "", status: "2")
                }
            }
            
            (((rootVC as! LGSideMenuController).rootViewController as? UINavigationController)?.viewControllers.first as? TabBarVC)?.setTabBarItems()
            completion(true)
        }) { (error, json) in
            print(error)
            completion(false)
        }
    }
    
    
    class func getOrderWithID(id: String, completion: @escaping((CurrentOrderModel?) -> Void)){
        let params : Parameters = [
            "orderid": id
        ]
        ApiInterface.requestApi(params: params, api_url: API.getorderdetail , success: { (json) in
            completion(CurrentOrderModel.init(json: json["data"]))
        }) { (error, json) in
            print(error)
            completion(nil)
        }
    }
    
    
    class func getCatCount(){
        ApiInterface.requestApi(params: [:], api_url: API.get_category_count, method: .get, encoding: URLEncoding.httpBody , success: { (json) in
            let data = json["data"].arrayValue
            guard data.isEmpty == false else{
                return
            }
            
            for item in data{
                let cat = item["categoryname"].stringValue.lowercased()
                let count = item["counts"].intValue
                if let index = appCategories.arrayValue.firstIndex(where: {$0["category"].stringValue.lowercased() == cat.lowercased()}){
                    appCategories[index]["count"].intValue = count
                }
            }
            
        }) { (error, json) in
        }
    }
    
     class func updateVersion(){
        guard isLoggedIn() else {return}
        
        let params: Parameters = [
            "phoneversion": UIDevice().type.rawValue,
            "appversion": Bundle.main.releaseVersionNumber ?? "0.0",
            "apprelease": "\(buildDate.timeIntervalSince1970)",
            "os":UIDevice.current.systemVersion
        ]
        
        ApiInterface.requestApi(params: params, api_url: API.updateinfo , success: { (json) in
        }) { (error, json) in
        }
    }
}

