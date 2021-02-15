//
//  WeatherService.swift
//  weatherApp
//
//  Created by Albert Estevan on 13/02/21.
//

import CoreLocation
import Foundation

public final class WeatherService: NSObject {
    
    private let locationManager = CLLocationManager()
    private let API_KEY = "c7f1810d25f7f4704cc956b0335046ac"
    private var completionHandler: ((Weather) -> Void)?

    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func loadWeatherData(_ completionHandler: @escaping((Weather) -> Void)) {
        self.completionHandler = completionHandler
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
    private func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D) {
        guard let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_KEY)&units=metric"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else { return }
            
            if let response = try? JSONDecoder().decode(APIResponse.self, from: data) {
                self.completionHandler?(Weather(response: response))
            }
        }.resume()
    }
    
    
}

extension WeatherService: CLLocationManagerDelegate {
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else { return }
        makeDataRequest(forCoordinates: location.coordinate)
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Something went wrong: \(error.localizedDescription)")
    }
}

//struct APIResponse: Decodable {
//    let name: String
//    let main: APIMain
//    let weather: [APIWeather]
//
//}

struct APIResponse: Decodable {
    let current: APICurrent
    let timezone: String

    let hourly: [APIHourly]
    let daily: [APIDaily]
//    enum CodingKeys: Array, CodingKey {
//        case current
//        case name = "timezone"
//    }
    
}

struct APICurrent: Decodable {
    let temp: Double
    let weather: [APIWeather]
}

struct APIWeather: Decodable {
    let description: String
    let iconName: String

    enum CodingKeys: String, CodingKey {
        case description
        case iconName = "main"
    }
}

struct APIHourly: Decodable {
    let dt: Int
    let temp: Double
    let weather: [APIWeather]
}

struct APIDaily: Decodable {
    let dt: Int
    let temp: APITemp
    let weather: [APIWeather]
    let sunrise: Int
    let sunset: Int
}

struct APITemp: Decodable {
    let day: Double
    let max: Double
    let min: Double
}


//struct APIMain: Decodable {
//    let temp: Double
//}
//
//struct APIWeather: Decodable {
//    let description: String
//    let iconName: String
//
//    enum CodingKeys: String, CodingKey {
//        case description
//        case iconName = "main"
//    }
//}
