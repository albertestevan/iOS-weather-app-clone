//
//  weatherAppApp.swift
//  weatherApp
//
//  Created by Albert Estevan on 13/02/21.
//

import SwiftUI

@main
struct weatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            let weatherService = WeatherService()
            let viewModel = WeatherViewModel(weatherService: weatherService)
            ContentView(viewModel: viewModel)
        }
    }
}
