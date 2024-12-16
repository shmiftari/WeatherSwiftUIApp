//
//  WeatherSwiftUIAppApp.swift
//  WeatherSwiftUIApp
//
//  Created by Gjakova on 16.12.24.
//

import SwiftUI

@main
struct WeatherSwiftUIApp: App {
    let container = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            WeatherView(viewModel: container.makeWeatherViewModel())
        }
    }
}
