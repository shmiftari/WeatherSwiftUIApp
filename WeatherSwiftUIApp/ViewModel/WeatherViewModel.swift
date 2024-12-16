//
//  WeatherViewModel.swift
//  WeatherSwiftUIApp
//
//  Created by Gjakova on 16.12.24.
//

import Foundation
import Reachability

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var cityName: String = "" {
        didSet {
            saveCityName()
        }
    }
    
    @Published var weather: WeatherResponse?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isConnected: Bool = true

    private let weatherService: WeatherServiceProtocol
    private let cityKey = "savedCity"

    private let reachability = try! Reachability()

    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
        startReachabilityMonitoring()
        loadCityName()
    }
    
    func startReachabilityMonitoring() {
        reachability.whenReachable = { _ in
            DispatchQueue.main.async {
                self.isConnected = true
            }
        }
        
        reachability.whenUnreachable = { _ in
            DispatchQueue.main.async {
                self.isConnected = false
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start reachability notifier")
        }
    }
    
    func removeSpecialCharacters(from input: String) -> String {
        let allowedCharacters = CharacterSet.alphanumerics
        return input.unicodeScalars.filter { allowedCharacters.contains($0) }
                                    .map { String($0) }
                                    .joined()
    }
    
    func fetchWeather() async {
        guard isConnected else {
            errorMessage = "No internet connection. Please check your network."
            return
        }

        let cleanedCityName = removeSpecialCharacters(from: cityName)

        guard !cleanedCityName.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        Task.detached(priority: .userInitiated) { [weak self] in
            do {
                guard let self = self else { return }
                let weather = try await self.weatherService.fetchWeather(for: self.cityName)

                await self.updateUI(weather: weather)
            } catch {
                await self?.handleError(error)
            }
        }
    }

    @MainActor
    func updateUI(weather: WeatherResponse) {
        self.weather = weather
        self.isLoading = false
    }

    @MainActor
    func handleError(_ error: Error) {
        self.errorMessage = "Failed to load weather. Please try again."
        self.isLoading = false
    }

    private func saveCityName() {
        UserDefaults.standard.set(cityName, forKey: cityKey)
    }

    private func loadCityName() {
        cityName = UserDefaults.standard.string(forKey: cityKey) ?? ""
    }
}
