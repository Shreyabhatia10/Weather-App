//
//  CurrentWeather.swift
//  Weather App
//
//  Created by Shreya Bhatia on 02/07/19.
//  Copyright © 2019 Shreya Bhatia. All rights reserved.
//

struct Weather {
    static let temperature = "temperature"
    static let humidity = "humidity"
    static let summary = "summary"
    static let timezone = "timezone"
}

class CurrentWeather {
    let temperature: Float?
    let humidity: Double?
    let summary: String?
    let timezone: String?
    
    init(json: [String: Any]) {
        self.temperature = json[Weather.temperature] as? Float
        self.humidity = json[Weather.humidity] as? Double
        self.summary = json[Weather.summary] as? String
        self.timezone = json[Weather.timezone] as? String
    }
}
