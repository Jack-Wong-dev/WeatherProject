//
//  Weather.swift
//  WeatherApp
//
//  Created by Jack Wong on 10/17/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let daily: DailyWeatherResult
    
    static func decodeWeatherFromData(from jsonData: Data) throws -> Weather {
        let response = try JSONDecoder().decode(Weather.self, from: jsonData)
        return response
    }
}

struct DailyWeatherResult: Codable {
    let data: [Forecast]
}

struct Forecast: Codable {

    private let time: Int
    let summary: String
    let icon: String
    let temperatureHigh: Double
    let temperatureLow: Double
    private let sunriseTime: Int
    private let sunsetTime: Int
    let windSpeed: Double
    let precipProbability: Double
    
    var formattedDate: String {
        let timeInterval = Date(timeIntervalSince1970: TimeInterval(time))
        
        let oldDateFormat = DateFormatter()
        oldDateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let newDateFormat = DateFormatter()
        newDateFormat.dateFormat = "EEEE, MMM d, yyyy"
        return newDateFormat.string(from: timeInterval)
    }
    
    var formattedSunriseTime: String {
        let timeInterval = Date(timeIntervalSince1970: TimeInterval(sunriseTime))
        
        let oldDateFormat = DateFormatter()
        oldDateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let newDateFormat = DateFormatter()
        newDateFormat.dateFormat = "h:mm a"
        return newDateFormat.string(from: timeInterval)
    }
    
    var formattedSunsetTime: String {
        let timeInterval = Date(timeIntervalSince1970: TimeInterval(sunsetTime))
        
        let oldDateFormat = DateFormatter()
        oldDateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let newDateFormat = DateFormatter()
        newDateFormat.dateFormat = "h:mm a"
        return newDateFormat.string(from: timeInterval)
    }
    
}


