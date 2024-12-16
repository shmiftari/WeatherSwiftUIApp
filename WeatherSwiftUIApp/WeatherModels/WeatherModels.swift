//
//  WeatherModels.swift
//  WeatherSwiftUIApp
//
//  Created by Gjakova on 16.12.24.
//

import Foundation

struct WeatherResponse: Decodable {
    let location: Location
    let current: CurrentWeather
}

struct Location: Decodable {
    let name: String
    let country: String
}

struct Condition: Decodable {
    let text: String
    let icon: String
}

struct CurrentWeather: Decodable {
    let temp_c: Int
    let condition: Condition
    let humidity: Int
    let uv: Int
    let feelslike_c: Int
    
    private enum CodingKeys: String, CodingKey {
        case temp_c
        case condition
        case humidity
        case uv
        case feelslike_c
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        condition = try container.decode(Condition.self, forKey: .condition)
        humidity = try container.decode(Int.self, forKey: .humidity)
        
        uv = Int(try container.decode(Double.self, forKey: .uv))
        feelslike_c = Int(try container.decode(Double.self, forKey: .feelslike_c))
        temp_c = Int(try container.decode(Double.self, forKey: .temp_c))
    }
}
