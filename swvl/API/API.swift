//
//  API.swift
//  swvl
//
//  Created by mohamed saeed on 5/24/19.
//  Copyright © 2019 mohamed saeed. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
class API {
    
    let apiKey = "dba0b6d3b11ed06f5e008073cbb762a6"
    func getPhotosOfMovie(title: String, onSucess: @escaping ([Photo])-> Void ,onError: @escaping (String)->Void) {
        
        Alamofire.request("https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&format=json&page=1&per_page=10&nojsoncallback=1", method: HTTPMethod.get, parameters: ["text":title], encoding: URLEncoding.queryString, headers: nil)
            .responseJSON { response in
                
                guard response.result.isSuccess else{
                    onError((response.error?.localizedDescription)!)
                    return
                }
                
                let res = response.result.value as! [String:Any]
                if let resObject = FlickrPhotoSearchResponse(JSON:res )  , let photos = resObject.photos?.photo {
                    onSucess(photos)
                    return
                }
                
                onError("can't parse the response")

        }
        
    }
}



