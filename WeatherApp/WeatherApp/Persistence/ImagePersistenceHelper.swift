//
//  ImagePersistenceHelper.swift
//  WeatherApp
//
//  Created by Jack Wong on 10/17/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import Foundation
import UIKit

class ImagePersistenceHelper {
    
    static let manager = ImagePersistenceHelper()
    
    private let persistenceHelper = PersistenceManager<Image>(fileName: "favorites.plist")
    
    func save(newImage: Image) throws {
        try persistenceHelper.save(newElement: newImage)
    }
    
    func get() throws -> [Image] {
        return try persistenceHelper.getObjects().reversed()
    }

    func deleteImage(with urlStr: String) throws {
        try persistenceHelper.delete(elementWith: urlStr)
    }
    
    private init() {}
}
