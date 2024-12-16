//
//  WeatherService.swift
//  WeatherSwiftUIApp
//
//  Created by Gjakova on 16.12.24.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) async throws -> WeatherResponse
}

class WeatherService: WeatherServiceProtocol {
    private let apiKey = "dee41a49adcc41e8bdb93400241612"
    private let baseURL = "https://api.weatherapi.com/v1"

    func fetchWeather(for city: String) async throws -> WeatherResponse {
        let endpoint = "\(baseURL)/current.json?key=\(apiKey)&q=\(city)"
        guard let url = URL(string: endpoint) else {
            throw WeatherError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
}

enum WeatherError: Error {
    case invalidURL
    case decodingError
    case networkError
}
