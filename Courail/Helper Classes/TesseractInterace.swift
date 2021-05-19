//
//  TesseractInterace.swift
//  Courail
//
//  Created by Omeesh Sharma on 15/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import TesseractOCR
import GPUImage

class TesseractInterace: NSObject {
    
    static let shared = TesseractInterace()
    
    func checkImage(_ image: UIImage)-> String{
        guard let tesseract = G8Tesseract(language: "eng") else { return ""}
        
        tesseract.engineMode = .tesseractCubeCombined
        tesseract.pageSegmentationMode = .auto
        tesseract.image = image.scaledImage(1000)?.preprocessedImage() ?? image
        tesseract.recognize()
        return tesseract.recognizedText ?? ""
    }
    
    func getPrice(_ data: String)-> String{
        let strArray = data.components(separatedBy: "\n").filter({$0 != "" && $0 != " "})
        
        let priceStrArray = strArray.filter({$0.contains("$")})
        var priceValues = [Double]()
        
        for price in priceStrArray{
            let priceFilter = price.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
            let priceDobule = JSON(priceFilter).doubleValue
            priceValues.append(priceDobule)
        }
        
        let subTotal = priceValues.sorted { (price1, price2) -> Bool in
            price1 > price2
        }.first ?? 0.0
        
        return String(format: "%.2f", subTotal)
    }
    
    func getItem(_ data: String)-> String{
        let strArray = data.components(separatedBy: "\n").filter({$0 != "" && $0 != " "})
        if let index = strArray.firstIndex(where: {$0.lowercased().contains("qty") || $0.lowercased().contains("quantity")}){
            return (strArray[index])
        } else{
            return (strArray.first ?? "")
        }
    }
}

extension UIImage {
    // 2
    func scaledImage(_ maxDimension: CGFloat) -> UIImage? {
        // 3
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        // 4
        if size.width > size.height {
            scaledSize.height = size.height / size.width * scaledSize.width
        } else {
            scaledSize.width = size.width / size.height * scaledSize.height
        }
        // 5
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // 6
        return scaledImage
    }
    
    func preprocessedImage() -> UIImage? {
        let stillImageFilter = GPUImageAdaptiveThresholdFilter()
        stillImageFilter.blurRadiusInPixels = 15.0
        let filteredImage = stillImageFilter.image(byFilteringImage: self)
        return filteredImage
    }
    
}
