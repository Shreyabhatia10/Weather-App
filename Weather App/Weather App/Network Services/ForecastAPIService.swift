//
//  ForecastAPIService.swift
//  Weather App
//
//  Created by Shreya Bhatia on 02/07/19.
//  Copyright © 2019 Shreya Bhatia. All rights reserved.
//
import Foundation

class ForecastAPIService {
    
    let apiKey: String
    let forecasBaseURL: URL?
    
    init(APIKey: String) {
        self.apiKey = APIKey
        forecasBaseURL = URL(string: "https://api.darksky.net/forecast/\(APIKey)/")
    }
    
    func getForecast(latitude: Double, longitude: Double, completion: @escaping (CurrentWeather?) -> Void) {
        if let forecastURL = URL(string: "\(latitude),\(longitude)", relativeTo: forecasBaseURL!) {
            
            let networkProcessor = NetworkProcessor(url: forecastURL)
            networkProcessor.downloadJSONFromURL({ (jsonDictionary) in
                if var weatherDictionary = jsonDictionary?["currently"] as? [String: Any], let timezone =  jsonDictionary?["timezone"] as? String {
                    weatherDictionary["timezone"] = timezone
                    let currentWeather = CurrentWeather(json: weatherDictionary)
                    completion(currentWeather)
                } else {
                    completion(nil)
                }
            })
        }
    }
}
