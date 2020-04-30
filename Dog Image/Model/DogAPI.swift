//
//  DogAPI.swift
//  Dog Image
//
//  Created by J on 2020-04-28.
//  Copyright © 2020 J. All rights reserved.
//

import Foundation
import UIKit

class DogAPI {
    enum Endpoint {
        case randomImageFromAllDogsCollection
        case randomImageForBreed(String)
        case listAllBreeds
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
    class func requestBreedsList(completionHandler: @escaping ([String], Error?) -> Void) {
        let breedListEndPoint = DogAPI.Endpoint.listAllBreeds
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: breedListEndPoint.url) { (data, response, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            let decoder = JSONDecoder()
            if let breedsResponse = try? decoder.decode(BreedsListResponse.self, from: data) {
                let breeds = breedsResponse.message.keys.map({$0})
                completionHandler(breeds, nil)
            }
        }
        task.resume()
    }
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void) {
        let randomImageEndPoint = DogAPI.Endpoint.randomImageForBreed(breed).url
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: randomImageEndPoint) { (data, response, error) in
            guard let data = data else {
                return completionHandler(nil, error)
            }
            
            let decoder = JSONDecoder()
            let imageData = try? decoder.decode(DogImage.self, from: data)
            completionHandler(imageData, nil)
        }
        task.resume()
    }
    
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
        }
        task.resume()
    }
}



