//
//  FileDownloader.swift
//  Courail
//
//  Created by Omeesh Sharma on 01/05/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Alamofire

class FileDownloader {
    
    static func loadFileAsync(url: URL, completion: @escaping (URL?, Error?) -> Void){
        sleep(5)
        
        guard let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completion(nil, nil)
            return
        }
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let fileURL = docsURL.appendingPathComponent("Courial_call_recording.mp3")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        Alamofire.download(url, to: destination).responseData { response in
            if let destinationUrl = response.destinationURL {
                completion(destinationUrl,nil)
            } else if let err = response.error{
                completion(nil, err)
            } else{
                completion(nil, nil)
            }
        }
    }
    
    
    
}
