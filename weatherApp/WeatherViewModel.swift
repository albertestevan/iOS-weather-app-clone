//
//  WeatherViewModel.swift
//  weatherApp
//
//  Created by Albert Estevan on 13/02/21.
//

import Foundation

private let defaultIcon = "cloud.sun.fill"
private let iconMap = [
    "Thunderstorm": "cloud.bolt.fill",
    "Drizzle": "cloud.drizzle.fill",
    "Rain": "cloud.rain.fill",
    "Snow": "cloud.snow.fill",
    "Atmosphere": "cloud.fog.fill",
    "Clear": "sun.max.fill",
    "Clouds": "smoke.fill",
    "": "cloud.fill"
]

public class WeatherViewModel: ObservableObject {
    @Published var cityName: String = "Default City"
    @Published var temperature: String = "--°"
    @Published var weatherDescription: String = "Default Desc"
    @Published var weatherIcon: String = defaultIcon
    
    @Published var hourly: Array<APIHourly> = []
    @Published var daily: Array<APIDaily> = []


    
    
    public let weatherService: WeatherService
    
    public init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    public func refresh() {
        weatherService.loadWeatherData { weather in
            DispatchQueue.main.async {
                self.cityName = weather.city
                self.temperature = "\(weather.temperature)°"
                self.weatherDescription = weather.description.capitalized
                self.weatherIcon = iconMap[weather.iconName] ?? defaultIcon
                
                self.hourly = weather.hourly
                self.daily = weather.daily

            }
        }

    }
}
