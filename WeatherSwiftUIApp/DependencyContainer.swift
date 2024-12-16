//
//  DependencyContainer.swift
//  WeatherSwiftUIApp
//
//  Created by Gjakova on 16.12.24.
//

@MainActor
class DependencyContainer {
    let weatherService: any WeatherServiceProtocol

    init() {
        weatherService = WeatherService()
    }

    func makeWeatherViewModel() -> WeatherViewModel {
        return WeatherViewModel(weatherService: weatherService)
    }
}
