//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Kasra Hosseininejad on 10/11/25.
//

import Foundation

struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let humidity: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}
