//
//  Weather.swift
//  weatherApp
//
//  Created by Albert Estevan on 13/02/21.
//

import Foundation

//public struct Hourly: Hashable {
//    let dt: Int
//    let temp: Double
//    let weather: [APIWeather]
//}

public struct Weather {
//    let city: String
//    let temperature: String
//    let description: String
//    let iconName: String
//
//    init(response: APIResponse) {
//        city = response.name
//        temperature = "\(Int(response.main.temp))"
//        description = response.weather.first?.description ?? ""
//        iconName = response.weather.first?.iconName ?? ""
//    }
    
    let city: String
    let temperature: String
    let description: String
    let iconName: String
    
    let hourly: [APIHourly]
    let daily: [APIDaily]

    
    init(response: APIResponse) {
        city = response.timezone
        temperature = "\(Int(response.current.temp))"
        description = response.current.weather.first?.description ?? ""
        iconName = response.current.weather.first?.iconName ?? ""
        
        hourly = response.hourly
        daily = response.daily

    }
}
