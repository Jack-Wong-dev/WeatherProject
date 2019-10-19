//
//  UserDefaults.swift
//  WeatherApp
//
//  Created by Jack Wong on 10/17/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import Foundation

class UserDefaultsWrapper {
    
    static let manager = UserDefaultsWrapper()
    
    func getSearchString() -> String? {
        return UserDefaults.standard.value(forKey: searchStringKey) as? String
    }
    
    func store(searchString: String) {
        UserDefaults.standard.set(searchString, forKey: searchStringKey)
    }
    
    private let searchStringKey = "searchStringKey"
    
    private init() {}
}
