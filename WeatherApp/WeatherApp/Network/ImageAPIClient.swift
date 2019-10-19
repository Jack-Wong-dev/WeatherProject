//
//  ImageAPIClient.swift
//  WeatherApp
//
//  Created by Jack Wong on 10/17/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import Foundation

class ImageAPIClient {
    
    static let manager = ImageAPIClient()
    
    static func getSearchResultsURLStr(from searchString: String) -> String {
        let formattedString = searchString.replacingOccurrences(of: " ", with: "+")
        
        return "https://pixabay.com/api/?key=\(SecretKeys.pixabay)&q=\(formattedString)"
    }

    func getImage(urlStr: String, completionHandler: @escaping (Result<[Image], AppError>) -> ())  {
        
        guard let url = URL(string: urlStr) else {
            print(AppError.badURL)
            return
        }
        
        NetworkManager.manager.performDataTask(withUrl: url, andMethod: .get) { (results) in
            switch results {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let imageInfo = try ImageWrapper.decodeImagesFromData(from: data)
                    completionHandler(.success(imageInfo))
                }
                catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
                
            }
        }
    }
    
    private init() {}
}
