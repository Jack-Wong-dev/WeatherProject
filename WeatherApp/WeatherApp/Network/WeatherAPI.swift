//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Jack Wong on 10/17/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import Foundation

class WeatherAPIClient {
    
    static let manager = WeatherAPIClient()
    
    static func getSearchResultsURLStr(from latitude: String, longitude: String) -> String {
        return "https://api.darksky.net/forecast/\(SecretKeys.darkSky)/\(latitude),\(longitude)?exclude=[minutely,hourly,alerts,flags]"
    }
    
    func getWeather(urlStr: String, completionHandler: @escaping (Result<[Forecast], AppError>) -> ())  {
        
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
                    let weatherInfo = try Weather.decodeWeatherFromData(from: data)
                    completionHandler(.success(weatherInfo.daily.data))
                }
                catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
                
            }
        }
    }
    
    private init() {}
}
