//
//  Image.swift
//  WeatherApp
//
//  Created by Jack Wong on 10/17/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import Foundation

struct ImageWrapper: Codable {
    let hits: [Image]
    
    static func decodeImagesFromData(from jsonData: Data) throws -> [Image] {
        let response = try JSONDecoder().decode(ImageWrapper.self, from: jsonData)
        return response.hits
    }
}

struct Image: Codable {
    let url: String
    
    static func getRandomImage(images: [Image]) -> Image? {
        if let randomImage = images.randomElement() {
            return randomImage
        }
        return nil
    }
    
    func existsInFavorites() -> Bool? {
        do {
            let allSavedImages = try ImagePersistenceHelper.manager.get()
            if allSavedImages.contains(where: { $0.url == self.url }) {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case url = "largeImageURL"
    }
    
}
